module PharNoteApp.EquipmentClass.View exposing (view, alwaysFindEquipmentClass, maybeFindEquipmentClass)

import PharNoteApp.EquipmentClass.Rest as Rest
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.EquipmentClass.Model exposing (FormAction(..), EquipmentClassTab(..), RefDataStatus(..), EquipmentClassType(..))
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
        userTableContents =
            --userTable model.filteredEquipmentClasss model.selectedEquipmentClassId model.order model.startDisplayIndex model.endDisplayIndex
            tableCard model mdlStore

        user =
            case model.formAction of
                Edit ->
                    WithSet model.scratchEquipmentClass

                Create ->
                    WithSet model.scratchEquipmentClass

                _ ->
                    WithRoles (alwaysFindEquipmentClass model.selectedEquipmentClassIndex model.filteredEquipmentClasss)

        cards =
            case model.selectedTab of
                Details ->
                    case user of
                        WithSet userWithRoleSet ->
                            (editCards userWithRoleSet model.refDataStatus model.formAction mdlStore)

                        WithRoles userWithRoles ->
                            (viewCards userWithRoles model.refDataStatus model.formAction mdlStore)

                Filter ->
                    (filterCards model.filterScratchEquipmentClass model.refDataStatus mdlStore)
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
                    [ userTableContents
                    , pager model
                    ]
                , cell
                    [ Grid.size All 6
                    , Color.background <| Color.color Color.Red Color.S100
                    ]
                    cards
                ]
            ]


viewCards : EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.RefDataStatus -> EquipmentClass.FormAction -> Material.Model -> List (Html AppMsg.Msg)
viewCards user refDataStatus action mdlStore =
    [ userCard user refDataStatus action mdlStore
    , Options.div
        [ Grid.size All 1
        , css "height" "32px"
        ]
        []

    --, roleCard user.roles mdlStore
    ]


editCards : EquipmentClass.EquipmentClassWithRoleSet -> EquipmentClass.RefDataStatus -> EquipmentClass.FormAction -> Material.Model -> List (Html AppMsg.Msg)
editCards scratchEquipmentClass refDataStatus action mdlStore =
    --check that ref data is loaded.
    let
        html =
            case refDataStatus of
                Loaded refData ->
                    [ userEditCard scratchEquipmentClass refData action mdlStore
                    , Options.div
                        [ Grid.size All 1
                        , css "height" "32px"
                        ]
                        []

                    --, roleEditCard scratchEquipmentClass.roles refData mdlStore
                    ]

                _ ->
                    [ text "no ref data" ]
    in
        html


maybeFindEquipmentClass : Maybe Int -> Array EquipmentClass.EquipmentClassWithRoles -> Maybe EquipmentClass.EquipmentClassWithRoles
maybeFindEquipmentClass maybeIndex users =
    case maybeIndex of
        Just idx ->
            Array.get idx users

        _ ->
            Nothing


alwaysFindEquipmentClass : Maybe Int -> Array EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.EquipmentClassWithRoles
alwaysFindEquipmentClass maybeIndex users =
    let
        maybeEquipmentClass =
            case maybeIndex of
                Just idx ->
                    Array.get idx users

                _ ->
                    Nothing
    in
        case maybeEquipmentClass of
            Just usr ->
                usr

            Nothing ->
                EquipmentClass.emptyEquipmentClassWithRoles


fieldStringValue : Maybe EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.FormAction -> (EquipmentClass.EquipmentClassWithRoles -> String) -> String
fieldStringValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.FormAction -> (EquipmentClass.EquipmentClassWithRoles -> Int) -> String
fieldIntValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user |> toString
            else
                ""

        Nothing ->
            ""


userDetails : EquipmentClass.EquipmentClassWithRoles -> Html AppMsg.Msg
userDetails user =
    Options.div
        [ css "display" "flex"
        , css "align-items" "flex-start"
        , css "justify-content" "space-between"
        ]
        [ Options.div []
            (List.map
                userInfo
                [ ( "First Name:", user.first_name )
                , ( "Last Name", user.last_name )
                , ( "Email", user.email )
                , ( "Photo Url", user.photo_url )
                ]
            )
        , Options.div []
            [ Options.img
                [ Options.attribute <| Html.Attributes.src user.photo_url
                , css "height" "96px"
                , css "width" "96px"
                ]
                []
            ]
        ]


userInfo : ( String, String ) -> Html AppMsg.Msg
userInfo ( fieldName, fieldValue ) =
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


