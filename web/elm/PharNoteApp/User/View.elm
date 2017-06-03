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


view : User.Model -> Html AppMsg.Msg
view model =
    let
        contents =
            userTable model.users model.selectedUser model.order
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
                    [ text "guten morgen"
                    , formColumn model
                    ]
                ]
            ]


formColumn : User.Model -> Html AppMsg.Msg
formColumn model =
    div [ class "col-md-3" ]
        [ userForm model ]


findUser : Int -> List User.User -> Maybe User.User
findUser id users =
    users
        |> List.filter (\user -> user.id == id)
        |> List.head


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
            case model.selectedUser of
                Just id ->
                    findUser id model.users

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


userTable : List User.User -> Maybe Int -> Maybe Table.Order -> Html AppMsg.Msg
userTable users selectedUser order =
    let
        sort =
            case order of
                Just Table.Ascending ->
                    List.sortBy sort_by_last_first

                Just Table.Descending ->
                    List.sortWith (\x y -> reverse (sort_by_last_first x) (sort_by_last_first y))

                Nothing ->
                    identity

        sortedUsers =
            sort users
    in
        div
            [ class "col-md-9"
            , on "keydown" (Json.map (\x -> AppMsg.MsgForUser (UserMsg.KeyX x)) keyCode)
            , tabindex 0
            ]
            [ Table.table []
                [ userTableHeader order
                , tbody [] (userRows sortedUsers selectedUser)
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


userRows : List User.User -> Maybe Int -> List (Html AppMsg.Msg)
userRows users selectedUser =
    let
        userID =
            case selectedUser of
                Just id ->
                    id

                Nothing ->
                    -1
    in
        users
            |> List.map (userRow userID)


userRow : Int -> User.User -> Html AppMsg.Msg
userRow userID user =
    let
        row_style =
            if userID == user.id then
                (Options.css "background-color" "green"
                    :: Options.onClick (AppMsg.MsgForUser (UserMsg.SelectUser user.id))
                    :: []
                )
            else
                (Options.onClick (AppMsg.MsgForUser (UserMsg.SelectUser user.id))
                    :: []
                )
    in
        Table.tr row_style
            [ Table.td [] [ button [ onClick (AppMsg.MsgForUser (UserMsg.EditUser user.id)), class "button btn-primary" ] [ text "Edit" ] ]
            , Table.td [] [ button [ onClick (AppMsg.MsgForUser (UserMsg.DeleteUser user.id)), class "button btn-primary" ] [ text "Delete" ] ]
            , Table.td [] [ text user.first_name ]
            , Table.td [] [ text user.last_name ]
            , Table.td [] [ text user.email ]
            , Table.td [] [ text user.photo_url ]
            ]


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


sort_by_last_first : User.User -> String
sort_by_last_first u =
    u.last_name ++ u.first_name
