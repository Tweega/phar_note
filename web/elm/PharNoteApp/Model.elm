module PharNoteApp.Model exposing (..)

import PharNoteApp.User.Model as User
import PharNoteApp.Role.Model as Role
import PharNoteApp.Campaign.Model as Campaign
import PharNoteApp.Equipment.Model as Equipment
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.Chart.Model as Chart
import Material
import PharNoteApp.Route exposing (Route)


--import PharNoteApp.User.Rest as Rest


type alias Model =
    { mdl : Material.Model
    , history : List (Maybe Route)
    , userData : User.Model
    , roleData : Role.Model
    , campaignData : Campaign.Model
    , equipmentData : Equipment.Model
    , equipmentClassData : EquipmentClass.Model
    , chartData : Chart.Model
    , activeUser : String --this should be a whole data structure?
    , activeRoute : Maybe Route
    }
