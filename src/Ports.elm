port module Ports exposing (..)

import Json.Encode as Encode
import Json.Decode exposing (Decoder, field, int)
import Array exposing (Array, fromList, get)
import Maybe exposing (withDefault)

import Player exposing (getStat)

import Types.Main exposing (Model)


type Cache
    = AsInt
    | AsArray
    | AsEncodeValue

type Uncache
    = FromInt Int
    | FromArray (Array Int)
    -- | FromEncodeValue Encode.Value


-- Commands
port cacheInt : Int -> Cmd a
port cachePlayerArray : Array Int -> Cmd a
port cachePlayerObject : Encode.Value -> Cmd a


-- Subscriptions
-- port exampleSub : (Encode.Value -> a) -> Sub a


-- Helper Functions
cache : Cache -> Model -> Cmd a
cache method model =
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
        case method of
            AsInt ->
                cacheInt 200

            AsArray ->
                cachePlayerArray
                    <| fromList [ p1_level, p1_win, p1_loss, p1_draw, p2_level, p2_win, p2_loss, p2_draw ]
                
            AsEncodeValue ->
                cachePlayerObject
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

uncache : Uncache -> UncachedItems
uncache method =
        case method of
            -- 200
            FromInt int ->
                { p1_level = -1
                , p1_win = -1
                , p1_loss = -1
                , p1_draw = -1
                , p2_level = -1
                , p2_win = -1
                , p2_loss = -1
                , p2_draw = -1
                }

            FromArray array ->
                { p1_level = withDefault 1 (get 0 array)
                , p1_win = withDefault 0 (get 1 array)
                , p1_loss = withDefault 0 (get 2 array)
                , p1_draw = withDefault 0 (get 3 array)
                , p2_level = withDefault 1 (get 4 array)
                , p2_win = withDefault 0 (get 5 array)
                , p2_loss = withDefault 0 (get 6 array)
                , p2_draw = withDefault 0 (get 7 array)
                }
                
            -- FromEncodeValue object ->
            --     (Decode.decodeValue Decode.int object)
                -- let
                    -- { p1_level = array[0]
                    -- , p1_win = array[1]
                    -- , p1_loss = array[2]
                    -- , p1_draw = array[3]
                    -- , p2_level = array[4]
                    -- , p2_win = array[5]
                    -- , p2_loss = array[6]
                    -- , p2_draw = array[7]
                    -- }
                    -- obj =
                    --     Decode.decodeString (Decode.keyValuePairs object)
                
                -- in
                    -- Debug.todo "return UncachedItems"

-- statDecoder : Decoder Int
-- statDecoder =
--     field "p1_level" int
--     field "p1_win" int
--     field "p1_loss" int
--     field "p1_draw" int
--     field "p2_level" int
--     field "p2_win" int
--     field "p2_loss" int
--     field "p2_draw" int

defaultItems : UncachedItems
defaultItems =  -- Returned if no cache was found
    { p1_level = 1
    , p1_win = 0
    , p1_loss = 0
    , p1_draw = 0
    , p2_level = 1
    , p2_win = 0
    , p2_loss = 0
    , p2_draw = 0
    }