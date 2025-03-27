library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part3 is
	port (KEY : in std_logic_vector(0 to 0); --manual clock
			SW : in std_logic_vector(1 downto 0); --sw0 reset, sw1 enable
			HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)); --displays
end entity;

architecture Behavior of part3 is
	-- counter sincrono
	component counterN is
		generic (N : natural);
		port
		(
			En, Clr, Clk : in std_logic;
			overflow : out std_logic;
			Q : out unsigned(N-1 downto 0)
		);			
	end component;
	
	component hexadecimal_ssd_decoder is
	port (c : in std_logic_vector(3 downto 0);
		  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Q_std : std_logic_vector(15 downto 0);
	
begin
	-- a differenza di part2 usiamo un solo counter
	counter : counterN
		generic map (N => 16)
		port map (En => SW(1), Clr => SW(0), clk => KEY(0), std_logic_vector(Q) => Q_std);
	
	-- print del risultato
	DEC0 : hexadecimal_ssd_decoder port map (c => Q_std(3 downto 0), dec => HEX0);
	DEC1 : hexadecimal_ssd_decoder port map (c => Q_std(7 downto 4), dec => HEX1);
	DEC2 : hexadecimal_ssd_decoder port map (c => Q_std(11 downto 8), dec => HEX2);
	DEC3 : hexadecimal_ssd_decoder port map (c => Q_std(15 downto 12), dec => HEX3);
	
end architecture;