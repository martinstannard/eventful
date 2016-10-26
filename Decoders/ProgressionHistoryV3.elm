module Decoders.ProgressionHistoryV3 exposing (History, decoder)

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
             "canonical_student_id":123
          }
       }
    ]

    This is decoded into a list of History data types.
-}
import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias History =
    { progress : Progress
    , event : Event
    }


decoder : JD.Decoder (List History)
decoder =
    JP.decode History
        |> JP.required "progress" progressDecoder
        |> JP.required "event" eventDecoder
        |> JD.list



-- Event


type alias Event =
    { precinct : String
    , lesson : Int
    , event_type : String
    , canonical_student_id : Int
    , activity : Int
    }


eventDecoder : JD.Decoder Event
eventDecoder =
    JP.decode Event
        |> JP.required "precinct" JD.string
        |> JP.required "lesson" JD.int
        |> JP.required "event_type" JD.string
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

