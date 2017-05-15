module PharNoteApp.Update exposing (..)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.Update as User


update : Msg -> Model -> Model
update msg model =
    { model
        | userData = User.update msg model.userData
    }
        ! []
