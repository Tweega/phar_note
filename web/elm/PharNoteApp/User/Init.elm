module PharNoteApp.User.Init exposing (..)

import PharNoteApp.User.Rest exposing (get)
import PharNoteApp.User.Model exposing (Model, FormAction(..))
import PharNoteApp.Msg as AppMsg
import Material.Table as Table


init : ( Model, Cmd AppMsg.Msg )
init =
    ( { users = []
      , formAction = None
      , selectedUser = Nothing
      , order = Just Table.Ascending
      , errors = Nothing
      , firstNameInput = ""
      , lastNameInput = ""
      , emailInput = ""
      , photoUrlInput = ""
      }
    , get
    )
