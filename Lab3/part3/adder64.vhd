library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity adder64 is
	port(
		A, B : in std_logic_vector(63 downto 0);
		S : out std_logic_vector(63 downto 0);
		cin : in std_logic;
		cout : out std_logic
	);
end entity;