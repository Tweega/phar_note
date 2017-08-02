module PharNoteApp.Campaign.BaseModel exposing (..)

import Date exposing (..)


--base model needed to avoid circular links between many to many data definitions


type alias Location =
    { id : Int
    , location_name : String
    }


type alias Product =
    { id : Int
    , product_name : String
    }


type alias Precision =
    { id : Int
    , precision : String
    }


type alias Class =
    { id : Int
    , name : String
    }


type alias Requirement =
    { id : Int
    , precision : Precision
    , current_fulfillment : Fulfilment

    -- , fulfilments : List Fulfilment
    }


type alias Fulfilment =
    { id : Int
    , precision : Precision
    }


type alias Campaign =
    { id : Int
    , campaign_name : String
    , campaign_desc : String

    -- , product : Product
    -- , location : Location
    -- , requirements : List Requirement
    , planned_start : String
    , planned_end : String
    , actual_start : String
    , actual_end : String
    , order_number : String
    }


type alias CampaignActual =
    { id : Int
    , campaign_name : String
    , campaign_desc : String
    , product : Product
    , location : Location
    , requirements : List Requirement
    , planned_start : Date
    , planned_end : Date
    , actual_start : Date
    , actual_end : Date
    , order_number : String

    -- , status
    }


emptyCampaign : Campaign
emptyCampaign =
    Campaign 0 "" "" "" "" "" "" ""
