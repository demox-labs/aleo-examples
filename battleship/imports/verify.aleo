program verify.aleo;

function create_board:
    input r0 as u64.private; // Carrier, length 5
    input r1 as u64.private; // Battleship, length 4
    input r2 as u64.private; // Cruiser, length 3
    input r3 as u64.private; // Destroyer, length 2

    // verify each ship input as valid in a row configuration

    // carrier, length 5
    mod r0 255u64 into r4; // mod 255 reduces any row in an 8x8 grid to a single row of at most 8 bits
    mod r4 31u64 into r5; // 5 flipped bits in order will be a multiple of 31, should be 0 if this is a valid row

    // battleship, length 4
    mod r1 255u64 into r6;
    mod r6 15u64 into r7;

    // cruiser, length 3
    mod r2 255u64 into r8;
    mod r8 7u64 into r9;

    // destroyer, length 2
    mod r3 255u64 into r10;
    mod r10 3u64 into r11;

    // verify each ship input as valid in a column configuration

    // carrier, length 5

    mod r0 4311810305u64


