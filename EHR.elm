module EHR
    exposing
        ( EHR
        , State(..)
        , Msg
        , init
        , view
        , update
        , state
        , fetch
        , data
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


type EHR a b
    = EHR
        { data : Maybe a
        , state : State
        , viewFn : a -> Html b
        }


type State
    = Fetching
    | NotFetching
    | FetchSucceeded
    | FetchFailed


type Msg a
    = FetchSucceed a
    | FetchFail Http.Error


init : (a -> Html b) -> EHR a b
init viewFn =
    EHR
        { data = Nothing
        , state = NotFetching
        , viewFn = viewFn
        }


view : EHR a b -> Html b
view (EHR model) =
    case model.data of
        Nothing ->
            div [] []

        Just data ->
            model.viewFn data


data : EHR a b -> Maybe a
data (EHR model) =
    model.data


update : Msg a -> EHR a b -> ( EHR a b, Cmd (Msg a) )
update msg (EHR model) =
    case msg of
        FetchSucceed quantums ->
            ( EHR { model | state = FetchSucceeded, data = Just quantums }, Cmd.none )

        FetchFail error ->
            ( EHR { model | state = FetchFailed, data = Nothing }, Cmd.none )


fetch : String -> JD.Decoder a -> EHR a b -> ( EHR a b, Cmd (Msg a) )
fetch url decoder (EHR model) =
    ( EHR { model | state = Fetching }, Task.perform FetchFail FetchSucceed (Http.get decoder url) )


state : EHR a b -> State
state (EHR model) =
    model.state
