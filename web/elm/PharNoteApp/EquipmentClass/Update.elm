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
                                    View.maybeFindPrecision class.precisions (Just idx)
                            in
                                case precision of
                                    Just p ->
                                        { model
                                            | selectedPrecisionId = Just p.id
                                            , selectedPrecisionIndex = Just idx

                                            --, scratchPrecision = EquipmentClass.Precision p.id p.precision
                                        }

                                    _ ->
                                        model
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

                    Just ec ->
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
                                            , selectedEquipmentClassId = Just ec.id
                                        }

                                    Just nextEquipmentClass ->
                                        { model
                                            | formAction = EquipmentClass.Delete
                                            , selectedEquipmentClassId = Just ec.id
                                            , previousSelectedEquipmentClassId = Just nextEquipmentClass.id
                                            , previousSelectedEquipmentClassIndex = Just nextIndex
                                        }
                        in
                            newModel ! [ Rest.delete ec ]

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
                                | formAction = EquipmentClass.None
                                , selectedEquipmentClassId = model.previousSelectedEquipmentClassId
                                , selectedEquipmentClassIndex = model.previousSelectedEquipmentClassIndex
                                , precisionAction = EquipmentClass.PrecisionNone
                                , selectedPrecisionId = model.previousSelectedPrecisionId

                                --, selectedPrecisionIndex = model.previousSelectedPrecisionIndex
                            }

                        _ ->
                            { model
                                | formAction = EquipmentClass.None
                                , precisionAction = EquipmentClass.PrecisionNone
                            }
            in
                newModel ! []

        CancelNewPrecision ->
            let
                newModel =
                    case model.precisionAction of
                        EquipmentClass.PrecisionCreate ->
                            { model
                                | precisionAction = EquipmentClass.PrecisionNone
                                , selectedPrecisionId = model.previousSelectedPrecisionId
                                , selectedPrecisionIndex = model.previousSelectedPrecisionIndex
                            }

                        _ ->
                            { model
                                | precisionAction = EquipmentClass.PrecisionNone
                            }
            in
                newModel ! []

        CancelDeletePrecision ->
            { model | precisionAction = EquipmentClass.PrecisionNone } ! []

        ConfirmDeletePrecision ->
            { model | precisionAction = EquipmentClass.PrecisionConfirmDelete } ! []

        DeletePrecision ->
            --all we want to do here is to remove the selected index from the precisions array in the class scratch object - do we want a confirmation?
            --should we not be able to assume that this precision definitely exists?
            let
                precisions =
                    model.scratchEquipmentClass.precisions

                maybeNewModel =
                    model.selectedPrecisionIndex
                        |> Maybe.andThen
                            (\precisionIndex ->
                                Array.get precisionIndex precisions
                                    |> Maybe.andThen
                                        (\p ->
                                            Just ( p, precisionIndex )
                                        )
                            )
                        |> Maybe.andThen
                            (\( precision, precisionIndex ) ->
                                let
                                    ( maybeNextPrecision, nextIndex ) =
                                        case View.maybeFindPrecision precisions (Just (precisionIndex + 1)) of
                                            Nothing ->
                                                case View.maybeFindPrecision precisions (Just (precisionIndex - 1)) of
                                                    Nothing ->
                                                        ( Nothing, -1 )

                                                    Just precis ->
                                                        ( Just precis, precisionIndex - 1 )

                                            Just prec ->
                                                ( Just prec, precisionIndex )

                                    newPrecisions =
                                        removeArrayItem precisionIndex precisions

                                    sc =
                                        model.scratchEquipmentClass

                                    --we need to update an element of an array(classes) so we will have to do a split
                                    newScratchClass =
                                        { sc | precisions = newPrecisions }

                                    newModel =
                                        case maybeNextPrecision of
                                            Nothing ->
                                                { model
                                                    | precisionAction = EquipmentClass.PrecisionNone
                                                    , selectedPrecisionId = Just precision.id
                                                    , scratchEquipmentClass = newScratchClass
                                                }

                                            Just nextPrecision ->
                                                { model
                                                    | precisionAction = EquipmentClass.PrecisionNone
                                                    , selectedPrecisionId = Just nextPrecision.id
                                                    , selectedPrecisionIndex = Just nextIndex
                                                    , previousSelectedPrecisionId = Just nextPrecision.id
                                                    , previousSelectedPrecisionIndex = Just nextIndex
                                                    , scratchEquipmentClass = newScratchClass
                                                }
                                in
                                    Just newModel
                            )
            in
                case maybeNewModel of
                    Nothing ->
                        model ! []

                    Just m ->
                        m ! []

        ProcessEquipmentClassGet (Ok classes) ->
            let
                --for each class, change precisions to an Array
                classesArray =
                    List.foldl
                        (\class acc ->
                            let
                                precisionArray =
                                    Array.fromList class.precisions

                                newClass =
                                    { class | precisions = precisionArray }
                            in
                                Array.push newClass acc
                        )
                        Array.empty
                        classes

                -- classesArray =
                --     Array.fromList (classes)
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
                -- classWithPrecisions =
                --     EquipmentClass.scratchToEquipmentClassWithPrecisionString model.scratchEquipmentClass
                x =
                    Debug.log "classWithPrecisions" model.scratchEquipmentClass
            in
                model ! [ Rest.post model.scratchEquipmentClass ]

        EquipmentClassPut user ->
            model ! [ Rest.put model.scratchEquipmentClass ]

        PrecisionPut ->
            --we want to update the class scratch
            --get the scratch class object--get the precisions of that--update the necessary one
            let
                maybeNewClass =
                    model.selectedPrecisionIndex
                        |> Maybe.andThen
                            (\precisionIndex ->
                                Array.get precisionIndex model.scratchEquipmentClass.precisions
                                    |> Maybe.andThen
                                        (\oldPrecision ->
                                            let
                                                newPrecision =
                                                    { oldPrecision | precision = model.scratchPrecision.precision }

                                                newPrecisions =
                                                    Array.set precisionIndex newPrecision model.scratchEquipmentClass.precisions

                                                sc =
                                                    model.scratchEquipmentClass
                                            in
                                                Just { sc | precisions = newPrecisions }
                                        )
                            )

                newModel =
                    case maybeNewClass of
                        Nothing ->
                            model

                        Just class ->
                            { model
                                | scratchEquipmentClass = class
                                , precisionAction = EquipmentClass.PrecisionNone
                            }
            in
                newModel ! []

        PrecisionPost ->
            --we want to update the class scratch
            --get the scratch class object--get the precisions of that--update the necessary one
            -- onto the end of the scratch precisions, append the scratch precision
            let
                newPrecisions =
                    Array.push model.scratchPrecision model.scratchEquipmentClass.precisions

                sc =
                    model.scratchEquipmentClass

                newClass =
                    { sc | precisions = newPrecisions }

                newModel =
                    { model
                        | scratchEquipmentClass = newClass
                        , precisionAction = EquipmentClass.PrecisionNone
                    }
            in
                newModel ! []

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
            let
                tempIdx =
                    Array.length model.scratchEquipmentClass.precisions

                tempId =
                    tempIdx * -1
            in
                { model
                    | precisionAction = EquipmentClass.PrecisionCreate
                    , scratchPrecision = EquipmentClass.Precision tempId ""
                    , selectedPrecisionId = Just tempId
                    , selectedPrecisionIndex = Just tempIdx
                    , previousSelectedPrecisionIndex = model.selectedPrecisionIndex
                    , previousSelectedPrecisionId = model.selectedPrecisionId
                }
                    ! []

        EditPrecision ->
            --this is a case for using maybe.andThen
            let
                newModel =
                    let
                        precisionIdx =
                            model.selectedPrecisionIndex

                        precision =
                            View.maybeFindPrecision model.scratchEquipmentClass.precisions precisionIdx

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
                , selectedPrecisionId = Nothing
                , selectedPrecisionIndex = Nothing
            }

        Just class ->
            let
                fp =
                    Array.get 0 class.precisions

                ( firstPrecisionId, firstPrecisionIndex ) =
                    case fp of
                        Just precision ->
                            ( precision.id, 0 )

                        _ ->
                            ( -1, -1 )
            in
                { model
                    | scratchEquipmentClass = EquipmentClass.EquipmentClassWithPrecision class.id class.name class.description class.precisions
                    , formAction = action
                    , selectedEquipmentClassId = Just class.id
                    , selectedEquipmentClassIndex = maybeEquipmentClassIndex
                    , selectedPrecisionId = Just firstPrecisionId
                    , selectedPrecisionIndex = Just firstPrecisionIndex
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
                                            Array.get 0 equip.precisions
                                    in
                                        case fp of
                                            Just precision ->
                                                precision.id

                                            _ ->
                                                -1
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



--this should go in a utility module


removeArrayItem : Int -> Array a -> Array a
removeArrayItem i a =
    let
        a1 =
            Array.slice 0 i a

        a2 =
            Array.slice (i + 1) (Array.length a) a
    in
        Array.append a1 a2



--this should go in a utility module


replaceArrayItem : Maybe Int -> a -> Array a -> Array a
replaceArrayItem maybeI a array_a =
    case maybeI of
        Nothing ->
            array_a

        Just i ->
            let
                a0 =
                    Array.slice 0 i array_a

                a2 =
                    Array.slice (i + 1) (Array.length array_a) array_a

                a1 =
                    Array.push a a0

                x =
                    Debug.log "a0" a0

                y =
                    Debug.log "a1" a1

                z =
                    Debug.log "a2" a2

                w =
                    Debug.log "a" a
            in
                Array.append a1 a2
