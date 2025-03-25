library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part3_tb is
end entity;

architecture Behavior of part3_tb is
	component part3 is
		port(SW : in std_logic_vector(3 downto 0);
			HEX0, HEX1 : out std_logic_vector(0 to 6));
	end component;

	signal input: std_logic_vector(3 downto 0);
	signal d0, d1: std_logic_vector(0 to 6);		
begin
	process
	begin
		for i in 0 to 15 loop
			input <= std_logic_vector(to_unsigned(i, input'length));
			-- input <= "0000", "1000" after 1 ns, "1010" after 2 ns,
				-- "1111" after 3 ns, "1001" after 4 ns;
			wait for 1 ns;
		end loop;
	end process;
	
	--0, 8, 10, 15, 9
	display: part3 port map (SW => input,
		HEX0 => d0, HEX1 => d1);
end architecture;
		
