module Eventful.View exposing (view)

import Eventful.Update exposing (Msg(..))
import Eventful.Model exposing (Model, Page(..))
import Quanta

import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Options exposing (css)

-- Aliases

type alias Mdl =
    Material.Model

-- View

view : Model -> Html Msg
view ({ currentPage } as model) =
    let
        viewPage = viewFromPage currentPage
    in
        viewPage model |> Material.Scheme.top

viewFromPage : Page -> Model -> Html Msg
viewFromPage page =
    case page of
        Index ->
            indexView

        Settings ->
            settingsView

settingsView : Model -> Html Msg
settingsView model =
    div []
        [ h1 [] [ text "This is the settings page" ]
        , h5 [] [ text "Add stuff here" ]
        ]

indexView : Model -> Html Msg
indexView model =
    let
        isFetching { quantaState } =
          Quanta.isFetching quantaState
        buttonText =
          if (isFetching model)
            then "Get History - Loading..."
            else "Get History"

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
                [ Button.onClick FetchQuanta
                , css "margin" "0 24px"
                ]
                [ text buttonText ]
            , br [] []
            , Quanta.viewFromQuantaState model.quantaState
            ]
