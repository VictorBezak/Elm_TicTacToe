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

testPlayer1 = Player "DevDood" 12 0 0 0
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
        p1_wins = "Wins:   " ++ String.fromInt( game.player1.wins )
        p1_losses = "Losses: " ++ String.fromInt( game.player1.losses )
        p1_draws = "Draws:  " ++ String.fromInt( game.player1.draws )

        player2 = game.player2
        p2_wins = "Wins:   " ++ String.fromInt( game.player2.wins )
        p2_losses = "Losses: " ++ String.fromInt( game.player2.losses )
        p2_draws = "Draws:  " ++ String.fromInt( game.player2.draws )
    in
    
    div [ id "container" ]
        [ header [ id "title" ] [ text "Tic-Tac-Toe" ]
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
        , footer [ id "footer" ]
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


-- UPDATE

type Conclusion
    = Victory
    | Draw

type Msg
    = CellClicked Int
    | GameOver Conclusion
    -- | ResetGame

update : Msg -> Model -> Model
update msg game =
    case msg of
        CellClicked cell ->
            game
                |> setCell cell
                |> updateGameStatus


setCell :  Int -> Model -> Model
setCell cell game =
    if game.activePlayer == game.player1 then
        { game | cells = set cell "X" game.cells }
    else
        { game | cells = set cell "O" game.cells }


updateGameStatus : Model -> Model
updateGameStatus game =
    let
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
            if      (a1 /= "") && (a1 == a2) && (a2 == a3) then True
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
        draw =
            if List.length emptyCellList == 0 then True else False
    
    in
        if draw then
            game
                |> updateDraws game.player1
                |> updateDraws game.player2
                |> gameOverMessage "draw"

        else if victory then
            if game.activePlayer == game.player1 then
                winner = game.player1
                loser = game.player2
            else
                winner = game.player2
                loser = game.player1
            
            game
                |> updateWins winner
                |> updateLosses loser
                |> gameOverMessage "victory"

        else
            if game.player1 == game.activePlayer then
                { game | activePlayer = game.player2 }
            else
                { game | activePlayer = game.player1 }


-- updatePlayerDraws : Model -> Model
-- updatePlayerDraws game =
--     game
--         |> sdPlayerIn
--             ( game.player1
--         |> incrementDraws game.player2

-- asPlayerIn : Player -> Model -> Player
-- asPlayerIn player game =
--     { game | player1 = }

-- incrementDraws : Player -> Model -> Model
-- incrementDraws player game =
--     case player.draws of
--         Just val ->
--             { player | draws = player.draws + 1 }
--         Nothing ->
--             player


updatePlayerWinsLosses : Model -> Model
updatePlayerWinsLosses game =
    let
        player1 = game.player1
        player2 = game.player2
        winner = game.activePlayer

    in
        if player1 == winner then
            incrementWins player1
            incrementLosses player2
        
        else
            incrementWins player2
            incrementLosses player1


incrementWins : Player -> Player
incrementWins player =
    case player.wins of
        Just val ->
            { player | wins = player.wins + 1 }
        Nothing ->
            player


incrementLosses : Player -> Player
incrementLosses player =
    case player.losses of
        Just val ->
            { player | losses = player.losses + 1 }
        Nothing ->
            player

gameOverMessage : String -> Model -> Model
gameOverMessage conclusion game =
    { game | status = conclusion }

viewGameOverMessage : Model -> Html Msg
viewGameOverMessage game =
    if game.status == "game in progress" then
        section [] []
    
    else if game.status == "draw" then
        section [ id "DrawMessage" ]
            [ p [] [ text "It's a draw!" ]
            , button [ class "playAgainBtn" ] [ text "Play Again?" ]
            ]
    
    else
        section [ id "VictoryMessage" ]
            [ p [] [ text game.activePlayer ++ " Won the Game!" ]
            , button [ class "playAgainBtn" ] [ text "Play Again?" ]
            ]


-- INITIALIZE

main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
