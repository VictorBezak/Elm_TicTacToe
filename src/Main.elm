module Main exposing (main)

import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import PlaySpace


-- MODEL

type alias Player =
    { username : String
    , winLossRecord : Array Int --(Win, Loss, Draw)
    , level : Int
    }

type alias Model =
    { cells : Array String
    , players : (Player, Player)
    , activePlayerId : Int
    , winnerId : Int
    , draw : Bool
    , description : String
    }

testPlayer1 = Player "DevDood" (Array.fromList [0, 0, 0]) 12
testPlayer2 = Player "DevDino" (Array.fromList [0, 0, 0]) 8

model : Model
model =
    { cells = PlaySpace.cells
    , players = (testPlayer1, testPlayer2)
    , activePlayerId = 1
    , winnerId = 0
    , draw = False
    , description = ""
    }


-- VIEW

{-
    OnClick
-}

view : Model -> Html Msg
view game =
    let
        cell_A1 =
            case (get 0 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_A2 =
            case (get 1 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_A3 =
            case (get 2 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_B1 =
            case (get 3 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_B2 =
            case (get 4 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_B3 =
            case (get 5 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_C1 =
            case (get 6 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_C2 =
            case (get 7 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""
        cell_C3 =
            case (get 8 game.cells) of
                Just content ->
                    content
                Nothing ->
                    ""

        player1 = Tuple.first game.players
        player2 = Tuple.second game.players

        p1_wins =
            case (get 0 player1.winLossRecord) of
                Just wins ->
                    String.fromInt( wins )
                Nothing ->
                    "NA"

        p1_losses =
            case (get 1 player1.winLossRecord) of
                Just losses ->
                    String.fromInt( losses )
                Nothing ->
                    "NA"
        p1_draws =
            case (get 2 player1.winLossRecord) of
                Just draws ->
                    String.fromInt( draws )
                Nothing ->
                    "NA"

        p2_wins =
            case (get 0 player2.winLossRecord) of
                Just wins ->
                    String.fromInt( wins )
                Nothing ->
                    "NA"
        p2_losses =
            case (get 1 player2.winLossRecord) of
                Just losses ->
                    String.fromInt( losses )
                Nothing ->
                    "NA"
        p2_draws =
            case (get 2 player2.winLossRecord) of
                Just draws ->
                    String.fromInt( draws )
                Nothing ->
                    "NA"
    in
    
    div [ id "container" ]
        [ header [ id "title" ] [ text "Tic-Tac-Toe" ]
        , main_ [ id "playspace" ]
            [ button [ onClick (CellClicked 0) ] [ text cell_A1 ]
            , button [ onClick (CellClicked 1) ] [ text cell_A2 ]
            , button [ onClick (CellClicked 2) ] [ text cell_A3 ]
            , button [ onClick (CellClicked 3) ] [ text cell_B1 ]
            , button [ onClick (CellClicked 4) ] [ text cell_B2 ]
            , button [ onClick (CellClicked 5) ] [ text cell_B3 ]
            , button [ onClick (CellClicked 6) ] [ text cell_C1 ]
            , button [ onClick (CellClicked 7) ] [ text cell_C2 ]
            , button [ onClick (CellClicked 8) ] [ text cell_C3 ]
            ]
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
    = Won Player
    | Lost Player
    | Draw

type Msg
    = CellClicked Int
    | GameOver Conclusion
    -- | ResetGame

update : Msg -> Model -> Model
update msg game =
    -- HOW DO WE PROPERLY UPDATE THE CELL CONTENTS VALUE?
    case msg of
        CellClicked cell ->
            if game.activePlayerId == 1 then
                { game | cells = set cell "X" game.cells
                , activePlayerId = ( modBy 2 game.activePlayerId ) + 1
                }
            else
                { game | cells = set cell "O" game.cells
                , activePlayerId = ( modBy 2 game.activePlayerId ) + 1
                }

        GameOver conclusion ->
            case conclusion of
                Won player ->
                    let
                        record = player.winLossRecord
                        wins = get 0 record

                    in
                        case wins of
                            Just val ->
                                player val
                                    |> setWins
                                    -- |> setWinnerId

                        
                            Nothing ->
                                game
                        
                Lost player ->
                    let
                        record = player.winLossRecord
                        losses = get 1 record

                    in
                        case losses of
                            Just val ->
                                { player | winLossRecord = set 1 (val  + 1) record }
                
                            Nothing ->
                                game

                Draw ->
                    let
                        player1 = Tuple.first game.players
                        player2 = Tuple.second game.players

                        record1 = player1.winLossRecord
                        record2 = player2.winLossRecord

                        draws1 = get 2 record1
                        draws2 = get 2 record2


                    in
                        case draws1 of
                            Just val ->
                                { player1 | winLossRecord = set 2 (val  + 1) record1 }
                
                            Nothing ->
                                game

                        -- case draws2 of
                        --     Just val ->
                        --         { player2 | winLossRecord = set 2 (val  + 1) record2 }
                
                        --     Nothing ->
                        --         game

setWins : Player -> Int -> Array Int -> Player
setWins player oldVal record =
    { player | winLossRecord = set 0 (oldVal  + 1) record }

setLosses : Player -> Int -> Array Int -> Player
setLosses player oldVal record =
    { player | winLossRecord = set 1 (oldVal  + 1) record }

setDraws : Player -> Int -> Array Int -> Player
setDraws player oldVal record =
    { player | winLossRecord = set 2 (oldVal  + 1) record }

setWinnerId : Model -> Player -> Model
setWinnerId game player =
    { game | winnerId = game.activePlayerId
    , description = player.username ++ " Won the Game!"
    }


-- INITIALIZE

main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
