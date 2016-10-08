module Eventful.Model exposing (Model, init, Page(..))

import Quanta exposing (Quanta, init)
import Material

type alias Model =
    { quanta : Quanta
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    }

type alias Url =
  String

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
