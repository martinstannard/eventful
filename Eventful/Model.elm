module Eventful.Model exposing (Model, init, Page(..))

import Quanta exposing (Quanta)
import Material
import Settings exposing (Settings, init)

type alias Model =
    { quanta : Quanta
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    , settings : Settings
    }


type Page
    = Index
    | Settings


init : Model
init =
    { quanta = Quanta.init
    , studentId = "1"
    , mdl = Material.model
    , currentPage = Index
    , settings = Settings.init
    }
