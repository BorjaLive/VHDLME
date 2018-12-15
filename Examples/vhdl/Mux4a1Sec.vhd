----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:35:26 15/12/2018
-- Module Name:    Mux4a1Sec - Arquitectura
-- Project Name:   Mux4a1Sec.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Mux4a1Sec is
	Port( c0 : In STD_LOGIC;
		   c1 : In STD_LOGIC;
		   c2 : In STD_LOGIC;
		   c3 : In STD_LOGIC;
		   s : In STD_LOGIC_VECTOR(1 downto 0);
		   salida : Out STD_LOGIC);
End Mux4a1Sec;

Architecture Arquitectura of Mux4a1Sec is
	Signal control :  INTEGER range 0 to 3;
Begin
	control <= CONV_INTEGER(s);

	Process(c0, c1, c2, c3, control)
	Begin
		If control = 0 Then salida <= c0;
			Elsif control = 1 Then salida <= c1;
			Elsif control = 2 Then salida <= c2;
			Else salida <= c3;
		End If;
	End Process;
End Arquitectura;
