module PharNoteApp.User.Msg exposing (..)

import PharNoteApp.User.BaseModel as BaseModel
import PharNoteApp.User.Model as User
import Http exposing (..)


type Msg
    = NoOp
    | EditUser Int
    | SelectUser Int
    | DeleteUser Int
    | NewUser
    | ProcessUserGet (Result Http.Error (List BaseModel.User))
    | ProcessUserPost (Result Http.Error BaseModel.User)
    | SetFirstNameInput String
    | SetLastNameInput String
    | SetEmailInput String
    | SetPhotoUrlInput String
    | UserPost User.Model
    | UserPut User.Model
    | Reorder
    | KeyX Int
    | SelectTab Int
