-------------------------------------------------------------------------------
-- Title      : 
-- Project    : Generic adder (RTL description)
-------------------------------------------------------------------------------
-- File       : adder.vhd
-- Author     : Group 2: Md. Chowdhury Justin Zeyeum
-- Company    : Tampere University
-- Created    : 2019-11-06
-- Last update: 2019-11-06
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: <Generic parameters, synchronous processes signed and integer>
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-06  1.0      zeyeum  Created
-------------------------------------------------------------------------------

-- Default libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity adder declaration
entity adder is
  generic (
    operand_width_g : integer
    );
  port (clk     : in  std_logic;
        rst_n   : in  std_logic;
        a_in    : in  std_logic_vector(operand_width_g-1 downto 0);
        b_in    : in  std_logic_vector(operand_width_g-1 downto 0);
        sum_out : out std_logic_vector(operand_width_g downto 0)
        );

end adder;

-------------------------------------------------------------------------------

architecture rtl of adder is
-- internal signal declarations
  signal sum_result :
    signed(operand_width_g downto 0);
begin
  process (clk, rst_n)
  begin
    if (rst_n = '0') then
      sum_out <= (others => '0');
    elsif (clk = '1' and clk'event) then
      sum_result <= resize(signed(a_in), operand_width_g+1) + resize(signed(b_in), operand_width_g+1);
    end if;
  end process;
end rtl;




