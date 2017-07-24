module PharNoteApp.Equipment.View exposing (view, alwaysFindEquipment, maybeFindEquipment)

import PharNoteApp.Equipment.Rest as Rest
import PharNoteApp.Equipment.Model as Equipment
import PharNoteApp.Equipment.BaseModel as EquipmentBase
import PharNoteApp.Equipment.Model exposing (FormAction(..), EquipmentTab(..), RefDataStatus(..))
import PharNoteApp.Equipment.Msg as EquipmentMsg exposing (Msg(..))
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


view : Equipment.Model -> Material.Model -> Html AppMsg.Msg
view model mdlStore =
    let
        equipTableContents =
            --equipTable model.filteredEquipment model.selectedEquipmentId model.order model.startDisplayIndex model.endDisplayIndex
            tableCard model mdlStore

        equip =
            case model.formAction of
                Edit ->
                    model.scratchEquipment

                Create ->
                    model.scratchEquipment

                _ ->
                    (alwaysFindEquipment model.selectedEquipmentIndex model.filteredEquipment)

        cards =
            case model.selectedTab of
                Details ->
                    case model.formAction of
                        Edit ->
                            (editCards equip model.refDataStatus model.formAction mdlStore)

                        Create ->
                            (editCards equip model.refDataStatus model.formAction mdlStore)

                        _ ->
                            (viewCards equip model.refDataStatus model.formAction mdlStore)

                Filter ->
                    (filterCards model.filterScratchEquipment model.refDataStatus mdlStore)
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
                    [ equipTableContents
                    , pager model
                    ]
                , cell
                    [ Grid.size All 6
                    , Color.background <| Color.color Color.Red Color.S100
                    ]
                    cards
                ]
            ]


viewCards : EquipmentBase.Equipment -> Equipment.RefDataStatus -> Equipment.FormAction -> Material.Model -> List (Html AppMsg.Msg)
viewCards equip refDataStatus action mdlStore =
    [ equipCard equip refDataStatus action mdlStore
    , Options.div
        [ Grid.size All 1
        , css "height" "32px"
        ]
        [ text "what is going on?" ]

    --, roleCard equip.roles mdlStore
    ]


editCards : EquipmentBase.Equipment -> Equipment.RefDataStatus -> Equipment.FormAction -> Material.Model -> List (Html AppMsg.Msg)
editCards scratchEquipment refDataStatus action mdlStore =
    --check that ref data is loaded.
    let
        html =
            case refDataStatus of
                Loaded refData ->
                    [ equipEditCard scratchEquipment refData action mdlStore
                    , Options.div
                        [ Grid.size All 1
                        , css "height" "32px"
                        ]
                        []

                    --, roleEditCard scratchEquipment.roles refData mdlStore
                    ]

                _ ->
                    [ text "no ref data" ]
    in
        html


maybeFindEquipment : Maybe Int -> Array EquipmentBase.Equipment -> Maybe EquipmentBase.Equipment
maybeFindEquipment maybeIndex equips =
    case maybeIndex of
        Just idx ->
            Array.get idx equips

        _ ->
            Nothing


alwaysFindEquipment : Maybe Int -> Array EquipmentBase.Equipment -> EquipmentBase.Equipment
alwaysFindEquipment maybeIndex equips =
    let
        maybeEquipment =
            case maybeIndex of
                Just idx ->
                    Array.get idx equips

                _ ->
                    Nothing
    in
        case maybeEquipment of
            Just usr ->
                usr

            Nothing ->
                EquipmentBase.emptyEquipment


fieldStringValue : Maybe EquipmentBase.Equipment -> Equipment.FormAction -> (EquipmentBase.Equipment -> String) -> String
fieldStringValue equip formAction extractor =
    case equip of
        Just equip ->
            if formAction == Edit then
                extractor equip
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe EquipmentBase.Equipment -> Equipment.FormAction -> (EquipmentBase.Equipment -> Int) -> String
fieldIntValue equip formAction extractor =
    case equip of
        Just equip ->
            if formAction == Edit then
                extractor equip |> toString
            else
                ""

        Nothing ->
            ""


equipDetails : EquipmentBase.Equipment -> Html AppMsg.Msg
equipDetails equip =
    Options.div
        [ css "display" "flex"
        , css "align-items" "flex-start"
        , css "justify-content" "space-between"
        ]
        [ Options.div []
            (List.map
                equipInfo
                [ ( "First Name:", equip.equipment_name )
                , ( "Last Name", equip.equipment_code )
                ]
            )
        ]


