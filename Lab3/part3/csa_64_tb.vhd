library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity csa_64_tb is
end entity;

architecture beh of csa_64_tb is

	component csa_64 is
		port(
		A, B : in std_logic_vector(63 downto 0);
		cin : in std_logic;
		key : in std_logic_vector(0 to 1);
		S : out std_logic_vector(63 downto 0);
		cout : buffer std_logic);
	end component;
 
signal inputA, inputB, sum : std_logic_vector(63 downto 0);
signal reset, ck, overflow : std_logic;
signal ciniz : std_logic;
begin
	inputA <= (63 downto 5 => '0', others=> '1'), (63 downto 0 => '1') after 10 ns; 
	inputB <= (63 downto 5 => '0', others=> '1');
	ciniz <= '0', '1' after 3 ns;
	ck <= '1', '0' after 3 ns, '1' after 6 ns, '0' after 9 ns, '1' after 12 ns;
	reset <= '0', '1' after 6 ns;
	CSA: csa_64 port map (A => inputA, B => inputB, cin => ciniz, KEY(0) => reset, KEY(1) => ck, cout => overflow, S => sum);
end architecture;

