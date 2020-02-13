port module Ports exposing (..)

import Json.Encode as Encode
import Json.Decode exposing (Decoder, map8, field, int, decodeValue)
import Array exposing (Array, fromList, get)
import Maybe exposing (withDefault)

import Player exposing (getStat)

import Types.Main exposing (Model)


-- Commands
port cachePlayer : Encode.Value -> Cmd a


-- Helper Functions
cache : Model -> Cmd a
cache model =
    let
        p1_level = getStat model.player1.level
        p1_win = getStat model.player1.wins
        p1_loss = getStat model.player1.losses
        p1_draw = getStat model.player1.draws

        p2_level = getStat model.player2.level
        p2_win = getStat model.player2.wins
        p2_loss = getStat model.player2.losses
        p2_draw = getStat model.player2.draws
    
    in
        cachePlayer
            <| Encode.object
                [ ( "p1_level", Encode.int p1_level )
                , ( "p1_win", Encode.int p1_win )
                , ( "p1_loss", Encode.int p1_loss )
                , ( "p1_draw", Encode.int p1_draw )
                , ( "p2_level", Encode.int p2_level )
                , ( "p2_win", Encode.int p2_win )
                , ( "p2_loss", Encode.int p2_loss )
                , ( "p2_draw", Encode.int p2_draw )
                ]

type alias UncachedItems =
    { p1_level : Int, p1_win : Int, p1_loss : Int, p1_draw : Int
    , p2_level : Int, p2_win : Int, p2_loss : Int, p2_draw : Int
    }

decode : Encode.Value -> (Result Json.Decode.Error UncachedItems)
decode value =
            decodeValue statDecoder value

statDecoder : Decoder UncachedItems
statDecoder =
    map8 UncachedItems
        (field "p1_level" int)
        (field "p1_win" int)
        (field "p1_loss" int)
        (field "p1_draw" int)
        (field "p2_level" int)
        (field "p2_win" int)
        (field "p2_loss" int)
        (field "p2_draw" int)

defaultData : UncachedItems
defaultData =  -- Returned if no cache was found
    { p1_level = 1
    , p1_win = 0
    , p1_loss = 0
    , p1_draw = 0
    , p2_level = 1
    , p2_win = 0
    , p2_loss = 0
    , p2_draw = 0
    }