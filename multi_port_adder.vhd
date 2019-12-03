-------------------------------------------------------------------------------
-- Title      : 
-- Project    : Multi port adder (Structural description)
-------------------------------------------------------------------------------
-- File       :  multi_port_adder.vhd
-- Author     : Group 2: Md. Chowdhury Justin Zeyeum
-- Company    : Tampere University
-- Created    : 2019-11-13
-- Last update: 2019-11-29
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: <How to connect VHDL Blocks together>
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-13  1.0      zeyeum  Created
-------------------------------------------------------------------------------

-- Default libraries
library ieee;
use ieee.std_logic_1164.all;

--entity multi port adder declaration
entity multi_port_adder is
  generic (
    operand_width_g   : integer := 16;
    num_of_operands_g : integer := 4
    );
  port (clk         : in  std_logic;
        rst_n       : in  std_logic;
        operands_in : in  std_logic_vector(operand_width_g*num_of_operands_g - 1 downto 0);
        sum_out     : out std_logic_vector(operand_width_g - 1 downto 0)
        );

end multi_port_adder;

-------------------------------------------------------------------------------

architecture structural of multi_port_adder is

-- introducing component adder from last exercise
  component adder is
    generic (
      operand_width_g : integer);
    port (
      clk : in std_logic;
      rst_n : in std_logic;
      a_in : in std_logic_vector((operand_width_g - 1) downto 0);
      b_in : in std_logic_vector((operand_width_g - 1) downto 0);
      sum_out : out std_logic_vector(operand_width_g downto 0));
      --sum_out : out std_logic_vector((operand_width_g - 1) downto 0);
      end component adder;

      --Introducing a new type and signal of this type
      --type array_r is array (0 to num_of_operands_g/2 - 1) of std_logic_vector(operand_width_g downto 0);
      type array_r is array (((num_of_operands_g/2) - 1) downto 0) of std_logic_vector(operand_width_g downto 0);
      signal subtotal : array_r;
      signal total : std_logic_vector((operand_width_g + 1) downto 0);

      begin  --structural

--Instantiating the first two adders
-- Connecting the first adder to the implementation.
-- Put the result in element 0 of the subtotal table.
        adder_1 : adder
          generic map (
            operand_width_g => operand_width_g)
          port map (
            clk => clk,
            rst_n => rst_n,
            a_in => operands_in((operand_width_g - 1) downto 0),
            b_in => operands_in(((operand_width_g * 2) - 1) downto operand_width_g),
            sum_out => subtotal(0));

-- Connecting a second adder to implementation.
-- Place the result in element 1 of the subtotal table.
        adder_2 : adder
          generic map (
            operand_width_g => operand_width_g)
          port map (
            clk => clk,
            rst_n => rst_n,
            a_in => operands_in(((operand_width_g * 3) - 1) downto (operand_width_g * 2)),
            b_in => operands_in(((operand_width_g * 4) - 1) downto (operand_width_g * 3)),
            sum_out => subtotal(1));

--Instantiating the third adder
-- Addition of the first two adder's results, ie
--elements 0 and 1 in the subtotal table.
        adder_3 : adder
          generic map (
            operand_width_g => operand_width_g + 1)
          port map (
            clk => clk,
            rst_n => rst_n,
            a_in => subtotal(0),
            b_in => subtotal(1),
            sum_out => total);

-- Put the total vector value at the sum_out output
-- except for the two most significant bits.
        sum_out <= total((operand_width_g - 1) downto 0);

--If there are no 4 operands, concentrate on severity failure.
        assert (num_of_operands_g = 4) report "severity failure -- num_of operands_g not equal to 4" severity failure;

      end structural;




