module PharNoteApp.Model exposing (..)

import PharNoteApp.User.Model as User
import PharNoteApp.Chart.Model as Chart
import Material


--import PharNoteApp.User.Rest as Rest


type alias Model =
    { mdl : Material.Model
    , userData : User.Model
    , chartData : Chart.Model
    , activeUser : String --this should be a whole data structure?
    }
