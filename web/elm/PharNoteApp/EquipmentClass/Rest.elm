module PharNoteApp.EquipmentClass.Rest exposing (..)

import PharNoteApp.Msg as AppMsg
import PharNoteApp.EquipmentClass.Msg exposing (..)
import PharNoteApp.EquipmentClass.BaseModel as EquipmentClassBase
import PharNoteApp.EquipmentClass.Model as EquipmentClass
import PharNoteApp.Role.Rest as Role
import Http
import Http exposing (..)
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline
import Array


classListDecoder : Json.Decode.Decoder (List EquipmentClassBase.EquipmentClass)
classListDecoder =
    Json.Decode.list classDecoder


classDecoder : Json.Decode.Decoder EquipmentClassBase.EquipmentClass
classDecoder =
    Json.Decode.Pipeline.decode EquipmentClassBase.EquipmentClass
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "description" Json.Decode.string


precisionListDecoder : Json.Decode.Decoder (List EquipmentClassBase.EquipmentPrecision)
precisionListDecoder =
    Json.Decode.list precisionDecoder


precisionDecoder : Json.Decode.Decoder EquipmentClassBase.EquipmentPrecision
precisionDecoder =
    Json.Decode.Pipeline.decode EquipmentClassBase.EquipmentPrecision
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "precision" Json.Decode.string


classPrecisionListDecoder : Json.Decode.Decoder (List EquipmentClass.EquipmentClassWithPrecisionList)
classPrecisionListDecoder =
    Json.Decode.list classPrecisionDecoder


classPrecisionDecoder : Json.Decode.Decoder EquipmentClass.EquipmentClassWithPrecisionList
classPrecisionDecoder =
    Json.Decode.Pipeline.decode EquipmentClass.EquipmentClassWithPrecisionList
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "description" Json.Decode.string
        |> Json.Decode.Pipeline.required "equipment_precision" precisionListDecoder


urlEquipmentClasss : String
urlEquipmentClasss =
    "http://localhost:4000/api/equipmentclass"


get : Cmd AppMsg.Msg
get =
    --Http.send AppMsg.MsgForEquipmentClass ProcessEquipmentClassGet (Http.get url listDecoder)
    Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassGet result)) (Http.get urlEquipmentClasss classPrecisionListDecoder)


payload : EquipmentClass.EquipmentClassWithPrecisionString -> Json.Encode.Value
payload ec =
    Json.Encode.object
        [ ( "name", Json.Encode.string ec.name )
        , ( "description", Json.Encode.string ec.description )
        , ( "precisions", Json.Encode.string ec.precisions )
        ]


payload2 : EquipmentClass.EquipmentClassWithPrecision -> Json.Encode.Value
payload2 ec =
    Json.Encode.object
        [ ( "name", Json.Encode.string ec.name )
        , ( "description", Json.Encode.string ec.description )
        ]


payload3 : EquipmentClass.EquipmentClassWithPrecision -> Json.Encode.Value
payload3 ec =
    Json.Encode.object
        [ ( "name", Json.Encode.string ec.name )
        , ( "description", Json.Encode.string ec.description )
        , ( "equipment_precision", Json.Encode.list (List.map encodePrecision (Array.toList ec.precisions)) )
        ]


encodePrecision : EquipmentClassBase.EquipmentPrecision -> Json.Encode.Value
encodePrecision prec =
    Json.Encode.object
        [ ( "id", Json.Encode.int prec.id )
        , ( "precision", Json.Encode.string prec.precision )
        ]


post : EquipmentClass.EquipmentClassWithPrecision -> Cmd AppMsg.Msg
post equipClass =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload3 equipClass))

        jj =
            Debug.log "json" body
    in
        --ProcessEquipmentClassPost (Result Http.Error EquipmentClass)
        --Http.send ProcessEquipmentClassPost (Http.post url body decoder)
        --send first arg is a function that can translate a result into a message
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassPost result)) (Http.post urlEquipmentClasss body classPrecisionDecoder)


put : EquipmentClass.EquipmentClassWithPrecisionString -> Cmd AppMsg.Msg
put equipClass =
    let
        putUrl =
            if equipClass.id < 1 then
                urlEquipmentClasss ++ "/bad"
            else
                urlEquipmentClasss ++ "/" ++ (toString equipClass.id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload equipClass))

        putRequest =
            Http.request
                { method = "PUT"
                , headers = []
                , url = putUrl
                , body = body
                , expect = Http.expectJson classPrecisionDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassPost result)) putRequest



--Http.send (AppMsg.MsgForEquipmentClass ProcessEquipmentClassPost) putRequest


delete : EquipmentClass.EquipmentClassWithPrecision -> Cmd AppMsg.Msg
delete equipClass =
    let
        putUrl =
            if equipClass.id < 1 then
                urlEquipmentClasss ++ "/bad"
            else
                urlEquipmentClasss ++ "/" ++ (toString equipClass.id)

        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload2 equipClass))

        putRequest =
            Http.request
                { method = "DELETE"
                , headers = []
                , url = putUrl
                , body = body
                , expect = Http.expectJson classPrecisionDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        --Http.send (AppMsg.MsgForEquipmentClass ProcessEquipmentClassPost) putRequest
        Http.send (\result -> AppMsg.MsgForEquipmentClass (ProcessEquipmentClassDelete result)) putRequest
