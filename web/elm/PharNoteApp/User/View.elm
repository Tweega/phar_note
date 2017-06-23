module PharNoteApp.User.View exposing (view, alwaysFindUser, maybeFindUser)

import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.Model as User
import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.User.Model exposing (FormAction(..), RefDataStatus(..), UserType(..))
import PharNoteApp.User.Msg as UserMsg exposing (Msg(..))
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
import Material.Card as Card
import Material.Button as Button
import Material.Toggles as Toggles
import Material.Elevation as Elevation
import Set exposing (Set)
import Dict exposing (Dict)


view : User.Model -> Material.Model -> Html AppMsg.Msg
view model mdlStore =
    let
        contents =
            userTable model.users model.selectedUserId model.order

        user =
            case model.formAction of
                Edit ->
                    WithSet model.scratchUser

                Create ->
                    WithSet model.scratchUser

                _ ->
                    WithRoles (alwaysFindUser model.selectedUserIndex model.users)

        cards =
            case user of
                WithSet userWithRoleSet ->
                    (editCards userWithRoleSet model.refDataStatus model.formAction mdlStore)

                WithRoles userWithRoles ->
                    (viewCards userWithRoles model.refDataStatus mdlStore)
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
                    [ Options.div [] [ text "buttons here" ]
                    , contents
                    ]
                , cell
                    [ Grid.size All 4
                    , Color.background <| Color.color Color.Red Color.S100
                    ]
                    cards
                ]
            ]


viewCards : User.UserWithRoles -> User.RefDataStatus -> Material.Model -> List (Html AppMsg.Msg)
viewCards user refDataStatus mdlStore =
    [ userCard user refDataStatus mdlStore
    , Options.div
        [ Grid.size All 1
        , css "height" "32px"
        ]
        []
    , roleCard user.roles mdlStore
    ]


editCards : User.UserWithRoleSet -> User.RefDataStatus -> User.FormAction -> Material.Model -> List (Html AppMsg.Msg)
editCards scratchUser refDataStatus action mdlStore =
    --check that ref data is loaded.
    let
        html =
            case refDataStatus of
                Loaded refData ->
                    [ userEditCard scratchUser refData action mdlStore
                    , Options.div
                        [ Grid.size All 1
                        , css "height" "32px"
                        ]
                        []
                    , roleEditCard scratchUser.roles refData mdlStore
                    ]

                _ ->
                    [ text "no ref data" ]
    in
        html


maybeFindUser : Maybe Int -> Array User.UserWithRoles -> Maybe User.UserWithRoles
maybeFindUser maybeIndex users =
    case maybeIndex of
        Just idx ->
            Array.get idx users

        _ ->
            Nothing


alwaysFindUser : Maybe Int -> Array User.UserWithRoles -> User.UserWithRoles
alwaysFindUser maybeIndex users =
    let
        maybeUser =
            case maybeIndex of
                Just idx ->
                    Array.get idx users

                _ ->
                    Nothing
    in
        case maybeUser of
            Just usr ->
                usr

            Nothing ->
                User.emptyUserWithRoles


fieldStringValue : Maybe User.UserWithRoles -> User.FormAction -> (User.UserWithRoles -> String) -> String
fieldStringValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe User.UserWithRoles -> User.FormAction -> (User.UserWithRoles -> Int) -> String
fieldIntValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user |> toString
            else
                ""

        Nothing ->
            ""


userDetails : User.UserWithRoles -> Html AppMsg.Msg
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


userForm : User.UserWithRoleSet -> User.RefData -> User.FormAction -> Material.Model -> Html AppMsg.Msg
userForm user refData action mdlStore =
    let
        buttonText =
            if action == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if action == Edit then
                AppMsg.MsgForUser (UserMsg.UserPut user)
            else
                AppMsg.MsgForUser (UserMsg.UserPost user)
    in
        div []
            [ div [ class "form-group" ]
                [ label [] [ text "First Name" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetFirstName s)), value user.first_name, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Last Name" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetLastName s)), value user.last_name, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Email" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetEmail s)), value user.email, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Photo URL" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetPhotoUrl s)), value user.photo_url, class "form-control" ] []
                ]

            --, button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
            , Button.render AppMsg.Mdl
                [ 3, 0 ]
                mdlStore
                [ Button.ripple
                , Button.accent
                , Options.onClick buttonAction
                ]
                [ text "Create" ]
            , Button.render AppMsg.Mdl
                [ 3, 1 ]
                mdlStore
                [ Button.ripple
                , Button.accent
                , Options.onClick (AppMsg.MsgForUser UserMsg.CancelNewUser)
                ]
                [ text "Cancel" ]
            ]


userTable : Array User.UserWithRoles -> Maybe Int -> Maybe Table.Order -> Html AppMsg.Msg
userTable users selectedUserId order =
    div
        [ on "keydown" (Json.map (\x -> AppMsg.MsgForUser (UserMsg.KeyX x)) keyCode)
        , tabindex 0
        , style
            [ ( "height", "40%" )
            , ( "width", "100%" )
            , ( "overflow-y", "hidden" )
            , ( "overflow-x", "hidden" )
            ]
        ]
        [ Table.table
            [ Options.css "margin" "0px"
            , Options.css "padding" "0px"
            ]
            [ userTableHeader order
            , tbody [] (userRows users selectedUserId)
            ]
        ]


