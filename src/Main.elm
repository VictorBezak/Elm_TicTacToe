module Main exposing (main)

import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import PlaySpace


-- MODEL

{-
    We could add a Tuple for type Player, where we hold both players.

    type alias Player =
        { username: String
        , winRecord: Tuple Int
        , level: Int
        }

    OR

    type PlayerAction
        = Won Player
        | Lost Player
        | Draw
-}
type alias Model =
    { cells : Array Int
    , activePlayerId : Int
    , winnerId : Int
    , draw : Bool
    , description : String
    }

model : Model
model =
    { cells = PlaySpace.cells
    , activePlayerId = 1
    , winnerId = 0
    , draw = False
    , description = ""
    }


-- VIEW

view : Model -> Html Msg
view game = 
    div [ class "playspace" ]
        (toList (Array.map renderCell game.cells))

renderCell : Int -> Html Msg
renderCell content =
    if content == 1 then
        div [ class "O-cell" ] [ text "O" ]

    else if content == 2 then
        div [ class "X-cell" ] [ text "X" ]

    else
        div [ class "empty-cell"
            , onClick (CellClicked "click") --WE NEED TO PASS THE ID INT OF THE CELL THAT WAS CLICKED
            ] []     
    

-- UPDATE

type Msg
    = CellClicked String
    | GameOver String

update : Msg -> Model -> Model
update msg game =
    -- HOW DO WE PROPERLY UPDATE THE CELL CONTENTS VALUE?
    case msg of
        CellClicked desc ->
            { game | description = desc
            , activePlayerId = ( modBy 2 game.activePlayerId ) + 1
            }

        GameOver conclusion ->
            if conclusion == "draw" then
                { game | draw = True
                , description = conclusion
                }
            
            else
                let
                    winner = game.activePlayerId
                
                in
                { game | winnerId = winner
                , description = "Player " ++ String.fromInt winnerId ++ " Won the Game!"
                }   


-- INITIALIZE

main : Program () Model Msg
main =
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }
