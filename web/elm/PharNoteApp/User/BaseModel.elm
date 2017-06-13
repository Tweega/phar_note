module PharNoteApp.User.BaseModel exposing (..)

--base model needed to avoid circular links between many to many data definitions


type alias User =
    { id : Int
    , first_name : String
    , last_name : String
    , email : String
    , photo_url : String
    }