userEditItem : ( String, String, String -> AppMsg.Msg ) -> Html AppMsg.Msg
userEditItem ( fieldName, fieldValue, userMsg ) =
    div [ class "form-group" ]
        [ label [] [ text fieldName ]
        , input
            [ value fieldValue
            , onInput userMsg
            , class "form-control"
            ]
            []
        ]


userForm : EquipmentClass.EquipmentClassWithRoleSet -> EquipmentClass.RefData -> EquipmentClass.FormAction -> Material.Model -> Html AppMsg.Msg
userForm user refData action mdlStore =
    div []
        [ div [ class "form-group" ]
            [ label [] [ text "First Name" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetFirstName s)), value user.first_name, class "form-control" ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Last Name" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetLastName s)), value user.last_name, class "form-control" ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Email" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetEmail s)), value user.email, class "form-control" ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Photo URL" ]
            , input [ onInput (\s -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetPhotoUrl s)), value user.photo_url, class "form-control" ] []
            ]
        , rolesHeading
        , Options.styled Html.ul
            [ css "list-style-type" "none"
            , css "margin" "0"
            , css "padding" "0"
            ]
            (roleOptions user.roles refData mdlStore)

        --, button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
        ]


userTable : Array EquipmentClass.EquipmentClassWithRoles -> Maybe Int -> Maybe Table.Order -> EquipmentClass.FormAction -> Int -> Int -> Html AppMsg.Msg
userTable users selectedEquipmentClassId order action startDisplayIndex endDisplayIndex =
    let
        divAt =
            case action of
                EquipmentClass.None ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.KeyX x)) keyCode)
                    ]

                EquipmentClass.CancelNewEquipmentClass ->
                    [ on "keydown" (Json.map (\x -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.KeyX x)) keyCode)
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
                [ userTableHeader order
                , tbody [] (userRows users action selectedEquipmentClassId startDisplayIndex endDisplayIndex)
                ]
            ]


tableCard : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg
tableCard model mdlStore =
    let
        ( msg, icon, tooltip ) =
            case model.selectedTab of
                Details ->
                    ( (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SelectTab Filter)), "filter_list", "Show filter form" )

                Filter ->
                    ( (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SelectTab Details)), "people", "Close filter form" )

        userCount =
            Array.length model.filteredEquipmentClasss

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
                        [ text ("(" ++ toString userCount ++ " users)") ]
                    ]

                _ ->
                    []

        textStuff =
            userTable model.filteredEquipmentClasss model.selectedEquipmentClassId model.order model.formAction model.startDisplayIndex model.endDisplayIndex
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
                    [ text "EquipmentClasss" ]
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


userTableHeader : Maybe Table.Order -> Html AppMsg.Msg
userTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th
                []
                [ text "First Name" ]
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


userRows : Array EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.FormAction -> Maybe Int -> Int -> Int -> List (Html AppMsg.Msg)
userRows users action selectedEquipmentClassId startDisplayIndex endDisplayIndex =
    let
        userId =
            case selectedEquipmentClassId of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        users
            |> Array.slice startDisplayIndex (endDisplayIndex + 1)
            |> Array.toIndexedList
            |> List.map (userRow action userId)



--bit of a pain to have to switch in and out of arrays.  May want to rethink this.  Possibly keep lists and just have an array containing ids backed by a map?
--look at using array.fold(l/r)


userRow : EquipmentClass.FormAction -> Int -> ( Int, EquipmentClass.EquipmentClassWithRoles ) -> Html AppMsg.Msg
userRow action userId ( idx, user ) =
    let
        f allowSelect =
            []
                |> (\a ->
                        if userId == user.id then
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
            [ Table.td [] [ text user.first_name ]
            , Table.td [] [ text user.last_name ]
            , Table.td [] [ text user.email ]
            , Table.td [ css "width" "100%" ] [ text user.photo_url ]
            ]


white : Options.Property a b
white =
    Color.text Color.white


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


optionsCard : EquipmentClass.Model -> Material.Model -> Html AppMsg.Msg
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


userCard : EquipmentClass.EquipmentClassWithRoles -> EquipmentClass.RefDataStatus -> EquipmentClass.FormAction -> Material.Model -> Html AppMsg.Msg
userCard user refData action mdlStore =
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
                        , Options.span [ css "float" "right", css "margin-right" "2em", css "margin-top" "7px" ] [ text "Are you sure you want to delete this user?" ]
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

                        _ ->
                            []

        textStuff =
            if List.length user.roles > 0 then
                [ userDetails user
                , rolesHeading
                , roleDetails user.roles
                ]
            else
                [ userDetails user
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


userEditCard : EquipmentClass.EquipmentClassWithRoleSet -> EquipmentClass.RefData -> EquipmentClass.FormAction -> Material.Model -> Html AppMsg.Msg
userEditCard scratchEquipmentClass refData action mdlStore =
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
                [ userForm scratchEquipmentClass refData action mdlStore
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
            , Options.onToggle (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.ToggleRole role.id))

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
            , Options.onToggle (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.ToggleFilterRole role.id))

            --, Options.onToggle (Toggle index)
            ]
            [ text role.role_name ]
        ]


