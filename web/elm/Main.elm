module Main exposing (..)

import Html exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.Init exposing (init)
import PharNoteApp.View exposing (view)
import PharNoteApp.Msg exposing (Msg)
import PharNoteApp.Subscriptions exposing (subscriptions)
import PharNoteApp.Update exposing (update)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
