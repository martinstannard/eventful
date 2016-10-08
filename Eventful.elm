module Main exposing (main)

import Eventful.Model exposing (Model, init)
import Eventful.Update exposing (Msg(..), update, urlUpdate)
import Eventful.View exposing (view)
import List
import Route
import Navigation

-- Main program

main : Program Never
main =
    Navigation.program Route.urlParser
        { init = \url -> urlUpdate url (init url)
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = \_ -> Sub.none
        }
