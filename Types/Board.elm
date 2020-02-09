type Id
    = A1
    | A2
    | A3
    | B1
    | B2
    | B3
    | C1
    | C2
    | C3

type Content
    = Empty
    | X
    | O

type State
    = Active
    | Inactive

type alias Cell =
    { id : Id
    , content : Content
    , state : State
    }

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