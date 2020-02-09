module Player exposing (viewStat, getStat, updateWins, updateLosses, updateDraws)

import Types exposing (Model, PlayerTurn(..), Player, Stats(..))

-- port module Player exposing (..)
-- import Json.Encode as Encode
-- port cache : Encode.Value -> Cmd msg

---------------------------------------------------------------------

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

updateWins : Player -> Model -> Model
updateWins player =
    updateModel <| setLevel <| setWins player

updateLosses : Player -> Model -> Model
updateLosses player =
    updateModel <| setLevel <| setLosses player

updateDraws : Player -> Model -> Model
updateDraws player =
    updateModel <| setLevel <| setDraws player

---------------------------------------------------------------------

-- Private functions
-- updateLevel : Player -> Model -> Model
-- updateLevel player =
--     updateModel <| setLevel player

updateModel : Player -> Model -> Model
updateModel player model =
    case model.playerTurn of
        Player1 ->
            { model | player1 = player }

        Player2 ->
            { model | player2 = player }

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
            getStat player.draws * 5
        
        lossExp =
            getStat player.losses

        totalExp =
            winExp + drawExp + lossExp
    
        playerLevel =
            (totalExp // 100) + 1  
    in
        { player | level = Level playerLevel }
