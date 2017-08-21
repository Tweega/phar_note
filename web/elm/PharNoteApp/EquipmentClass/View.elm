module PharNoteApp.EquipmentClass.View exposing (view, alwaysFindEquipmentClass, maybeFindEquipmentClass, maybeFindPrecision)

import PharNoteApp.EquipmentClass.Rest as Rest
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.EquipmentClass.Model exposing (FormAction(..), PrecisionAction(..))
import PharNoteApp.EquipmentClass.Msg as EquipmentClassMsg exposing (Msg(..))
import PharNoteApp.Role.BaseModel as RoleBase
import PharNoteApp.Msg as AppMsg
import PharNoteApp.HtmlUtils as HtmlUtils
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Table as Table
import Material.Options as Options exposing (when, nop, css)
import Material.Grid as Grid exposing (..)
import Material.Color as Color
import Material.Tabs as Tabs
import Json.Decode as Json
import Array exposing (..)
import Material
import Material.Icon as Icon
import Material.Tooltip as Tooltip
import Material.Card as Card
import Material.Button as Button
import Material.Toggles as Toggles
import Material.Elevation as Elevation
import Material.Slider as Slider
import Set exposing (Set)
import Dict exposing (Dict)


view : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg
view model mdlStore =
    let
        equipClassTableContents =
            --equipClassTable model.filteredEquipmentClass model.selectedEquipmentClassId model.order model.startDisplayIndex model.endDisplayIndex
            tableCard model mdlStore

        cards =
            case model.formAction of
                Edit ->
                    (editCards model.scratchEquipmentClass model.formAction model.precisionAction model.selectedPrecisionId model.scratchPrecision mdlStore)

                Create ->
                    (editCards model.scratchEquipmentClass model.formAction model.precisionAction model.selectedPrecisionId model.scratchPrecision mdlStore)

                _ ->
                    ((viewCards (alwaysFindEquipmentClass model.selectedEquipmentClassIndex model.classes) model.formAction mdlStore))
    in
        div [ style [ ( "height", "90vh" ), ( "border", "1px solid green" ), ( "overflow-y", "hidden" ) ] ]
            [ grid
                [ Options.many
                    [ css "display" "flex"
                    , css "align-items" "flex-start"
                    , css "justify-content" "space-around"
                    ]
                ]
                [ cell [ Grid.size All 5 ]
                    [ equipClassTableContents
                    , pager model
                    ]
                , cell
                    [ Grid.size All 6
                    , Color.background <| Color.color Color.Red Color.S100
                    ]
                    cards
                ]
            ]


viewCards : EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> Material.Model -> List (Html AppMsg.Msg)
viewCards equipClass action mdlStore =
    [ equipClassCard equipClass action mdlStore
    , Options.div
        [ Grid.size All 1
        , css "height" "32px"
        ]
        []

    --, precisionCard equipClass.precisions mdlStore
    ]


editCards : EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> EquipmentClass.PrecisionAction -> Maybe Int -> EquipmentClass.Precision -> Material.Model -> List (Html AppMsg.Msg)
editCards scratchEquipmentClass action precisionAction maybePrecisionId scratchPrecision mdlStore =
    --check that ref data is loaded.
    let
        html =
            [ equipClassEditCard scratchEquipmentClass action precisionAction maybePrecisionId scratchPrecision mdlStore
            , Options.div
                [ Grid.size All 1
                , css "height" "32px"
                ]
                []

            --, precisionEditCard scratchEquipmentClass.precisions precisionAction maybePrecisionId mdlStore
            ]
    in
        html


maybeFindEquipmentClass : Maybe Int -> Array EquipmentClass.EquipmentClassWithPrecision -> Maybe EquipmentClass.EquipmentClassWithPrecision
maybeFindEquipmentClass maybeIndex equipClass =
    case maybeIndex of
        Just idx ->
            Array.get idx equipClass

        _ ->
            Nothing


