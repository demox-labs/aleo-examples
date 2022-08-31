program verify.aleo;

closure bitcount:
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

// Check that two ones are present
closure check_bitcount:
    input r0 as u64; // Ship bitstring
    input r1 as u64; // Ship length

    call bitcount r0 into r2;
    is.eq r2 r1 into r3;

    output r3 as boolean; 

// Check that two ones are adjacent, assuming only two ones
closure adjacency_check:
    input r0 as u64; // Ship bitstring
    input r1 as u64; // Ship length vertical or horizontal bitstring

    div r0 r1 into r2;
    sub r2 1u64 into r3;
    and r2 r3 into r4;

    is.eq r4 0u64 into r5;

    output r5 as boolean;

// Check that two adjacent ones don't split a row of size 8
closure horizontal_check:
    input r0 as u64; // Ship bitstring
    input r1 as u64; // Ship length horizontal bitstring

    rem r0 255u64 into r2;
    div r2 r1 into r3;
    sub r3 1u64 into r4;
    and r3 r4 into r5;

    is.eq r5 0u64 into r6;
    output r6 as boolean;

closure validate_ship:
    input r0 as u64;
    input r1 as u64; // Ship length
    input r2 as u64; // Horizontal ship bitstring
    input r3 as u64; // Vertical ship bitstring

    call check_bitcount r0 r1 into r4;

    // if horizontal
    call adjacency_check r0 r2 into r5;
    call horizontal_check r0 r2 into r6;
    and r5 r6 into r7;

    // if vertical
    call adjacency_check r0 r3 into r8;
    
    or r7 r8 into r9;
    and r4 r9 into r10;

    output r10 as boolean;

function create_board:
    input r0 as u64.private; // Carrier, length 5
    input r1 as u64.private; // Battleship, length 4
    input r2 as u64.private; // Cruiser, length 3
    input r3 as u64.private; // Destroyer, length 2

    call validate_ship r0 5u64 31u64 4311810305u64 into r4;
    call validate_ship r1 4u64 15u64 16843009u64 into r5;
    call validate_ship r2 3u64 7u64 65793u64 into r6;
    call validate_ship r3 2u64 3u64 257u64 into r7;

    and r4 r5 into r8;
    and r8 r6 into r9;
    and r9 r7 into r10;

    assert.eq r10 true;

    or r0 r1 into r11;
    or r11 r2 into r12;
    or r12 r3 into r13;

    call check_bitcount r13 14u64 into r14;
    assert.eq r14 true;

    output r13 as u64.private;