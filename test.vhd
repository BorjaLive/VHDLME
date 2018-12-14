----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    10:06:28 14/12/2018
-- Module Name:    testies - Behavioral
-- Project Name:   test.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity testies is
	Port( A : In STD_LOGIC;
		   B : In STD_LOGIC_VECTOR(7 downto 0);
		   F : Out STD_LOGIC;
		   D : In INTEGER range 0 to 15);
End testies;

Architecture Behavioral of testies is
	Signal C :  STD_LOGIC := '1';
	Constant Signal E :  STD_LOGIC_VECTOR(3 downto 0) := (others => "0101");
Begin
	C <= A And B;
	F <= Not C;
End Behavioral;
