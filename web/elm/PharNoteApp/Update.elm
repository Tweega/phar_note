module PharNoteApp.Update exposing (..)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.Update as User


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

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
