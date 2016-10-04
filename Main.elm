module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Task
import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Options exposing (css)
import List exposing (reverse)


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = Noop
    | GetEvents
    | FetchSucceed (List Quantum)
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)


type alias Progress =
    { position : String
    , placement_test : Bool
    , map : Int
    , activity : Int
    }


type alias Event =
    { precinct : String
    , lesson : Int
    , event_type : String
    , canonical_student_id : Int
    , activity : Int
    }


type alias Quantum =
    { progress : Progress
    , event : Event
    }


type alias Model =
    { quanta : List Quantum
    , studentId : String
    , mdl : Material.Model
    }


initialModel : Model
initialModel =
    { quanta = []
    , studentId = "1"
    , mdl = Material.model
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetEvents ->
            { model | quanta = [] } ! [ loadEvents model.studentId ]

        FetchSucceed quanta ->
            ( { model | quanta = quanta }, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : a -> Sub Msg
subscriptions thing =
    Sub.none



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div [ style [ ( "padding", "2rem" ) ] ]
        [ h4 [] [text "Eventful"]
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
            [ Button.onClick GetEvents
            , css "margin" "0 24px"
            ]
            [ text "Get History" ]
        , br [] []
        , quantaTable (reverse model.quanta)
        ]
        |> Material.Scheme.top


quantaTable : List Quantum -> Html b
quantaTable quanta =
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
            (List.map quantumView quanta)
        ]


quantumView : Quantum -> Html b
quantumView quantum =
    Table.tr []
        [ Table.td [] [ text quantum.event.precinct ]
        , Table.td [] [ text quantum.event.event_type ]
        , Table.td [ Table.numeric ] [ text (toString quantum.event.lesson) ]
        , Table.td [ Table.numeric ] [ text (toString quantum.event.activity) ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString quantum.progress.map) ] ]
        , Table.td [] [ strong [] [ text quantum.progress.position ] ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString quantum.progress.activity) ] ]
        , Table.td [] [ strong [] [ text (toString quantum.progress.placement_test) ] ]
        ]


loadEvents : String -> Cmd Msg
loadEvents studentId =
    let
        url =
          -- "http://progression.coreos-staging.blakedev.com/history/maths/my_lessons/" ++ studentId
          "http://localhost:4000/api/v3/history/maths/my_lessons/" ++ studentId
          -- "http://ex-seeds.coreos-staging.blakedev.com/api/v3/history/" ++ studentId

        decoder =
            Json.list decodeQuanta
    in
        Task.perform FetchFail FetchSucceed (Http.get decoder url)


decodeProgress : Json.Decoder Progress
decodeProgress =
    decode Progress
        |> JsonPipeline.required "position" string
        |> JsonPipeline.required "placement_test" bool
        |> JsonPipeline.required "map" int
        |> JsonPipeline.required "activity" int


decodeEvent : Json.Decoder Event
decodeEvent =
    decode Event
        |> JsonPipeline.required "precinct" string
        |> JsonPipeline.required "lesson" int
        |> JsonPipeline.required "event_type" string
        |> JsonPipeline.required "canonical_student_id" int
        |> JsonPipeline.optional "activity" int 0


decodeQuantum : Json.Decoder Quantum
decodeQuantum =
    decode Quantum
        |> JsonPipeline.required "progress" decodeProgress
        |> JsonPipeline.required "event" decodeEvent
