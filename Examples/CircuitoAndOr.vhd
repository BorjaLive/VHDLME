----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    20:07:15 15/12/2018
-- Module Name:    CircuitoAndOr - Arquitectura
-- Project Name:   CircuitoAndOr.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity CircuitoAndOr is
	Port( a : In STD_LOGIC;
		   b : In STD_LOGIC;
		   c : In STD_LOGIC;
		   d : In STD_LOGIC;
		   e : In STD_LOGIC;
		   f : In STD_LOGIC;
		   g : In STD_LOGIC;
		   h : In STD_LOGIC;
		   i : In STD_LOGIC;
		   j : In STD_LOGIC;
		   k : In STD_LOGIC;
		   y : Out STD_LOGIC);
End CircuitoAndOr;

Architecture Arquitectura of CircuitoAndOr is
	Signal a0 :  STD_LOGIC;
	Signal a1 :  STD_LOGIC;
	Signal a2 :  STD_LOGIC;
	Signal a3 :  STD_LOGIC;
Begin
	a0 <= a and b and c and d;
	a1 <= e and f;
	a2 <= g and h and i;
	a3 <= j and k;
	y <= not (a0 or a1 or a2 or a3);
End Arquitectura;
