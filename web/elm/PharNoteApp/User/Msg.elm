module PharNoteApp.User.Msg exposing (..)

import PharNoteApp.User.Model as User


--import PharNoteApp.User.Model exposing (FilterAction(..))

import PharNoteApp.Role.BaseModel as Role
import Http exposing (..)


type Msg
    = NoOp
    | EditUser
    | SelectUser Int
    | DeleteUser
    | NewUser
    | CancelNewUser
    | ProcessUserGet (Result Http.Error (List User.UserWithRoles))
    | ProcessUserPost (Result Http.Error User.UserWithRoles)
    | ProcessUserDelete (Result Http.Error User.UserWithRoles)
    | ProcessRefDataGet (Result Http.Error (List Role.Role))
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPhotoUrl String
    | ToggleRole Int
    | UserPost User.UserWithRoleSet
    | UserPut User.UserWithRoleSet
    | Reorder
    | KeyX Int
    | PaginateUser Int
    | SelectTab User.UserTab
    | UserSlider Float
    | SetFilterFirstName String
    | SetFilterLastName String
    | ToggleFilterRole Int
    | ApplyUserFilter User.UserWithRoleSet
    | ResetUserFilter
    | ClearUserFilter
    | CancelUserFilter
    | ConfirmDeleteUser
    | CancelDeleteUser



--reset - clears entries on filter formAction
-- clear - goes back to original user list
-- cancel - just closes the filter form.
