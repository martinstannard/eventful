module EHR
    exposing
        ( EHR
        , State(..)
        , Msg
        , init
        , update
        , decoder
        , view
        , state
        , fetch
        )

{- ! A Elm HttpRequest is like a XHR but for Elm.
   It takes a endpoint, a decode of a model and will make
   a http request then tries to decode the value into
   the provided model.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD exposing ((:=))
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Material.Table as Table
import Event exposing (Event)
import Progress exposing (Progress)
import Http
import Task
import Settings exposing (Settings)


type EHR
    = EHR
        { data : Maybe (List Quantum)
        , state : State
        }


type State
    = Fetching
    | NotFetching
    | FetchSucceeded
    | FetchFailed


type Msg
    = FetchSucceed (List Quantum)
    | FetchFail Http.Error


type alias Quantum =
    { progress : Progress
    , event : Event
    }


init : EHR
init =
    EHR
        { data = Nothing
        , state = NotFetching
        }


update : Msg -> EHR -> ( EHR, Cmd Msg )
update msg (EHR model) =
    case msg of
        FetchSucceed quantums ->
            ( EHR { model | state = FetchSucceeded, data = Just quantums }, Cmd.none )

        FetchFail error ->
            ( EHR { model | state = FetchFailed, data = Nothing }, Cmd.none )


fetch : Settings -> String -> EHR -> ( EHR, Cmd Msg )
fetch settings studentId (EHR model) =
    let
        url =
            (Settings.endPoint settings) ++ studentId
    in
        ( EHR { model | state = Fetching }
        , Task.perform FetchFail FetchSucceed (Http.get decoder url)
        )


decoder : JD.Decoder (List Quantum)
decoder =
    decode Quantum
        |> JsonPipeline.required "progress" Progress.decoder
        |> JsonPipeline.required "event" Event.decoder
        |> JD.list


state : EHR -> State
state (EHR model) =
    model.state



-- View


view : EHR -> Html b
view (EHR model) =
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
