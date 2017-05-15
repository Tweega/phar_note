module PharNoteApp.Model exposing (..)

import PharNoteApp.User.Model as User


type alias Model =
    { userData : User.Model
    }


initialModel : Model
initialModel =
    { userData = User.model
    }


init : ( Model, Cmd Msg )
init =
    initialModel
