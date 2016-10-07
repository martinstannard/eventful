module MainDataType exposing (Msg(..), Page(..), Model)

import Http
import Quanta exposing (Quanta)
import Material


type Msg
    = GetEvents
    | FetchSucceed Quanta
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)


type Page
    = Index
    | Settings


type alias Model =
    { quanta : Quanta
    , studentId : String
    , mdl : Material.Model
    , currentPage : Page
    }
