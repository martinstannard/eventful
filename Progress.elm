module Progress exposing (..)

import Json.Decode as Json exposing ((:=), string, int, bool, list)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)


type alias Progress =
    { position : String
    , placement_test : Bool
    , map : Int
    , activity : Int
    }


decoder : Json.Decoder Progress
decoder =
    decode Progress
        |> JsonPipeline.required "position" string
        |> JsonPipeline.required "placement_test" bool
        |> JsonPipeline.required "map" int
        |> JsonPipeline.required "activity" int
