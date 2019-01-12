----------------------------------------------------------------------------------
-- Enginer:        Margaret
-- Create Date:    23:31:18 12/01/2019
-- Module Name:    Mux4a1_b - Noname_Architecture
-- Project Name:   Mux4a1_b.vme
-- Description:    Not provided
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Mux4a1_b is
	Port( c0 : In STD_LOGIC;
		   c1 : In STD_LOGIC;
		   c2 : In STD_LOGIC;
		   c3 : In STD_LOGIC;
		   O1 : Out STD_LOGIC;
		   s : In STD_LOGIC_VECTOR(1 downto 0));
End Mux4a1_b;

Architecture Noname_Architecture of Mux4a1_b is
	Signal control :  INTEGER range 0 to 3;
Begin
	control <= CONV_INTEGER(s);

	With control select
	O1 <= c0 When 0,
		   c1 When 1,
		   c2 When 2,
		   c3 When others;
End Noname_Architecture;
