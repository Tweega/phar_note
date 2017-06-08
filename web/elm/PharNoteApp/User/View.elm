module PharNoteApp.User.View exposing (view, findUser)

import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.Model as User
import PharNoteApp.User.Model exposing (FormAction(..))
import PharNoteApp.User.Msg as UserMsg exposing (Msg(..))
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


view : User.Model -> Material.Model -> Html AppMsg.Msg
view model mdlStore =
    let
        contents =
            userTable model.users model.selectedUserId model.order

        tabContents =
            case model.selectedTab of
                0 ->
                    sampleTab1 model

                _ ->
                    sampleTab2 model
    in
        div []
            [ grid
                [ Options.many
                    [ css "display" "flex"
                    , css "align-items" "flex-start"
                    , css "justify-content" "space-around"
                    ]
                ]
                [ cell [ Grid.size All 5 ]
                    [ Options.div [ css "width" "100%" ] [ text "buttons here" ]
                    , contents
                    ]
                , cell
                    [ Grid.size All 4
                    , Color.background <| Color.color Color.Red Color.S100
                    ]
                    [ userCard model mdlStore
                    , Options.div
                        [ Grid.size All 1
                        , css "height" "32px"
                        ]
                        []
                    , optionsCard model mdlStore
                    ]
                ]
            ]


sampleTab1 : User.Model -> List (Html AppMsg.Msg)
sampleTab1 model =
    [ text "alright??"
    , formColumn model
    ]


sampleTab2 : User.Model -> List (Html AppMsg.Msg)
sampleTab2 model =
    [ div [] [ text "hello there" ] ]


formColumn : User.Model -> Html AppMsg.Msg
formColumn model =
    div []
        [ userForm model ]


findUser : Int -> Array User.User -> Maybe User.User
findUser idx users =
    Array.get idx users


fieldStringValue : Maybe User.User -> User.FormAction -> (User.User -> String) -> String
fieldStringValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe User.User -> User.FormAction -> (User.User -> Int) -> String
fieldIntValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user |> toString
            else
                ""

        Nothing ->
            ""


userForm : User.Model -> Html AppMsg.Msg
userForm model =
    let
        user =
            case model.selectedUserIndex of
                Just idx ->
                    findUser idx model.users

                Nothing ->
                    Nothing

        firstName =
            fieldStringValue user model.formAction .first_name

        lastName =
            fieldStringValue user model.formAction .last_name

        email =
            fieldStringValue user model.formAction .email

        photoUrl =
            fieldStringValue user model.formAction .photo_url

        buttonText =
            if model.formAction == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if model.formAction == Edit then
                AppMsg.MsgForUser (UserMsg.UserPut model)
            else
                AppMsg.MsgForUser (UserMsg.UserPost model)
    in
        Html.form []
            [ div [ class "form-group" ]
                [ label [] [ text "First Name" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetFirstNameInput s)), value model.firstNameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Last Name" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetLastNameInput s)), value model.lastNameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Email" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetEmailInput s)), value model.emailInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Photo URL" ]
                , input [ onInput (\s -> AppMsg.MsgForUser (UserMsg.SetPhotoUrlInput s)), value model.photoUrlInput, class "form-control" ] []
                ]
            , button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
            ]


userTable : Array User.User -> Maybe Int -> Maybe Table.Order -> Html AppMsg.Msg
userTable users selectedUserId order =
    div
        [ on "keydown" (Json.map (\x -> AppMsg.MsgForUser (UserMsg.KeyX x)) keyCode)
        , tabindex 0
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


userRows : Array User.User -> Maybe Int -> List (Html AppMsg.Msg)
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


userRow : Int -> ( Int, User.User ) -> Html AppMsg.Msg
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
            , Table.td [] [ button [ class "button btn-primary" ] [ text "Delete" ] ]
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
                    [ text "Awesome" ]
                ]
            ]


userCard : User.Model -> Material.Model -> Html AppMsg.Msg
userCard model mdlStore =
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
                    [ text "Details" ]
                ]
            , Card.text [ white ]
                [ formColumn model
                ]
            , Card.actions
                [ Card.border ]
                [ Button.render AppMsg.Mdl
                    [ 1, 1 ]
                    mdlStore
                    [ Button.ripple, white ]
                    [ text "Awesome" ]
                ]
            ]
