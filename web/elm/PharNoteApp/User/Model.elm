module PharNoteApp.User.Model exposing (..)

import Material.Table as Table
import Http exposing (..)


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    }


type alias Model =
    { users : List User
    , formAction : FormAction
    , selectedUser : Maybe Int
    , order : Maybe Table.Order
    , errors : Maybe Http.Error
    , firstNameInput : String
    , lastNameInput : String
    , emailInput : String
    , photoUrlInput : String
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None
