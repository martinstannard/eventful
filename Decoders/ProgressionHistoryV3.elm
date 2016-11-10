module Decoders.ProgressionHistoryV3 exposing (History, decoder, view)

{-| Decoder for progression app, history endpoint. The history endpoint looks
    like this:
    [
       {
          "progress":{
             "position":"5",
             "placement_test":false,
             "map":1,
             "activity":1
          },
          "event":{
             "precinct":"my_lessons",
             "lesson":5,
             "event_type":"ResetProgress",
             "canonical_student_id":123,
             "created_at": "2016-11-10T08:49:49.639860",
          }
       }
    ]

    This is decoded into a list of History data types.
-}

import Json.Decode as JD
import Json.Decode.Pipeline as JP


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


type History
    = History (List Model)


type alias Model =
    { progress : Progress
    , event : Event
    }



--------------
-- Decoders --
--------------


decoder : JD.Decoder History
decoder =
    JP.decode Model
        |> JP.required "progress" progressDecoder
        |> JP.required "event" eventDecoder
        |> JD.list
        |> JD.map History



-- Event


type alias Event =
    { precinct : String
    , lesson : Int
    , event_type : String
    , created_at: String
    , canonical_student_id : Int
    , activity : Int
    }


eventDecoder : JD.Decoder Event
eventDecoder =
    JP.decode Event
        |> JP.required "precinct" JD.string
        |> JP.optional "lesson" JD.int 0
        |> JP.required "event_type" JD.string
        |> JP.required "created_at" JD.string
        |> JP.required "canonical_student_id" JD.int
        |> JP.optional "activity" JD.int 0



-- Progress


type alias Progress =
    { position : String
    , placement_test : Bool
    , map : Int
    , activity : Int
    }


progressDecoder : JD.Decoder Progress
progressDecoder =
    JP.decode Progress
        |> JP.required "position" JD.string
        |> JP.required "placement_test" JD.bool
        |> JP.required "map" JD.int
        |> JP.required "activity" JD.int



----------
-- View --
----------


view : History -> Html b
view (History models) =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "Created at" ]
                , Table.th [] [ text "Precinct" ]
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
            (List.map rowView models)
        ]


rowView : Model -> Html b
rowView { event, progress } =
    Table.tr []
        [ Table.td [] [ text event.created_at ]
        , Table.td [] [ text event.precinct ]
        , Table.td [] [ text event.event_type ]
        , Table.td [ Table.numeric ] [ text (toString event.lesson) ]
        , Table.td [ Table.numeric ] [ text (toString event.activity) ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString progress.map) ] ]
        , Table.td [] [ strong [] [ text progress.position ] ]
        , Table.td [ Table.numeric ] [ strong [] [ text (toString progress.activity) ] ]
        , Table.td [] [ strong [] [ text (toString progress.placement_test) ] ]
        ]
