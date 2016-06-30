module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
-- import Html.Attributes exposing (..)
-- import Html.Events exposing (on)
-- import Json.Decode as Json exposing ((:=))
-- import Mouse exposing (Position)

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Msg =
  Noop

type alias Progress =
  { map : Int
  , position : String
  , activity: Int
  , placement_test: Bool
  }

type alias Event =
  { student_id : Int
  , event_type : String
  , precinct: String
  }

type alias Thing =
  { event : Event
  , progress : Progress
  }

type alias Model =
  List Thing

p1 = { map = 1, position = "1", activity = 1, placement_test = False }
e1 = { student_id = 1, event_type = "CompleteLesson", precinct = "lessons"}

init : (Model, Cmd Msg)
init =
  (
   [{ event = e1, progress = p1 }]
   , Cmd.none
   )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  (model, Cmd.none)

subscriptions : a -> Sub Msg
subscriptions thing =
  Sub.none

view : Model -> Html b
view model =
  div []
      (List.map eventView model)

eventView : Thing -> Html b
eventView thing =
  div
    []
    [span [] [text (toString thing.event.student_id)]
    ,span [] [text thing.event.precinct]
    ,span [] [text thing.event.event_type]]
