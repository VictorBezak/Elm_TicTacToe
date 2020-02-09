type PlayerTurn
    = Player1
    | Player2

type Status
    = InProgress
    | Victory
    | Draw

type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : PlayerTurn
    , status : Status
    }