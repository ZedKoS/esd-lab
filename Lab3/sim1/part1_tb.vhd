--testbench del Signed Adder a 4 bit
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part1_tb is
end entity;

architecture Behavior of part1_tb is
component part1 is
	port (SW : in std_logic_vector(7 downto 0); --sw7-4 for A, sw3-0 for B
		KEY : in std_logic_vector(0 to 1); --key0 for activelow async reset, key1 for manual clk
		LEDR : out std_logic_vector(9 downto 0); --ledr9 for overflow, ledr3-0 for sum
		HEX0, HEX1, HEX2 : out std_logic_vector(0 to 6)); --hex0 for B, hex1 for A, hex2 for S
end component;

signal inputA, inputB, outputS : std_logic_vector(3 downto 0);
signal hex0, hex1, hex2 : std_logic_vector(0 to 6);
signal clock, reset, overflow : std_logic;
signal SW : std_logic_vector(7 downto 0);
signal LEDR : std_logic_vector(9 downto 0);
signal KEY : std_logic_vector(0 to 1);

begin
	SW(7 downto 4) <= inputA;
	SW(3 downto 0) <= inputB;
	KEY <= reset & clock;
	overflow <= LEDR(9);
	outputS <= LEDR(3 downto 0);

	DUT: part1 port map (SW => SW, KEY => KEY, LEDR => LEDR, HEX0 => hex0, HEX1 => hex1, HEX2 => hex2);

	reset <= '0', '1' after 12 ns;
process
begin
	clock <= '0', '1' after 5 ns;
	wait for 10 ns;
end process;
process
begin
	wait for 3 ns;
	for i in 0 to 7 loop
		inputA <= std_logic_vector(to_signed(i * 2, 4));
		inputB <= std_logic_vector(to_signed(i * 2 + 1, 4));
		wait for 10 ns;
	end loop;
end process;
end architecture;