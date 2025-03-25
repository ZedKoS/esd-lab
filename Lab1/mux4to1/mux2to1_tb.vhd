LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2to1_tb IS
END mux2to1_tb;

ARCHITECTURE Behavior OF mux2to1_tb IS
	COMPONENT mux2to1
		PORT (SW: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		      LEDR: OUT STD_LOGIC_VECTOR (9 DOWNTO 0));
	END COMPONENT;

	SIGNAL x, y: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL s: STD_LOGIC;
	SIGNAL output: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL input: STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	MUX: mux2to1 port map (SW => input, LEDR => output);
	x <= "101", "000" after 1 us, "111" after 3 us;
	y <= "010", "000" after 2 us, "111" after 4 us;
	s <= '1', '0' after 2500 ns;
	input(0) <= s;
	input(3 downto 1) <= x;
	input(6 downto 4) <= y;
end Behavior;
