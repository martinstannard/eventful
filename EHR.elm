module EHR
    exposing
        ( EHR
        , State(..)
        , Msg
        , init
        , update
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
import Json.Decode as JD
import Material.Table as Table
import Decoders.ProgressionHistoryV3 as History exposing (History)
import Task
import Http


type EHR
    = EHR
        { data : Maybe (List History)
        , state : State
        }


type State
    = Fetching
    | NotFetching
    | FetchSucceeded
    | FetchFailed


type Msg
    = FetchSucceed (List History)
    | FetchFail Http.Error


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


fetch : String -> JD.Decoder -> EHR -> ( EHR, Cmd Msg )
fetch url decoder (EHR model) =
    ( EHR { model | state = Fetching }, Task.perform FetchFail FetchSucceed (Http.get decoder url) )


state : EHR -> State
state (EHR model) =
    model.state
