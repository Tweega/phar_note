module PharNoteApp.User.Model exposing (..)


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    }
