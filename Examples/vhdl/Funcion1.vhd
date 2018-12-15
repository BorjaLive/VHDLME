----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:28:27 15/12/2018
-- Module Name:    Entidad - Arquitectura
-- Project Name:   Funcion1.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Entidad is
	Port( A : In STD_LOGIC;
		   B : In STD_LOGIC;
		   C : In STD_LOGIC;
		   D : In STD_LOGIC;
		   F : Out STD_LOGIC);
End Entidad;

Architecture Arquitectura of Entidad is
	Signal A_n :  STD_LOGIC;
	Signal B_n :  STD_LOGIC;
	Signal D_n :  STD_LOGIC;
	Signal s0 :  STD_LOGIC;
	Signal s1 :  STD_LOGIC;
Begin
	A_n <= Not A;
	B_n <= Not B;
	D_n <= Not D;
	s0 <= A_n And D_n;
	s1 <= A_n And C;
	F <= B_n Or s0 Or s1;
End Arquitectura;
