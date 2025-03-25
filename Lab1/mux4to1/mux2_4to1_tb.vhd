LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4to1_tb IS
END mux4to1_tb;

ARCHITECTURE Behavior OF mux4to1_tb IS
	COMPONENT mux4to1
		PORT (SW: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		      LEDR: OUT STD_LOGIC_VECTOR (9 DOWNTO 0));
	END COMPONENT;

	SIGNAL u, v, w: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL s: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL output: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL input: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	MUX: mux4to1 port map (SW => input, LEDR => output);
	u <= "10", "00" after 1 us, "11" after 3 us;
	v <= "01", "00" after 2 us, "11" after 4 us;
	w <= "10", "00" after 1.5 us, "11" after 3.5 us;
	s <= "01", "00" after 2.5 us, "11" after 4.5 us;
	input(1 downto 0) <= s;
	input(7 downto 6) <= u;
	input(5 downto 4) <= v;
	input(3 downto 2) <= w;
end Behavior;


 