maybeFindPrecision : Maybe Int -> List EquipmentClassBase.EquipmentPrecision -> Maybe EquipmentClassBase.EquipmentPrecision
maybeFindPrecision maybeId precisions =
    case precisions of
        [] ->
            Nothing

        precision :: t ->
            if precision.id == Maybe.withDefault -1 maybeId then
                Just precision
            else
                maybeFindPrecision maybeId
                    t


alwaysFindEquipmentClass : Maybe Int -> Array EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.EquipmentClassWithPrecision
alwaysFindEquipmentClass maybeIndex equipClass =
    let
        maybeEquipmentClass =
            case maybeIndex of
                Just idx ->
                    Array.get idx equipClass

                _ ->
                    Nothing
    in
        case maybeEquipmentClass of
            Just usr ->
                usr

            Nothing ->
                EquipmentClass.emptyEquipmentClassWithPrecision


fieldStringValue : Maybe EquipmentClassBase.EquipmentClass -> EquipmentClass.FormAction -> (EquipmentClassBase.EquipmentClass -> String) -> String
fieldStringValue equipClass formAction extractor =
    case equipClass of
        Just equipClass ->
            if formAction == Edit then
                extractor equipClass
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe EquipmentClassBase.EquipmentClass -> EquipmentClass.FormAction -> (EquipmentClassBase.EquipmentClass -> Int) -> String
fieldIntValue equipClass formAction extractor =
    case equipClass of
        Just equipClass ->
            if formAction == Edit then
                extractor equipClass |> toString
            else
                ""

        Nothing ->
            ""


equipClassDetails : EquipmentClass.EquipmentClassWithPrecision -> Html AppMsg.Msg
equipClassDetails equipClass =
    Options.div
        [ css "display" "flex"
        , css "align-items" "flex-start"
        , css "justify-content" "space-between"
        ]
        [ Options.div []
            (List.map
                equipClassInfo
                [ ( "Class Name:", equipClass.name )
                , ( "Class description", equipClass.description )
                ]
            )
        ]


equipClassInfo : ( String, String ) -> Html AppMsg.Msg
equipClassInfo ( fieldName, fieldValue ) =
    Options.div
        [ css "width" "100%"
        , css "float" "left"
        ]
        [ Options.div
            [ css "color" "rgba(0,0,0,0.9)"
            , css "width" "150px"
            , css "float" "left"
            , css "margin-top" "5px"
            ]
            [ text fieldName ]
        , Options.div
            [ css "color" "rgba(f,0,0,0.9)"
            , css "float" "left"
            , css "margin-top" "5px"
            ]
            [ text fieldValue ]
        ]


equipClassEditItem : ( String, String, String -> AppMsg.Msg ) -> Html AppMsg.Msg
equipClassEditItem ( fieldName, fieldValue, equipClassMsg ) =
    div [ class "form-group" ]
        [ label [] [ text fieldName ]
        , input
            [ value fieldValue
            , onInput equipClassMsg
            , class "form-control"
            ]
            []
        ]


equipClassForm : EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> Material.Model -> Html AppMsg.Msg
equipClassForm equipClass action mdlStore =
    div []
        [ div [ class "form-group" ]
            [ label [] [ text "Class Name" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetClassName s)), value equipClass.name, class "form-control" ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Class Description" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetClassDesc s)), value equipClass.description, class "form-control" ] []
            ]

        --, precisionsHeading
        , Options.styled Html.ul
            [ css "list-style-type" "none"
            , css "margin" "0"
            , css "padding" "0"
            ]
            []

        --(precisionOptions equipClass.precisions mdlStore)
        --, button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
        ]


