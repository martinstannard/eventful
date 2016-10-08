module Eventful.Model exposing (Model, init, Page(..))

import Quanta
import Material


type alias Model =
    { quanta : Quanta.Model
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
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
    }
