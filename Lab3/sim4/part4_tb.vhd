LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part4_tb is
end entity;

architecture behavior of part4_tb is
	component multiplier is
		port
		(
			x, y	: in	std_logic_vector(3 downto 0);
			z	: out	std_logic_vector(7 downto 0)
		);
	end component;

	signal x, y : std_logic_vector(3 downto 0);
	signal z : std_logic_vector(7 downto 0);
begin
	MULT: part4 port map (x, y, z);
	process
	begin
		for i in 0 to 15 loop
			x <= std_logic_vector(to_unsigned(i, x'length));
			for j in 0 to 15 loop
				y <= std_logic_vector(to_unsigned(j, y'length));
				wait for 1 ns;
			end loop;
			wait for 1 ns;
		end loop;
	end process;
end architecture;