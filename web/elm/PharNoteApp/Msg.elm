module PharNoteApp.Msg exposing (..)

import PharNoteApp.User.Msg as User
import PharNoteApp.Chart.Msg as Chart
import Material


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | MsgForUser User.Msg
    | MsgForChart Chart.Msg
    | SelectUser String