equipClassTable : Array EquipmentClass.EquipmentClassWithPrecision -> Maybe Int -> Maybe Table.Order -> EquipmentClass.FormAction -> Int -> Int -> Html AppMsg.Msg
equipClassTable equipClass selectedEquipmentClassId order action startDisplayIndex endDisplayIndex =
    let
        divAt =
            case action of
                EquipmentClass.None ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.PrecisionKeyX x)) keyCode)
                    ]

                EquipmentClass.CancelNewEquipmentClass ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.PrecisionKeyX x)) keyCode)
                    ]

                _ ->
                    []

        divAttributes =
            [ tabindex 0
            , style
                [ ( "height", "100%" )
                , ( "width", "100%" )
                , ( "overflow-y", "hidden" )
                , ( "overflow-x", "hidden" )
                ]
            ]
                ++ divAt
    in
        div
            divAttributes
            [ Table.table
                [ Options.css "margin" "0px"
                , Options.css "padding" "0px"
                , Options.css "width" "100%"
                ]
                [ equipClassTableHeader order
                , tbody [] (equipClassRows equipClass action selectedEquipmentClassId startDisplayIndex endDisplayIndex)
                ]
            ]


tableCard : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg
tableCard model mdlStore =
    let
        textStuff =
            equipClassTable model.classes model.selectedEquipmentClassId model.order model.formAction model.startDisplayIndex model.endDisplayIndex
    in
        Card.view
            [ css "width" "100%"
            , Color.background (Color.color Color.Yellow Color.S500)

            --, Options.cs "demo-options"
            ]
            [ Card.title
                [ Color.background (Color.color Color.Blue Color.S500)
                , css "padding" "0"

                -- Clear default padding to encompass scrim
                , Color.background <| Color.color Color.Teal Color.S300
                ]
                [ Card.head
                    [ white

                    --, Options.scrim 0.75
                    --, css "padding" "16px"
                    -- Restore default padding inside scrim
                    , css "width" "100%"
                    ]
                    [ text "EquipmentClass" ]
                ]
            , Card.text
                [ css "height" "400px"
                , css "width" "100%"
                ]
                [ Options.div
                    [ css "width" "100%"
                    ]
                    [ textStuff ]
                ]

            -- , Card.actions
            --     [ Card.border
            --     , css "float" "left"
            --     ]
            --actions
            ]


equipClassTableHeader : Maybe Table.Order -> Html AppMsg.Msg
equipClassTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th
                []
                [ text "Class Name" ]
            , Table.th
                [ order
                    |> Maybe.map Table.sorted
                    |> Maybe.withDefault nop
                , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.Reorder)
                ]
                [ text "last Name" ]
            , Table.th [] [ text "Email" ]
            , Table.th [ css "width" "100%" ] [ text "Photo url" ]
            ]
        ]


equipClassRows : Array EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> Maybe Int -> Int -> Int -> List (Html AppMsg.Msg)
equipClassRows equipClass action selectedEquipmentClassId startDisplayIndex endDisplayIndex =
    let
        equipClassId =
            case selectedEquipmentClassId of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        equipClass
            |> Array.slice startDisplayIndex (endDisplayIndex + 1)
            |> Array.toIndexedList
            |> List.map (equipClassRow action equipClassId)



--bit of a pain to have to switch in and out of arrays.  May want to rethink this.  Possibly keep lists and just have an array containing ids backed by a map?
--look at using array.fold(l/r)


equipClassRow : EquipmentClass.FormAction -> Int -> ( Int, EquipmentClass.EquipmentClassWithPrecision ) -> Html AppMsg.Msg
equipClassRow action equipClassId ( idx, equipClass ) =
    let
        f allowSelect =
            []
                |> (\a ->
                        if equipClassId == equipClass.id then
                            Options.css "background-color" "green" :: a
                        else
                            a
                   )
                |> (\a ->
                        if allowSelect == True then
                            Options.onClick (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SelectEquipmentClass idx)) :: a
                        else
                            a
                   )

        row_style =
            case action of
                EquipmentClass.None ->
                    f True

                EquipmentClass.CancelNewEquipmentClass ->
                    f True

                EquipmentClass.Edit ->
                    f False

                EquipmentClass.ConfirmDelete ->
                    f False

                _ ->
                    []
    in
        Table.tr row_style
            [ Table.td [] [ text equipClass.name ]
            , Table.td [] [ text equipClass.description ]

            --precisions tk
            ]


