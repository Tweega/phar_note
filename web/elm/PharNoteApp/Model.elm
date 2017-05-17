module PharNoteApp.Model exposing (..)

import PharNoteApp.User.Model as User


--import PharNoteApp.User.Rest as Rest


type alias Model =
    { userData : User.Model
    }
