module Pages.Index exposing (Index, Msg, init, update, view)

import List exposing (..)
import Dict exposing (..)
import Set exposing (..)
import EHR exposing (EHR)
import Decoders.ProgressionHistoryV3 as History exposing (History)
import Pages.Settings as Settings exposing (Settings)


-- Html

import Html exposing (..)
import Html.Attributes exposing (..)

-- Material

import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Tabs as Tabs
import Material.Options as Options exposing (css)
import Material.Icon as Icon
import Material.Slider as Slider


type Index
    = Index Model


type alias Model =
    { ehr : EHR History Msg
    , studentId : String
    , mdl : Material.Model
    , slider : Float
    }


type Msg
    = GetQuanta String
    | EHRMsg (EHR.Msg History)
    | UpdateStudentId String
    | SliderMsg Float
    | MDL (Material.Msg Msg)


init : Index
init =
    Index
        { ehr = EHR.init History.view
        , mdl = Material.model
        , studentId = "10891039"
        , slider = 0.0
        }


update : Msg -> Settings -> Index -> ( Index, Cmd Msg )
update msg settings (Index model) =
    case msg of
        GetQuanta studentId ->
            let
                url =
                    (Settings.endPoint settings) ++ studentId

                decoder =
                    History.decoder

                ( ehrStartedFetch, ehrCmds ) =
                    EHR.fetch url decoder model.ehr
            in
                ( Index { model | ehr = ehrStartedFetch }, Cmd.map EHRMsg ehrCmds )

        EHRMsg msg ->
            let
                ( ehr_, ehrCmds ) =
                    EHR.update msg model.ehr
            in
                ( Index { model | ehr = ehr_ }, Cmd.map EHRMsg ehrCmds )

        UpdateStudentId id ->
            ( Index { model | studentId = id }, Cmd.none )

        SliderMsg position ->
            ( Index { model | slider = position }, Cmd.none )

        _ ->
            ( Index model, Cmd.none )



-- View


view : Index -> Html Msg
view (Index model) =
    let
        buttonText =
            case EHR.state model.ehr of
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
            , Slider.view
              [ Slider.onChange SliderMsg
              , Slider.value model.slider
              ]
            , EHR.view model.ehr model.slider
            ]