white : Options.Property a b
white =
    Color.text Color.white


black : Options.Property a b
black =
    Color.text Color.black


updatesCard : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg
updatesCard model mdlStore =
    Card.view
        [ Elevation.e2
        , css "width" "100%"
        ]
        [ Card.title
            [ css "background" "url('images/pomegranate.jpg') center / cover"
            , css "min-height" "200px"
            , css "padding" "0"

            -- Clear default padding to encompass scrim
            , Color.background <| Color.color Color.Teal Color.S300
            ]
            [ Card.head
                [ white
                , Options.scrim 0.75
                , css "padding" "16px"

                -- Restore default padding inside scrim
                , css "width" "100%"
                ]
                [ text "Grenadine" ]
            ]
        , Card.text []
            [ text "Non-alcoholic syrup used for both its tart and sweet flavour as well as its deep red color." ]
        , Card.actions
            [ Card.border ]
            [ Button.render AppMsg.Mdl
                [ 1, 0 ]
                mdlStore
                [ Button.ripple, Button.accent ]
                [ text "Ingredients" ]
            ]
        ]


equipClassCard : EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> Material.Model -> Html AppMsg.Msg
equipClassCard equipClass action mdlStore =
    let
        option title index =
            Options.styled Html.li
                [ css "margin" "4px 0" ]
                [ Toggles.checkbox AppMsg.Mdl
                    index
                    mdlStore
                    [ Toggles.ripple
                    , Toggles.value (Maybe.withDefault False Nothing)

                    --somehow we need to get , Options.onToggle (AppMsg.MsgForChart (Toggle index))
                    -- to be List (Material.Toggles.Property Msg)
                    --, Options.onToggle (AppMsg.MsgForChart (ChartMsg.Toggle index))
                    --, Options.onToggle (Toggle index)
                    ]
                    [ text title ]
                ]

        actions =
            case action of
                EquipmentClass.ConfirmDelete ->
                    [ Options.div [ css "background-color" "red", css "overflow" "hidden" ]
                        [ Options.div
                            [ css "background-color" "white", css "float" "right", css "overflow" "hidden" ]
                            [ Button.render AppMsg.Mdl
                                [ 3, 2 ]
                                mdlStore
                                [ Button.ripple
                                , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.CancelDeleteEquipmentClass)
                                , Button.accent
                                , css "float" "right"
                                , Elevation.e2
                                ]
                                [ text "Mistake" ]
                            , Button.render AppMsg.Mdl
                                [ 3, 1 ]
                                mdlStore
                                [ Button.ripple
                                , Button.accent
                                , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.DeleteEquipmentClass)
                                , css "float" "right"
                                , css "margin-right" "1em"
                                , Elevation.e2
                                ]
                                [ text "Do it!" ]
                            ]
                        , Options.span [ css "float" "right", css "margin-right" "2em", css "margin-top" "7px" ] [ text "Are you sure you want to delete this equipClass?" ]
                        ]
                    ]

                _ ->
                    [ Button.render AppMsg.Mdl
                        [ 2, 2 ]
                        mdlStore
                        [ Button.icon

                        --, white
                        , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.NewEquipmentClass)
                        , css "float" "left"
                        ]
                        [ Icon.i "person_add" ]
                    , Button.render AppMsg.Mdl
                        [ 2, 3 ]
                        mdlStore
                        [ Button.icon
                        , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.EditEquipmentClass)
                        , css "float" "left"
                        ]
                        [ Icon.i "mode_edit" ]
                    , Button.render AppMsg.Mdl
                        [ 2, 4 ]
                        mdlStore
                        [ Button.icon
                        , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.ConfirmDeleteEquipmentClass)
                        , css "float" "right"
                        , css "margin-right" "15px"
                        ]
                        [ Icon.i "delete" ]
                    ]

        textStuff =
            if List.length equipClass.precisions > 0 then
                [ equipClassDetails equipClass
                , precisionsHeading
                , precisionDetails equipClass.precisions
                ]
            else
                [ equipClassDetails equipClass
                ]
    in
        Card.view
            [ css "width" "100%"
            , Color.background (Color.color Color.Pink Color.S500)

            --, Options.cs "demo-options"
            ]
            [ Card.title
                [ Color.background (Color.color Color.Blue Color.S500)
                , css "padding" "0"

                -- Clear default padding to encompass scrim
                , Color.background <| Color.color Color.Teal Color.S300
                ]
                [ Card.head
                    [ white

                    --, Options.scrim 0.75
                    --, css "padding" "16px"
                    -- Restore default padding inside scrim
                    --, css "width" "100%"
                    ]
                    [ text "Details" ]
                ]
            , Card.text [ white ]
                [ Options.div [ css "height" "400px" ]
                    textStuff
                ]
            , Card.actions
                [ Card.border
                , css "float" "left"
                ]
                actions
            ]


