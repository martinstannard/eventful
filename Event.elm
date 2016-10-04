module Event exposing (Event, decoder)

import Json.Decode as Json exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)


type alias Event =
    { precinct : String
    , lesson : Int
    , event_type : String
    , canonical_student_id : Int
    , activity : Int
    }


decoder : Json.Decoder Event
decoder =
    decode Event
        |> JsonPipeline.required "precinct" string
        |> JsonPipeline.required "lesson" int
        |> JsonPipeline.required "event_type" string
        |> JsonPipeline.required "canonical_student_id" int
        |> JsonPipeline.optional "activity" int 0
