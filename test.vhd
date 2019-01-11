----------------------------------------------------------------------------------
-- Enginer:        Arlin-T2
-- Create Date:    06:30:45 11/01/2019
-- Module Name:    Entity - Architecture
-- Project Name:   test.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Entity is
	Port( CK : In STD_LOGIC;
		   RS : In STD_LOGIC;
		   n1 : In STD_LOGIC;
		   n2 : In STD_LOGIC;
		   n3 : In STD_LOGIC;
		   n4 : In STD_LOGIC;
		   A : Out STD_LOGIC;
		   B : Out STD_LOGIC;
		   C : Out STD_LOGIC);
End Entity;

Architecture Architecture of Entity is
Begin
	Const estados reposo <= "00";
	Const estados llenado_A <= "01";
	Const estados llenado_B <= "10";
	Const estados llenado_C <= "11";

	A <= '1' When estada=llenado_A else
		  '0';
	B <= '1' When estada=llenado_B else
		  '0';
	C <= '1' When estada=llenado_C else
		  '0';

	Process(CK, RS, n1, n2, n3, n4)
	Begin
		Wait UntilCK = '1';

		If RS = '1' Then estada <= reposo;
			Elsif estada=reposo and n1='0' Then estada <= llenado_A;
			Elsif estada=llenado_A and n2='1' Then estada <= llenado_A;
			Elsif estada=llenado_B and n3='1' Then estada <= llenado_A;
			Elsif estada=llenado_C and n4='1' Then estada <= reposo;
		End If;
	End Process;
End Architecture;