precisionsHeading : Html AppMsg.Msg
precisionsHeading =
    Options.div
        [ white
        , css "font-size" "1.3em"
        , css "margin-top" "2em"
        ]
        [ text "Precisions"
        ]


precisionCard : List EquipmentClassBase.EquipmentPrecision -> Material.Model -> Html AppMsg.Msg
precisionCard precisions mdlStore =
    let
        option title index =
            Options.styled Html.li
                [ css "margin" "4px 0" ]
                [ Toggles.checkbox AppMsg.Mdl
                    index
                    mdlStore
                    [ Toggles.ripple
                    , Toggles.value (Maybe.withDefault False Nothing)

                    --somehow we need to get , Options.onToggle (AppMsg.MsgForChart (Toggle index))
                    -- to be List (Material.Toggles.Property Msg)
                    --, Options.onToggle (AppMsg.MsgForChart (ChartMsg.Toggle index))
                    --, Options.onToggle (Toggle index)
                    ]
                    [ text title ]
                ]
    in
        Card.view
            [ css "width" "100%"
            , Color.background (Color.color Color.Pink Color.S500)

            --, Options.cs "demo-options"
            ]
            [ Card.title
                [ Color.background (Color.color Color.Blue Color.S500)
                , css "padding" "0"

                -- Clear default padding to encompass scrim
                , Color.background <| Color.color Color.Teal Color.S300
                ]
                [ Card.head
                    [ white

                    --, Options.scrim 0.75
                    --, css "padding" "16px"
                    -- Restore default padding inside scrim
                    --, css "width" "100%"
                    ]
                    [ text "Roles" ]
                ]
            , Card.text [ white ]
                [ precisionDetails precisions
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 2, 2 ]
                    mdlStore
                    [ Button.icon
                    , white
                    , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.NewEquipmentClass)
                    ]
                    [ Icon.i "person_add" ]
                , Button.render AppMsg.Mdl
                    [ 2, 3 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.EditEquipmentClass)
                    ]
                    [ Icon.i "mode_edit_black" ]
                , Button.render AppMsg.Mdl
                    [ 2, 4 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.DeleteEquipmentClass)
                    ]
                    [ Icon.i "delete_black" ]
                , Button.render AppMsg.Mdl
                    [ 2, 5 ]
                    mdlStore
                    [ Button.icon ]
                    [ Icon.i "mode_comment" ]
                ]
            ]


precisionDetails : List EquipmentClassBase.EquipmentPrecision -> Html AppMsg.Msg
precisionDetails precisions =
    Options.div
        [ css "width" "100%"
        , css "float" "left"
        ]
        (List.indexedMap precisionInfo precisions)


precisionInfo : Int -> EquipmentClassBase.EquipmentPrecision -> Html AppMsg.Msg
precisionInfo i precision =
    Options.div
        [ css "width" "100%"
        , css "float" "left"
        , css "margin-top" "5px"
        ]
        [ Options.div
            [ css "color" "rgba(0,0,0,0.9)"
            , css "width" "150px"
            , css "float" "left"
            ]
            [ text precision.precision ]
        ]


