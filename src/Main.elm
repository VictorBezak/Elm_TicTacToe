module Main exposing (main)

import Browser
import Html exposing (Html, div, section, header, h1, h2, p, text, button)
import Html.Attributes exposing (id, class)
import Html.Events exposing (onClick)
import Board exposing (..)
import Player exposing (..)

import Model exposing (Model, PlayerTurn(..), Status(..), Player, Stats(..), Cell, Id(..), Content(..), State(..))

---------------------------------------------------------------------

-- FROM Player.elm
-- type alias Player =
--     { username : String
--     , level : Stats 
--     , wins : Stats
--     , losses : Stats
--     , draws : Stats
--     }

---------------------------------------------------------------------

-- FROM Board.elm
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

-- MODEL
-- type Status
--     = InProgress
--     | Victory
--     | Draw

-- type PlayerTurn
--     = Player1
--     | Player2

-- type alias Model =
--     { board : Board
--     , player1 : Player
--     , player2 : Player
--     , playerTurn : PlayerTurn
--     , status : Status
--     }

-- temporarily hardcoded
-- will remove if account creating is enabled
testPlayer1 : Player
testPlayer1 = Player "DevDood" (Level 1) (Wins 0) (Losses 0) (Draws 0)
testPlayer2 : Player
testPlayer2 = Player "DevDino" (Level 1) (Wins 0) (Losses 0) (Draws 0)

init : Model
init =
    { board = Board.emptyBoard
    , player1 = testPlayer1
    , player2 = testPlayer2
    , playerTurn = Player1
    , status = InProgress
    }


-- VIEW
view : Model -> Html Msg
view game =
    let
        player1 = game.player1
        p1_wins = "Wins:   " ++ viewStat player1.wins
        p1_losses = "Losses: " ++ viewStat player1.losses
        p1_draws = "Draws:  " ++ viewStat player1.draws

        player2 = game.player2
        p2_wins = "Wins:   " ++ viewStat player2.wins
        p2_losses = "Losses: " ++ viewStat player2.losses
        p2_draws = "Draws:  " ++ viewStat player2.draws

        a1 = game.board.a1
        a2 = game.board.a2
        a3 = game.board.a3
        b1 = game.board.b1
        b2 = game.board.b2
        b3 = game.board.b3
        c1 = game.board.c1
        c2 = game.board.c2
        c3 = game.board.c3
    
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
                [ button [ onClick (CellClicked a1), class (viewState a1.state) ] [ text (viewContent a1.content) ]
                , button [ onClick (CellClicked a2), class (viewState a2.state) ] [ text (viewContent a2.content) ]
                , button [ onClick (CellClicked a3), class (viewState a3.state) ] [ text (viewContent a3.content) ]
                , button [ onClick (CellClicked b1), class (viewState a1.state) ] [ text (viewContent b1.content) ]
                , button [ onClick (CellClicked b2), class (viewState a2.state) ] [ text (viewContent b2.content) ]
                , button [ onClick (CellClicked b3), class (viewState a3.state) ] [ text (viewContent b3.content) ]
                , button [ onClick (CellClicked c1), class (viewState a1.state) ] [ text (viewContent c1.content) ]
                , button [ onClick (CellClicked c2), class (viewState a2.state) ] [ text (viewContent c2.content) ]
                , button [ onClick (CellClicked c3), class (viewState a3.state) ] [ text (viewContent c3.content) ]
                ]
            , viewGameOverMessage game
            ]


viewState : State -> String
viewState state =
    case state of
        Active ->
            "active"

        Inactive ->
            "inactive"

viewActivePlayer : Model -> String
viewActivePlayer game =
    case game.playerTurn of
        Player1 ->
            game.player1.username

        Player2 ->
            game.player2.username

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
                    [ p [ class "gameOverText" ] [ text (viewActivePlayer game ++ " won the game!") ]
                    , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                    ]
                , div [ id "overlay" ] []
                ]


-- UPDATE
type Msg
    = CellClicked Cell
    | ResetGame

update : Msg -> Model -> Model
update msg game =
    case msg of
        CellClicked cell ->
            case cell.state of
                Active ->
                    game
                        |> updateCell game cell
                        |> updateGameStatus

                Inactive ->
                    game

        ResetGame ->
            game
                |> resetBoard emptyBoard


updateGameStatus : Model -> Model
updateGameStatus game =
    case checkEndgameConditions game of
        Victory ->
            case game.playerTurn of      
                Player1 ->
                    game
                        |> updateWins game.player1
                        |> updateLosses game.player2
                        |> setGameStatus Victory

                Player2 ->
                    game
                        |> updateWins game.player2
                        |> updateLosses game.player1
                        |> setGameStatus Victory
        
        Draw ->
            game
                |> updateDraws game.player1
                |> updateDraws game.player2
                |> setGameStatus Draw

        InProgress ->
            case game.playerTurn of
                Player1 ->
                    { game | playerTurn = Player2 }
                
                Player2 ->
                    { game | playerTurn = Player1 }

checkEndgameConditions : Model -> Status
checkEndgameConditions game =
    let
        board = game.board

        a1 = board.a1.content
        a2 = board.a2.content
        a3 = board.a3.content
        b1 = board.b1.content
        b2 = board.b2.content
        b3 = board.b3.content
        c1 = board.c1.content
        c2 = board.c2.content
        c3 = board.c3.content

        emptyCellList : List Content
        emptyCellList =
            List.filter (\cell -> cell == Empty) [a1, a2, a3, b1, b2, b3, c1, c2, c3]
    
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

setGameStatus : Status -> Model -> Model
setGameStatus conclusion game =
    { game | status = conclusion }

-- resetGame : Board -> Model -> Model
-- resetGame reset game =
--     { game | board = reset, status = InProgress }

-- updateWins : Player -> Model -> Model
-- updateWins player =
--     updateModel <| setLevel <| setWins player

-- updateLosses : Player -> Model -> Model
-- updateLosses player =
--     updateModel <| setLevel <| setLosses player

-- updateDraws : Player -> Model -> Model
-- updateDraws player =
--     updateModel <| setLevel <| setDraws player

-- updateModel : Player -> Model -> Model
-- updateModel player model =
--     case model.playerTurn of
--         Player1 ->
--             { model | player1 = player }

--         Player2 ->
--             { model | player2 = player }

-- setWins : Player -> Player
-- setWins player =
--     { player | wins = Wins (getStat player.wins + 1) }

-- setLosses : Player -> Player
-- setLosses player =
--     { player | losses = Losses (getStat player.losses + 1) }

-- setDraws : Player -> Player
-- setDraws player =
--     { player | draws = Draws (getStat player.draws + 1) }
    
-- setLevel : Player -> Player
-- setLevel player =
--     let
--         winExp =
--             getStat player.wins * 25

--         drawExp =
--             getStat player.draws * 5
        
--         lossExp =
--             getStat player.losses

--         totalExp =
--             winExp + drawExp + lossExp
    
--         playerLevel =
--             (totalExp // 100) + 1  
--     in
--         { player | level = Level playerLevel }


-- INITIALIZE
main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
