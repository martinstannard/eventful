module Quanta exposing (Quanta, init, decoder, view)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Material.Table as Table
import Event exposing (Event, decoder)
import Progress exposing (Progress, decoder)


type Quanta
    = Quanta (List Model)


type alias Model =
    { progress : Progress
    , event : Event
    }


init : Quanta
init =
    Quanta []


decoder : JD.Decoder Quanta
decoder =
    decode Model
        |> JsonPipeline.required "progress" Progress.decoder
        |> JsonPipeline.required "event" Event.decoder
        |> JD.list
        |> JD.map Quanta



-- View


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


rowView : Model -> Html b
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
