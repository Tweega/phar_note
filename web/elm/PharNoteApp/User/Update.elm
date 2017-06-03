module PharNoteApp.User.Update exposing (..)

import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Model exposing (..)
import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table


update : Msg -> Model -> ( Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        KeyX key ->
            let
                x =
                    Debug.log "keyCode" key
            in
                model ! []

        SelectUser id ->
            let
                user =
                    View.findUser id model.users

                --this will be slow for large data sets
                newModel =
                    populateUserData user model model.formAction
            in
                newModel
                    ! []

        Reorder ->
            { model | order = rotate model.order } ! []

        EditUser id ->
            let
                user =
                    View.findUser id model.users

                newModel =
                    populateUserData user model Edit
            in
                model
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
            let
                first_user =
                    Utils.first users

                new_model =
                    case first_user of
                        Nothing ->
                            model

                        Just user ->
                            { model
                                | firstNameInput = user.first_name
                                , lastNameInput = user.last_name
                                , emailInput = user.email
                                , photoUrlInput = user.photo_url
                                , selectedUser = Just user.id
                            }
            in
                { new_model
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


populateUserData : Maybe User -> Model -> FormAction -> Model
populateUserData user model action =
    case user of
        Nothing ->
            { model
                | firstNameInput = ""
                , lastNameInput = ""
                , emailInput = ""
                , photoUrlInput = ""
                , formAction = action
                , selectedUser = Nothing
            }

        Just u ->
            { model
                | firstNameInput = u.first_name
                , lastNameInput = u.last_name
                , emailInput = u.email
                , photoUrlInput = u.photo_url
                , formAction = action
                , selectedUser = Just u.id
            }