equipInfo : ( String, String ) -> Html AppMsg.Msg
equipInfo ( fieldName, fieldValue ) =
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


equipEditItem : ( String, String, String -> AppMsg.Msg ) -> Html AppMsg.Msg
equipEditItem ( fieldName, fieldValue, equipMsg ) =
    div [ class "form-group" ]
        [ label [] [ text fieldName ]
        , input
            [ value fieldValue
            , onInput equipMsg
            , class "form-control"
            ]
            []
        ]


equipForm : EquipmentBase.Equipment -> Equipment.RefData -> Equipment.FormAction -> Material.Model -> Html AppMsg.Msg
equipForm equip refData action mdlStore =
    div []
        [ div [ class "form-group" ]
            [ label [] [ text "Equip Name" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipment (EquipmentMsg.SetFirstName s)), value equip.equipment_name, class "form-control" ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Equip Code" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipment (EquipmentMsg.SetLastName s)), value equip.equipment_name, class "form-control" ] []
            ]
        , rolesHeading
        , Options.styled Html.ul
            [ css "list-style-type" "none"
            , css "margin" "0"
            , css "padding" "0"
            ]
            []

        --(roleOptions equip.roles refData mdlStore)
        --, button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
        ]


equipTable : Array EquipmentBase.Equipment -> Maybe Int -> Maybe Table.Order -> Equipment.FormAction -> Int -> Int -> Html AppMsg.Msg
equipTable equips selectedEquipmentId order action startDisplayIndex endDisplayIndex =
    let
        divAt =
            case action of
                Equipment.None ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipment (EquipmentMsg.KeyX x)) keyCode)
                    ]

                Equipment.CancelNewEquipment ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipment (EquipmentMsg.KeyX x)) keyCode)
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
                [ equipTableHeader order
                , tbody [] (equipRows equips action selectedEquipmentId startDisplayIndex endDisplayIndex)
                ]
            ]


tableCard : Equipment.Model -> Material.Model -> Html AppMsg.Msg
tableCard model mdlStore =
    let
        ( msg, icon, tooltip ) =
            case model.selectedTab of
                Details ->
                    ( (AppMsg.MsgForEquipment (EquipmentMsg.SelectTab Filter)), "filter_list", "Show filter form" )

                Filter ->
                    ( (AppMsg.MsgForEquipment (EquipmentMsg.SelectTab Details)), "people", "Close filter form" )

        equipCount =
            Array.length model.filteredEquipment

        c =
            Debug.log "eq count:" equipCount

        actions =
            case model.refDataStatus of
                Loaded data ->
                    [ Button.render AppMsg.Mdl
                        [ 4, 1 ]
                        mdlStore
                        [ Button.icon
                        , Options.onClick msg
                        , css "float" "left"
                        ]
                        [ Icon.view icon
                            [ Tooltip.attach AppMsg.Mdl [ 4, 11 ] ]
                        , Tooltip.render AppMsg.Mdl
                            [ 4, 11 ]
                            mdlStore
                            []
                            [ text tooltip ]
                        ]
                    , Options.div
                        [ css "float" "right"
                        , css "font-size" "0.8em"
                        , css "margin-right" "15px"
                        , css "margin-top" "5px"
                        ]
                        [ text ("(" ++ toString equipCount ++ " equips)") ]
                    ]

                _ ->
                    []

        textStuff =
            equipTable model.filteredEquipment model.selectedEquipmentId model.order model.formAction model.startDisplayIndex model.endDisplayIndex
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
                    [ text "Equipment" ]
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
            , Card.actions
                [ Card.border
                , css "float" "left"
                ]
                actions
            ]


equipTableHeader : Maybe Table.Order -> Html AppMsg.Msg
equipTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th
                []
                [ text "First Name" ]
            , Table.th
                [ order
                    |> Maybe.map Table.sorted
                    |> Maybe.withDefault nop
                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.Reorder)
                ]
                [ text "last Name" ]
            , Table.th [] [ text "Email" ]
            , Table.th [ css "width" "100%" ] [ text "Photo url" ]
            ]
        ]


equipRows : Array EquipmentBase.Equipment -> Equipment.FormAction -> Maybe Int -> Int -> Int -> List (Html AppMsg.Msg)
equipRows equips action selectedEquipmentId startDisplayIndex endDisplayIndex =
    let
        equipId =
            case selectedEquipmentId of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        equips
            |> Array.slice startDisplayIndex (endDisplayIndex + 1)
            |> Array.toIndexedList
            |> List.map (equipRow action equipId)



