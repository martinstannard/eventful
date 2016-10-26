module Eventful.Update exposing (Msg(..), update)

import Eventful.Model as Model exposing (Model, Page(..))
import Quanta exposing (Quanta)
import Material
import Http
import String
import Task
import Settings exposing (Settings)
import Navigation


toUrl : Model -> String
toUrl { currentPage } =
    let
        pageString =
            case currentPage of
                Settings ->
                    "settings"

                _ ->
                    ""
    in
        String.append "#/" pageString



-- Update


type Msg
    = QuantaMsg Quanta.Msg
    | GetQuanta String
    | UpdateStudentId String
    | MDL (Material.Msg Msg)
    | SettingsMsg Settings.Msg
    | SelectTab Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetQuanta studentId ->
            let
                ( quantaStartFetching, quantaCmds ) =
                    Quanta.fetch model.settings studentId model.quanta
            in
                ( { model | quanta = quantaStartFetching }, Cmd.map QuantaMsg quantaCmds )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        SettingsMsg msg ->
            ( { model | settings = Settings.update msg model.settings }, Cmd.none )

        SelectTab tab ->
            let
                updateTo page =
                    ( { model | currentPage = Index }, Navigation.modifyUrl (toUrl { model | currentPage = page }) )
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
