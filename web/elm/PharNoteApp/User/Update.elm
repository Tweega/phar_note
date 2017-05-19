module PharNoteApp.User.Update exposing (..)

import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Model exposing (..)
import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.View as View
import Material.Table as Table


update : Msg -> Model -> ( Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Reorder ->
            { model | order = rotate model.order } ! []

        EditUser id ->
            let
                user =
                    View.findUser id model.users

                firstName =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.first_name

                lastName =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.last_name

                email =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.email

                photoUrl =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.photo_url
            in
                { model
                    | firstNameInput = firstName
                    , lastNameInput = lastName
                    , emailInput = email
                    , photoUrlInput = photoUrl
                    , formAction = Edit
                    , selectedUser = Just id
                }
                    ! []

        DeleteUser id ->
            { model
                | formAction = Delete
                , selectedUser = Just id
            }
                ! [ Rest.delete { model | selectedUser = Just id } ]

        NewUser ->
            { model
                | formAction = Create
                , firstNameInput = ""
                , lastNameInput = ""
                , emailInput = ""
                , photoUrlInput = ""
                , selectedUser = Nothing
            }
                ! []

        ProcessUserGet (Ok users) ->
            { model
                | users = users
                , errors = Nothing
            }
                ! []

        ProcessUserGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserPost (Ok user) ->
            { model | formAction = None } ! [ Rest.get ]

        ProcessUserPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        SetFirstNameInput value ->
            { model | firstNameInput = value } ! []

        SetLastNameInput value ->
            { model | lastNameInput = value } ! []

        SetEmailInput value ->
            { model | emailInput = value } ! []

        SetPhotoUrlInput value ->
            { model | photoUrlInput = value } ! []

        UserPost model ->
            model ! [ Rest.post model ]

        UserPut model ->
            model ! [ Rest.put model ]



{- Rotate table ordering : Ascending -> Descending -> No sorting -> ... -}
--this should be a utility function.  Should we have to have a reference to a rendering module to determine sort order?


rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Nothing

        Nothing ->
            Just Table.Ascending