module Board exposing (viewContent, emptyBoard, resetBoard, updateCell)

import Model exposing (Model, PlayerTurn(..), Status(..), Board, Cell, Id(..), Content(..), State(..))

---------------------------------------------------------------------

-- FROM Main.elm
-- type Status
--     = InProgress
--     | Victory
--     | Draw

-- type PlayerTurn
--     = Player1
--     | Player2

-- type alias Model =
--     { board : Board
--     , player1 : Player
--     , player2 : Player
--     , playerTurn : PlayerTurn
--     , status : Status
--     }

---------------------------------------------------------------------

-- FROM Player.elm
-- type Stats
--     = Level Int
--     | Wins Int
--     | Draws Int
--     | Losses Int

-- type alias Player =
--     { username : String
--     , level : Stats 
--     , wins : Stats
--     , losses : Stats
--     , draws : Stats
--     }

---------------------------------------------------------------------

-- NATIVE
-- type Id
--     = A1
--     | A2
--     | A3
--     | B1
--     | B2
--     | B3
--     | C1
--     | C2
--     | C3

-- type Content
--     = Empty
--     | X
--     | O

-- type State
--     = Active
--     | Inactive

-- type alias Cell =
--     { id : Id
--     , content : Content
--     , state : State
--     }

-- type alias Board =
--     { a1 : Cell
--     , a2 : Cell
--     , a3 : Cell
--     , b1 : Cell
--     , b2 : Cell
--     , b3 : Cell
--     , c1 : Cell
--     , c2 : Cell
--     , c3 : Cell
--     }


viewContent : Content -> String
viewContent content =
    case content of
        Empty ->
            ""

        X ->
            "X"

        O ->
            "O"
    
emptyBoard : Board
emptyBoard =
    { a1 = { id = A1, content = Empty, state = Active }
    , a2 = { id = A2, content = Empty, state = Active }
    , a3 = { id = A3, content = Empty, state = Active }
    , b1 = { id = B1, content = Empty, state = Active }
    , b2 = { id = B2, content = Empty, state = Active }
    , b3 = { id = B3, content = Empty, state = Active }
    , c1 = { id = C1, content = Empty, state = Active }
    , c2 = { id = C2, content = Empty, state = Active }
    , c3 = { id = C3, content = Empty, state = Active }
    }

resetBoard : Board -> Model -> Model
resetBoard reset game =
    { game | board = reset, status = InProgress }

updateCell : Model -> Cell -> Model -> Model
updateCell model cell =
    updateModel <| updateBoard cell <| setCell model

--------------------------------------------------

-- Private Functions
updateModel : (Board -> Board) -> Model -> Model
updateModel boardUpdate model =
    { model | board = boardUpdate model.board }

updateBoard : Cell -> (Cell -> Cell) -> Board -> Board
updateBoard cell cellUpdate board =
    case cell.id of
        A1 ->
            { board | a1 = cellUpdate board.a1 }

        A2 ->
            { board | a2 = cellUpdate board.a2 }

        A3 ->
            { board | a3 = cellUpdate board.a3 }

        B1 ->
            { board | b1 = cellUpdate board.b1 }

        B2 ->
            { board | b2 = cellUpdate board.b2 }

        B3 ->
            { board | b3 = cellUpdate board.b3 }

        C1 ->
            { board | c1 = cellUpdate board.c1 }

        C2 ->
            { board | c2 = cellUpdate board.c2 }

        C3 ->
            { board | c3 = cellUpdate board.c3 }

setCell : Model -> Cell -> Cell
setCell game cell =
    case game.playerTurn of
        Player1 ->
            { cell | content = X, state = Inactive }

        Player2 ->
            { cell | content = O, state = Inactive }
