----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:47:52 13/12/2018
-- Module Name:    testies - Behavioral
-- Project Name:   test.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE, LCDF_VHDL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use LCDF_VHDL.FUNC_PRIMS.ALL;

Entity testies is
	Port(F : Out STD_LOGIC);
End testies;

Architecture Behavioral of testies is
	 Signal A :  STD_LOGIC;
	 Signal B :  STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 Signal C :  STD_LOGIC := '1';
	 Signal E :  STD_LOGIC_VECTOR(3 downto 0);
	 Signal D :  INTEGER range 0 to 15;
Begin

	Process(A, B, C, E, D)
	Begin
		C <= A And B;
		F <= Not C;

		p0: AND2 port map( in1 => A,  in2 => B,  out1 => C);
		p1: INV port map(in1 => C, out1 => F);

		D <= CONV_INTEGER(B);
		E <= CONV_STD_LOGIC_VECTOR(D, 4);

		F <= A When B = "00110011" else
			  C When A = '0' else
			  C;

		With D select
		F <= C When '0'|'1',
			  A When '1',
			  C When others;

		If A = '0' Then F <= '1';
			Elsif B = "00110011" Then F <= '0';
			Else A <= '1';
		End If;

		Case D is
			When 1 => F <= '0';
			When 2 => F <= '1';
			When others => F <= '0';
		End Case;

		For i in E'range loop
			If i = 2 Then E(i) <= '1';
				Else E(i) <= '0';
			End If;
		End Loop;
	End Process;
End Behavioral;
