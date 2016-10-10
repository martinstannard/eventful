module Settings exposing (Settings, Msg, init, view)

import String
import Html exposing (..)


type Settings
    = Settings Model


type Msg
    = UpdateUrl String


type alias Model =
    { url : String
    }


init : Settings
init =
    Settings
        { url = "http://progression.coreos-staging.blakedev.com/api/v3/history/maths/my_lessons/"
        }


update : Msg -> Settings -> Settings
update msg (Settings model) =
    case msg of
        UpdateUrl url ->
            Settings { model | url = url }


view : Settings -> Html Msg
view (Settings model) =
    div []
        [ h1 [] [ text "Settings" ]
        , input [] [ text model.url ]
        ]
