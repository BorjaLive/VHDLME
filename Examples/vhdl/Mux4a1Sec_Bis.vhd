----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:35:53 15/12/2018
-- Module Name:    Mux4a1Sec_Bis - Arquitectura
-- Project Name:   Mux4a1Sec_Bis.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Mux4a1Sec_Bis is
	Port( c0 : In STD_LOGIC;
		   c1 : In STD_LOGIC;
		   c2 : In STD_LOGIC;
		   s : In STD_LOGIC_VECTOR(1 downto 0);
		   salida : Out STD_LOGIC);
End Mux4a1Sec_Bis;

Architecture Arquitectura of Mux4a1Sec_Bis is
	Signal c3 :  STD_LOGIC;
Begin

	Process(c0, c1, c2, s)
	Begin
		If s = "00" Then salida<=c0;
			Elsif s = "01" Then salida<=c1;
			Elsif s = "10" Then salida<=c2;
		End If;
	End Process;
End Arquitectura;