equipClassEditCard : EquipmentClass.EquipmentClassWithPrecision -> EquipmentClass.FormAction -> EquipmentClass.PrecisionAction -> Maybe Int -> EquipmentClass.Precision -> Material.Model -> Html AppMsg.Msg
equipClassEditCard scratchEquipmentClass action precisionAction maybePrecisionId scratchPrecision mdlStore =
    let
        buttonText =
            if action == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if action == Edit then
                AppMsg.MsgForEquipmentClass (EquipmentClassMsg.EquipmentClassPut scratchEquipmentClass)
            else
                AppMsg.MsgForEquipmentClass (EquipmentClassMsg.EquipmentClassPost scratchEquipmentClass)

        option title index =
            Options.styled Html.li
                [ css "margin" "4px 0" ]
                [ Toggles.checkbox AppMsg.Mdl
                    index
                    mdlStore
                    [ Toggles.ripple
                    , Toggles.value (Maybe.withDefault False Nothing)

                    --somehow we need to get , Options.onToggle (AppMsg.MsgForChart (Toggle index))
                    -- to be List (Material.Toggles.Property Msg)
                    --, Options.onToggle (AppMsg.MsgForChart (ChartMsg.Toggle index))
                    --, Options.onToggle (Toggle index)
                    ]
                    [ text title ]
                ]
    in
        Card.view
            [ css "width" "100%"
            , Color.background (Color.color Color.Green Color.S500)

            --, Options.cs "demo-options"
            ]
            [ Card.title
                [ Color.background (Color.color Color.Blue Color.S500)
                , css "padding" "0"

                -- Clear default padding to encompass scrim
                , Color.background <| Color.color Color.Teal Color.S300
                ]
                [ Card.head
                    [ white

                    --, Options.scrim 0.75
                    --, css "padding" "16px"
                    -- Restore default padding inside scrim
                    --, css "width" "100%"
                    ]
                    [ text "Details" ]
                ]
            , Card.text [ white ]
                [ equipClassForm scratchEquipmentClass action mdlStore
                , precisionEditCard scratchEquipmentClass.precisions precisionAction maybePrecisionId scratchPrecision mdlStore
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 3, 0 ]
                    mdlStore
                    [ Button.ripple
                    , Button.accent
                    , Options.onClick buttonAction
                    ]
                    [ text buttonText ]
                , Button.render AppMsg.Mdl
                    [ 3, 1 ]
                    mdlStore
                    [ Button.ripple
                    , Button.accent
                    , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.CancelNewEquipmentClass)
                    ]
                    [ text "Cancel" ]
                ]
            ]


precisionEditCardx : List EquipmentClassBase.EquipmentPrecision -> Material.Model -> Html AppMsg.Msg
precisionEditCardx precisionSet mdlStore =
    Card.view
        [ css "width" "100%"
        , Color.background (Color.color Color.Pink Color.S500)
        , Options.cs "demo-options"
        ]
        [ Card.text [ white ]
            [ Options.styled Html.h3
                [ css "font-size" "1em"
                , css "margin" "0"
                ]
                [ text "Options"
                ]
            , Options.styled Html.ul
                [ css "list-style-type" "none"
                , css "margin" "0"
                , css "padding" "0"
                ]
                []

            --(precisionOptions precisionSet mdlStore)
            ]
        , Card.actions
            [ Card.border ]
            [ Button.render AppMsg.Mdl
                [ 11, 1 ]
                mdlStore
                [ Button.ripple, white ]
                [ text "Great" ]
            ]
        ]


