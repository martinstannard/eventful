module Main exposing (main)

import Eventful.Model exposing (init)
import Eventful.Update exposing (update)
import Eventful.View exposing (view)
import Route exposing (urlParser, urlUpdate)
import Navigation


-- Main program


main : Program Never
main =
    Navigation.program urlParser
        { init = \url -> urlUpdate url init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = \_ -> Sub.none
        }
