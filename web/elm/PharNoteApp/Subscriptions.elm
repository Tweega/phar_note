module PharNoteApp.Subscriptions exposing (subscriptions)

import PharNoteApp.Model exposing (Model)
import PharNoteApp.Msg exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
