# TicTacToe Project Notes

## Board.elm

NEEDS:

- view content
- check/update cell values

Notes:

- The only thing that will never change about a cell is its ID
- But we don't want it to be lowest level because then we'd have to destructure it to check what's inside it

***

Board as a collection of records

```elm
type Cell
    = A1
    | A2
    | A3
    | B1
    | B2
    | B3
    | C1
    | C2
    | C3

type alias Board =
    { a1 : Cell { content : Content, clickable : Clickable }
    , a2 : Cell { content : Content, clickable : Clickable }
    , a3 : Cell { content : Content, clickable : Clickable }
    , b1 : Cell { content : Content, clickable : Clickable }
    , b2 : Cell { content : Content, clickable : Clickable }
    , b3 : Cell { content : Content, clickable : Clickable }
    , c1 : Cell { content : Content, clickable : Clickable }
    , c2 : Cell { content : Content, clickable : Clickable }
    , c3 : Cell { content : Content, clickable : Clickable }
    }
```

- 

***

Board as a collection of containers

```elm
type Cell
    = A1 Content Clickable
    | A2 Content Clickable
    | A3 Content Clickable
    | B1 Content Clickable
    | B2 Content Clickable
    | B3 Content Clickable
    | C1 Content Clickable
    | C2 Content Clickable
    | C3 Content Clickable

type alias Board =
    { a1 : Cell
    , a2 : Cell
    , a3 : Cell
    , b1 : Cell
    , b2 : Cell
    , b3 : Cell
    , c1 : Cell
    , c2 : Cell
    , c3 : Cell
    }
```

- We'd have to destructure the Cell type with a case-statement everytime we want to access ANY data
