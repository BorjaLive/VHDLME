----------------------------------------------------------------------------------
-- Enginer:        Margaret
-- Create Date:    11:43:47 13/01/2019
-- Module Name:    Noname - Noname_Architecture
-- Project Name:   Parecido7.vme
-- Description:    Not provided
--
-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Noname is
	Port( E : In STD_LOGIC;
		   S : Out STD_LOGIC;
		   RS : In STD_LOGIC;
		   Q : Out STD_LOGIC_VECTOR(2 downto 0));
End Noname;

Architecture Noname_Architecture of Noname is
	Subtype estados is STD_LOGIC_VECTOR(2 downto 0);
	 Constant RESET :  estados := "000";
	 Constant L1 :  estados := "001";
	 Constant L2 :  estados := "010";
	 Constant LF :  estados := "011";
	 Constant H1 :  estados := "101";
	 Constant H2 :  estados := "110";
	 Constant HF :  estados := "111";
	Signal CK :  STD_LOGIC;
	Signal estado :  estados;
Begin
	Q <= estado;

	S <= '1' When (estado=HF or estado=LF) else
		  '0';

	Process(E, RS, estado)
	Begin
		If RS='1' Then estado <= reset;
			Elsif CK'event and CK='1' Then Case estado is
				When RESET => If E='1' Then estado <= H1;
					Else estado <= L1;
				End If;
				
				When H1 => If E='1' Then estado <= H2;
					Else estado <= RESET;
				End If;
				
				When H2 => If E='1' Then estado <= HF;
					Else estado <= RESET;
				End If;
				
				When HF => If E='1' Then estado <= HF;
					Else estado <= RESET;
				End If;
				
				When L1 => If E='1' Then estado <= RESET;
					Else estado <= L2;
				End If;
				
				When L2 => If E='1' Then estado <= RESET;
					Else estado <= LF;
				End If;
				
				When others => 
			End Case;
		End If;
	End Process;
End Noname_Architecture;
