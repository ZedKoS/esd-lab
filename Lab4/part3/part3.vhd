library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part3 is

	port (KEY : in std_logic_vector(0 to 0); --manual clock
			SW : in std_logic_vector(1 downto 0); --sw0 activelow reset, sw1 enable
			HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)); --displays
			
end entity;

architecture Behavior of part3 is

	component fourbitcounter_part3 is -- counter basato su Q <= Q + 1
	port (En, Clr, Clk : in std_logic;
			Q : buffer unsigned(15 downto 0));		
	end component;
	
	component hexadecimal_ssd_decoder is --dec
	port (c : in std_logic_vector(3 downto 0);
		  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Q : unsigned(15 downto 0); -- segnale da mandare al counter
	signal Q_std : std_logic_vector(15 downto 0); --segnale da mandare ai dec
	
	
begin
	-- a differenza di part2 usiamo un solo counter
	counter : fourbitcounter_part3 port map (En => SW(1), Clr => SW(0), 
											clk => KEY(0), Q => Q);
	
	Q_std <= std_logic_vector(Q);
	-- print del risultato
	DEC0 : hexadecimal_ssd_decoder port map (c => Q_std(3 downto 0), dec => HEX0);
	DEC1 : hexadecimal_ssd_decoder port map (c => Q_std(7 downto 4), dec => HEX1);
	DEC2 : hexadecimal_ssd_decoder port map (c => Q_std(11 downto 8), dec => HEX2);
	DEC3 : hexadecimal_ssd_decoder port map (c => Q_std(15 downto 12), dec => HEX3);
	
end architecture;