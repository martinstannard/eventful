module Eventful.Update exposing (Msg(..), update)

import Eventful.Model as Model exposing (Model, Page(..))
import Quanta exposing (Quanta)
import Material
import Http
import Task


-- Update


type Msg
    = GetEvents
    | FetchSucceed Quanta
    | FetchFail Http.Error
    | UpdateStudentId String
    | MDL (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetEvents ->
            ( { model | isLoading = True }, loadEvents model.studentId )

        FetchSucceed quanta ->
            ( { model | quanta = quanta, isLoading = False }, Cmd.none )

        FetchFail error ->
            ( { model | isLoading = False }, Cmd.none )

        UpdateStudentId id ->
            ( { model | studentId = id }, Cmd.none )

        _ ->
            ( model, Cmd.none )


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
