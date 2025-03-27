library ieee;
use ieee.std_logic_1164.all;

entity part2 is
	port (KEY : in std_logic_vector(0 to 0); --manual clock
			SW : in std_logic_vector(1 downto 0); --sw0 reset, sw1 enable
			HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)); --displays
end entity;

architecture Behavior of part2 is
	component counter4 is
	port (En, Clr, Clk : in std_logic;
			Q : out std_logic_vector(3 downto 0);
			outputCarry : out std_logic);
	end component;
	
	component hexadecimal_ssd_decoder is
	port (c : in std_logic_vector(3 downto 0);
		  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Enable_vec : std_logic_vector(0 to 4);
	signal Q : std_logic_vector(15 downto 0);
	signal Clk, Reset, En : std_logic;
begin
	En <= SW(1);
	Reset <= SW(0);
	Enable_vec(0) <= En;
	Clk <= KEY(0);

	Counter_loop:
	for i in 0 to 3 generate
		Counter : counter4 port map (En => Enable_vec(i), Clr => Reset, Clk => Clk, Q => Q(4*i+3 downto 4*i),
														outputCarry => Enable_vec(i+1));
	end generate;

	DEC0 : hexadecimal_ssd_decoder port map (c => Q(3 downto 0), dec => HEX0);
	DEC1 : hexadecimal_ssd_decoder port map (c => Q(7 downto 4), dec => HEX1);
	DEC2 : hexadecimal_ssd_decoder port map (c => Q(11 downto 8), dec => HEX2);
	DEC3 : hexadecimal_ssd_decoder port map (c => Q(15 downto 12), dec => HEX3);
end architecture;