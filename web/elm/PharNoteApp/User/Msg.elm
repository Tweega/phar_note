module PharNoteApp.User.Msg exposing (..)

import PharNoteApp.User.Model as User
import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditUser Int
    | SelectUser Int
    | DeleteUser Int
    | NewUser
    | CancelNewUser
    | ProcessUserGet (Result Http.Error (List User.UserWithRoles))
    | ProcessUserPost (Result Http.Error User.UserWithRoles)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | UserPost User.UserWithRoles
    | UserPut User.UserWithRoles
    | Reorder
    | KeyX Int
    | SelectTab Int
