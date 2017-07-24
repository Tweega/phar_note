module PharNoteApp.Route exposing (..)

import Navigation
import UrlParser exposing (parsePath, oneOf, map, top, s, (</>), string)


type Route
    = Chart
    | Users
    | Roles
    | Campaigns
    | Equipment
    | EquipmentClass


type alias RouteModel =
    Maybe Route


pathParser : UrlParser.Parser (Route -> a) a
pathParser =
    oneOf
        [ map Chart top
        , map Users (s "users")
        , map Roles (s "roles")
        , map Campaigns (s "campaigns")
        , map Equipment (s "equipment")
        , map EquipmentClass (s "equipmentclass")
        ]


init : Maybe Route -> List (Maybe Route)
init location =
    case location of
        Nothing ->
            [ Just Chart ]

        something ->
            [ something ]


urlFor : Route -> String
urlFor loc =
    case loc of
        Chart ->
            "/"

        Users ->
            "/users"

        Roles ->
            "/roles"

        Campaigns ->
            "/campaigns"

        Equipment ->
            "/equipment"

        EquipmentClass ->
            "/equipmentclass"


locFor : Navigation.Location -> Maybe Route
locFor path =
    parsePath pathParser path


type alias RouteDetails =
    { title : String
    , desc : String
    }


routeDetails : Maybe Route -> RouteDetails
routeDetails maybeRoute =
    case maybeRoute of
        Just Chart ->
            RouteDetails "Chart report sample" "this page has sample reports"

        Just Users ->
            RouteDetails "User Administration" "Add, Edit Delete users"

        Just Roles ->
            RouteDetails "Role Administration" "Add, Edit Delete roles"

        Just Campaigns ->
            RouteDetails "Campaign Administration" "Add, Edit  campaigns"

        Just Equipment ->
            RouteDetails "Equipment Administration" "Add, Edit, Delete  equipment"

        Just EquipmentClass ->
            RouteDetails "Equipment Class Administration" "Add, Edit, Delete  equipment classes"

        _ ->
            RouteDetails "" ""
