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

        SelectTab userTab ->
            { model | selectedTab = userTab } ! []

        KeyX key ->
            let
                userCount =
                    Array.length (model.filteredEquipments)

                currentIdx =
                    case model.selectedEquipmentIndex of
                        Nothing ->
                            -1

                        Just ndx ->
                            ndx

                idx =
                    if key == 38 && currentIdx > 0 then
                        currentIdx - 1
                    else if key == 40 && currentIdx < userCount - 1 then
                        currentIdx + 1
                    else
                        currentIdx

                --if selected user is off the beginning of screen then start window from index
                startIndex =
                    if idx < model.startDisplayIndex then
                        idx
                    else if idx > model.endDisplayIndex then
                        model.endDisplayIndex - model.pageSize + 2
                    else
                        model.startDisplayIndex

                endIndex =
                    startIndex + model.pageSize - 1

                user =
                    View.maybeFindEquipment (Just idx) model.filteredEquipments

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedEquipmentId = Just u.id
                                , selectedEquipmentIndex = Just idx
                                , startDisplayIndex = startIndex
                                , endDisplayIndex = endIndex
                            }

                        _ ->
                            model

                --populateScratchEquipmentData user (Just idx) model model.formAction
            in
                newModel ! []

        SelectEquipment idx ->
            let
                index =
                    model.startDisplayIndex + idx

                user =
                    View.maybeFindEquipment (Just index) model.filteredEquipments

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedEquipmentId = Just u.id
                                , selectedEquipmentIndex = Just index
                            }

                        _ ->
                            model

                --populateScratchEquipmentData user (Just idx) model model.formAction
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
                            List.sortBy sort_by_last_first

                        Just Table.Descending ->
                            List.sortWith (\x y -> reverse (sort_by_last_first x) (sort_by_last_first y))

                        Nothing ->
                            identity

                sortedEquipments =
                    sort (Array.toList model.filteredEquipments) |> Array.fromList

                nextEquipment =
                    View.alwaysFindEquipment model.selectedEquipmentIndex sortedEquipments
            in
                --the user index and id will nno longer match up now.  Either need to find current user, or keep selector on same page/offset
                { model | order = sortOrder, filteredEquipments = sortedEquipments, selectedEquipmentId = Just nextEquipment.id } ! []

        CancelDeleteEquipment ->
            { model | formAction = Equipment.None } ! []

        ConfirmDeleteEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                usr =
                    View.maybeFindEquipment idx model.filteredEquipments
            in
                { model | formAction = Equipment.ConfirmDelete } ! []

        DeleteEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                usr =
                    View.maybeFindEquipment idx model.filteredEquipments
            in
                case usr of
                    Nothing ->
                        model ! []

                    Just user ->
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
                                case View.maybeFindEquipment (Just (i + 1)) model.filteredEquipments of
                                    Nothing ->
                                        case View.maybeFindEquipment (Just (i - 1)) model.filteredEquipments of
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
                                            , selectedEquipmentId = Just user.id
                                        }

                                    Just nextEquipment ->
                                        { model
                                            | formAction = Equipment.Delete
                                            , selectedEquipmentId = Just user.id
                                            , previousSelectedEquipmentId = Just nextEquipment.id
                                            , previousSelectedEquipmentIndex = Just nextIndex
                                        }
                        in
                            newModel ! [ Rest.delete user ]

        EditEquipment ->
            let
                idx =
                    model.selectedEquipmentIndex

                user =
                    View.maybeFindEquipment idx model.filteredEquipments

                newModel =
                    populateScratchEquipmentData user idx model Equipment.Edit
            in
                newModel
                    ! []

        NewEquipment ->
            { model
                | formAction = Equipment.Create
                , scratchEquipment = Equipment.emptyEquipmentWithRoleSet
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

        ProcessRefDataGet (Ok roles) ->
            let
                roleDict =
                    List.map (\role -> ( role.id, role )) roles
                        |> Dict.fromList
            in
                { model
                    | refDataStatus = Loaded (Equipment.RefData roleDict)
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

        ProcessEquipmentGet (Ok users) ->
            let
                userArray =
                    Array.fromList (users)

                newModel =
                    filteredModel { model | users = userArray }
            in
                newModel ! []

        ProcessEquipmentGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessEquipmentPost (Ok user) ->
            { model | formAction = Equipment.None } ! [ Rest.get ]

        ProcessEquipmentPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessEquipmentDelete (Ok user) ->
            -- need to set current user to previousSelectedEquipmentId
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

        EquipmentPost user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            Equipment.scratchToEquipmentWithRoles model.scratchEquipment refData
                    in
                        model ! [ Rest.post userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        EquipmentPut user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            Equipment.scratchToEquipmentWithRoles model.scratchEquipment refData
                    in
                        model ! [ Rest.put userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        SetFirstName value ->
            let
                user =
                    model.scratchEquipment

                new_user =
                    { user | first_name = value }
            in
                { model | scratchEquipment = new_user } ! []

        SetLastName value ->
            let
                user =
                    model.scratchEquipment

                new_user =
                    { user | last_name = value }
            in
                { model | scratchEquipment = new_user } ! []

        SetEmail value ->
            let
                user =
                    model.scratchEquipment

                new_user =
                    { user | email = value }
            in
                { model | scratchEquipment = new_user } ! []

        SetPhotoUrl value ->
            let
                user =
                    model.scratchEquipment

                new_user =
                    { user | photo_url = value }
            in
                { model | scratchEquipment = new_user } ! []

        ToggleRole roleID ->
            let
                user =
                    model.scratchEquipment

                roleSet =
                    user.roles

                newRoleSet =
                    case Set.member roleID roleSet of
                        True ->
                            Set.remove roleID roleSet

                        False ->
                            Set.insert roleID roleSet

                newEquipment =
                    { user | roles = newRoleSet }
            in
                { model | scratchEquipment = newEquipment } ! []

        EquipmentSlider valuePC ->
            let
                len =
                    Array.length model.filteredEquipments

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
                    , userSliderValue = valuePC
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

                userCount =
                    Array.length model.filteredEquipments

                start =
                    if userCount - s < model.pageSize then
                        userCount - model.pageSize
                    else
                        s

                end =
                    start + model.pageSize - 1

                nextIdx =
                    start + offset

                nextEquipment =
                    View.alwaysFindEquipment (Just nextIdx) model.filteredEquipments
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
            { model | filterScratchEquipment = Equipment.emptyEquipmentWithRoleSet } ! []

        CancelEquipmentFilter ->
            { model | selectedTab = Details } ! []

        ClearEquipmentFilter ->
            let
                fm =
                    { model
                        | filterState = NoFilter
                        , filterScratchEquipment = Equipment.emptyEquipmentWithRoleSet
                        , selectedEquipmentIndex = Nothing
                    }
            in
                (filteredModel fm) ! []

        SetFilterFirstName value ->
            let
                user =
                    model.filterScratchEquipment

                new_user =
                    { user | first_name = value }
            in
                { model | filterScratchEquipment = new_user } ! []

        SetFilterLastName value ->
            let
                user =
                    model.filterScratchEquipment

                new_user =
                    { user | last_name = value }
            in
                { model | filterScratchEquipment = new_user } ! []

        ToggleFilterRole roleID ->
            let
                user =
                    model.filterScratchEquipment

                roleSet =
                    user.roles

                newRoleSet =
                    case Set.member roleID roleSet of
                        True ->
                            Set.remove roleID roleSet

                        False ->
                            Set.insert roleID roleSet

                newEquipment =
                    { user | roles = newRoleSet }
            in
                { model | filterScratchEquipment = newEquipment } ! []



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


populateScratchEquipmentData : Maybe Equipment.EquipmentWithRoles -> Maybe Int -> Equipment.Model -> Equipment.FormAction -> Equipment.Model
populateScratchEquipmentData maybeEquipment maybeEquipmentIndex model action =
    case maybeEquipment of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchEquipment = Equipment.emptyEquipmentWithRoleSet
                , formAction = action
                , selectedEquipmentId = Nothing
                , selectedEquipmentIndex = Nothing
            }

        Just u ->
            --if we only have role ids, not the whole role record, then we won't need the first map function
            let
                roleSet =
                    List.map (\r -> r.id) u.roles
                        |> Set.fromList
            in
                { model
                    | scratchEquipment = Equipment.EquipmentWithRoleSet u.id u.first_name u.last_name u.email u.photo_url roleSet
                    , formAction = action
                    , selectedEquipmentId = Just u.id
                    , selectedEquipmentIndex = maybeEquipmentIndex
                }


sort_by_last_first : Equipment.EquipmentWithRoles -> String
sort_by_last_first u =
    u.last_name ++ u.first_name


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


applyFilter : Equipment.EquipmentWithRoleSet -> Array Equipment.EquipmentWithRoles -> Array Equipment.EquipmentWithRoles
applyFilter filterEquipment userArray =
    Array.filter
        (\userWithRole ->
            let
                userRoleSet =
                    List.map (\r -> r.id) userWithRole.roles
                        |> Set.fromList
            in
                Set.size (Set.intersect filterEquipment.roles userRoleSet) > 0
        )
        userArray


filteredModel : Equipment.Model -> Equipment.Model
filteredModel model =
    let
        filteredEquipments =
            case model.filterState of
                Applied ->
                    applyFilter model.filterScratchEquipment model.users

                _ ->
                    model.users

        userCount =
            Array.length filteredEquipments

        ( selectedEquipmentId, selectedEquipmentIndex, firstIndex, lastIndex ) =
            case model.selectedEquipmentIndex of
                Nothing ->
                    let
                        firstEquipment =
                            Array.get 0 filteredEquipments

                        firstIdx =
                            0

                        lastIdx =
                            if userCount > model.pageSize then
                                model.pageSize - 1
                            else
                                userCount - 1
                    in
                        case firstEquipment of
                            Nothing ->
                                ( Nothing, Nothing, -1, -1 )

                            Just user ->
                                ( Just user.id, Just 0, firstIdx, lastIdx )

                _ ->
                    ( model.selectedEquipmentId, model.selectedEquipmentIndex, model.startDisplayIndex, model.endDisplayIndex )

        --if we have done an edit then the selected user and index will stay the same
    in
        { model
            | selectedEquipmentId = selectedEquipmentId
            , selectedEquipmentIndex = selectedEquipmentIndex
            , startDisplayIndex = firstIndex
            , endDisplayIndex = lastIndex
            , filteredEquipments = filteredEquipments
            , errors = Nothing
        }
