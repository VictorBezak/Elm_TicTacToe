module Model exposing (Model, PlayerTurn(..), Status(..), Player, Stats(..), Cell, Board, Id(..), Content(..), State(..))

-- module Model exposing
--     ( Model, Status(..), PlayerTurn(..)
--     , Player, Stats(..)
--     , Cell, Board, Id(..), Content(..), State(..)
--     )

---------------------------------------------------------------------

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

---------------------------------------------------------------------

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

---------------------------------------------------------------------

type Id
    = A1
    | A2
    | A3
    | B1
    | B2
    | B3
    | C1
    | C2
    | C3

type Content
    = Empty
    | X
    | O

type State
    = Active
    | Inactive

type alias Cell =
    { id : Id
    , content : Content
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
