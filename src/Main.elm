module Main exposing (main)

import Array exposing (Array, set)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Board exposing (..)
import Player exposing (..)


-- MODEL

type Status
    = InProgress
    | Victory
    | Draw

type Players
    = Player1
    | Player2

type alias Model =
    { board : Board
    , player1 : Player
    , player2 : Player
    , playerTurn : Players
    -- , status : Status
    }

-- temporarily hardcoded
-- will remove if account creating is enabled
testPlayer1 : Player
testPlayer1 = Player "DevDood" (Level 1) (Wins 0) (Losses 0) (Draws 0)
testPlayer2 : Player
testPlayer2 = Player "DevDino" (Level 1) (Wins 0) (Losses 0) (Draws 0)

model : Model
model =
    { board = Board.board
    , player1 = testPlayer1
    , player2 = testPlayer2
    , playerTurn = Player1
    -- , status = InProgress
    }


-- VIEW

view : Model -> Html Msg
view game =
    let
        player1 = game.player1
        p1_wins = "Wins:   " ++ showStat player1.wins
        p1_losses = "Losses: " ++ showStat player1.losses
        p1_draws = "Draws:  " ++ showStat player1.draws

        player2 = game.player2
        p2_wins = "Wins:   " ++ showStat player2.wins
        p2_losses = "Losses: " ++ showStat player2.losses
        p2_draws = "Draws:  " ++ showStat player2.draws

        board = game.board
    in
    
    div [ id "container" ]
        [ header [ id "header" ]
            [ h1 [ id "title" ] [ text "Tic-Tac-Toe" ]
            , div [ id "playerStats" ]
                [ div [ id "player1" ]
                    [ h2 [ class "playerName" ] [ text player1.username ]
                    , p [ class "playerRecord" ] [ text p1_wins ]
                    , p [ class "playerRecord" ] [ text p1_losses ]
                    , p [ class "playerRecord" ] [ text p1_draws ]
                    ]
                , div [ id "player2" ]
                    [ h2 [ class "playerName" ] [ text player2.username ]
                    , p [ class "playerRecord" ] [ text p2_wins ]
                    , p [ class "playerRecord" ] [ text p2_losses ]
                    , p [ class "playerRecord" ] [ text p2_draws ]
                    ]
                ]
            ]
        , section [ id "playspace" ]
            [ button [ onClick (CellClicked A1) ] [ text (showCell A1) ]
            , button [ onClick (CellClicked A2) ] [ text (showCell A2) ]
            , button [ onClick (CellClicked A3) ] [ text (showCell A3) ]
            , button [ onClick (CellClicked B1) ] [ text (showCell B1) ]
            , button [ onClick (CellClicked B2) ] [ text (showCell B2) ]
            , button [ onClick (CellClicked B3) ] [ text (showCell B3) ]
            , button [ onClick (CellClicked C1) ] [ text (showCell C1) ]
            , button [ onClick (CellClicked C2) ] [ text (showCell C2) ]
            , button [ onClick (CellClicked C3) ] [ text (showCell C3) ]
            ]
        , viewGameOverMessage game
        ]


-- UPDATE

type Msg
    = CellClicked Cell
    | ResetGame

update : Msg -> Model -> Model
update msg game =
    case msg of
        CellClicked cell ->
            game
                |> setCell cell
                |> checkGameStatus

        ResetGame ->
            game
                |> resetGameStatus
                |> resetBoard

-- The remaining functions are all helper functions
checkGameStatus : Model -> Model
checkGameStatus game =
    case (checkForWinDraw game) of
        Victory ->
            if game.playerTurn == Player1 then        
                game
                    |> updateWins game.player1
                    |> updateLosses game.player2
                    |> setGameStatus Victory
            else
                game
                    |> updateWins game.player2
                    |> updateLosses game.player1
                    |> setGameStatus Victory
        
        Draw ->
            game
                |> updateDraws game.player1
                |> updateDraws game.player2
                |> gameOverMessage "draw"
            

        InProgress ->
            game
        
        -- else if draw then
            -- game
            --     |> updateDraws game.player1
            --     |> updateDraws game.player2
            --     |> gameOverMessage "draw"

        -- else
        --     case game.playerTurn of
        --         Player1 ->
        --             { game | playerTurn = Player2 }
                
        --         Player2 ->
        --             { game | playerTurn = Player1 }

checkForWinDraw : Model -> Status
checkForWinDraw game =
    let
        board = game.board

        a1 = board.a1
        a2 = board.a2
        a3 = board.a3
        b1 = board.b1
        b2 = board.b2
        b3 = board.b3
        c1 = board.c1
        c2 = board.c2
        c3 = board.c3

        emptyCellList : List Cell
        emptyCellList =
            List.filter Empty [a1, a2, a3, b1, b2, b3, c1, c2, c3]
    
    in
        -- Horizontal Win Conditions
        if (a1 /= Empty) && (a1 == a2) && (a2 == a3) then Victory
        else if (b1 /= Empty) && (b1 == b2) && (b2 == b3) then Victory
        else if (c1 /= Empty) && (c1 == c2) && (c2 == c3) then Victory
        -- Vertical Win Conditions
        else if (a1 /= Empty) && (a1 == b1) && (b1 == c1) then Victory
        else if (a2 /= Empty) && (a2 == b2) && (b2 == c2) then Victory
        else if (a3 /= Empty) && (a3 == b3) && (b3 == c3) then Victory
        -- Diagonal Win Conditions
        else if (a1 /= Empty) && (a1 == b2) && (b2 == c3) then Victory
        else if (a3 /= Empty) && (a3 == b2) && (b2 == c1) then Victory
        -- No Victory, Check For Draw
        else if List.length emptyCellList == 0 then Draw
        else InProgress


updatePlayer : Player -> Model -> Model
updatePlayer updatedPlayer game =
    if updatedPlayer.username == game.player1.username then
        { game | player1 = updatedPlayer }
    else
        { game | player2 = updatedPlayer }

incrementDraws : Player -> Player
incrementDraws player =
    { player | draws = player.draws + 1 }

incrementWins : Player -> Player
incrementWins player =
    { player | wins = player.wins + 1 }

incrementLosses : Player -> Player
incrementLosses player =
    { player | losses = player.losses + 1 }

updateDraws : Player -> Model -> Model
updateDraws player =
    updatePlayer <| incrementDraws player

updateWins : Player -> Model -> Model
updateWins player =
    updatePlayer <| incrementWins player

updateLosses : Player -> Model -> Model
updateLosses player =
    updatePlayer <| incrementLosses player

gameOverMessage : String -> Model -> Model
gameOverMessage conclusion game =
    { game | status = conclusion }

setGameStatus : Status -> Model -> Model
setGameStatus conclusion game =
    { game | status = conclusion }

viewGameOverMessage : Model -> Html Msg
viewGameOverMessage game =
    case game.status of
        InProgress ->
            section [] []
    
        Draw ->
            div []
                [ section [ id "drawMsg" ]
                    [ p [ class "gameOverText" ] [ text "It's a draw!" ]
                    , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                    ]
                , div [ id "overlay" ] []
                ]
        
        Victory ->
            div []
                [ section [ id "victoryMsg" ]
                    [ p [ class "gameOverText" ] [ text (game.activePlayer.username ++ " won the game!") ]
                    , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                    ]
                , div [ id "overlay" ] []
                ]

resetGameStatus : Model -> Model
resetGameStatus game =
    { game | status = "game in progress" }

resetBoard : Model -> Model
resetBoard game =
    { game | board = Array.repeat 9 "" }

-- INITIALIZE

main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