--bit of a pain to have to switch in and out of arrays.  May want to rethink this.  Possibly keep lists and just have an array containing ids backed by a map?
--look at using array.fold(l/r)


equipRow : Equipment.FormAction -> Int -> ( Int, EquipmentBase.Equipment ) -> Html AppMsg.Msg
equipRow action equipId ( idx, equip ) =
    let
        f allowSelect =
            []
                |> (\a ->
                        if equipId == equip.id then
                            Options.css "background-color" "green" :: a
                        else
                            a
                   )
                |> (\a ->
                        if allowSelect == True then
                            Options.onClick (AppMsg.MsgForEquipment (EquipmentMsg.SelectEquipment idx)) :: a
                        else
                            a
                   )

        row_style =
            case action of
                Equipment.None ->
                    f True

                Equipment.CancelNewEquipment ->
                    f True

                Equipment.Edit ->
                    f False

                Equipment.ConfirmDelete ->
                    f False

                _ ->
                    []
    in
        Table.tr row_style
            [ Table.td [] [ text equip.equipment_name ]
            , Table.td [] [ text equip.equipment_code ]
            ]


white : Options.Property a b
white =
    Color.text Color.white


updatesCard : Equipment.Model -> Material.Model -> Html AppMsg.Msg
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


optionsCard : Equipment.Model -> Material.Model -> Html AppMsg.Msg
optionsCard model mdlStore =
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
                    [ option "Clicks per object" [ 0 ]
                    , option "Views per object" [ 1 ]
                    , option "Objects selected" [ 2 ]
                    , option "Objects viewed" [ 3 ]
                    ]
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 1, 1 ]
                    mdlStore
                    [ Button.ripple, white ]
                    [ text "Great" ]
                ]
            ]


equipCard : EquipmentBase.Equipment -> Equipment.RefDataStatus -> Equipment.FormAction -> Material.Model -> Html AppMsg.Msg
equipCard equip refData action mdlStore =
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
                Equipment.ConfirmDelete ->
                    [ Options.div [ css "background-color" "red", css "overflow" "hidden" ]
                        [ Options.div
                            [ css "background-color" "white", css "float" "right", css "overflow" "hidden" ]
                            [ Button.render AppMsg.Mdl
                                [ 3, 2 ]
                                mdlStore
                                [ Button.ripple
                                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.CancelDeleteEquipment)
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
                                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.DeleteEquipment)
                                , css "float" "right"
                                , css "margin-right" "1em"
                                , Elevation.e2
                                ]
                                [ text "Do it!" ]
                            ]
                        , Options.span [ css "float" "right", css "margin-right" "2em", css "margin-top" "7px" ] [ text "Are you sure you want to delete this equip?" ]
                        ]
                    ]

                _ ->
                    case refData of
                        Loaded data ->
                            [ Button.render AppMsg.Mdl
                                [ 2, 2 ]
                                mdlStore
                                [ Button.icon

                                --, white
                                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.NewEquipment)
                                , css "float" "left"
                                ]
                                [ Icon.i "person_add" ]
                            , Button.render AppMsg.Mdl
                                [ 2, 3 ]
                                mdlStore
                                [ Button.icon
                                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.EditEquipment)
                                , css "float" "left"
                                ]
                                [ Icon.i "mode_edit" ]
                            , Button.render AppMsg.Mdl
                                [ 2, 4 ]
                                mdlStore
                                [ Button.icon
                                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.ConfirmDeleteEquipment)
                                , css "float" "right"
                                , css "margin-right" "15px"
                                ]
                                [ Icon.i "delete" ]
                            ]

                        _ ->
                            []

        textStuff =
            [ equipDetails equip
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


rolesHeading : Html AppMsg.Msg
rolesHeading =
    Options.div
        [ white
        , css "font-size" "1.3em"
        , css "margin-top" "2em"
        ]
        [ text "Roles"
        ]


roleCard : List RoleBase.Role -> Material.Model -> Html AppMsg.Msg
roleCard roles mdlStore =
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
                [ roleDetails roles
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 2, 2 ]
                    mdlStore
                    [ Button.icon
                    , white
                    , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.NewEquipment)
                    ]
                    [ Icon.i "person_add" ]
                , Button.render AppMsg.Mdl
                    [ 2, 3 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.EditEquipment)
                    ]
                    [ Icon.i "mode_edit_black" ]
                , Button.render AppMsg.Mdl
                    [ 2, 4 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.DeleteEquipment)
                    ]
                    [ Icon.i "delete_black" ]
                , Button.render AppMsg.Mdl
                    [ 2, 5 ]
                    mdlStore
                    [ Button.icon ]
                    [ Icon.i "mode_comment" ]
                ]
            ]


