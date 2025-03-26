library ieee;
use ieee.std_logic_1164.all;

entity part4 is
	port (CLOCK_50 : in std_logic; --board clock
			SW : in std_logic_vector(1 downto 0); --sw0 activelow reset, sw1 enable
			HEX0 : out std_logic_vector(0 to 6)); --display
end entity;

architecture Behavior of part4 is
	
	component nbitcounter is
		generic (N : integer := 2); --default two bit counter
		port (En, Clr, Clk : in std_logic;
				Q : buffer std_logic_vector(N-1 downto 0);
				outputCarry : out std_logic);
	end component;
	
	component fourbitcounter is
		port (En, Clr, Clk : in std_logic;
				Q : out std_logic_vector(3 downto 0);
				outputCarry : out std_logic);
	end component;
	
	component hexadecimal_ssd_decoder is
		port (c : in std_logic_vector(3 downto 0);
			  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Enable_vec : std_logic_vector(0 to 13);
	signal Q : std_logic_vector(25 downto 0);
	signal Clk, Reset, En : std_logic;
begin
	En <= SW(1);
	Reset <= SW(0);
	Enable_vec(0) <= En;
	Counter_loop:
	for i in 0 to 12 generate
		Counter : nbitcounter port map (En => Enable_vec(i), Clr => Reset, Clk => CLOCK_50, Q => Q(2*i+1 downto 2*i),
														outputCarry => Enable_vec(i+1));
	end generate;
	
	DEC0 : hexadecimal_ssd_decoder port map (c => Q(25 downto 22), dec => HEX0);
end architecture;