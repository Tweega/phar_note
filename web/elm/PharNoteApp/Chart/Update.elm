module PharNoteApp.Chart.Update exposing (update)

import PharNoteApp.Chart.Model exposing (Model)
import PharNoteApp.Chart.Msg as ChartMsg
import PharNoteApp.Msg as AppMsg


--import Types exposing (User)

import Material


--import Material.Snackbar as Snackbar
--import Navigation
--import Route exposing (Route)

import Dict


--import Task


update : ChartMsg.Msg -> Model -> ( Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        ChartMsg.Toggle index ->
            let
                toggles =
                    case (Dict.get index model.toggles) of
                        Just v ->
                            Dict.insert index (not v) model.toggles

                        Nothing ->
                            Dict.insert index True model.toggles
            in
                { model | toggles = toggles } ! []
