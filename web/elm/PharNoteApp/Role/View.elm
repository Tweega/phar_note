module PharNoteApp.Role.View exposing (view, findRole)

import PharNoteApp.Role.Rest as Rest
import PharNoteApp.Role.BaseModel as BaseModel
import PharNoteApp.Role.Model as Role
import PharNoteApp.Role.Model exposing (FormAction(..))
import PharNoteApp.Role.Msg as RoleMsg
import PharNoteApp.Msg as AppMsg
import PharNoteApp.HtmlUtils as HtmlUtils
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Table as Table
import Material.Options as Options exposing (when, nop)


view : Role.Model -> Html AppMsg.Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ button [ onClick (AppMsg.MsgForRole RoleMsg.NewRole), class "button btn-primary" ] [ text "New Role" ]
            ]
        , div [ class "row" ]
            [ roleTable model.roles model.selectedRole model.order
            , formColumn model
            ]
        ]


formColumn : Role.Model -> Html AppMsg.Msg
formColumn model =
    let
        innerForm =
            if model.formAction == Create || model.formAction == Edit then
                roleForm model
            else
                div [] []
    in
        div [ class "col-md-3" ]
            [ innerForm ]


findRole : Int -> List BaseModel.Role -> Maybe BaseModel.Role
findRole id roles =
    roles
        |> List.filter (\role -> role.id == id)
        |> List.head


fieldStringValue : Maybe BaseModel.Role -> Role.FormAction -> (BaseModel.Role -> String) -> String
fieldStringValue role formAction extractor =
    case role of
        Just role ->
            if formAction == Edit then
                extractor role
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe BaseModel.Role -> Role.FormAction -> (BaseModel.Role -> Int) -> String
fieldIntValue role formAction extractor =
    case role of
        Just role ->
            if formAction == Edit then
                extractor role |> toString
            else
                ""

        Nothing ->
            ""


roleForm : Role.Model -> Html AppMsg.Msg
roleForm model =
    let
        role =
            case model.selectedRole of
                Just id ->
                    findRole id model.roles

                Nothing ->
                    Nothing

        roleName =
            fieldStringValue role model.formAction .role_name

        roleDesc =
            fieldStringValue role model.formAction .role_desc

        buttonText =
            if model.formAction == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if model.formAction == Edit then
                AppMsg.MsgForRole (RoleMsg.RolePut model)
            else
                AppMsg.MsgForRole (RoleMsg.RolePost model)
    in
        Html.form []
            [ div [ class "form-group" ]
                [ label [] [ text "Role" ]
                , input [ onInput (\s -> AppMsg.MsgForRole (RoleMsg.SetRoleNameInput s)), value model.roleNameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Last Name" ]
                , input [ onInput (\s -> AppMsg.MsgForRole (RoleMsg.SetRoleDescInput s)), value model.roleDescInput, class "form-control" ] []
                ]
            , button [ HtmlUtils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
            ]


roleTable : List BaseModel.Role -> Maybe Int -> Maybe Table.Order -> Html AppMsg.Msg
roleTable roles selectedRole order =
    --this needs to be done in update, otherwise index out of phase with selected item
    let
        sort =
            case order of
                Just Table.Ascending ->
                    List.sortBy sort_by_role

                Just Table.Descending ->
                    List.sortWith (\x y -> reverse (sort_by_role x) (sort_by_role y))

                Nothing ->
                    identity

        sortedRoles =
            sort roles
    in
        div [ class "col-md-9" ]
            [ Table.table []
                [ roleTableHeader order
                , tbody [] (roleRows sortedRoles selectedRole)
                ]
            ]


roleTableHeader : Maybe Table.Order -> Html AppMsg.Msg
roleTableHeader order =
    Table.thead []
        [ Table.tr []
            [ Table.th [] []
            , Table.th [] []
            , Table.th
                [ order
                    |> Maybe.map Table.sorted
                    |> Maybe.withDefault nop
                , Options.onClick (AppMsg.MsgForRole RoleMsg.Reorder)
                ]
                [ text "Role" ]
            , Table.th [] [ text "Description" ]
            ]
        ]


roleRows : List BaseModel.Role -> Maybe Int -> List (Html AppMsg.Msg)
roleRows roles selectedRole =
    roles
        |> List.map (roleRow selectedRole)


roleRow : Maybe Int -> BaseModel.Role -> Html AppMsg.Msg
roleRow selectedRole role =
    let
        row_style =
            case selectedRole of
                Just roleID ->
                    if roleID == role.id then
                        (Options.css "background-color" "green"
                            :: Options.onClick (AppMsg.MsgForRole (RoleMsg.SelectRole role.id))
                            :: []
                        )
                    else
                        (Options.onClick (AppMsg.MsgForRole (RoleMsg.SelectRole role.id))
                            :: []
                        )

                Nothing ->
                    (Options.onClick (AppMsg.MsgForRole (RoleMsg.SelectRole role.id))
                        :: []
                    )
    in
        Table.tr row_style
            [ Table.td [] [ button [ onClick (AppMsg.MsgForRole (RoleMsg.EditRole role.id)), class "button btn-primary" ] [ text "Edit" ] ]
            , Table.td [] [ button [ onClick (AppMsg.MsgForRole (RoleMsg.DeleteRole role.id)), class "button btn-primary" ] [ text "Delete" ] ]
            , Table.td [] [ text role.role_name ]
            , Table.td [] [ text role.role_desc ]
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


sort_by_role : BaseModel.Role -> String
sort_by_role u =
    u.role_name
