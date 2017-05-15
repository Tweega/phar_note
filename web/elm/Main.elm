module Main exposing (..)

import Html exposing (..)
import PharNoteApp.Model exposing (Model, init)
import PharNoteApp.View exposing (view)
import PharNoteApp.Update exposing (update)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
