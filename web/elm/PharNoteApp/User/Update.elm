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
    case msg of
        NoOp ->
            model ! []

        SelectTab idx ->
            { model | selectedTab = idx } ! []

        KeyX key ->
            let
                userCount =
                    Array.length (model.users)

                currentIdx =
                    case model.selectedUserIndex of
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
                    View.maybeFindUser (Just idx) model.users

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedUserId = Just u.id
                                , selectedUserIndex = Just idx
                            }

                        _ ->
                            model

                --populateScratchUserData user (Just idx) model model.formAction
            in
                newModel ! []

        SelectUser idx ->
            let
                user =
                    View.maybeFindUser (Just idx) model.users

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedUserId = Just u.id
                                , selectedUserIndex = Just idx
                            }

                        _ ->
                            model

                --populateScratchUserData user (Just idx) model model.formAction
            in
                newModel
                    ! []

        Reorder ->
            let
                sortOrder =
                    toggleSort model.order

                sort =
                    case sortOrder of
                        Just Table.Ascending ->
                            List.sortBy sort_by_last_first

                        Just Table.Descending ->
                            List.sortWith (\x y -> reverse (sort_by_last_first x) (sort_by_last_first y))

                        Nothing ->
                            identity

                sortedUsers =
                    sort (Array.toList model.users) |> Array.fromList
            in
                { model | order = sortOrder, users = sortedUsers } ! []

        DeleteUser ->
            let
                idx =
                    model.selectedUserIndex

                usr =
                    View.maybeFindUser idx model.users
            in
                case usr of
                    Nothing ->
                        model ! []

                    Just user ->
                        --we need to identify a record to be current after successful delete
                        let
                            --this would be a cse of using one of those never fail things as if idx was Nothing we would not get here.
                            i =
                                case idx of
                                    Just x ->
                                        x

                                    _ ->
                                        0

                            ( maybeNextUser, nextIndex ) =
                                case View.maybeFindUser (Just (i + 1)) model.users of
                                    Nothing ->
                                        case View.maybeFindUser (Just (i - 1)) model.users of
                                            Nothing ->
                                                ( Nothing, -1 )

                                            Just uu ->
                                                ( Just uu, i - 1 )

                                    Just u ->
                                        ( Just u, i )

                            newModel =
                                case maybeNextUser of
                                    Nothing ->
                                        { model
                                            | formAction = User.Delete
                                            , selectedUserId = Just user.id
                                        }

                                    Just nextUser ->
                                        { model
                                            | formAction = User.Delete
                                            , selectedUserId = Just user.id
                                            , previousSelectedUserId = Just nextUser.id
                                            , previousSelectedUserIndex = Just nextIndex
                                        }
                        in
                            newModel ! [ Rest.delete user ]

        EditUser ->
            let
                idx =
                    model.selectedUserIndex

                user =
                    View.maybeFindUser idx model.users

                newModel =
                    populateScratchUserData user idx model User.Edit
            in
                newModel
                    ! []

        NewUser ->
            { model
                | formAction = User.Create
                , scratchUser = User.emptyUserWithRoleSet
                , selectedUserId = Nothing
                , selectedUserIndex = Nothing
                , previousSelectedUserIndex = model.selectedUserIndex
                , previousSelectedUserId = model.selectedUserId
            }
                ! []

        CancelNewUser ->
            let
                newModel =
                    case model.formAction of
                        User.Create ->
                            { model
                                | formAction = User.Cancel
                                , selectedUserId = model.previousSelectedUserId
                                , selectedUserIndex = model.previousSelectedUserIndex
                            }

                        _ ->
                            { model
                                | formAction = User.Cancel
                            }
            in
                newModel ! []

        ProcessRefDataGet (Ok roles) ->
            let
                roleDict =
                    List.map (\role -> ( role.id, role )) roles
                        |> Dict.fromList
            in
                { model
                    | refDataStatus = Loaded (User.RefData roleDict)
                }
                    ! []

        ProcessRefDataGet (Err error) ->
            let
                x =
                    Debug.log "refdata error" error
            in
                { model
                    | errors = Just error
                }
                    ! []

        ProcessUserGet (Ok users) ->
            let
                x =
                    Debug.log "Fetched" "users"

                userArray =
                    Array.fromList (users)

                userCount =
                    Array.length userArray

                ( selectedUserId, selectedUserIndex, firstIndex, lastIndex ) =
                    case model.selectedUserIndex of
                        Nothing ->
                            let
                                first_user =
                                    Array.get 0 userArray

                                firstIdx =
                                    0

                                lastIdx =
                                    if userCount > model.pageSize then
                                        model.pageSize - 1
                                    else
                                        userCount - 1
                            in
                                case first_user of
                                    Nothing ->
                                        ( Nothing, Nothing, -1, -1 )

                                    Just user ->
                                        ( Just user.id, Just 0, firstIdx, lastIdx )

                        --working here.  If screen refreshes and other people have added/deleted users, then index will not be reliable.
                        -- need to check if the retrieved user has the correct id, otherwise do a proper search on id
                        --perhaps use dict, though it is a reasonable bet that the index will be within 1 or 2 of its previous value
                        --so alternate search in each direction - more index will only have been affected by activity in the lower index range
                        --if there has been a delete, then search lower indices - if there have been additions, then search higher
                        --we won't know what has happened, so search both ways?
                        --might alternatively consult the log for the past n seconds and calculate correct index from that
                        _ ->
                            ( model.selectedUserId, model.selectedUserIndex, model.startDisplayIndex, model.endDisplayIndex )

                y =
                    Debug.log "user id" model.selectedUserId

                z =
                    Debug.log "user index" model.selectedUserIndex

                --if we have done an edit then the selected user and index will stay the same
            in
                { model
                    | selectedUserId = selectedUserId
                    , selectedUserIndex = selectedUserIndex
                    , startDisplayIndex = firstIndex
                    , endDisplayIndex = lastIndex
                    , users = userArray
                    , errors = Nothing
                }
                    ! []

        ProcessUserGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserPost (Ok user) ->
            { model | formAction = User.None } ! [ Rest.get ]

        ProcessUserPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserDelete (Ok user) ->
            -- need to set current user to previousSelectedUserId
            { model
                | formAction = User.None
                , selectedUserId = model.previousSelectedUserId
                , selectedUserIndex = model.previousSelectedUserIndex
            }
                ! [ Rest.get ]

        ProcessUserDelete (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        UserPost user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            User.scratchToUserWithRoles model.scratchUser refData

                        h =
                            Debug.log "Roles" userWithRoles
                    in
                        model ! [ Rest.post userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        UserPut user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            User.scratchToUserWithRoles model.scratchUser refData
                    in
                        model ! [ Rest.put userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        SetFirstName value ->
            let
                user =
                    model.scratchUser

                new_user =
                    { user | first_name = value }
            in
                { model | scratchUser = new_user } ! []

        SetLastName value ->
            let
                user =
                    model.scratchUser

                new_user =
                    { user | last_name = value }
            in
                { model | scratchUser = new_user } ! []

        SetEmail value ->
            let
                user =
                    model.scratchUser

                new_user =
                    { user | email = value }
            in
                { model | scratchUser = new_user } ! []

        SetPhotoUrl value ->
            let
                user =
                    model.scratchUser

                new_user =
                    { user | photo_url = value }
            in
                { model | scratchUser = new_user } ! []

        ToggleRole roleID ->
            let
                user =
                    model.scratchUser

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
            in
                { model | scratchUser = newUser } ! []

        UserSlider valuePC ->
            let
                len =
                    Array.length model.users

                reducedLen =
                    len - model.pageSize

                start =
                    floor ((valuePC / 100) * (toFloat reducedLen))

                end =
                    start + model.pageSize
            in
                { model
                    | startDisplayIndex = start
                    , endDisplayIndex = end
                }
                    ! []



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
    case maybeUser of
        Nothing ->
            --could we realistically arrive here?
            { model
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
                { model
                    | scratchUser = User.UserWithRoleSet u.id u.first_name u.last_name u.email u.photo_url roleSet
                    , formAction = action
                    , selectedUserId = Just u.id
                    , selectedUserIndex = maybeUserIndex
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