pager : EquipmentClass.Model -> Html AppMsg.Msg
pager model =
    let
        pageCount =
            floor (toFloat (Array.length model.classes) / toFloat model.pageSize)

        pageList =
            List.range 0 pageCount

        --|> List.reverse --reverse to have page isons increment from left to right
        currentPage =
            floor (toFloat model.endDisplayIndex / toFloat model.pageSize)

        pageMarker i =
            let
                x =
                    if currentPage == i then
                        [ ( "backgroundColor", "blue" )
                        , ( "border-bottom", "3px solid #73AD21" )
                        ]
                    else
                        [ ( "backgroundColor", "black" ) ]

                styleList =
                    [ ( "display", "inline-block" )
                    , ( "height", "15px" )
                    , ( "width", "15px" )
                    , ( "float", "right" )
                    , ( "margin-top", "5px" )
                    , ( "margin-left", "5px" )

                    --  , ( "border", "3px solid #73AD21" )
                    ]
                        ++ x
            in
                div
                    [ style styleList
                    , HtmlUtils.onClickNoDefault (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.PaginateEquipmentClass i))
                    ]
                    []

        html =
            if pageCount > 0 then
                (List.map pageMarker pageList)
            else
                []
    in
        div
            []
            html



--[]
--
-- slider : EquipmentClass.Model -> Html AppMsg.Msg
-- slider model =
--     p [ style [ ( "width", "300px" ) ] ]
--         [ Slider.view
--             [ Slider.onChange (\value -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.EquipmentClassSlider value))
--             , Slider.value model.equipClassSliderValue
--             ]
--         ]
--precisionEditCard : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg


addAction : List Int -> Material.Model -> AppMsg.Msg -> String -> String -> Bool -> List (Html AppMsg.Msg) -> List (Html AppMsg.Msg)
addAction indexList mdlStore msg float icon include actions =
    if include == True then
        actions
            ++ [ Button.render AppMsg.Mdl
                    indexList
                    mdlStore
                    [ Button.icon
                    , Options.onClick msg
                    , css "float" float
                    ]
                    [ Icon.i icon ]
               ]
    else
        actions


fBool : Bool
fBool =
    True


x : EquipmentClass.Precision -> Html AppMsg.Msg
x scratchPrecision =
    Options.div
        [ css "width" "100%"
        , css "align-self" "flex-end"
        ]
        [ div [ class "form-group" ]
            [ label [] [ text "precision" ]
            , input
                [ value scratchPrecision.precision
                , onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetPrecision s))
                , class "form-control"
                ]
                []
            ]
        , text "buttons here"
        ]


activeEditButtons mdlStore =
    []
        |> addAction
            [ 12, 2 ]
            mdlStore
            (AppMsg.MsgForEquipmentClass EquipmentClassMsg.CancelNewPrecision)
            "left"
            "person_add"
            fBool


precisionEditCard : List EquipmentClassBase.EquipmentPrecision -> EquipmentClass.PrecisionAction -> Maybe Int -> EquipmentClass.Precision -> Material.Model -> Html AppMsg.Msg
precisionEditCard precisionList precisionAction maybePrecisionId scratchPrecision mdlStore =
    let
        textStuff =
            --if precision action is edit then
            case precisionAction of
                EquipmentClass.PrecisionEdit ->
                    x scratchPrecision

                EquipmentClass.PrecisionCreate ->
                    x scratchPrecision

                _ ->
                    precisionTable precisionList precisionAction maybePrecisionId mdlStore

        actions =
            case precisionAction of
                EquipmentClass.PrecisionEdit ->
                    activeEditButtons mdlStore

                EquipmentClass.PrecisionCreate ->
                    activeEditButtons mdlStore

                _ ->
                    []
                        |> addAction
                            [ 12, 2 ]
                            mdlStore
                            (AppMsg.MsgForEquipmentClass EquipmentClassMsg.NewPrecision)
                            "left"
                            "person_add"
                            fBool
                        |> addAction
                            [ 12, 2 ]
                            mdlStore
                            (AppMsg.MsgForEquipmentClass EquipmentClassMsg.EditPrecision)
                            "left"
                            "mode_edit"
                            fBool
                        |> addAction
                            [ 12, 2 ]
                            mdlStore
                            (AppMsg.MsgForEquipmentClass EquipmentClassMsg.DeletePrecision)
                            "right"
                            "delete"
                            fBool
    in
        Card.view
            [ css "width" "80%"
            , css "margin-top" "2em"
            , Color.background (Color.color Color.Yellow Color.S500)

            --, Options.cs "demo-options"
            ]
            [ Card.title
                [ Color.background (Color.color Color.Blue Color.S500)
                , css "padding" "0"

                -- Clear default padding to encompass scrim
                , Color.background <| Color.color Color.Teal Color.S300
                ]
                [ Card.head
                    [ white

                    --, Options.scrim 0.75
                    --, css "padding" "16px"
                    -- Restore default padding inside scrim
                    , css "width" "100%"
                    ]
                    [ text "Precisions" ]
                ]
            , Card.text
                [ css "height" "400px"
                , css "width" "100%"
                ]
                [ Options.div
                    [ css "width" "100%"
                    , css "display" "flex"
                    , css "flex-direction" "column"
                    , css "justify-content" "space-between"
                    , css "height" "100%"
                    ]
                    [ Options.div
                        [ css "width" "100%"
                        , css "align-self" "flex-start"
                        ]
                        [ textStuff ]
                    ]
                ]
            , Card.actions
                [ Card.border
                , css "float" "left"
                , black
                ]
                actions
            ]


