module PharNoteApp.Role.BaseModel exposing (..)


type alias Role =
    { id : Int
    , role_name : String
    , role_desc : String
    }


emptyRole : Role
emptyRole =
    Role 0 "" ""
