module Player exposing (viewStat, getStat, updateWins, updateLosses, updateDraws)

import Model exposing (Model, PlayerTurn(..), Player, Stats(..))
-- import Board exposing (Id, Content, State)
-- port module Player exposing (..)
-- import Json.Encode as Encode
-- port cache : Encode.Value -> Cmd msg

---------------------------------------------------------------------

-- FROM Main.elm
-- type PlayerTurn
--     = Player1
--     | Player2

-- type Status
--     = InProgress
--     | Victory
--     | Draw

-- type alias Model =
--     { board : Board
--     , player1 : Player
--     , player2 : Player
--     , playerTurn : PlayerTurn
--     , status : Status
--     }

---------------------------------------------------------------------

-- FROM Board.elm
-- type Id
--     = A1
--     | A2
--     | A3
--     | B1
--     | B2
--     | B3
--     | C1
--     | C2
--     | C3

-- type Content
--     = Empty
--     | X
--     | O

-- type State
--     = Active
--     | Inactive

-- type alias Cell =
--     { id : Id
--     , content : Content
--     , state : State
--     }

-- type alias Board =
--     { a1 : Cell
--     , a2 : Cell
--     , a3 : Cell
--     , b1 : Cell
--     , b2 : Cell
--     , b3 : Cell
--     , c1 : Cell
--     , c2 : Cell
--     , c3 : Cell
--     }

---------------------------------------------------------------------

-- NATIVE
-- type Stats
--     = Level Int
--     | Wins Int
--     | Draws Int
--     | Losses Int

-- type alias Player =
--     { username : String
--     , level : Stats 
--     , wins : Stats
--     , losses : Stats
--     , draws : Stats
--     }


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
