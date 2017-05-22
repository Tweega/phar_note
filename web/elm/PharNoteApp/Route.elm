module PharNoteApp.Route exposing (..)

import Navigation
import UrlParser exposing (parsePath, oneOf, map, top, s, (</>), string)


type Route
    = Home
    | Users
    | Roles


type alias RouteModel =
    Maybe Route


pathParser : UrlParser.Parser (Route -> a) a
pathParser =
    oneOf
        [ map Home top
        , map Users (s "users")
        , map Roles (s "roles")
        ]


init : Maybe Route -> List (Maybe Route)
init location =
    case location of
        Nothing ->
            [ Just Home ]

        something ->
            [ something ]


urlFor : Route -> String
urlFor loc =
    case loc of
        Home ->
            "/"

        Users ->
            "/users"

        Roles ->
            "/roles"


locFor : Navigation.Location -> Maybe Route
locFor path =
    parsePath pathParser path
