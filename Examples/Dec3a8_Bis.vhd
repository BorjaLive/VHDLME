----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    18:00:50 09/12/2018
-- Module Name:    Dec3a8 - Arquitectura
-- Project Name:   Dec3a8_Bis.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powred by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity Dec3a8 is
	Port(a : In STD_LOGIC;
		  b : In STD_LOGIC;
		  c : In STD_LOGIC;
		  salida : Out STD_LOGIC_VECTOR(0 to 7));
End Dec3a8;

Architecture Arquitectura of Dec3a8 is
	 Signal entrada :  STD_LOGIC_VECTOR(2 downto 0);
Begin
	entrada <= c & b & a;

	salida <= "10000000" When entrada = "000" else
		       "01000000" When entrada = "001" else
		       "00100000" When entrada = "010" else
		       "00010000" When entrada = "011" else
		       "00001000" When entrada = "100" else
		       "00000100" When entrada = "101" else
		       "00000010" When entrada = "110" else
		       "00000001";
End Arquitectura;
