module PharNoteApp.View exposing (view)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Chart.Charts as Charts


--import PharNoteApp.Msg exposing (Msg(..))

import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.View as UserView
import PharNoteApp.Role.View as RoleView
import PharNoteApp.Campaign.View as CampaignView
import PharNoteApp.Chart.View as ChartView
import PharNoteApp.Route exposing (..)
import Html exposing (Html, text, div, span, form)
import Html.Attributes exposing (href, src, style)
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Icon as Icon
import Material.Color as Color
import Material.Menu as Menu
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Options as Options exposing (css, cs, when)
import Material.Scheme


styles : String
styles =
    """
   .demo-options .mdl-checkbox__box-outline {
      border-color: rgba(255, 255, 255, 0.89);
    }

   .mdl-layout__drawer {
      border: none !important;
   }

   .mdl-layout__drawer .mdl-navigation__link:hover {
      background-color: #00BCD4 !important;
      color: #37474F !important;
    }
   """


view : Model -> Html AppMsg.Msg
view model =
    Material.Scheme.top <|
        Layout.render AppMsg.Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            , Options.css "display" "flex !important"
            , Options.css "flex-direction" "row"
            , Options.css "align-items" "center"
            ]
            { header = [ viewHeader model ]
            , drawer = [ drawerHeader model, viewDrawer model ]
            , tabs = ( [], [] )
            , main =
                [ viewBody model
                , confirmDialog model
                ]
                    ++ Charts.createDefinitions
            }


viewHeader : Model -> Html AppMsg.Msg
viewHeader model =
    let
        details =
            routeDetails model.activeRoute
    in
        Layout.row
            [ Color.background <| Color.color Color.Grey Color.S100
            , Color.text <| Color.color Color.Grey Color.S900
            ]
            [ Layout.title [] [ text details.title ]
            , Layout.spacer
            , Layout.navigation []
                [ Html.img [ style [ ( "max-height", "50px" ) ], src "images/Hogwartscrest.png" ]
                    []
                ]
            ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Chart }
    , { text = "Users", iconName = "group", route = Just Users }
    , { text = "Roles", iconName = "alarm", route = Just Roles }
    , { text = "Campaigns", iconName = "list", route = Just Campaigns }
    , { text = "Organizations", iconName = "store", route = Nothing }
    , { text = "Project", iconName = "view_list", route = Nothing }
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html AppMsg.Msg
viewDrawerMenuItem model menuItem =
    let
        isCurrentLocation =
            case model.history of
                currentLocation :: _ ->
                    currentLocation == menuItem.route

                _ ->
                    False

        onClickCmd =
            case ( isCurrentLocation, menuItem.route ) of
                ( False, Just route ) ->
                    route |> urlFor |> AppMsg.NewUrl |> Options.onClick

                _ ->
                    Options.nop
    in
        Layout.link
            [ onClickCmd
            , when isCurrentLocation (Color.background <| Color.color Color.BlueGrey Color.S600)
            , Options.css "color" "rgba(255, 255, 255, 0.56)"
            , Options.css "font-weight" "500"
            ]
            [ Icon.view menuItem.iconName
                [ Color.text <| Color.color Color.BlueGrey Color.S500
                , Options.css "margin-right" "32px"
                ]
            , text menuItem.text
            ]


viewDrawer : Model -> Html AppMsg.Msg
viewDrawer model =
    Layout.navigation
        [ Color.background <| Color.color Color.BlueGrey Color.S800
        , Color.text <| Color.color Color.BlueGrey Color.S50
        , Options.css "flex-grow" "1"
        ]
    <|
        (List.map (viewDrawerMenuItem model) menuItems)
            ++ [ Layout.spacer
               , Layout.link
                    [ Dialog.openOn "click"
                    ]
                    [ Icon.view "help"
                        [ Color.text <| Color.color Color.BlueGrey Color.S500
                        ]
                    ]
               ]


drawerHeader : Model -> Html AppMsg.Msg
drawerHeader model =
    Options.styled Html.header
        [ css "display" "flex"
        , css "box-sizing" "border-box"
        , css "justify-content" "flex-end"
        , css "padding" "16px"
        , css "height" "151px"
        , css "flex-direction" "column"
        , cs "demo-header"
        , Color.background <| Color.color Color.BlueGrey Color.S900
        , Color.text <| Color.color Color.BlueGrey Color.S50
        ]
        [ Options.styled Html.img
            [ Options.attribute <| src "images/elm.png"
            , css "width" "48px"
            , css "height" "48px"
            , css "border-radius" "24px"
            ]
            []
        , Options.styled Html.div
            [ css "display" "flex"
            , css "flex-direction" "row"
            , css "align-items" "center"
            , css "width" "100%"
            , css "position" "relative"
            ]
            [ Html.span [] [ text model.activeUser ]
            , Layout.spacer
            , Menu.render AppMsg.Mdl
                [ 1, 2, 3, 4 ]
                model.mdl
                [ Menu.ripple
                , Menu.bottomRight
                , Menu.icon "arrow_drop_down"
                ]
                [ Menu.item
                    [ Menu.onSelect (AppMsg.SelectUser "elm.mdl@example.0") ]
                    [ text "elm.mdl@example.0" ]
                , Menu.item
                    [ Menu.onSelect (AppMsg.SelectUser "elm.mdl@example.1") ]
                    [ text "elm.mdl@example.1" ]
                , Menu.item
                    [ Menu.onSelect (AppMsg.SelectUser "elm.mdl@example.2") ]
                    [ text "elm.mdl@example.2" ]
                , Menu.item
                    [ Menu.onSelect (AppMsg.SelectUser "elm.mdl@example.3") ]
                    [ text "elm.mdl@example.3" ]
                ]
            ]
        ]


viewBody : Model -> Html AppMsg.Msg
viewBody model =
    case model.history |> List.head |> Maybe.withDefault Nothing of
        Just Chart ->
            ChartView.view model.chartData

        Just Users ->
            UserView.view model.userData model.mdl

        Just Roles ->
            RoleView.view model.roleData

        Just Campaigns ->
            CampaignView.view model.campaignData model.mdl

        Nothing ->
            text "404"


confirmDialog : Model -> Html AppMsg.Msg
confirmDialog model =
    Dialog.view
        []
        [ Dialog.title [ css "font-size" "1em" ] [ text "Are you sure?" ]
        , Dialog.content []
            [ Html.p []
                [ text "Proceed with delete?" ]
            ]
        , Dialog.actions []
            [ Options.styled Html.span
                [ Dialog.closeOn "click" ]
                [ Button.render AppMsg.Mdl
                    [ 5, 1, 7 ]
                    model.mdl
                    [ Button.ripple
                    ]
                    [ text "Mistake" ]
                , Button.render AppMsg.Mdl
                    [ 5, 1, 6 ]
                    model.mdl
                    [ Button.ripple
                    ]
                    [ text "Do it!" ]
                ]
            ]
        ]
