module Board exposing (Content, State, Board, board, showCell, setCell)

import Player exposing (Player)


-- Players and Model schemas were copied here to
-- satisfy definitions for our setCell function
type PlayerTurn
    = Player1
    | Player2

type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : PlayerTurn
    }

type Content
    = Empty
    | X
    | O

type State
    = Active
    | Inactive

type alias Board =
    { a1 : { content : Content, state : State }
    , a2 : { content : Content, state : State }
    , a3 : { content : Content, state : State }
    , b1 : { content : Content, state : State }
    , b2 : { content : Content, state : State }
    , b3 : { content : Content, state : State }
    , c1 : { content : Content, state : State }
    , c2 : { content : Content, state : State }
    , c3 : { content : Content, state : State }
    }

    
board : Board
board =
    { a1 = { content = Empty, state = Active }
    , a2 = { content = Empty, state = Active }
    , a3 = { content = Empty, state = Active }
    , b1 = { content = Empty, state = Active }
    , b2 = { content = Empty, state = Active }
    , b3 = { content = Empty, state = Active }
    , c1 = { content = Empty, state = Active }
    , c2 = { content = Empty, state = Active }
    , c3 = { content = Empty, state = Active }
    }

showCell : Content -> String
showCell content =
    case content of
        Empty ->
            ""

        X ->
            "X"

        O ->
            "O"

setCell : { contents : Content, state : State } -> Model -> { contents : Content, state : State }
setCell cell game =
    case game.playerTurn of
        Player1 ->
            { cell | contents = X, state = Inactive }

        Player2 ->
            { cell | contents = O, state = Inactive }
