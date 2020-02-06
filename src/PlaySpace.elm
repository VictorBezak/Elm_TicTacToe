module PlaySpace exposing (..)

import Array exposing (Array, repeat, get)


type alias Player =
    { username : String
    , level : Int
    , wins : Int
    , losses : Int
    , draws : Int
    }

type alias Model =
    { cells : Array String
    , player1 : Player
    , player2 : Player
    , activePlayer : Player
    , status : String
    }


cells : Array String
cells =
    repeat 9 ""

cell_A1 : Model -> String
cell_A1 game =
    case get 0 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_A2 : Model -> String
cell_A2 game =
    case get 1 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_A3 : Model -> String
cell_A3 game =
    case get 2 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_B1 : Model -> String
cell_B1 game =
    case get 3 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_B2 : Model -> String
cell_B2 game =
    case get 4 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_B3 : Model -> String
cell_B3 game =
    case get 5 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_C1 : Model -> String
cell_C1 game =
    case get 6 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_C2 : Model -> String
cell_C2 game =
    case get 7 game.cells of
        Just content ->
            content
        Nothing ->
            ""

cell_C3 : Model -> String
cell_C3 game =
    case get 8 game.cells of
        Just content ->
            content
        Nothing ->
            ""
