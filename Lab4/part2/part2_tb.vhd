library ieee;
use ieee.std_logic_1164.all;

entity part2_tb is
end entity;

architecture Behavior of part2_tb is

	component lab4part2 is
		port (KEY : in std_logic_vector(0 to 0); --manual clock
			SW : in std_logic_vector(1 downto 0); --sw0 activelow reset, sw1 enable
			HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)); --displays
	end component;

	signal output0, output2, output3, output1 : std_logic_vector(0 to 6);
	signal Reset, En : std_logic;
	signal clk : std_logic_vector(0 to 0);
begin

	En <= '0', '1' after 5 ns;

	Reset <= '0', '1' after 30 ns;

	test : lab4part2 port map (KEY => Clk, SW(0) => Reset, SW(1) => en, HEX0 => output0, 
		HEX1 => output1, HEX2 => output2, HEX3 => output3);
	
	process

		begin
    		
    			clk <= "0", "1" after 2 ns;
    			wait for 4 ns;  

	end process;
end architecture;
