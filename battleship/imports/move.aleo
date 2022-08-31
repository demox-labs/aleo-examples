program move.aleo;

record move:
    owner as address.private;
    gates as u64.private;
    incoming_fire_coordinate as u64.private;
    player_1 as address.private;
    player_2 as address.private;
    prev_hit_or_miss as u64.private;

function create_move:
    input r0 as move.record;
    input r1 as u64.private; // incoming_fire_coordinate to send to opponent
    input r2 as u64.private; // prev_hit_or_miss to let opponent know result of their last move

    is.eq r0.owner r0.player_1 into r3;
    ternary r3 r0.player_2 r0.player_1 into r4;

    cast r4 r0.gates r1 r0.player_1 r0.player_2 r2 into r5 as move.record;

    output r5 as move.record;

function start_game:
    // self.caller will be player 1
    input r0 as address.private; // player 2

    cast r0 0u64 0u64 self.caller r0 0u64 into r1 as move.record;

    output r1 as move.record;