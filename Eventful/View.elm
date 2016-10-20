module Eventful.View exposing (view)

import Eventful.Update exposing (Msg(..))
import Eventful.Model exposing (Model, Page(..))
import Quanta
import Settings
import Html exposing (..)
import Html.App
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
    viewHelper model |> Material.Scheme.top


viewHelper : Model -> Html Msg
viewHelper ({ currentPage } as model) =
    case currentPage of
        Index ->
            indexView model

        Settings ->
            Settings.view model.settings
                |> Html.App.map (\msg -> SettingsMsg msg)


indexView : Model -> Html Msg
indexView model =
    let
        isFetching { quantaState } =
          Quanta.isFetching quantaState
        hasFailed { quantaState } =
          Quanta.hasFailed quantaState
        buttonText =
          if (isFetching model)
            then "Get History - Loading..."
            else if (hasFailed model)
              then "Get History - Failed, try again"
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
                [ Button.onClick StartFetchQuanta
                , css "margin" "0 24px"
                ]
                [ text buttonText ]
            , br [] []
            , Quanta.viewFromQuantaState model.quantaState
            ]
