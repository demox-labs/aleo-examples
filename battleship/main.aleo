import board.aleo;
import move.aleo;
import verify.aleo;

// The 'battleship.aleo' program.
program battleship.aleo;

function initialize_board:
    input r0 as u64.private; // Carrier, length 5
    input r1 as u64.private; // Battleship, length 4
    input r2 as u64.private; // Cruiser, length 3
    input r3 as u64.private; // Destroyer, length 2
    input r4 as address.private;

    call verify.aleo/create_board r0 r1 r2 r3 into r5;

    call board.aleo/initialize_board r5 r4 into r6;

    output r6 as board.aleo/board_state.record;

function offer_battleship:
    input r0 as board.aleo/board_state.record;

    call board.aleo/start_board r0 into r1;
    call move.aleo/start_game r0.player_2 into r2;

    output r1 as board.aleo/board_state.record;
    output r2 as move.aleo/move.record;

function start_battleship:
    input r0 as board.aleo/board_state.record;
    input r1 as move.aleo/move.record;

    assert.eq r0.player_1 r1.player_2;
    assert.eq r0.player_2 r1.player_1;

    call board.aleo/start_board r0 into r2;
    call move.aleo/start_game r0.player_2 into r3;

    output r2 as board.aleo/board_state.record;
    output r3 as move.aleo/move.record;

function play:
    input r0 as board.aleo/board_state.record; // board state
    input r1 as move.aleo/move.record; // incoming move from opponent
    input r2 as u64.private; // coordinate to send out to opponent


    // play coordinate on own board. will fail if not a valid move
    call board.aleo/update_played_tiles r0 r2 into r3;

    // update own board with result of last shot
    call board.aleo/update_hits_and_misses r3 r1.prev_hit_or_miss into r4;

    // assess whether incoming move firing coordinate is a hit
    and r1.incoming_fire_coordinate r0.ships into r5;

    call move.aleo/create_move r1 r2 r5 into r6;

    output r4 as board.aleo/board_state.record;
    output r6 as move.aleo/move.record;