roleOptions : Set Int -> EquipmentClass.RefData -> Material.Model -> List (Html AppMsg.Msg)
roleOptions roleSet refData mdlStore =
    --may want to sort the list
    let
        roles =
            Dict.toList refData.roles
    in
        List.map
            (\( index, role ) ->
                let
                    value =
                        Set.member role.id roleSet
                in
                    roleOption role index value mdlStore
            )
            roles


roleFilterOptions : Set Int -> EquipmentClass.RefData -> Material.Model -> List (Html AppMsg.Msg)
roleFilterOptions roleSet refData mdlStore =
    --may want to sort the list
    let
        roles =
            Dict.toList refData.roles
    in
        List.map
            (\( index, role ) ->
                let
                    value =
                        Set.member role.id roleSet
                in
                    roleFilterOption role index value mdlStore
            )
            roles


roleEditCard : Set Int -> EquipmentClass.RefData -> Material.Model -> Html AppMsg.Msg
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


pager : EquipmentClass.Model -> Html AppMsg.Msg
pager model =
    let
        pageCount =
            floor (toFloat (Array.length model.filteredEquipmentClasss) / toFloat model.pageSize)

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


slider : EquipmentClass.Model -> Html AppMsg.Msg
slider model =
    p [ style [ ( "width", "300px" ) ] ]
        [ Slider.view
            [ Slider.onChange (\value -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.EquipmentClassSlider value))
            , Slider.value model.userSliderValue
            ]
        ]


filterCards : EquipmentClass.EquipmentClassWithRoleSet -> EquipmentClass.RefDataStatus -> Material.Model -> List (Html AppMsg.Msg)
filterCards scratchEquipmentClass refDataStatus mdlStore =
    --check that ref data is loaded.
    let
        html =
            case refDataStatus of
                Loaded refData ->
                    [ userFilterCard scratchEquipmentClass refData mdlStore ]

                _ ->
                    [ text "no ref data" ]
    in
        html


userFilterCard : EquipmentClass.EquipmentClassWithRoleSet -> EquipmentClass.RefData -> Material.Model -> Html AppMsg.Msg
userFilterCard filterEquipmentClass refData mdlStore =
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
                , Options.onClick (AppMsg.MsgForEquipmentClass (EquipmentClassMsg.ApplyEquipmentClassFilter filterEquipmentClass))
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
            --     , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.ResetEquipmentClassFilter)
            --     ]
            --     [ text "Reset" ]
            , Button.render AppMsg.Mdl
                [ 3, 3 ]
                mdlStore
                [ Button.icon
                , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.CancelEquipmentClassFilter)
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
                        , Options.onClick (AppMsg.MsgForEquipmentClass EquipmentClassMsg.ClearEquipmentClassFilter)
                        , css "float" "left"
                        ]
                        [ Icon.view "undo"
                            [ Tooltip.attach AppMsg.Mdl [ 3, 21 ] ]
                        , Tooltip.render AppMsg.Mdl
                            [ 3, 21 ]
                            mdlStore
                            []
                            [ text "Revert to original user list" ]
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
                            userEditItem
                            [ ( "First Name:", filterEquipmentClass.first_name, (\f -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetFilterFirstName f)) )
                            , ( "Last Name", filterEquipmentClass.last_name, (\f -> AppMsg.MsgForEquipmentClass (EquipmentClassMsg.SetFilterLastName f)) )
                            ]
                        )
                    , Options.div []
                        [ Options.styled Html.ul
                            [ css "list-style-type" "none"
                            , css "margin" "0"
                            , css "padding" "0"
                            ]
                            (roleFilterOptions filterEquipmentClass.roles refData mdlStore)
                        ]
                    ]
                ]
            , Card.actions
                [ Card.border
                , css "float" "left"
                ]
                actions
            ]