module Main exposing (main)

import Browser
import Html exposing (Html, div, section, header, h1, h2, p, text, button)
import Html.Attributes exposing (id, class)
import Html.Events exposing (onClick)
import Json.Encode as Encode

import Player exposing (..)
import Board exposing (..)
import Ports exposing (..)

import Types.Main exposing (Model, PlayerTurn(..), Status(..))
import Types.Player exposing (Player, Stats(..))
import Types.Board exposing (Cell, Id(..), Content(..), State(..))


---------------------------------------------------------------------
-- MODEL

init : Maybe Encode.Value -> (Model, Cmd msg)
init flag =
    let
        items : UncachedItems
        items =
            case flag of
                Just data ->
                    case decode data of
                        Ok obj ->
                            obj
                        
                        Err _ ->
                            defaultData
                
                Nothing ->
                    defaultData

        testPlayer1 : Player  -- temporarily hardcoded. will remove if account creating is enabled
        testPlayer1 = Player "DevDood" (Level items.p1_level) (Wins items.p1_win) (Losses items.p1_loss) (Draws items.p1_draw)

        testPlayer2 : Player
        testPlayer2 = Player "DevDino" (Level items.p2_level) (Wins items.p2_win) (Losses items.p2_loss) (Draws items.p2_draw)
        
    in
    
    ( { board = Board.emptyBoard
        , player1 = testPlayer1  -- Cached player1
        , player2 = testPlayer2  -- Cached player2
        , playerTurn = Player1
        , status = InProgress
        }
    , Cmd.none
    )


---------------------------------------------------------------------
-- VIEW

view : Model -> Html Msg
view game =
    let
        player1 = game.player1
        p1_level = "Level:   " ++ viewStat player1.level
        p1_wins = "Wins:   " ++ viewStat player1.wins
        p1_losses = "Losses: " ++ viewStat player1.losses
        p1_draws = "Draws:  " ++ viewStat player1.draws

        player2 = game.player2
        p2_level = "Level:   " ++ viewStat player2.level
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
                ]
            , section [ id "board" ]
                [ button [ onClick (CellClicked a1), class (viewState a1.state) ] [ text (viewContent a1.content) ]
                , button [ onClick (CellClicked a2), class (viewState a2.state) ] [ text (viewContent a2.content) ]
                , button [ onClick (CellClicked a3), class (viewState a3.state) ] [ text (viewContent a3.content) ]
                , button [ onClick (CellClicked b1), class (viewState b1.state) ] [ text (viewContent b1.content) ]
                , button [ onClick (CellClicked b2), class (viewState b2.state) ] [ text (viewContent b2.content) ]
                , button [ onClick (CellClicked b3), class (viewState b3.state) ] [ text (viewContent b3.content) ]
                , button [ onClick (CellClicked c1), class (viewState c1.state) ] [ text (viewContent c1.content) ]
                , button [ onClick (CellClicked c2), class (viewState c2.state) ] [ text (viewContent c2.content) ]
                , button [ onClick (CellClicked c3), class (viewState c3.state) ] [ text (viewContent c3.content) ]
                ]
            , div [ id "playersDiv" ]
                [ div [ id "player1", class "player" ]
                    [ h2 [ class "playerName" ] [ text game.player1.username ]
                    , p [ class "playerLevel" ] [ text p1_level ]
                    , p [ class "playerRecord" ] [ text p1_wins ]
                    , p [ class "playerRecord" ] [ text p1_losses ]
                    , p [ class "playerRecord" ] [ text p1_draws ]
                    ]
                , div [ id "player2", class "player" ]
                    [ h2 [ class "playerName" ] [ text game.player2.username ]
                    , p [ class "playerLevel" ] [ text p2_level ]
                    , p [ class "playerRecord" ] [ text p2_wins ]
                    , p [ class "playerRecord" ] [ text p2_losses ]
                    , p [ class "playerRecord" ] [ text p2_draws ]
                    ]
                ]
            , viewGameOverMessage game
            ]


-- View Helper Functions
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
            div [ class "gameOverDiv" ]
                [ section [ id "drawMsg" ]
                    [ p [ class "gameOverText" ] [ text "It's a draw!" ]
                    , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                    ]
                ]
        
        Victory ->
            div [ class "gameOverDiv" ]
                [ section [ id "victoryMsg" ]
                    [ p [ class "gameOverText" ] [ text (viewActivePlayer game ++ " won the game!") ]
                    , button [ onClick ResetGame, class "gameOverBtn" ] [ text "Play Again?" ]
                    ]
                ]


---------------------------------------------------------------------
-- UPDATE

type Msg
    = CellClicked Cell
    | ResetGame

update : Msg -> Model -> (Model, Cmd a)
update msg game =
    case msg of
        CellClicked cell ->
            case cell.state of
                Active ->
                    game
                        |> updateCell game cell
                        |> updateGameStatus

                Inactive ->
                    ( game, Cmd.none )

        ResetGame ->
            game
                |> resetBoard emptyBoard


-- Update Helper Functions
updateGameStatus : Model -> (Model, Cmd a)
updateGameStatus game =
    case checkEndgameConditions game of
        Victory ->
            game
                |> updateWinLoss
                |> freezeCells
                |> setGameStatus Victory
        
        Draw ->
            game
                |> updateDraws
                |> setGameStatus Draw

        InProgress ->
            game
                |> nextTurn

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

setGameStatus : Status -> Model -> (Model, Cmd a)
setGameStatus conclusion game =    
    ( { game | status = conclusion }
    , cache game
    )

nextTurn : Model -> (Model, Cmd a)
nextTurn game =
    case game.playerTurn of
        Player1 ->
            ( { game | playerTurn = Player2 }
            , Cmd.none
            )
        
        Player2 ->
            ( { game | playerTurn = Player1 }
            , Cmd.none
            )


---------------------------------------------------------------------
-- MAIN

main : Program (Maybe Encode.Value) Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
