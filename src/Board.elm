module Board exposing (viewContent, emptyBoard, resetBoard, updateCell, freezeCells)

import Types.Main exposing (Model, PlayerTurn(..), Status(..))
import Types.Board exposing (Board, Cell, Id(..), Content(..), State(..))


---------------------------------------------------------------------
-- Public Functions

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

resetBoard : Board -> Model -> (Model, Cmd a)
resetBoard reset game =
    ( { game | board = reset, status = InProgress }
    , Cmd.none
    )

updateCell : Model -> Cell -> Model -> Model
updateCell model cell =
    updateModel <| updateBoard cell <| setCell model

freezeCells : Model -> Model
freezeCells =
    freezeGame <| freezeBoard <| freezeCell


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

freezeGame : (Board -> Board) -> Model -> Model
freezeGame freeze game =
    { game | board = freeze game.board }

freezeBoard : (Cell -> Cell) -> Board -> Board
freezeBoard freeze board =
    { board
    | a1 = freeze board.a1
    , a2 = freeze board.a2
    , a3 = freeze board.a3
    , b1 = freeze board.b1
    , b2 = freeze board.b2
    , b3 = freeze board.b3
    , c1 = freeze board.c1
    , c2 = freeze board.c2
    , c3 = freeze board.c3
    }

freezeCell : Cell -> Cell
freezeCell cell =
    { cell | state = Inactive }
