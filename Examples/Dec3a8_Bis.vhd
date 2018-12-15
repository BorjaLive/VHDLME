----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:37:53 15/12/2018
-- Module Name:    Dec3a8 - Arquitectura
-- Project Name:   Dec3a8_Bis.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Dec3a8 is
	Port( a : In STD_LOGIC;
		   b : In STD_LOGIC;
		   c : In STD_LOGIC;
		   EN : In STD_LOGIC;
		   salida : Out STD_LOGIC_VECTOR(0 to 7));
End Dec3a8;

Architecture Arquitectura of Dec3a8 is
	Signal entrada :  STD_LOGIC_VECTOR(2 downto 0);
	Signal entrada_int :  INTEGER range 0 to 7;
	Signal salida_en :  STD_LOGIC_VECTOR(0 to 7);
Begin
	entrada <= c & b & a;

	entrada_int <= CONV_INTEGER(entrada);

	With entrada_int select
	salida_en <= "10000000" When 0,
		          "01000000" When 1,
		          "00100000" When 2,
		          "00010000" When 3,
		          "00001000" When 4,
		          "00000100" When 5,
		          "00000010" When 6,
		          "00000001" When others;

	salida <= salida_en When EN = '1' else
		       "00000000";
End Arquitectura;
