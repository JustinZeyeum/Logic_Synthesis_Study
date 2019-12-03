-------------------------------------------------------------------------------
-- Title      : Exercise 05
-- Project    : tb_multi_port_adder.vhd
-------------------------------------------------------------------------------
-- File       : tb_multi_port_adder.vhd
-- Author     : Group 2: Md. Chowdhury Justin Zeyeum
-- Company    : Tampere University
-- Created    : 2019-11-20
-- Last update: 2019-11-29
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Creating testbench for multiport adder
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-20  1.0     Zeyeum     Created
-------------------------------------------------------------------------------
--default libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

--Creating entity
entity tb_multi_port_adder is
  generic (
     operand_width_g : integer := 3);

end tb_multi_port_adder;

-- architecture declaration
architecture testbench of tb_multi_port_adder is


-- Define constants: bit widths and duration of clk period
  constant clk_period_c      : time    := 10 ns;  --Standard for the length of the clock cycle
  constant num_of_operands_c : integer := 4;  --A constant that determines the number of operands
  constant duv_delay_c       : integer := 2;  --Standard for DUV delay

-- creating the needed signals
  signal clk            : std_logic := '0';  --Signal to clock with initial value 0
  signal rst_n          : std_logic := '0';  --Down active reset with start value 0
  --signal operands_r : std_logic_vector((operand_width_c*num_of_operands_c)-1 downto 0);  --The signal to be connected to the input of the block to be tested
  signal operands_r     : std_logic_vector(15 downto 0);
  signal sum            : std_logic_vector(operand_width_g downto 0);  --output from DUV
  signal output_valid_r : std_logic_vector(duv_delay_c downto 0);  --Shift register for delay compensation

-- Creating files with text types

  file input_f       : text open read_mode is "input.txt";
  file ref_results_f : text open read_mode is "ref_results.txt"; --this causes
  --an overflow during simulation
 -- file ref_results_f : text open read_mode is "ref_results_4b.txt";--we use this for simulation
  file output_f      : text open write_mode is "output.txt";

--Creating component for the multi_port_adder
  component multi_port_adder is
    generic (
      operand_width_g   : integer;
      num_of_operands_g : integer
      );
    port (clk         : in  std_logic;
          rst_n       : in  std_logic;
          operands_in : in  std_logic_vector(((operand_width_g*num_of_operands_g) - 1) downto 0);
          sum_out     : out std_logic_vector((operand_width_g - 1) downto 0)
          );

  end component multi_port_adder;

begin  --testbench

--Assignment of not clock signals to clk
--generating the clock signals
-- type: combinational
  clk_gen : process (clk)
  begin  --clk_gen process
    clk <= not clk after (clk_period_c / 2);
  end process clk_gen;

-- Setting the reset signal
  rst_n <= '1' after (clk_period_c * 4);

-- Instantiating the multi_port_adder

  multi_port_adder_1 : multi_port_adder
    generic map (
      --operand_width_g   => operand_width_g,
      operand_width_g   => (operand_width_g + 1),
      num_of_operands_g => num_of_operands_c)
    port map (
      clk         => clk,
      rst_n       => rst_n,
      operands_in => operands_r,
      sum_out     => sum);

--Create a synchronous process for reading input files (input_reader)
--type: sequential
  input_reader : process (clk, rst_n)   --inputs

    variable line_v             : line;      --line number declaration
    type one_line is array ((num_of_operands_c - 1) downto 0) of integer;
--integer values(table)
    variable integer_variable_v : one_line;  --4 integer values of type integers

  begin  -- process input_reader

    if rst_n = '0' then                   --synchronous reset 
      operands_r     <= (others => '0');  --output
      output_valid_r <= (others => '0');  --output

    elsif clk'event and clk = '1' then  --rising clock edge
      output_valid_r <= output_valid_r((duv_delay_c - 1) downto 0) & '1';  --output_valid_r vector has 0-bit value of 1 and a shifter to the left

      -- if the end of file is not reached, we read the next line;
      if (not endfile(input_f)) then
        readline(input_f, line_v);

        --reading values from row to table in loops
        for ii in (num_of_operands_c - 1) downto 0 loop
          read(line_v, integer_variable_v(ii));
         operands_r(((num_of_operands_c * (ii + 1)) -1) downto (num_of_operands_c * ii)) <= std_logic_vector(to_signed(integer_variable_v(ii), 4));

        end loop;

      end if;

    end if;

  end process input_reader;

  --Create a synchronous process for the checker (checker)
  --type : sequential

  checker : process(clk, rst_n)
    -- creating variables for the reference file and the line
    variable ref_line_v    : line;      -- reference line declaration
    variable output_line_v : integer;   -- output line of integer type
    variable line_out_v    : line;      -- output line

  begin  -- process checker

    if rst_n = '0' then                 --asynchronous reset
      --resetting the signal sum to 0

    elsif clk'event and clk = '1' then  --rising clock edge

      -- If the highest bit of the shift register is one, the validation process is started
      if output_valid_r(duv_delay_c) = '1' then

        -- If the end of the scan file has not been reached
        if (not endfile(ref_results_f)) then

          -- Read line and line value from the check file
          readline(ref_results_f, ref_line_v);
          read(ref_line_v, output_line_v);

          -- Checking whether the calculated value corresponds to the read value. If not
          -- throwing the Assert and informing the tester.

         assert ((to_integer(signed(sum))) = output_line_v) report "value is not equivalent to the reference value!" severity failure;
          -- write the output of the tested block (DUV) to the output file output_f
          write(line_out_v, (to_integer(signed(sum))));
          writeline(output_f, line_out_v);

        else
          -- If the simulation passes successfully, the lap will be reported as being pushed
          assert false report "Simulation done!" severity failure;

        end if;

      end if;

    end if;

  end process checker;


end testbench;
