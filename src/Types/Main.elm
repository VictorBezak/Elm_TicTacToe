module Types.Main exposing (Model, PlayerTurn(..), Status(..))

import Types.Player exposing (Player)
import Types.Board exposing (Board)


type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : PlayerTurn
    , status : Status
    }

type PlayerTurn
    = Player1
    | Player2

type Status
    = InProgress
    | Victory
    | Draw
