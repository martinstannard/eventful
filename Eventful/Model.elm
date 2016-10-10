module Eventful.Model exposing (Model, init, Page(..))

import Quanta exposing (Quanta)
import Material


type alias Model =
    { quanta : Quanta
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    , isLoading : Bool
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
    , isLoading = False
    }
