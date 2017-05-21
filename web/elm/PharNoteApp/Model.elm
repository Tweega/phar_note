module PharNoteApp.Model exposing (..)

import PharNoteApp.User.Model as User
import PharNoteApp.Chart.Model as Chart
import Material
import PharNoteApp.Route exposing (Route)


--import PharNoteApp.User.Rest as Rest


type alias Model =
    { mdl : Material.Model
    , history : List (Maybe Route)
    , userData : User.Model
    , chartData : Chart.Model
    , activeUser : String --this should be a whole data structure?
    }
