module Types.Player exposing (Player, Stats(..))


type alias Player =
    { username : String
    , level : Stats 
    , wins : Stats
    , losses : Stats
    , draws : Stats
    -- , encoded : Encode.Value
    }

type Stats
    = Level Int
    | Wins Int
    | Draws Int
    | Losses Int


{- Ideas:
    - We don't need to encode our entire model, because we
      only care to cache our player stats

    - We could add an "encoded" key to ourPlayer alias, or
      we could just create a function to build the encoded
      object when needed
-}