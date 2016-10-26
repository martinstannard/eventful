module Main exposing (main)

import Navigation
import Pages.Index as Index exposing (Index)
import Pages.Settings as Settings exposing (Settings)
import String
import AllDict exposing (AllDict)


-- Html

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)


-- Material

import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Table as Table
import Material.Tabs as Tabs
import Material.Options as Options exposing (css)
import Material.Icon as Icon


-- Main program


main : Program Never
main =
    Navigation.program urlParser
        { init = \url -> urlUpdate url init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { currentPage : Page
    , settings : Settings
    , tab : Int
    , mdl : Material.Model
    }


type Msg
    = SettingsMsg Settings.Msg
    | IndexMsg Index.Msg
    | SelectTab Int
    | MDL (Material.Msg Msg)


type Page
    = Index
    | Settings


init : Model
init =
    { currentPage = Index
    , index = Index.init
    , settings = Settings.init
    , tab = 0
    , mdl = Material.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IndexMsg msg ->
            ( { model | index = Index.update msg model.index }, Cmd.none )

        SettingsMsg msg ->
            ( { model | settings = Settings.update msg model.settings }, Cmd.none )

        SelectTab tab ->
            let
                updateTo page =
                    ( { model | currentPage = Index, tab = tab }, Navigation.modifyUrl (toUrl { model | currentPage = page }) )
            in
                case tab of
                    0 ->
                        updateTo Index

                    1 ->
                        updateTo Settings

                    _ ->
                        ( { model | currentPage = Index, tab = tab }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view ({ currentPage } as model) =
    Tabs.render MDL
        [ 0 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab SelectTab
        , Tabs.activeTab model.tab
        ]
        [ Tabs.label [ Options.center ]
            [ Icon.i "info_outline"
            , Options.span [ css "width" "4px" ] []
            , text "Index"
            ]
        , Tabs.label [ Options.center ]
            [ Icon.i "code"
            , Options.span [ css "width" "4px" ] []
            , text "Settings"
            ]
        ]
        [ viewPage model |> Material.Scheme.top ]


viewPage : Model -> Html Msg
viewPage ({ currentPage } as model) =
    case currentPage of
        Index ->
            Index.view model.index
                |> Html.App.map IndexMsg

        Settings ->
            Settings.view model.settings
                |> Html.App.map SettingsMsg



-- url stuff


urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    let
        changeToPage page =
            ( { model | currentPage = page }, Cmd.none )
    in
        url
            |> AllDict.get url routes
            |> Maybe.withDefault Index
            |> changeToPage


fromUrl : String -> String
fromUrl url =
    String.dropLeft 2 url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .hash)


toUrl : Model -> String
toUrl { currentPage } =
    currentPage
        |> (\x -> AllDict.get x routes)
        |> Maybe.withDefault Index
        |> (\x -> AllDict.get x reverseRoutes)
        |> String.append "#/"


routes : AllDict String Page
routes =
    AllDict.fromList urlPagePairs


reverseRoutes : AllDict Page String
reverseRoutes =
    let
        reverseTuple ( a, b ) =
            ( b, a )
    in
        urlPagePairs
            |> List.map reverseTuple
            |> AllDict.fromList


urlPagePairs : List ( String, Page )
urlPagePairs =
    [ ( "", Index )
    , ( "index", Index )
    , ( "settings", Settings )
    ]
