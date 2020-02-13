module Player exposing (viewStat, getStat, updateWinLoss, updateDraws)

import Types.Main exposing (Model, PlayerTurn(..))
import Types.Player exposing (Player, Stats(..))


---------------------------------------------------------------------
-- Public Functions

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

updateWinLoss : Model -> Model
updateWinLoss =
    updateModelVictory winLevelUpdate lossLevelUpdate

updateDraws : Model -> Model
updateDraws =
    updateModelDraw drawLevelUpdate


---------------------------------------------------------------------
-- Private functions

updateModelVictory : (Player -> Player) -> (Player -> Player) -> Model -> Model
updateModelVictory winUpdate lossUpdate game =
    case game.playerTurn of
        Player1 ->
            { game
            | player1 = winUpdate game.player1
            , player2 = lossUpdate game.player2
            }

        Player2 ->
            { game
            | player1 = lossUpdate game.player1
            , player2 = winUpdate game.player2
            }

updateModelDraw : (Player -> Player) -> Model -> Model
updateModelDraw drawUpdate game =
    { game
    | player1 = drawUpdate game.player1
    , player2 = drawUpdate game.player2
    }

winLevelUpdate : Player -> Player
winLevelUpdate player =
    player
        |> setWins
        |> setLevel

lossLevelUpdate : Player -> Player
lossLevelUpdate player =
    player
        |> setLosses
        |> setLevel

drawLevelUpdate : Player -> Player
drawLevelUpdate player =
    player
        |> setDraws
        |> setLevel

setWins : Player -> Player
setWins player =
    { player | wins = Wins (getStat player.wins + 1) }

setLosses : Player -> Player
setLosses player =
    { player | losses = Losses (getStat player.losses + 1) }

setDraws : Player -> Player
setDraws player =
    { player | draws = Draws (getStat player.draws + 1) }
    
setLevel : Player -> Player
setLevel player =
    let
        winExp =
            getStat player.wins * 25

        drawExp =
            getStat player.draws * 10
        
        lossExp =
            getStat player.losses * 5

        totalExp =
            winExp + drawExp + lossExp
    
        playerLevel =
            (totalExp // 50) + 1  
    in
        { player | level = Level playerLevel }