roleDetails : List RoleBase.Role -> Html AppMsg.Msg
roleDetails roles =
    Options.div
        [ css "width" "100%"
        , css "float" "left"
        ]
        (List.indexedMap roleInfo roles)


roleInfo : Int -> RoleBase.Role -> Html AppMsg.Msg
roleInfo i role =
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
            [ text role.role_name ]
        , Options.div
            [ css "float" "left"
            ]
            [ text role.role_desc ]
        ]


equipEditCard : EquipmentBase.Equipment -> Equipment.RefData -> Equipment.FormAction -> Material.Model -> Html AppMsg.Msg
equipEditCard scratchEquipment refData action mdlStore =
    let
        buttonText =
            if action == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if action == Edit then
                AppMsg.MsgForEquipment (EquipmentMsg.EquipmentPut scratchEquipment)
            else
                AppMsg.MsgForEquipment (EquipmentMsg.EquipmentPost scratchEquipment)

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
                [ equipForm scratchEquipment refData action mdlStore
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
                    , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.CancelNewEquipment)
                    ]
                    [ text "Cancel" ]
                ]
            ]


roleOption : RoleBase.Role -> Int -> Bool -> Material.Model -> Html AppMsg.Msg
roleOption role index value mdlStore =
    Options.styled Html.li
        [ css "margin" "4px 0" ]
        [ Toggles.checkbox AppMsg.Mdl
            [ 4, index ]
            mdlStore
            [ Toggles.ripple
            , Toggles.value value

            --somehow we need to get , Options.onToggle (AppMsg.MsgForChart (Toggle index))
            -- to be List (Material.Toggles.Property Msg)
            , Options.onToggle (AppMsg.MsgForEquipment (EquipmentMsg.ToggleRole role.id))

            --, Options.onToggle (Toggle index)
            ]
            [ text role.role_name ]
        ]


roleFilterOption : RoleBase.Role -> Int -> Bool -> Material.Model -> Html AppMsg.Msg
roleFilterOption role index value mdlStore =
    Options.styled Html.li
        [ css "margin" "4px 0" ]
        [ Toggles.checkbox AppMsg.Mdl
            [ 8, index ]
            mdlStore
            [ Toggles.ripple
            , Toggles.value value

            --somehow we need to get , Options.onToggle (AppMsg.MsgForChart (Toggle index))
            -- to be List (Material.Toggles.Property Msg)
            , Options.onToggle (AppMsg.MsgForEquipment (EquipmentMsg.ToggleFilterRole role.id))

            --, Options.onToggle (Toggle index)
            ]
            [ text role.role_name ]
        ]


roleOptions : Set Int -> Equipment.RefData -> Material.Model -> List (Html AppMsg.Msg)
roleOptions roleSet refData mdlStore =
    -- --may want to sort the list
    -- let
    --     roles =
    --         Dict.toList refData.roles
    -- in
    --     List.map
    --         (\( index, role ) ->
    --             let
    --                 value =
    --                     Set.member role.id roleSet
    --             in
    --                 roleOption role index value mdlStore
    --         )
    --         roles
    []


roleFilterOptions : Set Int -> Equipment.RefData -> Material.Model -> List (Html AppMsg.Msg)
roleFilterOptions roleSet refData mdlStore =
    -- --may want to sort the list
    -- let
    --     roles =
    --         Dict.toList refData.roles
    -- in
    --     List.map
    --         (\( index, role ) ->
    --             let
    --                 value =
    --                     Set.member role.id roleSet
    --             in
    --                 roleFilterOption role index value mdlStore
    --         )
    --         roles
    []


roleEditCard : Set Int -> Equipment.RefData -> Material.Model -> Html AppMsg.Msg
roleEditCard roleSet refData mdlStore =
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
                (roleOptions roleSet refData mdlStore)
            ]
        , Card.actions
            [ Card.border ]
            [ Button.render AppMsg.Mdl
                [ 1, 1 ]
                mdlStore
                [ Button.ripple, white ]
                [ text "Great" ]
            ]
        ]


