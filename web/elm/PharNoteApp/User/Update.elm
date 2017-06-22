module PharNoteApp.User.Update exposing (..)

import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Model as User
import PharNoteApp.User.BaseModel as UserBase
import PharNoteApp.User.Model exposing (RefDataStatus(..))
import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table
import Array exposing (fromList)
import Dict exposing (Dict)
import Set exposing (Set)


update : Msg -> User.Model -> ( User.Model, Cmd AppMsg.Msg )
update msg model =
    let
        details =
            model.details

        selector =
            model.selector
    in
        case msg of
            NoOp ->
                model ! []

            KeyDown key ->
                let
                    userCount =
                        Array.length (details.users)

                    currentIdx =
                        case details.selectedUserIndex of
                            Nothing ->
                                -1

                            Just ndx ->
                                ndx

                    idx =
                        if key == 38 && currentIdx > 0 then
                            currentIdx - 1
                        else if key == 40 && currentIdx < userCount - 1 then
                            currentIdx + 1
                        else
                            currentIdx

                    user =
                        View.maybeFindUser (Just idx) details.users

                    newDetails =
                        case user of
                            Just u ->
                                { details
                                    | selectedUserId = Just u.id
                                    , selectedUserIndex = Just idx
                                }

                            _ ->
                                details

                    newModel =
                        { model
                            | details = newDetails
                        }

                    --populateScratchUserData user (Just idx) model model.formAction
                in
                    newModel ! []

            SelectUser idx ->
                let
                    user =
                        View.maybeFindUser (Just idx) details.users

                    ( newDetails, newSelector ) =
                        case user of
                            Just u ->
                                ( { details
                                    | selectedUserId = Just u.id
                                    , selectedUserIndex = Just idx
                                  }
                                , { selector
                                    | selectedUserId = Just u.id
                                    , selectedUserIndex = Just idx
                                  }
                                )

                            _ ->
                                ( details, selector )

                    newModel =
                        { model
                            | selector = newSelector
                            , details = newDetails
                        }

                    --populateScratchUserData user (Just idx) model model.formAction
                in
                    newModel
                        ! []

            Reorder ->
                let
                    sortOrder =
                        toggleSort details.order

                    sort =
                        case sortOrder of
                            Just Table.Ascending ->
                                List.sortBy sort_by_last_first

                            Just Table.Descending ->
                                List.sortWith (\x y -> reverse (sort_by_last_first x) (sort_by_last_first y))

                            Nothing ->
                                identity

                    sortedUsers =
                        sort (Array.toList details.users) |> Array.fromList

                    newDetails =
                        { details | order = sortOrder, users = sortedUsers }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            DeleteUser ->
                let
                    idx =
                        details.selectedUserIndex

                    usr =
                        View.maybeFindUser idx details.users

                    ( newDetails, cmds ) =
                        case usr of
                            Nothing ->
                                ( details, [] )

                            Just user ->
                                ( { details
                                    | formAction = User.Delete
                                    , selectedUserId = Just user.id
                                  }
                                , [ Rest.delete user ]
                                )

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! cmds

            EditUser ->
                let
                    idx =
                        details.selectedUserIndex

                    user =
                        View.maybeFindUser idx details.users

                    newModel =
                        populateScratchUserData user idx model User.Edit
                in
                    newModel
                        ! []

            NewUser ->
                let
                    newDetails =
                        { details
                            | formAction = User.Create
                            , scratchUser = User.emptyUserWithRoleSet
                            , selectedUserId = Nothing
                            , selectedUserIndex = Nothing
                            , previousSelectedUserIndex = details.selectedUserIndex
                            , previousSelectedUserId = details.selectedUserId
                        }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            CancelNewUser ->
                let
                    newDetails =
                        case details.formAction of
                            User.Create ->
                                { details
                                    | formAction = User.Cancel
                                    , selectedUserId = details.previousSelectedUserId
                                    , selectedUserIndex = details.previousSelectedUserIndex
                                }

                            _ ->
                                { details
                                    | formAction = User.Cancel
                                }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            ProcessRefDataGet (Ok roles) ->
                let
                    roleDict =
                        List.map (\role -> ( role.id, role )) roles
                            |> Dict.fromList

                    newDetails =
                        { details
                            | refDataStatus = Loaded (User.RefData roleDict)
                        }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            ProcessRefDataGet (Err error) ->
                let
                    newDetails =
                        { details
                            | errors = Just error
                        }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            ProcessUserGet (Ok users) ->
                let
                    x =
                        Debug.log "Fetched" "users"

                    userArray =
                        Array.fromList (users)

                    ( selectedUserId, selectedUserIndex ) =
                        case details.selectedUserIndex of
                            Nothing ->
                                let
                                    first_user =
                                        Array.get 0 userArray
                                in
                                    case first_user of
                                        Nothing ->
                                            ( Nothing, Nothing )

                                        Just user ->
                                            ( Just user.id, Just 0 )

                            _ ->
                                ( details.selectedUserId, details.selectedUserIndex )

                    --if we have done an edit then the selected user and index will stay the same
                    newDetails =
                        { details
                            | selectedUserId = selectedUserId
                            , selectedUserIndex = selectedUserIndex
                            , users = userArray
                            , errors = Nothing
                        }

                    newSelector =
                        { selector
                            | selectedUserId = selectedUserId
                            , selectedUserIndex = selectedUserIndex
                        }
                in
                    { model
                        | selector = newSelector
                        , details = newDetails
                    }
                        ! []

            ProcessUserGet (Err error) ->
                let
                    newDetails =
                        { details
                            | errors = Just error
                        }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            ProcessUserPost (Ok user) ->
                let
                    newDetails =
                        { details | formAction = User.None }
                in
                    { model
                        | details = newDetails
                    }
                        ! [ Rest.get ]

            ProcessUserPost (Err error) ->
                let
                    newDetails =
                        { details
                            | errors = Just error
                        }

                    newModel =
                        { model
                            | details = newDetails
                        }
                in
                    newModel ! []

            UserPost user ->
                case details.refDataStatus of
                    Loaded refData ->
                        let
                            userWithRoles =
                                User.scratchToUserWithRoles details.scratchUser refData

                            h =
                                Debug.log "Roles" userWithRoles
                        in
                            model ! [ Rest.post userWithRoles ]

                    _ ->
                        --need to provide a message here.
                        model ! []

            UserPut user ->
                case details.refDataStatus of
                    Loaded refData ->
                        let
                            userWithRoles =
                                User.scratchToUserWithRoles details.scratchUser refData
                        in
                            model ! [ Rest.put userWithRoles ]

                    _ ->
                        --need to provide a message here.
                        model ! []

            SetFirstName value ->
                let
                    user =
                        details.scratchUser

                    new_user =
                        { user | first_name = value }

                    newDetails =
                        { details | scratchUser = new_user }
                in
                    { model | details = newDetails } ! []

            SetLastName value ->
                let
                    user =
                        details.scratchUser

                    new_user =
                        { user | last_name = value }

                    newDetails =
                        { details | scratchUser = new_user }
                in
                    { model | details = newDetails } ! []

            SetEmail value ->
                let
                    user =
                        details.scratchUser

                    new_user =
                        { user | email = value }

                    newDetails =
                        { details | scratchUser = new_user }
                in
                    { model | details = newDetails } ! []

            SetPhotoUrl value ->
                let
                    user =
                        details.scratchUser

                    new_user =
                        { user | photo_url = value }

                    newDetails =
                        { details | scratchUser = new_user }
                in
                    { model | details = newDetails } ! []

            ToggleRole roleID ->
                let
                    user =
                        details.scratchUser

                    roleSet =
                        user.roles

                    newRoleSet =
                        case Set.member roleID roleSet of
                            True ->
                                Set.remove roleID roleSet

                            False ->
                                Set.insert roleID roleSet

                    newUser =
                        { user | roles = newRoleSet }

                    newDetails =
                        { details | scratchUser = newUser }
                in
                    { model | details = newDetails } ! []



