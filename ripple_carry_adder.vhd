-------------------------------------------------------------------------------
-- Title      : 
-- Project    : Ripple carry adder (Gate level description)
-------------------------------------------------------------------------------
-- File       : ripple_carry_adder.vhd
-- Author     : Group 2: Md. Chowdhury Justin Zeyeum
-- Company    : Tampere University
-- Created    : 2019-10-30
-- Last update: 2019-10-30
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: <Introducing entity,architecture,signals,gate level and logic
-- gates>
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-10-30  1.0      zeyeum  Created
-------------------------------------------------------------------------------

-- Default libraries
library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity ripple_carry_adder is
  port (
    a_in  : in  std_logic_vector(2 downto 0);
    b_in  : in  std_logic_vector(2 downto 0);
    s_out : out std_logic_vector(3 downto 0)
    );
end ripple_carry_adder;

-------------------------------------------------------------------------------

architecture gate of ripple_carry_adder is

-- internal signal declarations 
  signal Carry_ha : std_logic;
  signal C        : std_logic;
  signal D        : std_logic;
  signal E        : std_logic;
  signal Carry_fa : std_logic;
  signal F        : std_logic;
  signal G        : std_logic;
  signal H        : std_logic;


begin  -- gate
-- signal assignments here
  s_out(0) <= a_in(0) xor b_in(0);
  Carry_ha <= a_in(0) and b_in(0);
  C        <= a_in(1) xor b_in(1);
  s_out(1) <= C xor Carry_ha;
  D        <= Carry_ha and C;
  E        <= a_in(1) and b_in(1);
  Carry_fa <= D or E;
  F        <= a_in(2) xor b_in(2);
  s_out(2) <= F xor Carry_fa;
  G        <= Carry_fa and F;
  H        <= b_in(2) and a_in(2);
  s_out(3) <= G or H;


end gate;
