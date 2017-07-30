module PharNoteApp.Equipment.Update exposing (..)

import PharNoteApp.Equipment.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.Equipment.Model as Equipment
import PharNoteApp.Equipment.BaseModel as EquipmentBase
import PharNoteApp.Equipment.Model exposing (RefDataStatus(..), FilterState(..), EquipmentTab(..))
import PharNoteApp.Equipment.Rest as Rest
import PharNoteApp.Equipment.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table
import Array exposing (fromList, Array)
import Dict exposing (Dict)
import Set exposing (Set)


update : Msg -> Equipment.Model -> ( Equipment.Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        SelectTab equipmentTab ->
            { model | selectedTab = equipmentTab } ! []

        KeyX key ->
            let
                equipmentCount =
                    Array.length (model.filteredEquipment)

                currentIdx =
                    case model.selectedEquipmentIndex of
                        Nothing ->
                            -1

                        Just ndx ->
                            ndx

                idx =
                    if key == 38 && currentIdx > 0 then
                        currentIdx - 1
                    else if key == 40 && currentIdx < equipmentCount - 1 then
                        currentIdx + 1
                    else
                        currentIdx

                --if selected equipment is off the beginning of screen then start window from index
                startIndex =
                    if idx < model.startDisplayIndex then
                        idx
                    else if idx > model.endDisplayIndex then
                        model.endDisplayIndex - model.pageSize + 2
                    else
                        model.startDisplayIndex

                endIndex =
                    startIndex + model.pageSize - 1

                equipment =
                    View.maybeFindEquipment (Just idx) model.filteredEquipment

                newModel =
                    case equipment of
                        Just u ->
                            { model
                                | selectedEquipmentId = Just u.id
                                , selectedEquipmentIndex = Just idx
                                , startDisplayIndex = startIndex
                                , endDisplayIndex = endIndex
                            }

                        _ ->
                            model

                --populateScratchEquipmentData equipment (Just idx) model model.formAction
            in
                newModel ! []

        SelectEquipment idx ->
            let
                index =
                    model.startDisplayIndex + idx

                equipment =
                    View.maybeFindEquipment (Just index) model.filteredEquipment

                newModel =
                    case equipment of
                        Just u ->
                            { model
                                | selectedEquipmentId = Just u.id
                                , selectedEquipmentIndex = Just index
                            }

                        _ ->
                            model

                --populateScratchEquipmentData equipment (Just idx) model model.formAction
            in
                newModel
                    ! []

        Reorder ->
            let
                sortOrder =
                    toggleSort model.order

                sort =
                    case sortOrder of
                        Just Table.Ascending ->
                            List.sortBy sort_by_equipment_name

                        Just Table.Descending ->
                            List.sortWith (\x y -> reverse (sort_by_equipment_name x) (sort_by_equipment_name y))

                        Nothing ->
                            identity

                sortedEquipment =
                    sort (Array.toList model.filteredEquipment) |> Array.fromList

                nextEquipment =
                    View.alwaysFindEquipment model.selectedEquipmentIndex sortedEquipment
            in
                --the equipment index and id will nno longer match up now.  Either need to find current equipment, or keep selector on same page/offset
                { model | order = sortOrder, filteredEquipment = sortedEquipment, selectedEquipmentId = Just nextEquipment.id } ! []

        CancelDeleteEquipment ->
            { model | formAction = Equipment.None } ! []

        ConfirmDeleteEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                usr =
                    View.maybeFindEquipment idx model.filteredEquipment
            in
                { model | formAction = Equipment.ConfirmDelete } ! []

        DeleteEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                usr =
                    View.maybeFindEquipment idx model.filteredEquipment
            in
                case usr of
                    Nothing ->
                        model ! []

                    Just equipment ->
                        --we need to identify a record to be current after successful delete
                        let
                            --this would be a case of using one of those Maybe.andThen things as if idx was Nothing we would not get here.
                            i =
                                case idx of
                                    Just x ->
                                        x

                                    _ ->
                                        0

                            ( maybeNextEquipment, nextIndex ) =
                                case View.maybeFindEquipment (Just (i + 1)) model.filteredEquipment of
                                    Nothing ->
                                        case View.maybeFindEquipment (Just (i - 1)) model.filteredEquipment of
                                            Nothing ->
                                                ( Nothing, -1 )

                                            Just uu ->
                                                ( Just uu, i - 1 )

                                    Just u ->
                                        ( Just u, i )

                            newModel =
                                case maybeNextEquipment of
                                    Nothing ->
                                        { model
                                            | formAction = Equipment.Delete
                                            , selectedEquipmentId = Just equipment.id
                                        }

                                    Just nextEquipment ->
                                        { model
                                            | formAction = Equipment.Delete
                                            , selectedEquipmentId = Just equipment.id
                                            , previousSelectedEquipmentId = Just nextEquipment.id
                                            , previousSelectedEquipmentIndex = Just nextIndex
                                        }
                        in
                            --newModel ! [ Rest.delete equipment ]
                            newModel ! []

        EditEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                equipment =
                    View.maybeFindEquipment idx model.filteredEquipment

                newModel =
                    populateScratchEquipmentData equipment idx model Equipment.Edit
            in
                newModel
                    ! []

        NewEquipment ->
            { model
                | formAction = Equipment.Create
                , scratchEquipment = EquipmentBase.emptyEquipment
                , selectedEquipmentId = Nothing
                , selectedEquipmentIndex = Nothing
                , previousSelectedEquipmentIndex = model.selectedEquipmentIndex
                , previousSelectedEquipmentId = model.selectedEquipmentId
            }
                ! []

        CancelNewEquipment ->
            let
                newModel =
                    case model.formAction of
                        Equipment.Create ->
                            { model
                                | formAction = Equipment.CancelNewEquipment
                                , selectedEquipmentId = model.previousSelectedEquipmentId
                                , selectedEquipmentIndex = model.previousSelectedEquipmentIndex
                            }

                        _ ->
                            { model
                                | formAction = Equipment.CancelNewEquipment
                            }
            in
                newModel ! []

        ProcessRefDataGet (Ok class_precisions) ->
            { model
                | refDataStatus = Loaded (Equipment.RefData class_precisions)
            }
                ! []

        ProcessRefDataGet (Err error) ->
            let
                x =
                    Debug.log "refdata error" error
            in
                { model
                    | errors = Just error
                }
                    ! []

        ProcessEquipmentGet (Ok equipment) ->
            let
                equipmentArray =
                    Array.fromList (equipment)

                c =
                    Debug.log "ProcessEquipmentGet eq count:" Array.length equipmentArray

                newModel =
                    filteredModel { model | equipment = equipmentArray }
            in
                newModel ! []

        ProcessEquipmentGet (Err error) ->
            let
                c =
                    Debug.log "ProcessEquipmentGet error:" error
            in
                { model
                    | errors = Just error
                }
                    ! []

        ProcessEquipmentPost (Ok equipment) ->
            { model | formAction = Equipment.None } ! [ Rest.get ]

        ProcessEquipmentPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessEquipmentDelete (Ok equipment) ->
            -- need to set current equipment to previousSelectedEquipmentId
            { model
                | formAction = Equipment.None
                , selectedEquipmentId = model.previousSelectedEquipmentId
                , selectedEquipmentIndex = model.previousSelectedEquipmentIndex
            }
                ! [ Rest.get ]

        ProcessEquipmentDelete (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        EquipmentPost equipment ->
            model ! []

        EquipmentPut equipment ->
            model ! []

        SetFirstName value ->
            let
                equipment =
                    model.scratchEquipment

                new_equipment =
                    { equipment | equipment_name = value }
            in
                { model | scratchEquipment = new_equipment } ! []

        SetLastName value ->
            let
                equipment =
                    model.scratchEquipment

                new_equipment =
                    { equipment | equipment_code = value }
            in
                { model | scratchEquipment = new_equipment } ! []

        ToggleRole roleID ->
            -- let
            --     equipment =
            --         model.scratchEquipment
            --
            --     roleSet =
            --         equipment.roles
            --
            --     newRoleSet =
            --         case Set.member roleID roleSet of
            --             True ->
            --                 Set.remove roleID roleSet
            --
            --             False ->
            --                 Set.insert roleID roleSet
            --
            --     newEquipment =
            --         { equipment | roles = newRoleSet }
            -- in
            --     { model | scratchEquipment = newEquipment } ! []
            model ! []

        EquipmentSlider valuePC ->
            let
                len =
                    Array.length model.filteredEquipment

                reducedLen =
                    len - model.pageSize

                start =
                    floor ((valuePC / 100) * (toFloat reducedLen))

                end =
                    start + model.pageSize
            in
                { model
                    | startDisplayIndex = start
                    , endDisplayIndex = end
                    , equipmentSliderValue = valuePC
                }
                    ! []

        PaginateEquipment page ->
            let
                g =
                    Debug.log "page" page

                idx =
                    Maybe.withDefault 0 model.selectedEquipmentIndex

                offset =
                    idx - model.startDisplayIndex

                s =
                    page * model.pageSize

                equipmentCount =
                    Array.length model.filteredEquipment

                start =
                    if equipmentCount - s < model.pageSize then
                        equipmentCount - model.pageSize
                    else
                        s

                end =
                    start + model.pageSize - 1

                nextIdx =
                    start + offset

                nextEquipment =
                    View.alwaysFindEquipment (Just nextIdx) model.filteredEquipment
            in
                { model
                    | startDisplayIndex = start
                    , endDisplayIndex = end
                    , selectedEquipmentId = Just nextEquipment.id
                    , selectedEquipmentIndex = Just nextIdx
                }
                    ! []

        ApplyEquipmentFilter filterEquipment ->
            let
                fm =
                    { model | filterState = Applied, selectedEquipmentIndex = Nothing }
            in
                (filteredModel fm) ! []

        ResetEquipmentFilter ->
            { model | filterScratchEquipment = EquipmentBase.emptyEquipment } ! []

        CancelEquipmentFilter ->
            { model | selectedTab = Details } ! []

        ClearEquipmentFilter ->
            let
                fm =
                    { model
                        | filterState = NoFilter
                        , filterScratchEquipment = EquipmentBase.emptyEquipment
                        , selectedEquipmentIndex = Nothing
                    }
            in
                (filteredModel fm) ! []

        SetFilterFirstName value ->
            let
                equipment =
                    model.filterScratchEquipment

                new_equipment =
                    { equipment | equipment_name = value }
            in
                { model | filterScratchEquipment = new_equipment } ! []

        SetFilterLastName value ->
            let
                equipment =
                    model.filterScratchEquipment

                new_equipment =
                    { equipment | equipment_code = value }
            in
                { model | filterScratchEquipment = new_equipment } ! []

        ToggleFilterRole roleID ->
            -- let
            --     equipment =
            --         model.filterScratchEquipment
            --
            --     roleSet =
            --         equipment.roles
            --
            --     newRoleSet =
            --         case Set.member roleID roleSet of
            --             True ->
            --                 Set.remove roleID roleSet
            --
            --             False ->
            --                 Set.insert roleID roleSet
            --
            --     newEquipment =
            --         { equipment | roles = newRoleSet }
            -- in
            --     { model | filterScratchEquipment = newEquipment } ! []
            model ! []



{- Rotate table ordering : Ascending -> Descending -> No sorting -> ... -}
--this should be a utility function.  Should we have to have a reference to a rendering module to determine sort order?


toggleSort : Maybe Table.Order -> Maybe Table.Order
toggleSort order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Just Table.Ascending

        Nothing ->
            Just Table.Ascending


populateScratchEquipmentData : Maybe EquipmentBase.Equipment -> Maybe Int -> Equipment.Model -> Equipment.FormAction -> Equipment.Model
populateScratchEquipmentData maybeEquipment maybeEquipmentIndex model action =
    case maybeEquipment of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchEquipment = EquipmentBase.emptyEquipment
                , formAction = action
                , selectedEquipmentId = Nothing
                , selectedEquipmentIndex = Nothing
            }

        Just u ->
            --if we only have role ids, not the whole role record, then we won't need the first map function
            { model
                | scratchEquipment = EquipmentBase.Equipment u.id u.equipment_name u.equipment_code u.class_id u.class_name u.precision_id u.precision
                , formAction = action
                , selectedEquipmentId = Just u.id
                , selectedEquipmentIndex = maybeEquipmentIndex
            }


sort_by_equipment_name : EquipmentBase.Equipment -> String
sort_by_equipment_name u =
    u.equipment_name


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


applyFilter : EquipmentBase.Equipment -> Array EquipmentBase.Equipment -> Array EquipmentBase.Equipment
applyFilter filterEquipment equipmentArray =
    -- Array.filter
    --     (\equipmentWithRole ->
    --         let
    --             equipmentRoleSet =
    --                 List.map (\r -> r.id) equipmentWithRole.roles
    --                     |> Set.fromList
    --         in
    --             Set.size (Set.intersect filterEquipment.roles equipmentRoleSet) > 0
    --     )
    equipmentArray


filteredModel : Equipment.Model -> Equipment.Model
filteredModel model =
    let
        filteredEquipment =
            case model.filterState of
                Applied ->
                    applyFilter model.filterScratchEquipment model.equipment

                _ ->
                    model.equipment

        equipmentCount =
            Array.length filteredEquipment

        ( selectedEquipmentId, selectedEquipmentIndex, firstIndex, lastIndex ) =
            case model.selectedEquipmentIndex of
                Nothing ->
                    let
                        firstEquipment =
                            Array.get 0 filteredEquipment

                        firstIdx =
                            0

                        lastIdx =
                            if equipmentCount > model.pageSize then
                                model.pageSize - 1
                            else
                                equipmentCount - 1
                    in
                        case firstEquipment of
                            Nothing ->
                                ( Nothing, Nothing, -1, -1 )

                            Just equipment ->
                                ( Just equipment.id, Just 0, firstIdx, lastIdx )

                _ ->
                    ( model.selectedEquipmentId, model.selectedEquipmentIndex, model.startDisplayIndex, model.endDisplayIndex )

        --if we have done an edit then the selected equipment and index will stay the same
    in
        { model
            | selectedEquipmentId = selectedEquipmentId
            , selectedEquipmentIndex = selectedEquipmentIndex
            , startDisplayIndex = firstIndex
            , endDisplayIndex = lastIndex
            , filteredEquipment = filteredEquipment
            , errors = Nothing
        }
