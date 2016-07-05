module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing (string, int, list)
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
    | FetchSucceed (List Event)
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
    , lesson :
        Int
        -- , activity : Int
        -- , quiz : Int
    }


type alias Thing =
    { event : Event
    , progress : Progress
    }


type alias Model =
    { events : List Event
    , studentId : String
    }


initialModel : { events : List Event, studentId : String }
initialModel =
    { events = []
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
            { model | events = [] } ! [ loadEvents model.studentId ]

        FetchSucceed events ->
            ( { model | events = events }, Cmd.none )

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
        , eventTable model.events
        ]


eventTable : List Event -> Html b
eventTable events =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Student" ]
                , th [] [ text "Precinct" ]
                , th [] [ text "Event Type" ]
                , th [] [ text "Lesson" ]
                ]
            ]
        , tbody []
            (List.map eventView events)
        ]


eventView : Event -> Html b
eventView event =
    tr []
        [ td [] [ text (toString event.student_id) ]
        , td [] [ text event.precinct ]
        , td [] [ text event.event_type ]
        , td [] [ text (toString event.lesson) ]
        ]


loadEvents : String -> Cmd Msg
loadEvents studentId =
    let
        url =
            "//localhost:3000/events/?student_id=" ++ studentId
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeEvents url)


decodeEvent : Json.Decoder Event
decodeEvent =
    decode Event
        |> JsonPipeline.required "student_id" int
        |> JsonPipeline.required "precinct" string
        |> JsonPipeline.required "event_type" string
        |> JsonPipeline.required "lesson" int


decodeEvents : Json.Decoder (List Event)
decodeEvents =
    Json.list decodeEvent
