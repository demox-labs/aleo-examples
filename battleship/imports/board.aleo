program board.aleo;

// battleship boards are represented by 8x8 squares.
// A u64 is all that is required to represent a hit or a miss on a single board.
// Starting from the top row, left to right, a hit is 1 and a miss is 0.
// A first move resulting in a hit in row 1, column 3 would be:
// 00100000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
// A second u64 is needed to represent which squares have been played.

record board_state:
    owner as address.private;
    gates as u64.private;
    hits_and_misses as u64.private; // the hits and misses registered on opponent's board
    played_tiles as u64.private; // tiles you've played on opponent's board
    ships as u64.private; // the ships on your own board
    player_1 as address.private;
    player_2 as address.private;
    game_started as boolean.private;
    //board_hash as field.private; combination of address and ships

// very hard to acertain validity of a board without loops. Just going to accept any board initialization and worry about validity later.
function initialize_board:
    input r0 as u64.private;
    input r1 as address.private;

    // need to make sure the intended ship positions are valid. The allowed ships are one of each:
    // 5, 4, 3, and 2. Ships may lay vertically or horizontally. Ships may not be diagonal and may not overlap.
    // Ships may touch.

    cast self.caller 0u64 0u64 0u64 r0 self.caller r1 false into r2 as board_state.record;

    output r2 as board_state.record;

function start_board:
    input r0 as board_state.record;

    // ensure this board hasn't been used to start a game before
    assert.eq false r0.game_started;

    cast r0.owner r0.gates r0.hits_and_misses r0.played_tiles r0.ships r0.player_1 r0.player_2 true into r1 as board_state.record;

    output r1 as board_state.record;

function update_played_tiles:
    input r0 as board_state.record;
    input r1 as u64.private; // your next move

    // need to make sure r1 is a valid move. Only one bit of r1 should be flipped.
    sub r1 1u64 into r2;
    // bitwise and operation
    and r1 r2 into r3;
    assert.eq 0u64 r3;

    // need to make sure r1 is a valid move given the played_tiles. no bits should overlap.
    and r0.played_tiles r1 into r4;
    assert.eq 0u64 r4;

    or r0.played_tiles r1 into r5; // new played tiles

    cast r0.owner r0.gates r0.hits_and_misses r5 r0.ships r0.player_1 r0.player_2 r0.game_started into r6 as board_state.record;

    output r6 as board_state.record;

function update_hits_and_misses:
    input r0 as board_state.record;
    input r1 as u64.private; // hit or miss -- a hit will have one flipped bit. a miss will be all 0s

    or r0.hits_and_misses r1 into r2; // updated hits and misses

    cast r0.owner r0.gates r2 r0.played_tiles r0.ships r0.player_1 r0.player_2 r0.game_started into r3 as board_state.record;

    output r3 as board_state.record;
