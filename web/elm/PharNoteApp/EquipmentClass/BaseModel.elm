module PharNoteApp.EquipmentClass.BaseModel exposing (..)

--base model needed to avoid circular links between many to many data definitions


type alias EquipmentClass =
    { id : Int
    , name : String
    , description : String
    }


type alias EquipmentPrecision =
    { id : Int
    , precision : String
    }


emptyEquipmentClass : EquipmentClass
emptyEquipmentClass =
    EquipmentClass 0 "" ""


emptyEquipmentPrecision : EquipmentPrecision
emptyEquipmentPrecision =
    EquipmentPrecision 0 ""
