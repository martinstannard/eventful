module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Http
import Task
import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Options exposing (css)
import List exposing (reverse)
import Event exposing (..)
import Progress exposing (..)
import Quanta exposing (..)


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = Noop
    | GetEvents
    | FetchSucceed Quanta
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)


type alias Model =
    { quanta : Quanta
    , studentId : String
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { quanta = Quanta.init
      , studentId = "1"
      , mdl = Material.model
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetEvents ->
            ( model, loadEvents model.studentId )

        FetchSucceed quanta ->
            ( { model | quanta = quanta }, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : a -> Sub Msg
subscriptions thing =
    Sub.none



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    div [ style [ ( "padding", "2rem" ) ] ]
        [ h4 [] [ text "Eventful" ]
        , Textfield.render MDL
            [ 0 ]
            model.mdl
            [ Textfield.label "Student Id"
            , Textfield.floatingLabel
            , Textfield.value model.studentId
            , Textfield.onInput UpdateStudentId
            ]
        , Button.render MDL
            [ 0 ]
            model.mdl
            [ Button.onClick GetEvents
            , css "margin" "0 24px"
            ]
            [ text "Get History" ]
        , br [] []
        , Quanta.view model.quanta
        ]
        |> Material.Scheme.top


loadEvents : String -> Cmd Msg
loadEvents studentId =
    let
        url =
            "http://progression.coreos-staging.blakedev.com/api/v3/history/maths/my_lessons/" ++ studentId

        --          "http://localhost:4000/api/v3/history/maths/my_lessons/" ++ studentId
        decoder =
            Quanta.decoder
    in
        Task.perform FetchFail FetchSucceed (Http.get decoder url)
