library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity fourbitcounter_part3 is

	port (En, Clr, Clk : in std_logic;
			Q : buffer unsigned(15 downto 0));			
			
end entity;

architecture beh of fourbitcounter_part3 is
	
begin

	process(clr, clk, en)
	
	begin
	
		if (Clr = '0' ) then Q <= (others => '0'); -- clear attivo basso -> resetta Q
		
		elsif(clr = '1' and En = '1') then 
			
			if (Clk'event and Clk = '1') then --ogni fronte di salita aggiungo 1 a Q
			
				Q <= Q + 1;
				
			end if;
			
		end if;
		
	end process;
			
end architecture;