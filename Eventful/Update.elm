module Eventful.Update exposing (Msg(..), update)

import Eventful.Model as Model exposing (Model, Page(..))
import Quanta exposing (Quanta, QuantaState, fetchSuccess, fetchFailure, fetchStart)
import Material
import Http
import String
import Task
import Settings
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
    = StartFetchQuanta
    | FetchQuanta
    | FetchSucceed Quanta
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)
    | SettingsMsg Settings.Msg
    | SelectTab Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartFetchQuanta ->
            update FetchQuanta { model | quantaState = Quanta.fetchStart model.quantaState }

        FetchQuanta ->
            ( model, fetchQuanta model.settings model.studentId )

        FetchSucceed quanta ->
            ( { model | quantaState = Quanta.fetchSuccess model.quantaState quanta }, Cmd.none )

        FetchFail error ->
            ( { model | quantaState = Quanta.fetchFailure model.quantaState }, Cmd.none )

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


fetchQuanta : Settings -> String -> Cmd Msg
fetchQuanta settings studentId =
    let
        url =
            Settings.endPoint settings studentId

        --          "http://localhost:4000/api/v3/history/maths/my_lessons/" ++ studentId
        decoder =
            Quanta.decoder
    in
        Task.perform FetchFail FetchSucceed (Http.get decoder url)
