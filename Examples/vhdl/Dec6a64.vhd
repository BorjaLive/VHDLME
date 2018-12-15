----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    18:50:37 15/12/2018
-- Module Name:    Dec6a64 - Arquitectura
-- Project Name:   Dec6a64.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Dec6a64 is
	Port( entrada : In STD_LOGIC_VECTOR(5 downto 0);
		   salida : Out STD_LOGIC_VECTOR(0 to 63));
End Dec6a64;

Architecture Arquitectura of Dec6a64 is
	Signal p :  INTEGER range 0 to 63;
Begin
	p <= CONV_INTEGER(entrada);

	Process(p)
	Begin
		For i in salida'range loop
			If i = p Then salida(i) <= '1';
				Else salida(i) <= '0';
			End If;
		End Loop;
	End Process;
End Arquitectura;
