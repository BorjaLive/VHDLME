----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:22:13 15/12/2018
-- Module Name:    Entidad - Arquitectura
-- Project Name:   Funcion2.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
Begin
	A_n <= Not A;
	B_n <= Not B;
	D_n <= Not D;
	F <= (A_n And D_n) Or (A_n And C) Or B_n;
End Arquitectura;