pager : Equipment.Model -> Html AppMsg.Msg
pager model =
    let
        pageCount =
            floor (toFloat (Array.length model.filteredEquipment) / toFloat model.pageSize)

        pageList =
            List.range 0 pageCount

        --|> List.reverse --reverse to have page isons increment from left to right
        currentPage =
            floor (toFloat model.endDisplayIndex / toFloat model.pageSize)

        x =
            Debug.log "currentPage" currentPage

        y =
            Debug.log "model.startDisplayIndex" model.startDisplayIndex

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
                    , HtmlUtils.onClickNoDefault (AppMsg.MsgForEquipment (EquipmentMsg.PaginateEquipment i))
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


slider : Equipment.Model -> Html AppMsg.Msg
slider model =
    p [ style [ ( "width", "300px" ) ] ]
        [ Slider.view
            [ Slider.onChange (\value -> AppMsg.MsgForEquipment (EquipmentMsg.EquipmentSlider value))
            , Slider.value model.equipmentSliderValue
            ]
        ]


filterCards : EquipmentBase.Equipment -> Equipment.RefDataStatus -> Material.Model -> List (Html AppMsg.Msg)
filterCards scratchEquipment refDataStatus mdlStore =
    --check that ref data is loaded.
    let
        html =
            case refDataStatus of
                Loaded refData ->
                    [ equipFilterCard scratchEquipment refData mdlStore ]

                _ ->
                    [ text "no ref data" ]
    in
        html


equipFilterCard : EquipmentBase.Equipment -> Equipment.RefData -> Material.Model -> Html AppMsg.Msg
equipFilterCard filterEquipment refData mdlStore =
    let
        option title index =
            Options.styled Html.li
                [ css "margin" "4px 0" ]
                [ Toggles.checkbox AppMsg.Mdl
                    [ 6, index ]
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

        --makeAction msg icon tooltip index =
        acts =
            [ Button.render AppMsg.Mdl
                [ 3, 1 ]
                mdlStore
                [ Button.icon
                , Options.onClick (AppMsg.MsgForEquipment (EquipmentMsg.ApplyEquipmentFilter filterEquipment))
                , css "float" "left"
                ]
                [ Icon.view "filter_list"
                    [ Tooltip.attach AppMsg.Mdl [ 3, 11 ] ]
                , Tooltip.render AppMsg.Mdl
                    [ 3, 11 ]
                    mdlStore
                    []
                    [ text "Apply filter" ]
                ]

            --
            --                 [ Icon.view "add"
            --     [ Tooltip.attach Mdl [0] ]
            -- , Tooltip.render Mdl [0] model.mdl
            --     []
            --     [ text "This is an add icon" ]
            -- ]
            -- , Button.render AppMsg.Mdl
            --     [ 3, 1 ]
            --     mdlStore
            --     [ Button.ripple
            --     , Button.accent
            --     , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.ResetEquipmentFilter)
            --     ]
            --     [ text "Reset" ]
            , Button.render AppMsg.Mdl
                [ 3, 3 ]
                mdlStore
                [ Button.icon
                , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.CancelEquipmentFilter)
                , css "float" "right"
                , css "margin-right" "15px"
                ]
                [ Icon.i "people" ]
            ]

        actions =
            acts
                ++ [ Button.render AppMsg.Mdl
                        [ 3, 2 ]
                        mdlStore
                        [ Button.icon
                        , Options.onClick (AppMsg.MsgForEquipment EquipmentMsg.ClearEquipmentFilter)
                        , css "float" "left"
                        ]
                        [ Icon.view "undo"
                            [ Tooltip.attach AppMsg.Mdl [ 3, 21 ] ]
                        , Tooltip.render AppMsg.Mdl
                            [ 3, 21 ]
                            mdlStore
                            []
                            [ text "Revert to original equip list" ]
                        ]
                   ]

        --[ text "Close" ]
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
                [ Options.div
                    [ css "display" "flex"
                    , css "align-items" "flex-start"
                    , css "justify-content" "space-between"
                    ]
                    [ Options.div []
                        (List.map
                            equipEditItem
                            [ ( "Equip Name:", filterEquipment.equipment_name, (\f -> AppMsg.MsgForEquipment (EquipmentMsg.SetFilterFirstName f)) )
                            , ( "Equip Code", filterEquipment.equipment_code, (\f -> AppMsg.MsgForEquipment (EquipmentMsg.SetFilterLastName f)) )
                            ]
                        )
                    , Options.div []
                        [ Options.styled Html.ul
                            [ css "list-style-type" "none"
                            , css "margin" "0"
                            , css "padding" "0"
                            ]
                            []

                        --(roleFilterOptions filterEquipment.roles refData mdlStore)
                        ]
                    ]
                ]
            , Card.actions
                [ Card.border
                , css "float" "left"
                ]
                actions
            ]
