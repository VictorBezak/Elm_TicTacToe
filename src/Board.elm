module Board exposing (Content(..), State(..), Cell, Board, board, viewContent)
-- ADD resetGame, emptyCells

-- import Player exposing (Player)



type Stats
    = Level Int
    | Wins Int
    | Draws Int
    | Losses Int

type alias Player =
    { username : String
    , level : Stats 
    , wins : Stats
    , losses : Stats
    , draws : Stats
    }

type Status
    = InProgress
    | Victory
    | Draw

type PlayerTurn
    = Player1
    | Player2

type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : PlayerTurn
    , status : Status
    }

---------------------------------------------------------------------

type Content
    = Empty
    | X
    | O

type State
    = Active
    | Inactive

type alias Cell =
    { content : Content
    , state : State
    }

type alias Board =
    { a1 : Cell
    , a2 : Cell
    , a3 : Cell
    , b1 : Cell
    , b2 : Cell
    , b3 : Cell
    , c1 : Cell
    , c2 : Cell
    , c3 : Cell
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


viewContent : Content -> String
viewContent content =
    case content of
        Empty ->
            ""

        X ->
            "X"

        O ->
            "O"


-- setCell : Cell -> Model -> Cell
-- setCell cell game =
--     case game.playerTurn of
--         Player1 ->
--             { cell | content = X, state = Inactive }

--         Player2 ->
--             { cell | content = O, state = Inactive }
        

-- updateBoard : Cell -> (Cell -> Model -> Cell) -> Model -> Model
-- updateBoard cell game =
--     { game | cell }

-- updateCell : Cell -> Model
-- updateCell cell =
--         updateSecondLayer <| setCell cell 


-- resetGame : Board -> Model -> Model
-- resetGame reset game =
--     { game | board = reset, status = InProgress }

-- emptyCells : Board
-- emptyCells =
--     { a1 = { content = Empty, state = Active }
--     , a2 = { content = Empty, state = Active }
--     , a3 = { content = Empty, state = Active }
--     , b1 = { content = Empty, state = Active }
--     , b2 = { content = Empty, state = Active }
--     , b3 = { content = Empty, state = Active }
--     , c1 = { content = Empty, state = Active }
--     , c2 = { content = Empty, state = Active }
--     , c3 = { content = Empty, state = Active }
--     }
    