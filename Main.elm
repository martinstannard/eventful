module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=), string, int, bool, list, tuple2, keyValuePairs, object2, dict)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Task


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
    | FetchSucceed (List Quanta)
    | FetchFail Http.Error
    | UpdateStudentId String


type alias Progress =
      { map : Int
      , position : String
      , activity : Int
      , placement_test : Bool
      }


type alias Event =
    { student_id : Int
    , event_type : String
    , precinct : String
    , lesson : Int
    , activity : Int
        -- , quiz : Int
    }


type alias Quanta =
    { progress : Progress
    , event : Event
    }


type alias Model =
    { quantas : List Quanta
    , studentId : String
    }


initialModel : { quantas : List Quanta, studentId : String }
initialModel =
    { quantas = []
    , studentId = "1"
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
            { model | quantas = [] } ! [ loadEvents model.studentId ]

        FetchSucceed quantas ->
            ( { model | quantas = quantas }, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : a -> Sub Msg
subscriptions thing =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "id"
            , value model.studentId
            , autofocus True
            , onInput UpdateStudentId
            ]
            []
        , button [ onClick GetEvents ] [ text "Get Events!" ]
        , br [] []
        , quantaTable model.quantas
        ]


quantaTable : List Quanta -> Html b
quantaTable quantas =
  table []
          [ thead []
              [ tr []
                  [ th [] [ text "Student" ]
                  , th [] [ text "Precinct" ]
                  , th [] [ text "Event Type" ]
                  , th [] [ text "Lesson" ]
                  , th [] [ text "Activity" ]
                  , th [] [ text "Map" ]
                  , th [] [ text "Position" ]
                  , th [] [ text "Activity" ]
                  , th [] [ text "Placement Test" ]
                  ]
              ]
          , tbody []
              (List.map quantaView quantas)
          ]


quantaView : Quanta -> Html b
quantaView quanta =
  tr []
        [ td [] [ text (toString quanta.event.student_id) ]
        , td [] [ text quanta.event.precinct ]
        , td [] [ text quanta.event.event_type ]
        , td [] [ text (toString quanta.event.lesson) ]
        , td [] [ text (toString quanta.event.activity) ]
        , td [] [ text (toString quanta.progress.map) ]
        , td [] [ text quanta.progress.position ]
        , td [] [ text (toString quanta.progress.activity) ]
        , td [] [ text (toString quanta.progress.placement_test) ]
        ]


loadEvents : String -> Cmd Msg
loadEvents studentId =
    let
        url =
          "//localhost:4000/api/v3/history/" ++ studentId
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeQuantas url)


decodeProgress : Json.Decoder Progress
decodeProgress =
  decode Progress
    |> JsonPipeline.required "map" int
    |> JsonPipeline.required "position" string
    |> JsonPipeline.required "activity" int
    |> JsonPipeline.required "placement_test" bool


decodeEvent : Json.Decoder Event
decodeEvent =
    decode Event
        |> JsonPipeline.required "student_id" int
        |> JsonPipeline.required "event_type" string
        |> JsonPipeline.required "precinct" string
        |> JsonPipeline.required "lesson" int
        |> JsonPipeline.required "activity" int


decodeQuanta : Json.Decoder Quanta
decodeQuanta =
  decode Quanta
    |> JsonPipeline.required "progress" decodeProgress
    |> JsonPipeline.required "event" decodeEvent


decodeQuantas : Json.Decoder (List Quanta)
decodeQuantas =
  Json.list decodeQuanta
