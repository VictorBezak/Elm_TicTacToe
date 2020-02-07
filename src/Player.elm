module Player exposing (Stats, Player, showStat, getStat, updateStat, calculateLevel)


type Stats
    = Level Int (Maybe Player)
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


showStat : Stats -> String
showStat stat =
    case stat of
        Level level _ ->
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
        Level level _ ->
            level

        Wins wins ->
            wins

        Losses losses ->
            losses

        Draws draws ->
            draws

updateStat : Stats -> Int
updateStat stat =
    case stat of
        Level _ player ->
            case player of
                Just experience ->
                    calculateLevel experience
                Nothing ->
                    0
                
        Wins wins ->
            wins + 1

        Losses losses ->
            losses + 1

        Draws draws ->
            draws + 1

calculateLevel : Player -> Int
calculateLevel player =
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
            (totalExp // 100) + 1  -- Add 1 because players start at lvl 1
    in
        playerLevel
        