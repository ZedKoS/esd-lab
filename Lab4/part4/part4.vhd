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
				Q : buffer std_logic_vector(N-1 downto 0));
	end component;
	
	component hexadecimal_ssd_decoder is
		port (c : in std_logic_vector(3 downto 0);
			  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Enable_vec : std_logic_vector(0 to 13);
	signal Q_out : std_logic_vector(25 downto 0);
	signal Clk, Reset, En : std_logic;
begin
	Reset <= SW(0);
	Counter : nbitcounter generic map (N => 26)
				port map (En => SW(1), Clr => Reset, Clk => CLOCK_50, Q => Q_out);
	DEC0 : hexadecimal_ssd_decoder port map (c => Q_out(25 downto 22), dec => HEX0);
end architecture;