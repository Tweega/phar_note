module PharNoteApp.User.Update exposing (..)

import PharNoteApp.User.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.User.Model as User
import PharNoteApp.User.Model exposing (RefDataStatus(..))
import PharNoteApp.User.Rest as Rest
import PharNoteApp.User.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table
import Array exposing (fromList)
import Dict


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
                    View.findUser idx model.users

                newModel =
                    populateUserData user idx model model.formAction
            in
                newModel ! []

        SelectUser idx ->
            let
                user =
                    View.findUser idx model.users

                newModel =
                    populateUserData user idx model model.formAction
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

        EditUser idx ->
            let
                user =
                    View.findUser idx model.users

                newModel =
                    populateUserData user idx model User.Edit
            in
                model
                    ! []

        DeleteUser idx ->
            let
                usr =
                    View.findUser idx model.users

                r =
                    case usr of
                        Nothing ->
                            model ! []

                        Just user ->
                            { model
                                | formAction = User.Delete
                                , selectedUserId = Just user.id
                            }
                                ! [ Rest.delete { model | selectedUserId = Just user.id } ]
            in
                r

        NewUser ->
            { model
                | formAction = User.Create
                , firstNameInput = ""
                , lastNameInput = ""
                , emailInput = ""
                , photoUrlInput = ""
                , selectedUserId = Nothing
                , selectedUserIndex = Nothing
            }
                ! []

        ProcessRefDataGet (Ok roles) ->
            let
                new_d =
                    List.foldl (\role roleDict -> Dict.insert role.id role roleDict)
                        Dict.empty
                        roles
            in
                { model
                    | refData = Loaded (User.RefData new_d)
                }
                    ! []

        ProcessRefDataGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserGet (Ok users) ->
            let
                x =
                    Debug.log "Fetching" "users"

                first_user =
                    Utils.first users

                new_model =
                    --if we have done an edit then the selected user and index will stay the same
                    case first_user of
                        Nothing ->
                            model

                        Just user ->
                            --only fill in user details if we don't have any
                            { model
                                | firstNameInput = user.first_name
                                , lastNameInput = user.last_name
                                , emailInput = user.email
                                , photoUrlInput = user.photo_url
                                , selectedUserId = Just user.id
                                , selectedUserIndex = Just 0
                            }
            in
                { new_model
                    | users = Array.fromList (users)
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

        SetFirstNameInput value ->
            { model | firstNameInput = value } ! []

        SetLastNameInput value ->
            { model | lastNameInput = value } ! []

        SetEmailInput value ->
            { model | emailInput = value } ! []

        SetPhotoUrlInput value ->
            { model | photoUrlInput = value } ! []

        UserPost model ->
            model ! [ Rest.post model ]

        UserPut model ->
            model ! [ Rest.put model ]



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


populateUserData : Maybe User.UserWithRoles -> Int -> User.Model -> User.FormAction -> User.Model
populateUserData user idx model action =
    case user of
        Nothing ->
            { model
                | firstNameInput = ""
                , lastNameInput = ""
                , emailInput = ""
                , photoUrlInput = ""
                , formAction = action
                , selectedUserId = Nothing
                , selectedUserIndex = Nothing
            }

        Just u ->
            { model
                | firstNameInput = u.first_name
                , lastNameInput = u.last_name
                , emailInput = u.email
                , photoUrlInput = u.photo_url
                , formAction = action
                , selectedUserId = Just u.id
                , selectedUserIndex = Just idx
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
