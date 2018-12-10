----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    15:22:24 10/12/2018
-- Module Name:    Mux4a1Sec_Bis - Arquitectura
-- Project Name:   Mux4a1Sec_Bis.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powred by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Mux4a1Sec_Bis is
	Port(c0 : In STD_LOGIC;
		  c1 : In STD_LOGIC;
		  c2 : In STD_LOGIC;
		  c3 : In STD_LOGIC;
		  s : In STD_LOGIC_VECTOR(1 downto 0);
		  salida : Out STD_LOGIC);
End Mux4a1Sec_Bis;

Architecture Arquitectura of Mux4a1Sec_Bis is
Begin

	Process(c0, c1, c2, c3, s)
	Begin
		Case s is
			When "00" => salida<=c0;
			When "01" => salida<=c1;
			When "10" => salida<=c2;
			When others => salida<=c3;
		End Case;
	End Process;
End Arquitectura;
