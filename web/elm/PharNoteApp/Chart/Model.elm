module PharNoteApp.Chart.Model exposing (..)

import Dict exposing (Dict)
import Material


type alias Model =
    { mdl : Material.Model
    , toggles : Dict (List Int) Bool
    }
