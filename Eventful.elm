module Main exposing (main)

import Eventful.Model exposing (Model, init)
import Eventful.Update exposing (Msg(..), update, urlUpdate)
import Eventful.View exposing (view)
import List
import Route
import Navigation

-- import Html.App exposing (Cmd)

-- Main program

main : Program Never
main =
    Navigation.program Route.urlParser
        { init = \url -> (init url, Cmd.none)
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = \_ -> Sub.none
        }
