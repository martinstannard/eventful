module Route exposing (urlParser)

import String
import Navigation
import Eventful.Model exposing (Model, Page(..))
import Eventful.Update exposing (Msg)


-- URL PARSERS - check out evancz/url-parser for fancier URL parsing


fromUrl : String -> String
fromUrl url =
    String.dropLeft 2 url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .hash)
