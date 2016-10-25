module Route exposing (urlParser, urlUpdate)

import String
import Navigation
import Eventful.Model exposing (Model, Page(..))
import Eventful.Update exposing (Msg(..), update)

-- URL PARSERS - check out evancz/url-parser for fancier URL parsing

fromUrl : String -> String
fromUrl url =
    String.dropLeft 2 url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .hash)


urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    let
        changeToPage page =
            ( { model | currentPage = page }, Cmd.none )
    in
        case url of
            "settings" ->
                changeToPage Settings

            _ ->
                changeToPage Index
