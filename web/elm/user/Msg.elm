module PharNoteApp.User.Msg exposing (..)


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
