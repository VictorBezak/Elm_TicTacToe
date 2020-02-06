module Main exposing (main, Model)

import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import PlaySpace exposing (..)


-- MODEL

type alias Player =
    { username : String
    , level : Int
    , wins : Int
    , losses : Int
    , draws : Int
    }

type alias Model =
    { cells : Array String
    , player1 : Player
    , player2 : Player
    , activePlayer : Player
    , status : String
    }

-- temporarily hardcoded
-- will remove if account creating is enabled
testPlayer1 : Player
testPlayer1 = Player "DevDood" 12 0 0 0
testPlayer2 : Player
testPlayer2 = Player "DevDino" 8 0 0 0

model : Model
model =
    { cells = PlaySpace.cells
    , player1 = testPlayer1
    , player2 = testPlayer2
    , activePlayer = testPlayer1
    , status = "game in progress"
    }


-- VIEW

view : Model -> Html Msg
view game =
    let
        player1 = game.player1
        p1_wins = "Wins:   " ++ String.fromInt game.player1.wins
        p1_losses = "Losses: " ++ String.fromInt game.player1.losses
        p1_draws = "Draws:  " ++ String.fromInt game.player1.draws

        player2 = game.player2
        p2_wins = "Wins:   " ++ String.fromInt game.player2.wins
        p2_losses = "Losses: " ++ String.fromInt game.player2.losses
        p2_draws = "Draws:  " ++ String.fromInt game.player2.draws
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
            [ button [ onClick (CellClicked 0) ] [ text (cell_A1 game) ]
            , button [ onClick (CellClicked 1) ] [ text (cell_A2 game) ]
            , button [ onClick (CellClicked 2) ] [ text (cell_A3 game) ]
            , button [ onClick (CellClicked 3) ] [ text (cell_B1 game) ]
            , button [ onClick (CellClicked 4) ] [ text (cell_B2 game) ]
            , button [ onClick (CellClicked 5) ] [ text (cell_B3 game) ]
            , button [ onClick (CellClicked 6) ] [ text (cell_C1 game) ]
            , button [ onClick (CellClicked 7) ] [ text (cell_C2 game) ]
            , button [ onClick (CellClicked 8) ] [ text (cell_C3 game) ]
            ]
        , viewGameOverMessage game
        ]


-- UPDATE

type Msg
    = CellClicked Int
    | ResetGame

update : Msg -> Model -> Model
update msg game =
    case msg of
        CellClicked cell ->
            game
                |> setCell cell
                |> updateGameStatus

        ResetGame ->
            game
                |> resetGameStatus
                |> resetBoard

-- The remaining functions are all helper functions
setCell :  Int -> Model -> Model
setCell cell game =
    if game.activePlayer == game.player1 then
        { game | cells = set cell "X" game.cells }
    else
        { game | cells = set cell "O" game.cells }

updateGameStatus : Model -> Model
updateGameStatus game =
    let
        -- variables in this 'cell' block == cell contents : String
        a1 = cell_A1 game
        a2 = cell_A2 game
        a3 = cell_A3 game
        b1 = cell_B1 game
        b2 = cell_B2 game
        b3 = cell_B3 game
        c1 = cell_C1 game
        c2 = cell_C2 game
        c3 = cell_C3 game

        victory : Bool
        victory =
            -- Horizontal Win Conditions
            if (a1 /= "") && (a1 == a2) && (a2 == a3) then True
            else if (b1 /= "") && (b1 == b2) && (b2 == b3) then True
            else if (c1 /= "") && (c1 == c2) && (c2 == c3) then True
            -- Vertical Win Conditions
            else if (a1 /= "") && (a1 == b1) && (b1 == c1) then True
            else if (a2 /= "") && (a2 == b2) && (b2 == c2) then True
            else if (a3 /= "") && (a3 == b3) && (b3 == c3) then True
            -- Diagonal Win Conditions
            else if (a1 /= "") && (a1 == b2) && (b2 == c3) then True
            else if (a3 /= "") && (a3 == b2) && (b2 == c1) then True
            -- No Victory
            else False
        
        emptyCellList : List String
        emptyCellList =
            List.filter String.isEmpty (Array.toList game.cells)

        draw : Bool
        draw = List.length emptyCellList == 0
        
    in
        if victory then
            if game.activePlayer == game.player1 then        
                game
                    |> updateWins game.player1
                    |> updateLosses game.player2
                    |> gameOverMessage "victory"
            else
                game
                    |> updateWins game.player2
                    |> updateLosses game.player1
                    |> gameOverMessage "victory"
        
        else if draw then
            game
                |> updateDraws game.player1
                |> updateDraws game.player2
                |> gameOverMessage "draw"

        else
            if game.player1 == game.activePlayer then
                { game | activePlayer = game.player2 }
            else
                { game | activePlayer = game.player1 }

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

viewGameOverMessage : Model -> Html Msg
viewGameOverMessage game =
    if game.status == "game in progress" then
        section [] []
    
    else if game.status == "draw" then
        div []
            [ section [ id "drawMsg" ]
                [ p [ class "gameOverText" ] [ text "It's a draw!" ]
                , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                ]
            , div [ id "overlay" ] []
            ]
        
    
    else
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
    { game | cells = Array.repeat 9 "" }

-- INITIALIZE

main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
