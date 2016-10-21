module Quanta
    exposing
        ( Quanta
        , init
        , decoder
        , view
        , QuantaState
        , initQuantaState
        , isFetching
        , fetchStart
        , fetchSuccess
        , fetchFailure
        , viewFromQuantaState
        , hasFailed
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Material.Table as Table
import Event exposing (Event)
import Progress exposing (Progress)


type QuantaState
    = QuantaState
        { maybeQuanta : Maybe Quanta
        , fetchingState : FetchState
        , lastFetchSuccess : Maybe SuccessState
        }


type FetchState
    = Fetching
    | NotFetching


type SuccessState
    = Succeeded
    | Failed


type Quanta
    = Quanta (List Quantum)


type alias Quantum =
    { progress : Progress
    , event : Event
    }


init : Quanta
init =
    Quanta []


initQuantaState : QuantaState
initQuantaState =
    QuantaState
        { maybeQuanta = Nothing
        , fetchingState = NotFetching
        , lastFetchSuccess = Nothing
        }


fetchSuccess : QuantaState -> Quanta -> QuantaState
fetchSuccess (QuantaState quantaState) quanta =
    QuantaState
        { quantaState
            | maybeQuanta = Just quanta
            , fetchingState = NotFetching
            , lastFetchSuccess = Just Succeeded
        }


fetchFailure : QuantaState -> QuantaState
fetchFailure (QuantaState quantaState) =
    QuantaState
        { quantaState
            | fetchingState = NotFetching
            , lastFetchSuccess = Just Failed
        }


fetchStart : QuantaState -> QuantaState
fetchStart (QuantaState quantaState) =
    QuantaState
        { quantaState
            | fetchingState = Fetching
        }


isFetching : QuantaState -> Bool
isFetching (QuantaState { fetchingState }) =
    case fetchingState of
        Fetching ->
            True

        _ ->
            False


hasFailed : QuantaState -> Bool
hasFailed (QuantaState { lastFetchSuccess }) =
    case lastFetchSuccess of
        Just Failed ->
            True

        _ ->
            False


decoder : JD.Decoder Quanta
decoder =
    decode Quantum
        |> JsonPipeline.required "progress" Progress.decoder
        |> JsonPipeline.required "event" Event.decoder
        |> JD.list
        |> JD.map Quanta



-- View


viewFromQuantaState : QuantaState -> Html a
viewFromQuantaState (QuantaState { maybeQuanta }) =
    case maybeQuanta of
        Nothing ->
            Table.table [] []

        Just quanta ->
            view quanta


view : Quanta -> Html b
view (Quanta quanta) =
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
            (List.map rowView quanta)
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
