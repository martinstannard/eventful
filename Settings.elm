module Settings
    exposing
        ( Settings
        , Msg
        , init
        , view
        , update
        , endPoint
        )

import String
import Html exposing (..)
import Html.Events as HE exposing (..)
import Html.Attributes as HA exposing (..)
import Dict exposing (Dict)


-- Material

import Material.Textfield as Textfield
import Material


type Settings
    = Settings Model


type Msg
    = UpdateUrl String
    | MDL (Material.Msg Msg)


type alias Model =
    { url : String
    , mdl : Material.Model
    }


init : Settings
init =
    Settings
        { url = "http://progression.coreos-staging.blakedev.com/api/v3/history/maths/my_lessons/"
        , mdl = Material.model
        }


update : Msg -> Settings -> Settings
update msg (Settings model) =
    case msg of
        UpdateUrl url ->
            Settings { model | url = url }

        _ ->
            Settings model


endPoint : Settings -> String
endPoint (Settings settings) =
    settings.url


view : Settings -> Html Msg
view (Settings model) =
    div []
        [ h1 [] [ text "Settings" ]
        , Textfield.render MDL
            [ 0 ]
            model.mdl
            [ Textfield.label "Endpoint"
            , Textfield.floatingLabel
            , Textfield.onInput UpdateUrl
            , Textfield.value model.url
            ]
        ]


type Endpoint
    = StagingHistory
    | StagingProgress


endpoints : Dict Endpoint String
endpoints =
    let
        stagingApi =
            "http://progression.coreos-staging.blakedev.com/api/v3"
    in
        Dict.fromList
            [ ( StagingHistory, stagingApi ++ "/history/maths/my_lessons/" )
            , ( StagingProgress, stagingApi ++ "/progress/maths/my_lessons/" )
            ]
