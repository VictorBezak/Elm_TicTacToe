module Board exposing (viewContent, emptyBoard, resetBoard, updateCell)

import Types exposing (Model, PlayerTurn(..), Status(..), Board, Cell, Id(..), Content(..), State(..))

---------------------------------------------------------------------

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
