module Eventful.Model exposing (Model, init, Page(..))

import Quanta exposing (QuantaState, initQuantaState)
import Material
import Settings exposing (Settings, init)


type alias Model =
    { quantaState : QuantaState
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
    { quantaState = initQuantaState
    , studentId = "123"
    , mdl = Material.model
    , currentPage = Index
    , settings = Settings.init
    , tab = 0
    }
