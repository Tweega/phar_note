module PharNoteApp.EquipmentClass.Update exposing (..)

import PharNoteApp.EquipmentClass.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.EquipmentClass.Model exposing (RefDataStatus(..), FilterState(..), EquipmentClassTab(..))
import PharNoteApp.EquipmentClass.Rest as Rest
import PharNoteApp.EquipmentClass.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table
import Array exposing (fromList, Array)
import Dict exposing (Dict)
import Set exposing (Set)


update : Msg -> EquipmentClass.Model -> ( EquipmentClass.Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        SelectTab userTab ->
            { model | selectedTab = userTab } ! []

        KeyX key ->
            let
                userCount =
                    Array.length (model.classes)

                currentIdx =
                    case model.selectedEquipmentClassIndex of
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
                    View.maybeFindEquipmentClass (Just idx) model.filteredEquipmentClasss

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedEquipmentClassId = Just u.id
                                , selectedEquipmentClassIndex = Just idx
                                , startDisplayIndex = startIndex
                                , endDisplayIndex = endIndex
                            }

                        _ ->
                            model

                --populateScratchEquipmentClassData user (Just idx) model model.formAction
            in
                newModel ! []

        SelectEquipmentClass idx ->
            let
                index =
                    model.startDisplayIndex + idx

                user =
                    View.maybeFindEquipmentClass (Just index) model.classes

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedEquipmentClassId = Just u.id
                                , selectedEquipmentClassIndex = Just index
                            }

                        _ ->
                            model

                --populateScratchEquipmentClassData user (Just idx) model model.formAction
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

                sortedEquipmentClasss =
                    sort (Array.toList model.classes) |> Array.fromList

                nextEquipmentClass =
                    View.alwaysFindEquipmentClass model.selectedEquipmentClassIndex sortedEquipmentClasss
            in
                --the user index and id will nno longer match up now.  Either need to find current user, or keep selector on same page/offset
                { model | order = sortOrder, classes = sortedEquipmentClasss, selectedEquipmentClassId = Just nextEquipmentClass.id } ! []

        CancelDeleteEquipmentClass ->
            { model | formAction = EquipmentClass.None } ! []

        ConfirmDeleteEquipmentClass ->
            let
                idx =
                    model.selectedEquipmentClassIndex

                usr =
                    View.maybeFindEquipmentClass idx model.classes
            in
                { model | formAction = EquipmentClass.ConfirmDelete } ! []

        DeleteEquipmentClass ->
            let
                idx =
                    model.selectedEquipmentClassIndex

                usr =
                    View.maybeFindEquipmentClass idx model.classes
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

                            ( maybeNextEquipmentClass, nextIndex ) =
                                case View.maybeFindEquipmentClass (Just (i + 1)) model.filteredEquipmentClasss of
                                    Nothing ->
                                        case View.maybeFindEquipmentClass (Just (i - 1)) model.filteredEquipmentClasss of
                                            Nothing ->
                                                ( Nothing, -1 )

                                            Just uu ->
                                                ( Just uu, i - 1 )

                                    Just u ->
                                        ( Just u, i )

                            newModel =
                                case maybeNextEquipmentClass of
                                    Nothing ->
                                        { model
                                            | formAction = EquipmentClass.Delete
                                            , selectedEquipmentClassId = Just user.id
                                        }

                                    Just nextEquipmentClass ->
                                        { model
                                            | formAction = EquipmentClass.Delete
                                            , selectedEquipmentClassId = Just user.id
                                            , previousSelectedEquipmentClassId = Just nextEquipmentClass.id
                                            , previousSelectedEquipmentClassIndex = Just nextIndex
                                        }
                        in
                            newModel ! [ Rest.delete user ]

        EditEquipmentClass ->
            let
                idx =
                    model.selectedEquipmentClassIndex

                user =
                    View.maybeFindEquipmentClass idx model.classes

                newModel =
                    populateScratchEquipmentClassData user idx model EquipmentClass.Edit
            in
                newModel
                    ! []

        NewEquipmentClass ->
            { model
                | formAction = EquipmentClass.Create
                , scratchEquipmentClass = EquipmentClass.emptyEquipmentClassWithRoleSet
                , selectedEquipmentClassId = Nothing
                , selectedEquipmentClassIndex = Nothing
                , previousSelectedEquipmentClassIndex = model.selectedEquipmentClassIndex
                , previousSelectedEquipmentClassId = model.selectedEquipmentClassId
            }
                ! []

        CancelNewEquipmentClass ->
            let
                newModel =
                    case model.formAction of
                        EquipmentClass.Create ->
                            { model
                                | formAction = EquipmentClass.CancelNewEquipmentClass
                                , selectedEquipmentClassId = model.previousSelectedEquipmentClassId
                                , selectedEquipmentClassIndex = model.previousSelectedEquipmentClassIndex
                            }

                        _ ->
                            { model
                                | formAction = EquipmentClass.CancelNewEquipmentClass
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
                    | refDataStatus = Loaded (EquipmentClass.RefData roleDict)
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

        ProcessEquipmentClassGet (Ok classes) ->
            let
                classesArray =
                    Array.fromList (classes)
            in
                { model | classes = classesArray } ! []

        ProcessEquipmentClassGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessEquipmentClassPost (Ok user) ->
            { model | formAction = EquipmentClass.None } ! [ Rest.get ]

        ProcessEquipmentClassPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessEquipmentClassDelete (Ok user) ->
            -- need to set current user to previousSelectedEquipmentClassId
            { model
                | formAction = EquipmentClass.None
                , selectedEquipmentClassId = model.previousSelectedEquipmentClassId
                , selectedEquipmentClassIndex = model.previousSelectedEquipmentClassIndex
            }
                ! [ Rest.get ]

        ProcessEquipmentClassDelete (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        EquipmentClassPost user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            EquipmentClass.scratchToEquipmentClassWithRoles model.scratchEquipmentClass refData
                    in
                        model ! [ Rest.post userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        EquipmentClassPut user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            EquipmentClass.scratchToEquipmentClassWithRoles model.scratchEquipmentClass refData
                    in
                        model ! [ Rest.put userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        SetFirstName value ->
            let
                user =
                    model.scratchEquipmentClass

                new_user =
                    { user | first_name = value }
            in
                { model | scratchEquipmentClass = new_user } ! []

        SetLastName value ->
            let
                user =
                    model.scratchEquipmentClass

                new_user =
                    { user | last_name = value }
            in
                { model | scratchEquipmentClass = new_user } ! []

        SetEmail value ->
            let
                user =
                    model.scratchEquipmentClass

                new_user =
                    { user | email = value }
            in
                { model | scratchEquipmentClass = new_user } ! []

        SetPhotoUrl value ->
            let
                user =
                    model.scratchEquipmentClass

                new_user =
                    { user | photo_url = value }
            in
                { model | scratchEquipmentClass = new_user } ! []

        ToggleRole roleID ->
            let
                user =
                    model.scratchEquipmentClass

                roleSet =
                    user.roles

                newRoleSet =
                    case Set.member roleID roleSet of
                        True ->
                            Set.remove roleID roleSet

                        False ->
                            Set.insert roleID roleSet

                newEquipmentClass =
                    { user | roles = newRoleSet }
            in
                { model | scratchEquipmentClass = newEquipmentClass } ! []

        EquipmentClassSlider valuePC ->
            let
                len =
                    Array.length model.classes

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

        PaginateEquipmentClass page ->
            let
                g =
                    Debug.log "page" page

                idx =
                    Maybe.withDefault 0 model.selectedEquipmentClassIndex

                offset =
                    idx - model.startDisplayIndex

                s =
                    page * model.pageSize

                userCount =
                    Array.length model.classes

                start =
                    if userCount - s < model.pageSize then
                        userCount - model.pageSize
                    else
                        s

                end =
                    start + model.pageSize - 1

                nextIdx =
                    start + offset

                nextEquipmentClass =
                    View.alwaysFindEquipmentClass (Just nextIdx) model.classes
            in
                { model
                    | startDisplayIndex = start
                    , endDisplayIndex = end
                    , selectedEquipmentClassId = Just nextEquipmentClass.id
                    , selectedEquipmentClassIndex = Just nextIdx
                }
                    ! []


toggleSort : Maybe Table.Order -> Maybe Table.Order
toggleSort order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Just Table.Ascending

        Nothing ->
            Just Table.Ascending


populateScratchEquipmentClassData : Maybe EquipmentClass.EquipmentClassWithRoles -> Maybe Int -> EquipmentClass.Model -> EquipmentClass.FormAction -> EquipmentClass.Model
populateScratchEquipmentClassData maybeEquipmentClass maybeEquipmentClassIndex model action =
    case maybeEquipmentClass of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchEquipmentClass = EquipmentClass.emptyEquipmentClassWithRoleSet
                , formAction = action
                , selectedEquipmentClassId = Nothing
                , selectedEquipmentClassIndex = Nothing
            }

        Just u ->
            --if we only have role ids, not the whole role record, then we won't need the first map function
            let
                roleSet =
                    List.map (\r -> r.id) u.roles
                        |> Set.fromList
            in
                { model
                    | scratchEquipmentClass = EquipmentClass.EquipmentClassWithRoleSet u.id u.first_name u.last_name u.email u.photo_url roleSet
                    , formAction = action
                    , selectedEquipmentClassId = Just u.id
                    , selectedEquipmentClassIndex = maybeEquipmentClassIndex
                }


sort_by_last_first : EquipmentClass.EquipmentClassWithRoles -> String
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


applyFilter : EquipmentClass.EquipmentClassWithRoleSet -> Array EquipmentClass.EquipmentClassWithRoles -> Array EquipmentClass.EquipmentClassWithRoles
applyFilter filterEquipmentClass userArray =
    Array.filter
        (\userWithRole ->
            let
                userRoleSet =
                    List.map (\r -> r.id) userWithRole.roles
                        |> Set.fromList
            in
                Set.size (Set.intersect filterEquipmentClass.roles userRoleSet) > 0
        )
        userArray


filteredModel : EquipmentClass.Model -> EquipmentClass.Model
filteredModel model =
    let
        filteredEquipmentClasss =
            case model.filterState of
                Applied ->
                    applyFilter model.filterScratchEquipmentClass model.users

                _ ->
                    model.users

        userCount =
            Array.length filteredEquipmentClasss

        ( selectedEquipmentClassId, selectedEquipmentClassIndex, firstIndex, lastIndex ) =
            case model.selectedEquipmentClassIndex of
                Nothing ->
                    let
                        firstEquipmentClass =
                            Array.get 0 filteredEquipmentClasss

                        firstIdx =
                            0

                        lastIdx =
                            if userCount > model.pageSize then
                                model.pageSize - 1
                            else
                                userCount - 1
                    in
                        case firstEquipmentClass of
                            Nothing ->
                                ( Nothing, Nothing, -1, -1 )

                            Just user ->
                                ( Just user.id, Just 0, firstIdx, lastIdx )

                _ ->
                    ( model.selectedEquipmentClassId, model.selectedEquipmentClassIndex, model.startDisplayIndex, model.endDisplayIndex )

        --if we have done an edit then the selected user and index will stay the same
    in
        { model
            | selectedEquipmentClassId = selectedEquipmentClassId
            , selectedEquipmentClassIndex = selectedEquipmentClassIndex
            , startDisplayIndex = firstIndex
            , endDisplayIndex = lastIndex
            , filteredEquipmentClasss = filteredEquipmentClasss
            , errors = Nothing
        }
