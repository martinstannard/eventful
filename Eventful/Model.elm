module Eventful.Model exposing (Model, init, Page(..))

import Quanta exposing (QuantaState, initQuantaState)
import Material

type alias Model =
    { quantaState : QuantaState
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    }

type Page
    = Index
    | Settings

init : Model
init =
    { quantaState = initQuantaState
    , studentId = "1"
    , mdl = Material.model
    , currentPage = Index
    }
