module PharNoteApp.Msg exposing (..)

import PharNoteApp.User.Msg as User


type Msg
    = NoOp
    | MsgForUser User.Msg
