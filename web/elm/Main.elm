module Main exposing (..)

import Html exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.Init exposing (init)
import PharNoteApp.View exposing (view)
import PharNoteApp.Msg exposing (Msg(..))
import PharNoteApp.Subscriptions exposing (subscriptions)
import PharNoteApp.Update exposing (update)
import Navigation


main : Program Never Model Msg
main =
    Navigation.program NavigateTo
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
