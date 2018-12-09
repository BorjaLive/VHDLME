----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    17:27:39 09/12/2018
-- Module Name:    Mux4a1_b - Arquitectura
-- Project Name:   Mux4a1_b.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powred by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Mux4a1_b is
	Port(c0 : In STD_LOGIC;
		  c1 : In STD_LOGIC;
		  c2 : In STD_LOGIC;
		  c3 : In STD_LOGIC;
		  s : In STD_LOGIC_VECTOR(1 downto 0);
		  o1 : Out STD_LOGIC);
End Mux4a1_b;

Architecture Arquitectura of Mux4a1_b is
	 Signal control :  INTEGER range 0 to 3;
Begin
	control <= CONV_INTEGER(s);

	With control select
	o1 <= c0 When 0,
		  c1 When 1,
		  c2 When 2,
		  c3 When others;
End Arquitectura;
