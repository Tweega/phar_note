module View exposing (view, findUser)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import User exposing (..)
import HttpUtils
import Material.Table as Table
import Material.Options as Options exposing (when, nop)
import PharNoteApp.User.Model as User


view : User.Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ button [ onClick MsgForUser NewUser, class "button btn-primary" ] [ text "New User" ]
            ]
        , div [ class "row" ]
            [ userTable model.users model.order
            , formColumn model
            ]
        ]


formColumn : User.Model -> Html Msg
formColumn model =
    let
        innerForm =
            if model.formAction == Create || model.formAction == Edit then
                userForm model
            else
                div [] []
    in
        div [ class "col-md-3" ]
            [ innerForm ]


findUser : Int -> List User -> Maybe User
findUser id users =
    users
        |> List.filter (\user -> user.id == id)
        |> List.head


fieldStringValue : Maybe User -> FormAction -> (User -> String) -> String
fieldStringValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe User -> FormAction -> (User -> Int) -> String
fieldIntValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user |> toString
            else
                ""

        Nothing ->
            ""


userForm : User.Model -> Html Msg
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
            if model.formAction == MsgForUser Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if model.formAction == MsgForUser Edit then
                MsgForUser UserPut model
            else
                MsgForUser UserPost model
    in
        Html.form []
            [ div [ class "form-group" ]
                [ label [] [ text "First Name" ]
                , input [ onInput MsgForUser SetFirstNameInput, value model.firstNameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Last Name" ]
                , input [ onInput MsgForUser SetLastNameInput, value model.lastNameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Email" ]
                , input [ onInput MsgForUser SetEmailInput, value model.emailInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Photo URL" ]
                , input [ onInput MsgForUser SetPhotoUrlInput, value model.photoUrlInput, class "form-control" ] []
                ]
            , button [ HttpUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
            ]


userTable : List User -> Maybe Table.Order -> Html Msg
userTable users order =
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
        div [ class "col-md-9" ]
            [ Table.table []
                [ userTableHeader order
                , tbody [] (userRows sortedUsers)
                ]
            ]


userTableHeader : Maybe Table.Order -> Html Msg
userTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th [] []
            , Table.th [] []
            , Table.th
                [ order
                    |> Maybe.map Table.sorted
                    |> Maybe.withDefault nop
                , Options.onClick MsgForUser Reorder
                ]
                [ text "First Name" ]
            , Table.th [] [ text "last Name" ]
            , Table.th [] [ text "Email" ]
            , Table.th [] [ text "Photo url" ]
            ]
        ]


userRows : List User -> List (Html Msg)
userRows users =
    users
        |> List.map userRow


userRow : User -> Html Msg
userRow user =
    Table.tr []
        [ Table.td [] [ button [ onClick (MsgForUser EditUser user.id), class "button btn-primary" ] [ text "Edit" ] ]
        , Table.td [] [ button [ onClick (MsgForUser DeleteUser user.id), class "button btn-primary" ] [ text "Delete" ] ]
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


sort_by_last_first : User -> String
sort_by_last_first u =
    u.last_name ++ u.first_name
