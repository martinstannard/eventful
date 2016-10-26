module Pages.Index exposing (Index, Msg, init, update, view)

import List exposing (..)
import Dict exposing (..)
import Set exposing (..)
import EHR exposing (EHR)
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


type Index
    = Index Model


type alias Model =
    { ehr : EHR
    , studentId : String
    , mdl : Material.Model
    }


type Msg
    = GetQuanta String
    | EHRMsg EHR.Msg
    | UpdateStudentId String
    | MDL (Material.Msg Msg)


init : Model
init =
    { ehr = EHR.init
    , mdl = Material.model
    , studentId = "123"
    }


update : Msg -> Index -> Index
update msg (Index model) =
    case msg of
        GetQuanta studentId ->
            let
                url =
                    (Settings.endPoint model.settings) ++ studentId

                ( quantaStartFetching, quantaCmds ) =
                    EHR.fetch url model.quanta
            in
                ( { model | quanta = quantaStartFetching }, Cmd.map EHRMsg quantaCmds )

        EHRMsg msg ->
            let
                ( quanta_, quantaCmds ) =
                    EHR.update msg model.quanta
            in
                ( { model | quanta = quanta_ }, Cmd.map EHRMsg quantaCmds )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )


-- View


view : Model -> Html Msg
view model =
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
            , viewData model.quanta
            ]


viewData : EHR -> Html b
viewData (EHR model) =
    let
        quantums =
            Maybe.withDefault [] model.data
    in
        Table.table []
            [ Table.thead []
                [ Table.tr []
                    [ Table.th [] [ text "Precinct" ]
                    , Table.th [] [ text "Event Type" ]
                    , Table.th [] [ text "Lesson" ]
                    , Table.th [] [ text "Activity" ]
                    , Table.th [] [ text "Map" ]
                    , Table.th [] [ text "Position" ]
                    , Table.th [] [ text "Activity" ]
                    , Table.th [] [ text "Placement Test" ]
                    ]
                ]
            , tbody []
                (List.map rowView quantums)
            ]


rowView : Quantum -> Html b
rowView { event, progress } =
    Table.tr []
        [ Table.td [] [ text event.precinct ]
        , Table.td [] [ text event.event_type ]
        , Table.td [ Table.numeric ] [ text (toString event.lesson) ]
        , Table.td [ Table.numeric ] [ text (toString event.activity) ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString progress.map) ] ]
        , Table.td [] [ strong [] [ text progress.position ] ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString progress.activity) ] ]
        , Table.td [] [ strong [] [ text (toString progress.placement_test) ] ]
        ]