{- Rotate table ordering : Ascending -> Descending -> No sorting -> ... -}
--this should be a utility function.  Should we have to have a reference to a rendering module to determine sort order?


toggleSort : Maybe Table.Order -> Maybe Table.Order
toggleSort order =
    case order of
        Just Table.Ascending ->
            Just Table.Descending

        Just Table.Descending ->
            Just Table.Ascending

        Nothing ->
            Just Table.Ascending


populateScratchUserData : Maybe User.UserWithRoles -> Maybe Int -> User.Model -> User.FormAction -> User.Model
populateScratchUserData maybeUser maybeUserIndex model action =
    let
        details =
            model.details

        newDetails =
            case maybeUser of
                Nothing ->
                    --could we realistically arrive here?
                    { details
                        | scratchUser = User.emptyUserWithRoleSet
                        , formAction = action
                        , selectedUserId = Nothing
                        , selectedUserIndex = Nothing
                    }

                Just u ->
                    --if we only have role ids, not the whole role record, then we won't need the first map function
                    let
                        roleSet =
                            List.map (\r -> r.id) u.roles
                                |> Set.fromList
                    in
                        { details
                            | scratchUser = User.UserWithRoleSet u.id u.first_name u.last_name u.email u.photo_url roleSet
                            , formAction = action
                            , selectedUserId = Just u.id
                            , selectedUserIndex = maybeUserIndex
                        }
    in
        { model
            | details = newDetails
        }


sort_by_last_first : User.UserWithRoles -> String
sort_by_last_first u =
    u.last_name ++ u.first_name


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ
