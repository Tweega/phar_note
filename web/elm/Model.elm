module Model exposing (..)

import Http
import User exposing (..)
import Material.Table as Table


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


init : Model
init =
    { users = []
    , formAction = None
    , selectedUser = Nothing
    , order = Just Table.Ascending
    , errors = Nothing
    , firstNameInput = ""
    , lastNameInput = ""
    , emailInput = ""
    , photoUrlInput = ""
    }



-- Update


type Msg
    = NoOp
    | EditUser Int
    | DeleteUser Int
    | NewUser
    | ProcessUserGet (Result Http.Error (List User))
    | ProcessUserPost (Result Http.Error User)
    | SetFirstNameInput String
    | SetLastNameInput String
    | SetEmailInput String
    | SetPhotoUrlInput String
    | UserPost Model
    | UserPut Model
    | Reorder
