module Decoders.ProgressionProgressV3 exposing (Progress, decoder)

{-| Decoder for progression app, progress endpoint. The progress endpoint looks
    like this:
    {
       "student_progress":[
          {
             "show_placement_test":true,
             "id":"my_lessons",
             "current_position":"1",
             "current_map":1,
             "current_activity":1
          }
       ]
    }

    This is decoded into a list of Progress data types.
-}

import Json.Decode as JD
import Json.Decode.Pipeline as JP


type alias Progress =
    {}


decoder : JD.Decoder Progress
decoder =
    JP.decode Progress
        |> JP.required "student_progress" studentProgressDecoder



-- Event


type alias StudentProgress =
    { show_placement_test : Bool
    , id : String
    , current_position : String
    , current_map : Int
    , current_activity : Int
    }


studentProgressDecoder : JD.Decoder StudentProgress
studentProgressDecoder =
    JP.decode StudentProgress
        |> JP.required "show_placement_test" JD.bool
        |> JP.required "id" JD.string
        |> JP.required "current_position" JD.string
        |> JP.required "current_map" JD.int
        |> JP.optional "current_activity" JD.int 0


