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
import Event exposing (Event, decoder)
import Progress exposing (Progress, decoder)
import Quanta exposing (Quanta, init, decoder, view)
import Navigation
import Route
import MainDataType exposing (Msg(..), Page(..), Model)


-- Aliases


type alias Url =
    String


type alias Mdl =
    Material.Model



-- Main program


main : Program Never
main =
    Navigation.program Route.urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = Route.urlUpdate
        , subscriptions = \_ -> Sub.none
        }


init : Url -> ( Model, Cmd Msg )
init url =
    let
        model =
            { quanta = Quanta.init
            , studentId = "1"
            , mdl = Material.model
            , currentPage = Index
            }

        mainCmds =
            Cmd.none

        ( modelWithUrl, urlCmds ) =
            Route.urlUpdate url model
    in
        ( modelWithUrl, Cmd.batch [ mainCmds, urlCmds ] )



-- Update


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



-- View


view : Model -> Html Msg
view ({ currentPage } as model) =
    case currentPage of
        Index ->
            indexView model |> Material.Scheme.top

        Settings ->
            settingsView model |> Material.Scheme.top


settingsView : Model -> Html Msg
settingsView model =
    div []
        [ h1 [] [ text "This is the settings page" ]
        , h5 [] [ text "Add stuff here" ]
        ]


indexView : Model -> Html Msg
indexView model =
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
