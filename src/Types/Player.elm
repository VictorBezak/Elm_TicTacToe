module Types.Player exposing (Player, Stats(..))


type alias Player =
    { username : String
    , level : Stats 
    , wins : Stats
    , losses : Stats
    , draws : Stats
    }

type Stats
    = Level Int
    | Wins Int
    | Draws Int
    | Losses Int
