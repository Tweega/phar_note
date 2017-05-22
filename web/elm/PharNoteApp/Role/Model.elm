module PharNoteApp.Role.Model exposing (..)

import Material.Table as Table
import Http exposing (..)


type alias Role =
    { id : Int
    , role_name : String
    , role_desc : String
    }


type alias Model =
    { roles : List Role
    , formAction : FormAction
    , selectedRole : Maybe Int
    , roleNameInput : String
    , roleDescInput : String
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None
