module Main exposing (main)

import Array exposing (..)
-- import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
-- import PlaySpace


-- MODEL

{--
type alias Model =
    { cells : Array Int
    , activePlayer : Int
    , winner : Int
    , draw : Bool
    , description : String
    }

model : Model
model =
    { cells = PlaySpace.cells
    , activePlayer = 1
    , winner = 0
    , draw = False
    , description = ""
    }
--}

-- VIEW

{--
view : Model -> Html msg
view game = 
--}
    {--
    div [ class "playspace" ]
        ( Array.map renderCell game.cells )

    renderCell : Int -> Html Msg
    renderCell content =
        if content == 1 then
            div [ class "O-cell" ] [ text "O" ]

        else if content == 2 then
            div [ class "X-cell" ] [ text "X" ]

        else
            div [ class "empty-cell"
                , onClick CellClicked
                ] []
    --}

    {--
    div [ class "playspace" ]
        [ div [ class "cell", id "A1", onClick CellClicked ] []
        , div [ class "cell", id "A2", onClick CellClicked ] []
        , div [ class "cell", id "A3", onClick CellClicked ] []
        , div [ class "cell", id "B1", onClick CellClicked ] []
        , div [ class "cell", id "B2", onClick CellClicked ] []
        , div [ class "cell", id "B3", onClick CellClicked ] []
        , div [ class "cell", id "C1", onClick CellClicked ] []
        , div [ class "cell", id "C2", onClick CellClicked ] []
        , div [ class "cell", id "C3", onClick CellClicked ] []
        ]
    --}

layout : Html msg
layout =
    div [ id "container" ]
        [ header [ id "title" ] [ text "Tic-Tac-Toe" ]
        , main_ [ id "playspace" ]
            [ button [ id "A1" ] []
            , button [ id "A2" ] []
            , button [ id "A3" ] []
            , button [ id "B1" ] []
            , button [ id "B2" ] []
            , button [ id "B3" ] []
            , button [ id "C1" ] []
            , button [ id "C2" ] []
            , button [ id "C3" ] []
            ]
        , footer [ id "footer" ]
            [ div [ id "player1" ]
                [ p [ class "playerName" ] [ text "Player 1"]
                , p [ class "playerWinCount" ] [ text "Win Count: "]
                ]
            , div [ id "player2" ]
                [ p [ class "playerName" ] [ text "Player 2"]
                , p [ class "playerWinCount" ] [ text "Win Count: "]
                ]
            ]
        ]
        
    

-- UPDATE

{--
type Msg
    = CellClicked String
    | GameOver String

update : Msg -> Model -> Model
update msg game =
    -- HOW DO WE PROPERLY UPDATE THE CELL CONTENTS VALUE?
    case msg of
        CellClicked desc ->
            { game | description = desc
            , activePlayer = ( modBy 2 game.activePlayer ) + 1
            }

        GameOver conclusion ->
            if conclusion == "draw" then
                { game | draw = True }
            
            else
                { game | winner = game.activePlayer }
--}
            


{--}
main : Html msg
main = layout
--}

{--
main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
--}
