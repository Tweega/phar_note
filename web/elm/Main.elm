module Main exposing (..)

import Html exposing (..)
import Model exposing (..)
import UserHttp
import Update
import Subscriptions
import View


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init ! [ UserHttp.get ]
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
