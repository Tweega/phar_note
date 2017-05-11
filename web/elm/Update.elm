module Update exposing (..)

import Model exposing (..)
import UserHttp
import View
import Material.Table as Table


update : Msg -> Model -> ( Model, Cmd Msg )
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
                ! [ UserHttp.delete { model | selectedUser = Just id } ]

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
            { model | formAction = None } ! [ UserHttp.get ]

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
            model ! [ UserHttp.post model ]

        UserPut model ->
            model ! [ UserHttp.put model ]



{- Rotate table ordering : Ascending -> Descending -> No sorting -> ... -}
--this should be a utility function


rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Nothing

        Nothing ->
            Just Table.Ascending