userTableHeader : Maybe Table.Order -> Html AppMsg.Msg
userTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th [] []
            , Table.th [] []
            , Table.th
                [ order
                    |> Maybe.map Table.sorted
                    |> Maybe.withDefault nop
                , Options.onClick (AppMsg.MsgForUser UserMsg.Reorder)
                ]
                [ text "First Name" ]
            , Table.th [] [ text "last Name" ]
            , Table.th [] [ text "Email" ]
            , Table.th [] [ text "Photo url" ]
            ]
        ]


userRows : Array User.UserWithRoles -> Maybe Int -> List (Html AppMsg.Msg)
userRows users selectedUserId =
    let
        userId =
            case selectedUserId of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        users
            |> Array.toIndexedList
            |> List.map (userRow userId)



--bit of a pain to have to switch in and out of arrays.  May want to rethink this.  Possibly keep lists and just have an array containing ids backed by a map?
--look at using array.fold(l/r)


userRow : Int -> ( Int, User.UserWithRoles ) -> Html AppMsg.Msg
userRow userId ( idx, user ) =
    let
        row_style =
            if userId == user.id then
                (Options.css "background-color" "green"
                    :: Options.onClick (AppMsg.MsgForUser (UserMsg.SelectUser idx))
                    :: []
                )
            else
                (Options.onClick (AppMsg.MsgForUser (UserMsg.SelectUser idx))
                    :: []
                )
    in
        Table.tr row_style
            [ Table.td [] [ button [ class "button btn-primary" ] [ text "Edit" ] ]
            , Table.td [] [ button [ onClick (AppMsg.MsgForUser UserMsg.DeleteUser), class "button btn-primary" ] [ text "Delete" ] ]
            , Table.td [] [ text user.first_name ]
            , Table.td [] [ text user.last_name ]
            , Table.td [] [ text user.email ]
            , Table.td [] [ text user.photo_url ]
            ]


white : Options.Property a b
white =
    Color.text Color.white


updatesCard : User.Model -> Material.Model -> Html AppMsg.Msg
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


optionsCard : User.Model -> Material.Model -> Html AppMsg.Msg
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


userCard : User.UserWithRoles -> User.RefDataStatus -> Material.Model -> Html AppMsg.Msg
userCard user refData mdlStore =
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
            case refData of
                Loaded data ->
                    [ Button.render AppMsg.Mdl
                        [ 1, 1 ]
                        mdlStore
                        [ Button.ripple
                        , white
                        , Options.onClick (AppMsg.MsgForUser UserMsg.NewUser)
                        ]
                        [ text "Create user" ]
                    ]

                _ ->
                    []
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
                [ userDetails user
                ]
            , Card.actions
                [ Card.border ]
                actions
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
                    [ 2, 1 ]
                    mdlStore
                    [ Button.ripple
                    , white
                    , Options.onClick (AppMsg.MsgForUser UserMsg.EditUser)
                    ]
                    [ text "Marvelloos" ]
                , Button.render AppMsg.Mdl
                    [ 2, 2 ]
                    mdlStore
                    [ Button.icon
                    , white
                    , Options.onClick (AppMsg.MsgForUser UserMsg.NewUser)
                    ]
                    [ Icon.i "person_add" ]
                , Button.render AppMsg.Mdl
                    [ 2, 3 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForUser UserMsg.EditUser)
                    ]
                    [ Icon.i "mode_edit_black" ]
                , Button.render AppMsg.Mdl
                    [ 2, 4 ]
                    mdlStore
                    [ Button.icon
                    , Options.onClick (AppMsg.MsgForUser UserMsg.DeleteUser)
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
        [ css "height" "120px"
        , css "width" "100%"
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
            [ css "width" "35%"
            , css "color" "rgba(0,0,0,0.9)"
            , css "float" "left"
            ]
            [ text role.role_name ]
        , Options.div
            [ css "float" "left"
            ]
            [ text role.role_desc ]
        ]


userEditCard : User.UserWithRoleSet -> User.RefData -> User.FormAction -> Material.Model -> Html AppMsg.Msg
userEditCard scratchUser refData action mdlStore =
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
                [ userForm scratchUser refData action mdlStore
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 1, 1 ]
                    mdlStore
                    [ Button.ripple, white ]
                    [ text "jolly good" ]
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
            , Options.onToggle (AppMsg.MsgForUser (UserMsg.ToggleRole role.id))

            --, Options.onToggle (Toggle index)
            ]
            [ text role.role_name ]
        ]


roleOptions : Set Int -> User.RefData -> Material.Model -> List (Html AppMsg.Msg)
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


roleEditCard : Set Int -> User.RefData -> Material.Model -> Html AppMsg.Msg
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