precisionTable : List EquipmentClassBase.EquipmentPrecision -> EquipmentClass.PrecisionAction -> Maybe Int -> Material.Model -> Html AppMsg.Msg
precisionTable precisionList precisionAction maybePrecisionId mdlStore =
    let
        divAt =
            case precisionAction of
                EquipmentClass.PrecisionNone ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.PrecisionKeyX x)) keyCode)
                    ]

                _ ->
                    []

        divAttributes =
            [ tabindex 0
            , style
                [ ( "height", "100%" )
                , ( "width", "100%" )
                , ( "overflow-y", "hidden" )
                , ( "overflow-x", "hidden" )
                ]
            ]
                ++ divAt
    in
        div
            divAttributes
            [ Table.table
                [ Options.css "margin" "0px"
                , Options.css "padding" "0px"
                , Options.css "width" "100%"
                ]
                [ --equipClassTableHeader order
                  tbody [] (precisionRows precisionList precisionAction maybePrecisionId)
                ]
            ]


precisionRows : List EquipmentClassBase.EquipmentPrecision -> EquipmentClass.PrecisionAction -> Maybe Int -> List (Html AppMsg.Msg)
precisionRows precisions action selectedPrecisionId =
    let
        precisionId =
            case selectedPrecisionId of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        precisions
            |> List.indexedMap (,)
            |> List.map (precisionRow action precisionId)



--bit of a pain to have to switch in and out of arrays.  May want to rethink this.  Possibly keep lists and just have an array containing ids backed by a map?
--look at using array.fold(l/r)


precisionRow : EquipmentClass.PrecisionAction -> Int -> ( Int, EquipmentClassBase.EquipmentPrecision ) -> Html AppMsg.Msg
precisionRow action precisionId ( idx, precision ) =
    let
        x =
            Debug.log "precision action: " action

        y =
            Debug.log "precisionId: " precisionId

        z =
            Debug.log "precision.id: " precision.id

        f allowSelect =
            []
                |> (\a ->
                        if precisionId == precision.id then
                            Options.css "background-color" "green" :: a
                        else
                            a
                   )
                |> (\a ->
                        if allowSelect == True then
                            Options.onClick (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SelectPrecision precision.id)) :: a
                        else
                            a
                   )

        row_style =
            case action of
                EquipmentClass.PrecisionNone ->
                    f True

                EquipmentClass.CancelNewPrecision ->
                    f True

                EquipmentClass.PrecisionEdit ->
                    f False

                EquipmentClass.PrecisionConfirmDelete ->
                    f False

                _ ->
                    []
    in
        Table.tr row_style
            [ Table.td [] [ text precision.precision ]

            --precisions tk
            ]
