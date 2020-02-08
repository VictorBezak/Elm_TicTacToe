module Player exposing (..)
-- port module Player exposing (..)

-- import Json.Encode as Encode

-- port cache : Encode.Value -> Cmd msg


type alias TotalExperience = Int

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


viewStat : Stats -> String
viewStat stat =
    case stat of
        Level level ->
            String.fromInt level

        Wins wins ->
            String.fromInt wins

        Losses losses ->
            String.fromInt losses

        Draws draws ->
            String.fromInt draws


getStat : Stats -> Int
getStat stat =
    case stat of
        Level level ->
            level

        Wins wins ->
            wins

        Losses losses ->
            losses

        Draws draws ->
            draws


updateWins : Player -> Player
updateWins player =
    { player | wins = Wins (getStat player.wins + 1)}


updateLosses : Player -> Player
updateLosses player =
    let
        newValue = getStat player.losses + 1
    in
        { player | losses = Losses newValue}


updateDraws : Player -> Player
updateDraws player =
    { player | draws = Draws (getStat player.draws + 1)}
    

updateLevel : Player -> Player
updateLevel player =
    let
        winExp =
            getStat player.wins * 25

        drawExp =
            getStat player.draws * 5
        
        lossExp =
            getStat player.losses

        totalExp =
            winExp + drawExp + lossExp
    
        playerLevel =
            (totalExp // 100) + 1  
    in
        { player | level = Level playerLevel }
