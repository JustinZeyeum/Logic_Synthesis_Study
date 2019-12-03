# Logic_Synthesis_Study

To convert a natural language Specification into hardware description, verify it, and synthesize into FPGA chip, also the relation between VHDL description and logic realization, and clock synchronization principles.
This is a class exercises. Below is the main objectives of each exercise:

1) Ripple carry adder (Gate level description):

The purpose of this exercise is to introduce basic terms;
* entity which defines the interface of a block (and parameters)
* architecture which defines the internal implementation of a block
* gate level representation
* basic logic gates
* defining signals
* datatypes std_logic and std_logic_vector
The task is to represent a 3-bit ripple-carry-adder which has a 4-bit output ( s = a + b )

2) Generic adder (RTL description)

In this exercise we get familiarized with;
* the power of expression and the brilliance of RTL-description
* defining generic-parameters
* synchronous processes
* types signed and integer
* type conversions
*** The assignment is to describe a synchronous adder which has n-bit inputs and the output width is n+1 bits ( sum = a + b)

3) Multi port adder (Structural description)

The purpose of this exercise is to learn:
* How to connect VHDL-blocks together
* Keyword component
* How to introduce new signal types (keyword type)
*** The task is to implement a multiport adder using the adder block of the last exercise (s = a1 + a2 + ...)

4) VHDL Test bench design

The purpose of the exercise is to learn:
* Implementation of a test bench with the VHDL-language
* How to manage files using VHDL '93 standard
* Implementation of more complex processes
*** The task is to implement a test bench for the multi port adder (multi_port_adder) implemented in the last exercises

5) Triangular wave generator

The purpose of the exercise is to learn:
* the implementation of counters and synchronous logic
* the usage of the waveform window in ModelSim
*** The task is to implement and verify a parameterizable triangular wave generator
    -The implementation is bidirectional step counter which uses signed values
    -The generator counts from the smallest to the largest value and vice versa using predefined steps
    -After reset, the counter starts from value zero and counting begins upwards
    
6)    
