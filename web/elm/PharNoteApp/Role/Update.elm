module PharNoteApp.Role.Update exposing (..)

import PharNoteApp.Role.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.Role.Model exposing (..)
import PharNoteApp.Role.Rest as Rest
import PharNoteApp.Role.View as View
import Material.Table as Table


update : Msg -> Model -> ( Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        SelectRole id ->
            { model
                | selectedRole = Just id
            }
                ! []

        Reorder ->
            { model | order = rotate model.order } ! []

        EditRole id ->
            let
                role =
                    View.findRole id model.roles

                roleName =
                    case role of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.role_name

                roleDesc =
                    case role of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.role_desc
            in
                { model
                    | roleNameInput = roleName
                    , roleDescInput = roleDesc
                    , formAction = Edit
                    , selectedRole = Just id
                }
                    ! []

        DeleteRole id ->
            { model
                | formAction = Delete
                , selectedRole = Just id
            }
                ! [ Rest.delete { model | selectedRole = Just id } ]

        NewRole ->
            { model
                | formAction = Create
                , roleNameInput = ""
                , roleDescInput = ""
                , selectedRole = Nothing
            }
                ! []

        ProcessRoleGet (Ok roles) ->
            { model
                | roles = roles
                , errors = Nothing
            }
                ! []

        ProcessRoleGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessRolePost (Ok role) ->
            { model | formAction = None } ! [ Rest.get ]

        ProcessRolePost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        SetRoleNameInput value ->
            { model | roleNameInput = value } ! []

        SetRoleDescInput value ->
            { model | roleDescInput = value } ! []

        RolePost model ->
            model ! [ Rest.post model ]

        RolePut model ->
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
