// The 'closure_example.aleo' program.
program closure_example.aleo;



function hello:
    input r0 as u32.public;
    
    call bar r0 into r1;
    
    output r1 as u32.public;

closure bar:
    input r0 as u32;

    add r0 1u32 into r1;
    output r1 as u32;