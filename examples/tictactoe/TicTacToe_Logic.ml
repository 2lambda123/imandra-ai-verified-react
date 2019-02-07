(* generated by imandra-extract from "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire" *)

open Imandra_prelude;;

(* start generated code here *)

#1 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type player =
  | X 
  | O 
#5 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type square_state = player option
#7 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type grid =
  {
  a: square_state ;
  b: square_state ;
  c: square_state ;
  d: square_state ;
  e: square_state ;
  f: square_state ;
  g: square_state ;
  h: square_state ;
  i: square_state }
#19 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let a_grid =
  {
    a = ((Some (O))[@explicit_arity ]);
    b = ((Some (X))[@explicit_arity ]);
    c = ((Some (O))[@explicit_arity ]);
    d = None;
    e = None;
    f = ((Some (X))[@explicit_arity ]);
    g = None;
    h = None;
    i = None
  }
#31 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type move =
  | A 
  | B 
  | C 
  | D 
  | E 
  | F 
  | G 
  | H 
  | I 
#42 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type game_state = {
  grid: grid ;
  last_player: player option }
#47 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

type game_status =
  | Won of player 
  | InProgress 
  | InvalidMove of move 
  | Tied 
#53 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let initial_game =
  {
    grid =
      {
        a = None;
        b = None;
        c = None;
        d = None;
        e = None;
        f = None;
        g = None;
        h = None;
        i = None
      };
    last_player = None
  }
#68 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let initial_player = X
#70 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let value { grid = { a; b; c; d; e; f; g; h; i };_} =
  function
  | A -> a
  | B -> b
  | C -> c
  | D -> d
  | E -> e
  | F -> f
  | G -> g
  | H -> h
  | I -> i
#82 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let is_winning { grid = { a; b; c; d; e; f; g; h; i };_} player =
  let winning_state =
    (((Some (player))[@explicit_arity ]), ((Some (player))
      [@explicit_arity ]), ((Some (player))[@explicit_arity ])) in
  ((a, b, c) = winning_state) ||
    (((d, e, f) = winning_state) ||
       (((g, h, i) = winning_state) ||
          (((a, d, g) = winning_state) ||
             (((b, e, h) = winning_state) ||
                (((c, f, i) = winning_state) ||
                   (((a, e, i) = winning_state) ||
                      ((c, e, g) = winning_state)))))))
#95 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let other_player = function | X -> O | O -> X
#100 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let move_counts { a; b; c; d; e; f; g; h; i } =
  List.fold_right
    (fun el ->
       fun (x, o) ->
         match el with
         | None -> (x, o)
         | ((Some (X))[@explicit_arity ]) -> ((x + (Z.of_string "1")), o)
         | ((Some (O))[@explicit_arity ]) -> (x, (o + (Z.of_string "1"))))
    ~base:((Z.of_string "0"), (Z.of_string "0")) [a; b; c; d; e; f; g; h; i]
#112 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let is_valid_grid grid last_player =
  let (x, o) = move_counts grid in
  if x > o
  then
    (last_player = ((Some (X))[@explicit_arity ])) &&
      ((x - o) = (Z.of_string "1"))
  else
    if x < o
    then
      (last_player = ((Some (O))[@explicit_arity ])) &&
        ((o - x) = (Z.of_string "1"))
    else true
#123 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let is_tie { grid = { a; b; c; d; e; f; g; h; i };_} =
  List.for_all ((<>) None) [a; b; c; d; e; f; g; h; i]
#131 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let goal_valid_grid_has_no_more_than_one_move_diff game =
  let (x, o) = move_counts game.grid in
  not
    ((is_valid_grid game.grid game.last_player) &&
       ((x - o) >= (Z.of_string "2")))
#136 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let is_valid_game game =
  let winning_X = is_winning game X in
  let winning_O = is_winning game O in
  (is_valid_grid game.grid game.last_player) &&
    (((not winning_X) && (not winning_O)) || (winning_X <> winning_O))
#147 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let is_valid_move game player move =
  (not ((is_winning game X) || ((is_winning game O) || (is_tie game)))) &&
    ((is_valid_game game) &&
       ((((game.last_player = None) && (player = initial_player)) ||
           (game.last_player = ((Some ((other_player player)))
              [@explicit_arity ])))
          && ((value game move) = None)))
#157 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let play_move { grid;_} player move =
  let play = ((Some (player))[@explicit_arity ]) in
  let grid =
    match move with
    | A -> { grid with a = play }
    | B -> { grid with b = play }
    | C -> { grid with c = play }
    | D -> { grid with d = play }
    | E -> { grid with e = play }
    | F -> { grid with f = play }
    | G -> { grid with g = play }
    | H -> { grid with h = play }
    | I -> { grid with i = play } in
  { grid; last_player = play }
#175 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let status game =
  if is_winning game X
  then ((Won (X))[@explicit_arity ])
  else
    if is_winning game O
    then ((Won (O))[@explicit_arity ])
    else if is_tie game then Tied else InProgress
#186 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let play ({ last_player;_} as game) move =
  let player =
    match last_player with
    | None -> initial_player
    | ((Some (player))[@explicit_arity ]) -> other_player player in
  if is_valid_move game player move
  then let game = play_move game player move in (game, (status game))
  else (game, ((InvalidMove (move))[@explicit_arity ]))
#200 "/Users/dave/dev/ai/verified-react/examples/tictactoe/TicTacToe_Logic.ire"

let goal_game_progression game player move =
  ((is_valid_game game) && (is_valid_move game player move)) ==>
    (is_valid_game (play_move game player move))
