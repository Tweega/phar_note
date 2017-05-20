module PharNoteApp.Update exposing (..)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.Update as User
import PharNoteApp.Chart.Update as Chart
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Mdl message_ ->
            Material.update Mdl message_ model

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
