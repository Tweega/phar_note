module PharNoteApp.Campaign.Update exposing (..)

import PharNoteApp.Campaign.Msg exposing (..)
import PharNoteApp.Msg as AppMsg
import PharNoteApp.Campaign.Model as Campaign
import PharNoteApp.Campaign.BaseModel as CampaignBase
import PharNoteApp.Campaign.Model exposing (RefDataStatus(..), FilterState(..), CampaignTab(..))
import PharNoteApp.Campaign.Rest as Rest
import PharNoteApp.Campaign.View as View
import PharNoteApp.Utils as Utils
import Material.Table as Table
import Array exposing (fromList, Array)
import Dict exposing (Dict)
import Set exposing (Set)


update : Msg -> Campaign.Model -> ( Campaign.Model, Cmd AppMsg.Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        SelectTab userTab ->
            { model | selectedTab = userTab } ! []

        KeyX key ->
            let
                userCount =
                    Array.length (model.filteredCampaigns)

                currentIdx =
                    case model.selectedCampaignIndex of
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

                --if selected user is off the beginning of screen then start window from index
                startIndex =
                    if idx < model.startDisplayIndex then
                        idx
                    else if idx > model.endDisplayIndex then
                        model.endDisplayIndex - model.pageSize + 2
                    else
                        model.startDisplayIndex

                endIndex =
                    startIndex + model.pageSize - 1

                user =
                    View.maybeFindCampaign (Just idx) model.filteredCampaigns

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedCampaignId = Just u.id
                                , selectedCampaignIndex = Just idx
                                , startDisplayIndex = startIndex
                                , endDisplayIndex = endIndex
                            }

                        _ ->
                            model

                --populateScratchCampaignData user (Just idx) model model.formAction
            in
                newModel ! []

        SelectCampaign idx ->
            let
                index =
                    model.startDisplayIndex + idx

                user =
                    View.maybeFindCampaign (Just index) model.filteredCampaigns

                newModel =
                    case user of
                        Just u ->
                            { model
                                | selectedCampaignId = Just u.id
                                , selectedCampaignIndex = Just index
                            }

                        _ ->
                            model

                --populateScratchCampaignData user (Just idx) model model.formAction
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

                sortedCampaigns =
                    sort (Array.toList model.filteredCampaigns) |> Array.fromList

                nextCampaign =
                    View.alwaysFindCampaign model.selectedCampaignIndex sortedCampaigns
            in
                --the user index and id will nno longer match up now.  Either need to find current user, or keep selector on same page/offset
                { model | order = sortOrder, filteredCampaigns = sortedCampaigns, selectedCampaignId = Just nextCampaign.id } ! []

        CancelDeleteCampaign ->
            { model | formAction = Campaign.None } ! []

        ConfirmDeleteCampaign ->
            let
                idx =
                    model.selectedCampaignIndex

                usr =
                    View.maybeFindCampaign idx model.filteredCampaigns
            in
                { model | formAction = Campaign.ConfirmDelete } ! []

        DeleteCampaign ->
            let
                idx =
                    model.selectedCampaignIndex

                usr =
                    View.maybeFindCampaign idx model.filteredCampaigns
            in
                case usr of
                    Nothing ->
                        model ! []

                    Just user ->
                        --we need to identify a record to be current after successful delete
                        let
                            --this would be a case of using one of those Maybe.andThen things as if idx was Nothing we would not get here.
                            i =
                                case idx of
                                    Just x ->
                                        x

                                    _ ->
                                        0

                            ( maybeNextCampaign, nextIndex ) =
                                case View.maybeFindCampaign (Just (i + 1)) model.filteredCampaigns of
                                    Nothing ->
                                        case View.maybeFindCampaign (Just (i - 1)) model.filteredCampaigns of
                                            Nothing ->
                                                ( Nothing, -1 )

                                            Just uu ->
                                                ( Just uu, i - 1 )

                                    Just u ->
                                        ( Just u, i )

                            newModel =
                                case maybeNextCampaign of
                                    Nothing ->
                                        { model
                                            | formAction = Campaign.Delete
                                            , selectedCampaignId = Just user.id
                                        }

                                    Just nextCampaign ->
                                        { model
                                            | formAction = Campaign.Delete
                                            , selectedCampaignId = Just user.id
                                            , previousSelectedCampaignId = Just nextCampaign.id
                                            , previousSelectedCampaignIndex = Just nextIndex
                                        }
                        in
                            newModel ! [ Rest.delete user ]

        EditCampaign ->
            let
                idx =
                    model.selectedCampaignIndex

                user =
                    View.maybeFindCampaign idx model.filteredCampaigns

                newModel =
                    populateScratchCampaignData user idx model Campaign.Edit
            in
                newModel
                    ! []

        NewCampaign ->
            { model
                | formAction = Campaign.Create
                , scratchCampaign = Campaign.emptyCampaignWithRoleSet
                , selectedCampaignId = Nothing
                , selectedCampaignIndex = Nothing
                , previousSelectedCampaignIndex = model.selectedCampaignIndex
                , previousSelectedCampaignId = model.selectedCampaignId
            }
                ! []

        CancelNewCampaign ->
            let
                newModel =
                    case model.formAction of
                        Campaign.Create ->
                            { model
                                | formAction = Campaign.CancelNewCampaign
                                , selectedCampaignId = model.previousSelectedCampaignId
                                , selectedCampaignIndex = model.previousSelectedCampaignIndex
                            }

                        _ ->
                            { model
                                | formAction = Campaign.CancelNewCampaign
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
                    | refDataStatus = Loaded (Campaign.RefData roleDict)
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

        ProcessCampaignGet (Ok users) ->
            let
                userArray =
                    Array.fromList (users)

                newModel =
                    filteredModel { model | users = userArray }
            in
                newModel ! []

        ProcessCampaignGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessCampaignPost (Ok user) ->
            { model | formAction = Campaign.None } ! [ Rest.get ]

        ProcessCampaignPost (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessCampaignDelete (Ok user) ->
            -- need to set current user to previousSelectedCampaignId
            { model
                | formAction = Campaign.None
                , selectedCampaignId = model.previousSelectedCampaignId
                , selectedCampaignIndex = model.previousSelectedCampaignIndex
            }
                ! [ Rest.get ]

        ProcessCampaignDelete (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        CampaignPost user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            Campaign.scratchToCampaignWithRoles model.scratchCampaign refData
                    in
                        model ! [ Rest.post userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        CampaignPut user ->
            case model.refDataStatus of
                Loaded refData ->
                    let
                        userWithRoles =
                            Campaign.scratchToCampaignWithRoles model.scratchCampaign refData
                    in
                        model ! [ Rest.put userWithRoles ]

                _ ->
                    --need to provide a message here.
                    model ! []

        SetFirstName value ->
            let
                user =
                    model.scratchCampaign

                new_user =
                    { user | first_name = value }
            in
                { model | scratchCampaign = new_user } ! []

        SetLastName value ->
            let
                user =
                    model.scratchCampaign

                new_user =
                    { user | last_name = value }
            in
                { model | scratchCampaign = new_user } ! []

        SetEmail value ->
            let
                user =
                    model.scratchCampaign

                new_user =
                    { user | email = value }
            in
                { model | scratchCampaign = new_user } ! []

        SetPhotoUrl value ->
            let
                user =
                    model.scratchCampaign

                new_user =
                    { user | photo_url = value }
            in
                { model | scratchCampaign = new_user } ! []

        ToggleRole roleID ->
            let
                user =
                    model.scratchCampaign

                roleSet =
                    user.roles

                newRoleSet =
                    case Set.member roleID roleSet of
                        True ->
                            Set.remove roleID roleSet

                        False ->
                            Set.insert roleID roleSet

                newCampaign =
                    { user | roles = newRoleSet }
            in
                { model | scratchCampaign = newCampaign } ! []

        CampaignSlider valuePC ->
            let
                len =
                    Array.length model.filteredCampaigns

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
                    , userSliderValue = valuePC
                }
                    ! []

        PaginateCampaign page ->
            let
                g =
                    Debug.log "page" page

                idx =
                    Maybe.withDefault 0 model.selectedCampaignIndex

                offset =
                    idx - model.startDisplayIndex

                s =
                    page * model.pageSize

                userCount =
                    Array.length model.filteredCampaigns

                start =
                    if userCount - s < model.pageSize then
                        userCount - model.pageSize
                    else
                        s

                end =
                    start + model.pageSize - 1

                nextIdx =
                    start + offset

                nextCampaign =
                    View.alwaysFindCampaign (Just nextIdx) model.filteredCampaigns
            in
                { model
                    | startDisplayIndex = start
                    , endDisplayIndex = end
                    , selectedCampaignId = Just nextCampaign.id
                    , selectedCampaignIndex = Just nextIdx
                }
                    ! []

        ApplyCampaignFilter filterCampaign ->
            let
                fm =
                    { model | filterState = Applied, selectedCampaignIndex = Nothing }
            in
                (filteredModel fm) ! []

        ResetCampaignFilter ->
            { model | filterScratchCampaign = Campaign.emptyCampaignWithRoleSet } ! []

        CancelCampaignFilter ->
            { model | selectedTab = Details } ! []

        ClearCampaignFilter ->
            let
                fm =
                    { model
                        | filterState = NoFilter
                        , filterScratchCampaign = Campaign.emptyCampaignWithRoleSet
                        , selectedCampaignIndex = Nothing
                    }
            in
                (filteredModel fm) ! []

        SetFilterFirstName value ->
            let
                user =
                    model.filterScratchCampaign

                new_user =
                    { user | first_name = value }
            in
                { model | filterScratchCampaign = new_user } ! []

        SetFilterLastName value ->
            let
                user =
                    model.filterScratchCampaign

                new_user =
                    { user | last_name = value }
            in
                { model | filterScratchCampaign = new_user } ! []

        ToggleFilterRole roleID ->
            let
                user =
                    model.filterScratchCampaign

                roleSet =
                    user.roles

                newRoleSet =
                    case Set.member roleID roleSet of
                        True ->
                            Set.remove roleID roleSet

                        False ->
                            Set.insert roleID roleSet

                newCampaign =
                    { user | roles = newRoleSet }
            in
                { model | filterScratchCampaign = newCampaign } ! []



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


populateScratchCampaignData : Maybe Campaign.CampaignWithRoles -> Maybe Int -> Campaign.Model -> Campaign.FormAction -> Campaign.Model
populateScratchCampaignData maybeCampaign maybeCampaignIndex model action =
    case maybeCampaign of
        Nothing ->
            --could we realistically arrive here?
            { model
                | scratchCampaign = Campaign.emptyCampaignWithRoleSet
                , formAction = action
                , selectedCampaignId = Nothing
                , selectedCampaignIndex = Nothing
            }

        Just u ->
            --if we only have role ids, not the whole role record, then we won't need the first map function
            let
                roleSet =
                    List.map (\r -> r.id) u.roles
                        |> Set.fromList
            in
                { model
                    | scratchCampaign = Campaign.CampaignWithRoleSet u.id u.first_name u.last_name u.email u.photo_url roleSet
                    , formAction = action
                    , selectedCampaignId = Just u.id
                    , selectedCampaignIndex = maybeCampaignIndex
                }


sort_by_last_first : Campaign.CampaignWithRoles -> String
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


applyFilter : Campaign.CampaignWithRoleSet -> Array Campaign.CampaignWithRoles -> Array Campaign.CampaignWithRoles
applyFilter filterCampaign userArray =
    Array.filter
        (\userWithRole ->
            let
                userRoleSet =
                    List.map (\r -> r.id) userWithRole.roles
                        |> Set.fromList
            in
                Set.size (Set.intersect filterCampaign.roles userRoleSet) > 0
        )
        userArray


filteredModel : Campaign.Model -> Campaign.Model
filteredModel model =
    let
        filteredCampaigns =
            case model.filterState of
                Applied ->
                    applyFilter model.filterScratchCampaign model.users

                _ ->
                    model.users

        userCount =
            Array.length filteredCampaigns

        ( selectedCampaignId, selectedCampaignIndex, firstIndex, lastIndex ) =
            case model.selectedCampaignIndex of
                Nothing ->
                    let
                        firstCampaign =
                            Array.get 0 filteredCampaigns

                        firstIdx =
                            0

                        lastIdx =
                            if userCount > model.pageSize then
                                model.pageSize - 1
                            else
                                userCount - 1
                    in
                        case firstCampaign of
                            Nothing ->
                                ( Nothing, Nothing, -1, -1 )

                            Just user ->
                                ( Just user.id, Just 0, firstIdx, lastIdx )

                _ ->
                    ( model.selectedCampaignId, model.selectedCampaignIndex, model.startDisplayIndex, model.endDisplayIndex )

        --if we have done an edit then the selected user and index will stay the same
    in
        { model
            | selectedCampaignId = selectedCampaignId
            , selectedCampaignIndex = selectedCampaignIndex
            , startDisplayIndex = firstIndex
            , endDisplayIndex = lastIndex
            , filteredCampaigns = filteredCampaigns
            , errors = Nothing
        }
