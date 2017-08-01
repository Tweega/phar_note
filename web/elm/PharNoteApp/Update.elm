module PharNoteApp.Update exposing (..)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.Update as User
import PharNoteApp.User.Rest as UserData
import PharNoteApp.Role.Update as Role
import PharNoteApp.Role.Rest as RoleData
import PharNoteApp.Equipment.Update as Equipment
import PharNoteApp.Equipment.Rest as EquipmentData
import PharNoteApp.EquipmentClass.Update as EquipmentClass
import PharNoteApp.EquipmentClass.Rest as EquipmentClassData
import PharNoteApp.Chart.Update as Chart
import PharNoteApp.Route as Route
import Material
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Mdl message_ ->
            Material.update Mdl message_ model

        NavigateTo location ->
            location
                |> Route.locFor
                |> urlUpdate model

        NewUrl url ->
            model ! [ Navigation.newUrl url ]

        SelectUser user ->
            { model
                | activeUser = user
            }
                ! []

        MsgForUser userMsg ->
            let
                ( user_data, cmd ) =
                    User.update userMsg model.userData
            in
                ( { model
                    | userData = user_data
                  }
                , cmd
                )

        MsgForRole roleMsg ->
            let
                ( role_data, cmd ) =
                    Role.update roleMsg model.roleData
            in
                ( { model
                    | roleData = role_data
                  }
                , cmd
                )

        MsgForCampaign campaignMsg ->
            model ! []

        MsgForEquipment equipMsg ->
            let
                ( equip_data, cmd ) =
                    Equipment.update equipMsg model.equipmentData
            in
                ( { model
                    | equipmentData = equip_data
                  }
                , cmd
                )

        MsgForEquipmentClass equipMsg ->
            let
                ( equipclass_data, cmd ) =
                    EquipmentClass.update equipMsg model.equipmentClassData
            in
                ( { model
                    | equipmentClassData = equipclass_data
                  }
                , cmd
                )

        MsgForChart chartMsg ->
            let
                ( chart_data, cmd ) =
                    Chart.update chartMsg model.chartData
            in
                ( { model
                    | chartData = chart_data
                  }
                , cmd
                )


urlUpdate : Model -> Maybe Route.Route -> ( Model, Cmd Msg )
urlUpdate model route =
    let
        newModel =
            { model
                | history = route :: model.history
                , activeRoute = route
            }

        cmd =
            case route of
                Just Route.Users ->
                    case model.userData.selectedUserId of
                        Nothing ->
                            [ UserData.get ]

                        Just something ->
                            []

                Just Route.Roles ->
                    [ RoleData.get ]

                Just Route.Equipment ->
                    case model.equipmentData.selectedEquipmentId of
                        Nothing ->
                            [ EquipmentData.get ]

                        Just something ->
                            []

                Just Route.EquipmentClass ->
                    case model.equipmentClassData.selectedEquipmentClassId of
                        Nothing ->
                            [ EquipmentClassData.get ]

                        Just something ->
                            []

                _ ->
                    []
    in
        newModel ! cmd
