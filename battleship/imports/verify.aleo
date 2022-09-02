program verify.aleo;

closure c_bitcount:
    input r0 as u64;

    div r0 2u64 into r1;
    div r0 4u64 into r2;
    div r0 8u64 into r3;

    and r1 8608480567731124087u64 into r4;
    and r2 3689348814741910323u64 into r5;
    and r3 1229782938247303441u64 into r6;

    sub r0 r4 into r7;
    sub r7 r5 into r8;
    sub r8 r6 into r9;

    div r9 16u64 into r10;
    add r9 r10 into r11;
    and r11 1085102592571150095u64 into r12;
    rem r12 255u64 into r13;

    output r13 as u64;

// Check that flipped bits are adjacent, assuming only adjacency as passed in with r1
closure c_adjacency_check:
    input r0 as u64; // Ship bitstring
    input r1 as u64; // Ship length vertical or horizontal bitstring

    div r0 r1 into r2; // this may result in 0
    // subtracting 1 from 0 will cause an underflow
    is.eq r2 0u64 into r3;
    // setting to 3 will guarantee failure
    ternary r3 3u64 r2 into r4;

    sub r4 1u64 into r5;
    and r4 r5 into r6;

    is.eq r6 0u64 into r7;

    output r7 as boolean;

// Check that two adjacent ones don't split a row of size 8
closure c_horizontal_check:
    input r0 as u64; // Ship bitstring
    input r1 as u64; // Ship length horizontal bitstring

    rem r0 255u64 into r2;
    div r2 r1 into r3;

    // subtracting 1 from 0 will cause an underflow
    is.eq r3 0u64 into r4;
    // setting to 3 will guarantee failure
    ternary r4 3u64 r3 into r5;
    sub r5 1u64 into r6;
    and r5 r6 into r7;

    is.eq r7 0u64 into r8;
    output r8 as boolean;

function validate_ship_placement:
    input r0 as u64.private; // Ship placement on board
    input r1 as u64.private; // Ship length
    input r2 as u64.private; // Horizontal ship bitstring
    input r3 as u64.private; // Vertical ship bitstring

    // check bitcount -- all other validations depend on the bitcount being the appropriate number
    call c_bitcount r0 into r4; // how many bits in the ship placement
    assert.eq r4 r1;

    // if horizontal
    call c_adjacency_check r0 r2 into r5; // true if bits are adjacent horizontally
    call c_horizontal_check r0 r2 into r6; // true if those horizontal bits are not split across rows
    and r5 r6 into r7; // true if bits are adjacent horizontally and not split across rows

    // if vertical
    call c_adjacency_check r0 r3 into r8; // true if bits are adjacent vertically

    or r7 r8 into r9; // ship is valid if valid either vertically or horizontally

    output r9 as boolean.private;

function create_board:
    input r0 as u64.private; // Carrier, length 5
    input r1 as u64.private; // Battleship, length 4
    input r2 as u64.private; // Cruiser, length 3
    input r3 as u64.private; // Destroyer, length 2

    // bitwise combine the ship placements together
    or r0 r1 into r4;
    or r2 r3 into r5;
    or r4 r5 into r6; // full bitwise combination of ships

    call c_bitcount r6 into r7;
    assert.eq r7 14u64; // given 4 individually-valid ships, a valid combination should yield exactly 14 flipped bits.

    output r6 as u64.private;