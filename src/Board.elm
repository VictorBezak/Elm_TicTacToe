module Board exposing (Clickable, Cell, Content, Board, board, showCell, setCell)

import Player exposing (Player)


-- Players and Model schemas were copied here to
-- satisfy definitions for our setCell function
type Players
    = Player1
    | Player2

type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : Players
    -- , status : Status
    }

type Content
    = Empty
    | X
    | O

type Clickable
    = Active
    | Inactive

type Cell
    = A1
    | A2
    | A3
    | B1
    | B2
    | B3
    | C1
    | C2
    | C3

type alias Board =
    { a1 : { id : Cell, content : Content, clickable : Clickable }
    , a2 : { id : Cell, content : Content, clickable : Clickable }
    , a3 : { id : Cell, content : Content, clickable : Clickable }
    , b1 : { id : Cell, content : Content, clickable : Clickable }
    , b2 : { id : Cell, content : Content, clickable : Clickable }
    , b3 : { id : Cell, content : Content, clickable : Clickable }
    , c1 : { id : Cell, content : Content, clickable : Clickable }
    , c2 : { id : Cell, content : Content, clickable : Clickable }
    , c3 : { id : Cell, content : Content, clickable : Clickable }
    }

    
board : Board
board =
    { a1 = { id = A1, content = Empty, clickable = Active }
    , a2 = { id = A2, content = Empty, clickable = Active }
    , a3 = { id = A3, content = Empty, clickable = Active }
    , b1 = { id = B1, content = Empty, clickable = Active }
    , b2 = { id = B2, content = Empty, clickable = Active }
    , b3 = { id = B3, content = Empty, clickable = Active }
    , c1 = { id = C1, content = Empty, clickable = Active }
    , c2 = { id = C2, content = Empty, clickable = Active }
    , c3 = { id = C3, content = Empty, clickable = Active }
    }

showCell : Cell -> String
showCell cell =
    let
        case cell of
            

    in
        case content of
            Empty ->
                ""

            X ->
                "X"

            O ->
                "O"

setCell : Cell -> Model -> Cell
setCell cell game =
    case game.playerTurn of
        Player1 ->
            cell X Inactive

        Player2 ->
            cell O Inactive
