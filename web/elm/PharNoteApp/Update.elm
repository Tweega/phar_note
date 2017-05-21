module PharNoteApp.Update exposing (..)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.Update as User
import PharNoteApp.User.Rest as UserData
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
            { model | history = route :: model.history }
    in
        case route of
            Just Route.Users ->
                newModel ! [ UserData.get ]

            _ ->
                newModel ! []
