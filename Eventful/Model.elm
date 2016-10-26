module Eventful.Model exposing (Model, init, Page(..))

import EHR exposing (EHR)
import Material
import Settings exposing (Settings)


type alias Model =
    { quanta : EHR
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    , settings : Settings
    , tab : Int
    }


type Page
    = Index
    | Settings


init : Model
init =
    { quanta = EHR.init
    , studentId = "123"
    , mdl = Material.model
    , currentPage = Index
    , settings = Settings.init
    , tab = 0
    }
