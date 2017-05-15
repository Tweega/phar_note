module PharNoteApp.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


--import Html.Lazy exposing (lazy, lazy2)

import PharNoteApp.Msg exposing (..)
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.View as UserView


view : Model -> Html Msg
view model =
    let
        userData =
            model.userData
    in
        div
            []
            [ section
                [ id "PharNoteApp" ]
                [ User.taskEntry userData
                ]
            ]
