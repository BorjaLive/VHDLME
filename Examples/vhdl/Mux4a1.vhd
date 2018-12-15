----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:30:10 15/12/2018
-- Module Name:    Mux4a1 - Arquitectura
-- Project Name:   Mux4a1.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Mux4a1 is
	Port( c0 : In STD_LOGIC;
		   c1 : In STD_LOGIC;
		   c2 : In STD_LOGIC;
		   c3 : In STD_LOGIC;
		   s0 : In STD_LOGIC;
		   s1 : In STD_LOGIC;
		   s : Out STD_LOGIC);
End Mux4a1;

Architecture Arquitectura of Mux4a1 is
	Signal control :  STD_LOGIC_VECTOR(1 downto 0);
Begin
	control <= s1 & s0;

	s <= c0 When control = "00" else
		  c1 When control = "01" else
		  c2 When control = "10" else
		  c3;
End Arquitectura;
