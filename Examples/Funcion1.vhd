----------------------------------------------------------------------------------
-- Enginer:        
-- Create Date:    19:38:27 15/12/2018
-- Module Name:    Entidad - Arquitectura
-- Project Name:   Funcion1.vme
-- Description:    
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE, LCDF_VHDL;
use IEEE.STD_LOGIC_1164.ALL;
use LCDF_VHDL.FUNC_PRIMS.ALL;

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
	p0: INV port map(in1 => A, out1 => A_n);
	p1: INV port map(in1 => B, out1 => B_n);
	p2: INV port map(in1 => D, out1 => D_n);
	p3: AND2 port map( in1 => A_n,  in2 => D_n,  out1 => s0);
	p4: AND2 port map( in1 => A_n,  in2 => C,  out1 => s1);
	p5: OR3 port map( in1 => B_n,  in2 => s0,  in3 => s1,  out1 => F);
End Arquitectura;
