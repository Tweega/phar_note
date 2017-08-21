module PharNoteApp.EquipmentClass.Update exposing (..)

import PharNoteApp.EquipmentClass.Msg exposing (Msg(..))
import PharNoteApp.Msg as AppMsg
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
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

        PrecisionKeyX key ->
            model ! []

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
                    View.maybeFindEquipmentClass (Just idx) model.classes

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

        SelectPrecision idx ->
            let
                equipClass =
                    View.maybeFindEquipmentClass model.selectedEquipmentClassIndex model.classes

                newModel =
                    case equipClass of
                        Nothing ->
                            model

                        Just class ->
                            let
                                precision =
                                    View.maybeFindPrecision (Just idx) class.precisions
                            in
                                case precision of
                                    Just p ->
                                        { model
                                            | selectedPrecisionId = Just p.id
                                            , scratchPrecision = EquipmentClass.Precision p.id p.precision
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

                sortedEquipmentClass =
                    sort (Array.toList model.classes) |> Array.fromList

                nextEquipmentClass =
                    View.alwaysFindEquipmentClass model.selectedEquipmentClassIndex sortedEquipmentClass
            in
                --the user index and id will nno longer match up now.  Either need to find current user, or keep selector on same page/offset
                { model | order = sortOrder, classes = sortedEquipmentClass, selectedEquipmentClassId = Just nextEquipmentClass.id } ! []

        CancelDeleteEquipmentClass ->
            { model
                | formAction = EquipmentClass.None
                , precisionAction = EquipmentClass.PrecisionNone
            }
                ! []

        ConfirmDeleteEquipmentClass ->
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
                                case View.maybeFindEquipmentClass (Just (i + 1)) model.classes of
                                    Nothing ->
                                        case View.maybeFindEquipmentClass (Just (i - 1)) model.classes of
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

                eqClass =
                    View.maybeFindEquipmentClass idx model.classes

                newModel =
                    populateScratchEquipmentClassData eqClass idx model EquipmentClass.Edit
            in
                newModel
                    ! []

        NewEquipmentClass ->
            { model
                | formAction = EquipmentClass.Create
                , scratchEquipmentClass = EquipmentClass.emptyEquipmentClassWithPrecision
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
                                , precisionAction = EquipmentClass.CancelNewPrecision
                                , selectedPrecisionId = model.previousSelectedPrecisionId
                                , selectedPrecisionIndex = model.previousSelectedPrecisionIndex
                            }

                        _ ->
                            { model
                                | formAction = EquipmentClass.CancelNewEquipmentClass
                                , precisionAction = EquipmentClass.CancelNewPrecision
                            }
            in
                newModel ! []

        CancelNewPrecision ->
            let
                newModel =
                    case model.precisionAction of
                        EquipmentClass.PrecisionCreate ->
                            { model
                                | precisionAction = EquipmentClass.CancelNewPrecision
                                , selectedPrecisionId = model.previousSelectedPrecisionId
                                , selectedPrecisionIndex = model.previousSelectedPrecisionIndex
                            }

                        _ ->
                            { model
                                | precisionAction = EquipmentClass.CancelNewPrecision
                            }
            in
                newModel ! []

        CancelDeletePrecision ->
            { model | precisionAction = EquipmentClass.PrecisionNone } ! []

        ConfirmDeletePrecision ->
            { model | precisionAction = EquipmentClass.PrecisionConfirmDelete } ! []

        DeletePrecision ->
            let
                classIdx =
                    model.selectedEquipmentClassIndex

                eqClass =
                    View.maybeFindEquipmentClass classIdx model.classes

                ( class, precision ) =
                    case eqClass of
                        Nothing ->
                            ( EquipmentClass.emptyEquipmentClassWithPrecision, Nothing )

                        Just c ->
                            let
                                precisionIdx =
                                    model.selectedPrecisionIndex
                            in
                                ( c, View.maybeFindPrecision precisionIdx c.precisions )
            in
                case precision of
                    Nothing ->
                        model ! []

                    Just p ->
                        --we need to identify a record to be current after successful delete
                        let
                            --this would be a case of using one of those Maybe.andThen things as if idx was Nothing we would not get here.
                            i =
                                case model.selectedPrecisionIndex of
                                    Just x ->
                                        x

                                    _ ->
                                        0

                            ( maybeNextPrecision, nextIndex ) =
                                case View.maybeFindPrecision (Just (i + 1)) class.precisions of
                                    Nothing ->
                                        case View.maybeFindPrecision (Just (i - 1)) class.precisions of
                                            Nothing ->
                                                ( Nothing, -1 )

                                            Just precis ->
                                                ( Just precis, i - 1 )

                                    Just prec ->
                                        ( Just prec, i )

                            newModel =
                                case maybeNextPrecision of
                                    Nothing ->
                                        { model
                                            | precisionAction = EquipmentClass.PrecisionDelete
                                            , selectedPrecisionId = Just p.id
                                        }

                                    Just nextPrecision ->
                                        { model
                                            | precisionAction = EquipmentClass.PrecisionDelete
                                            , selectedPrecisionId = Just p.id
                                            , previousSelectedPrecisionId = Just nextPrecision.id
                                            , previousSelectedPrecisionIndex = Just nextIndex
                                        }
                        in
                            --for the moment, save precisions along with equipment class? or place on separate tab and save separately?
                            --newModel ! [ Rest.delete user ]
                            newModel ! []

        ProcessEquipmentClassGet (Ok classes) ->
            let
                classesArray =
                    Array.fromList (classes)

                new_model =
                    filteredModel model classesArray
            in
                new_model ! []

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
            let
                classWithPrecisions =
                    EquipmentClass.scratchToEquipmentClassWithPrecisionString model.scratchEquipmentClass
            in
                model ! [ Rest.post classWithPrecisions ]

        EquipmentClassPut user ->
            let
                classWithPrecisions =
                    EquipmentClass.scratchToEquipmentClassWithPrecisionString model.scratchEquipmentClass
            in
                model ! [ Rest.put classWithPrecisions ]

        SetClassName value ->
            let
                class =
                    model.scratchEquipmentClass

                new_class =
                    { class | name = value }
            in
                { model | scratchEquipmentClass = new_class } ! []

        SetClassDesc value ->
            let
                class =
                    model.scratchEquipmentClass

                new_class =
                    { class | description = value }
            in
                { model | scratchEquipmentClass = new_class } ! []

        ToggleRole roleID ->
            model ! []

        PaginateEquipmentClass page ->
            let
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

        NewPrecision ->
            { model
                | scratchPrecision = EquipmentClass.emptyPrecision
            }
                ! []

        EditPrecision ->
            --this is a case for using maybe.andThen
            let
                classIdx =
                    model.selectedEquipmentClassIndex

                eqClass =
                    View.maybeFindEquipmentClass classIdx model.classes

                newModel =
                    case eqClass of
                        Nothing ->
                            model

                        Just class ->
                            let
                                precisionIdx =
                                    model.selectedPrecisionIndex

                                precision =
                                    View.maybeFindPrecision precisionIdx class.precisions

                                modl =
                                    populateScratchPrecisionData precision precisionIdx model EquipmentClass.PrecisionEdit
                            in
                                modl
            in
                newModel
                    ! []

        SetPrecision precision ->
            let
                scratchPrecision =
                    model.scratchPrecision

                new_precision =
                    { scratchPrecision | precision = precision }
            in
                { model | scratchPrecision = new_precision } ! []


toggleSort : Maybe Table.Order -> Maybe Table.Order
toggleSort order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Just Table.Ascending

        Nothing ->
            Just Table.Ascending


populateScratchEquipmentClassData : Maybe EquipmentClass.EquipmentClassWithPrecision -> Maybe Int -> EquipmentClass.Model -> EquipmentClass.FormAction -> EquipmentClass.Model
populateScratchEquipmentClassData maybeEquipmentClass maybeEquipmentClassIndex model action =
    case maybeEquipmentClass of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchEquipmentClass = EquipmentClass.emptyEquipmentClassWithPrecision
                , formAction = action
                , selectedEquipmentClassId = Nothing
                , selectedEquipmentClassIndex = Nothing
            }

        Just u ->
            --if we only have role ids, not the whole role record, then we won't need the first map function
            let
                roleSet =
                    List.map (\r -> r.id) u.precisions
                        |> Set.fromList
            in
                { model
                    | scratchEquipmentClass = EquipmentClass.EquipmentClassWithPrecision u.id u.name u.description u.precisions
                    , formAction = action
                    , selectedEquipmentClassId = Just u.id
                    , selectedEquipmentClassIndex = maybeEquipmentClassIndex
                }


