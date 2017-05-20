module PharNoteApp.View exposing (view)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.Model exposing (Model)
import PharNoteApp.User.View as UserView
import PharNoteApp.Chart.View as ChartView
import Html exposing (Html, text, div, span, form)
import Html.Attributes exposing (href, src)
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Icon as Icon
import Material.Color as Color
import Material.Menu as Menu
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Options as Options exposing (css, cs, when)


--import Route exposing (Route(..))

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
                ]

            --  ++ Charts.createDefinitions
            }


viewHeader : Model -> Html AppMsg.Msg
viewHeader model =
    Layout.row
        [ Color.background <| Color.color Color.Grey Color.S100
        , Color.text <| Color.color Color.Grey Color.S900
        ]
        [ Layout.title [] [ text "elm-mdl Dashboard Example" ]
        , Layout.spacer
        , Layout.navigation []
            []
        ]


type alias MenuItem =
    { text : String
    , iconName : String

    --, route : Maybe Route
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard" }
    , { text = "Users", iconName = "group" }
    , { text = "Last Activity", iconName = "alarm" }
    , { text = "Reports", iconName = "list" }
    , { text = "Organizations", iconName = "store" }
    , { text = "Project", iconName = "view_list" }
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html AppMsg.Msg
viewDrawerMenuItem model menuItem =
    let
        isCurrentLocation =
            False

        --some location code removed from above for the time being
    in
        Layout.link
            [ when isCurrentLocation (Color.background <| Color.color Color.BlueGrey Color.S600)
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
    ChartView.view model.chartData
