module Route exposing (urlUpdate, urlParser)

import String
import Navigation
import MainDataType exposing (Model, Msg, Page(..))


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
        setPage =
            \x -> ( { model | currentPage = x }, Cmd.none )
    in
        if url == "settings" then
            setPage Settings
        else
            setPage Index