populateScratchPrecisionData : Maybe EquipmentClass.Precision -> Maybe Int -> EquipmentClass.Model -> EquipmentClass.PrecisionAction -> EquipmentClass.Model
populateScratchPrecisionData maybePrecision maybePrecisionIndex model action =
    case maybePrecision of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchPrecision = EquipmentClass.emptyPrecision
                , precisionAction = action
                , selectedPrecisionId = Nothing
                , selectedPrecisionIndex = Nothing
            }

        Just p ->
            { model
                | scratchPrecision = EquipmentClass.Precision p.id p.precision
                , precisionAction = action
                , selectedPrecisionId = Just p.id
                , selectedPrecisionIndex = maybePrecisionIndex
            }


sort_by_last_first : EquipmentClass.EquipmentClassWithPrecision -> String
sort_by_last_first u =
    u.name


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


filteredModel : EquipmentClass.Model -> Array EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.Model
filteredModel model classes =
    let
        equipmentCount =
            Array.length classes

        ( selectedEquipmentId, selectedEquipmentIndex, firstIndex, lastIndex, selectedPrecisionId ) =
            case model.selectedEquipmentClassIndex of
                Nothing ->
                    let
                        firstEquipment =
                            Array.get 0 classes

                        firstIdx =
                            0

                        lastIdx =
                            if equipmentCount > model.pageSize then
                                model.pageSize - 1
                            else
                                equipmentCount - 1

                        selectedPrecisionId =
                            case firstEquipment of
                                Nothing ->
                                    -1

                                Just equip ->
                                    let
                                        fp =
                                            List.head equip.precisions
                                    in
                                        case fp of
                                            Just precision ->
                                                precision.id

                                            _ ->
                                                -1

                        x =
                            Debug.log "xxx precision id" selectedPrecisionId
                    in
                        case firstEquipment of
                            Nothing ->
                                ( Nothing, Nothing, -1, -1, Nothing )

                            Just equipment ->
                                ( Just equipment.id, Just 0, firstIdx, lastIdx, Just selectedPrecisionId )

                _ ->
                    ( model.selectedEquipmentClassId, model.selectedEquipmentClassIndex, model.startDisplayIndex, model.endDisplayIndex, model.selectedPrecisionId )

        --if we have done an edit then the selected equipment and index will stay the same
    in
        { model
            | classes = classes
            , selectedEquipmentClassId = selectedEquipmentId
            , selectedPrecisionId = selectedPrecisionId
            , selectedEquipmentClassIndex = selectedEquipmentIndex
            , startDisplayIndex = firstIndex
            , endDisplayIndex = lastIndex
            , errors = Nothing
        }
