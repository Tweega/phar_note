module PharNoteApp.Equipment.BaseModel exposing (..)

--base model needed to avoid circular links between many to many data definitions


type alias Equipment =
    { id : Int
    , equipment_name : String
    , equipment_code : String
    , class_id : Int
    , class_name : String
    , precision_id : Int
    , precision : String
    }


emptyEquipment : Equipment
emptyEquipment =
    Equipment 0 "" "" 0 "" 0 ""
