module ProgressionHistoryV3 exposing (History, decoder)

import Json.Decode as JD exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)


type alias Event =
    { precinct : String
    , lesson : Int
    , event_type : String
    , canonical_student_id : Int
    , activity : Int
    }


type alias History =
    { progress : Progress
    , event : Event
    }


decoder : JD.Decoder History
decoder =
    decode History
        |> JsonPipeline.required "progress" progressDecoder
        |> JsonPipeline.required "event" eventDecoder
        |> JD.list


progressDecoder : JD.Decoder Event
progressDecoder =
    decode Event
        |> JsonPipeline.required "precinct" string
        |> JsonPipeline.required "lesson" int
        |> JsonPipeline.required "event_type" string
        |> JsonPipeline.required "canonical_student_id" int
        |> JsonPipeline.optional "activity" int 0


type alias Progress =
    { position : String
    , placement_test : Bool
    , map : Int
    , activity : Int
    }


eventDecoder : JD.Decoder Progress
eventDecoder =
    decode Progress
        |> JsonPipeline.required "position" string
        |> JsonPipeline.required "placement_test" bool
        |> JsonPipeline.required "map" int
        |> JsonPipeline.required "activity" int
