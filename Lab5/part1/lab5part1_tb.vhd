library ieee;
use ieee.std_logic_1164.all;

entity lab5part1_tb is
end entity;

architecture Beh of lab5part1_tb is

component lab5part1 is
	port (SW : in std_logic_vector(1 downto 0); --sw0 for reset_n, sw1 for input
			KEY : in std_logic_vector(0 downto 0); --key0 for manual clock
			LEDR : out std_logic_vector(9 downto 0)); --ledr9 for output, ledr0-8 for state output
end component;

signal Clock, Reset, w : std_logic;
signal leds : std_logic_vector(9 downto 0);

begin
	Clock_process : process
			begin
				Clock <= '0', '1' after 5 ns;
				wait for 10 ns;
			end process;
	Reset <= '0', '1' after 13 ns;
	w <= '0', '1' after 14 ns, '0' after 17 ns, '1' after 71 ns, '0' after 98 ns;
	dut : lab5part1 port map (SW(0) => Reset, SW(1) => w, KEY(0) => Clock, LEDR => leds);
end architecture;
