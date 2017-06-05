module PharNoteApp.User.View exposing (view, findUser)

import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.Model as User
import PharNoteApp.User.Model exposing (FormAction(..))
import PharNoteApp.User.Msg as UserMsg
import PharNoteApp.Msg as AppMsg
import PharNoteApp.HtmlUtils as HtmlUtils
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Table as Table
import Material.Options as Options exposing (when, nop, css)
import Material.Grid as Grid exposing (..)
import Material.Color as Color
import Json.Decode as Json
import Array exposing (..)


view : User.Model -> Html AppMsg.Msg
view model =
    let
        contents =
            userTable model.users model.selectedUserId model.order
    in
        div []
            [ grid [ noSpacing ]
                [ cell [ Grid.size All 6, Grid.offset Desktop 1 ] [ contents ]
                , cell
                    [ Grid.size All 4
                    , Grid.offset Desktop 1
                    , Grid.align Top
                    , css "position" "relative"
                    , Color.background <| Color.color Color.Yellow Color.S50
                    ]
                    [ text "hello bonjour comment allez vous?"
                    , formColumn model
                    ]
                ]
            ]


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
        [ Table.table []
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
