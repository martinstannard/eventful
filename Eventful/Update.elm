module Eventful.Update exposing (Msg(..), update)

import Eventful.Model as Model exposing (Model, Page(..))
import Quanta exposing (Quanta, QuantaState, fetchSuccess, fetchFailure, fetchStart)
import Material
import Http
import Task
import Settings


-- Update


type Msg
    = StartFetchQuanta
    | FetchQuanta
    | FetchSucceed Quanta
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)
    | SettingsMsg Settings.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartFetchQuanta ->
            update FetchQuanta { model | quantaState = Quanta.fetchStart model.quantaState }

        FetchQuanta ->
            ( model, fetchQuanta model.studentId )

        FetchSucceed quanta ->
            ( { model | quantaState = Quanta.fetchSuccess model.quantaState quanta }, Cmd.none )

        FetchFail error ->
            ( { model | quantaState = Quanta.fetchFailure model.quantaState }, Cmd.none )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        SettingsMsg msg ->
            ( { model | settings = Settings.update msg model.settings }, Cmd.none )

        _ ->
            ( model, Cmd.none )


fetchQuanta : String -> Cmd Msg
fetchQuanta studentId =
    let
        url =
            "http://progression.coreos-staging.blakedev.com/api/v3/history/maths/my_lessons/" ++ studentId

        --          "http://localhost:4000/api/v3/history/maths/my_lessons/" ++ studentId
        decoder =
            Quanta.decoder
    in
        Task.perform FetchFail FetchSucceed (Http.get decoder url)
