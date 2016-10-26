module Eventful.View exposing (view)

import Eventful.Update exposing (Msg(..))
import Eventful.Model exposing (Model, Page(..))
import EHR
import Settings
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Tabs as Tabs
import Material.Options as Options exposing (css)
import Material.Icon as Icon


-- Aliases


type alias Mdl =
    Material.Model



-- View


view : Model -> Html Msg
view ({ currentPage } as model) =
    Tabs.render MDL
        [ 0 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab SelectTab
        , Tabs.activeTab model.tab
        ]
        [ Tabs.label [ Options.center ]
            [ Icon.i "info_outline"
            , Options.span [ css "width" "4px" ] []
            , text "Index"
            ]
        , Tabs.label [ Options.center ]
            [ Icon.i "code"
            , Options.span [ css "width" "4px" ] []
            , text "Settings"
            ]
        ]
        [ viewPage model |> Material.Scheme.top ]


viewPage : Model -> Html Msg
viewPage ({ currentPage } as model) =
    case currentPage of
        Index ->
            indexView model

        Settings ->
            Settings.view model.settings
                |> Html.App.map SettingsMsg


indexView : Model -> Html Msg
indexView model =
    let
        buttonText =
            case EHR.state model.quanta of
                EHR.Fetching ->
                    "Get History - Loading..."

                EHR.FetchFailed ->
                    "Get History - Failed, try again"

                _ ->
                    "Get History"
    in
        div [ style [ ( "padding", "2rem" ) ] ]
            [ h4 [] [ text "Eventful" ]
            , Textfield.render MDL
                [ 0 ]
                model.mdl
                [ Textfield.label "Student Id"
                , Textfield.floatingLabel
                , Textfield.value model.studentId
                , Textfield.onInput UpdateStudentId
                ]
            , Button.render MDL
                [ 0 ]
                model.mdl
                [ Button.onClick (GetQuanta model.studentId)
                , css "margin" "0 24px"
                ]
                [ text buttonText ]
            , br [] []
            , EHR.view model.quanta
            ]
