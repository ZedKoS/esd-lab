library ieee;
use ieee.std_logic_1164.all;

entity part3_tb is
end entity;

architecture Behavior of part3_tb is
	component part3 is
		port (KEY : in std_logic_vector(0 to 0); --manual clock
			SW : in std_logic_vector(1 downto 0); --sw0 reset, sw1 enable
			HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(0 to 6)); --displays
	end component;

	signal output0, output2, output3, output1 : std_logic_vector(0 to 6);
    signal KEY : std_logic_vector(0 to 0);
	signal Reset, En, Clk : std_logic;

begin
    KEY(0) <= Clk;
	test : part3 port map (KEY => KEY, SW(0) => Reset, SW(1) => En, HEX0 => output0, 
		HEX1 => output1, HEX2 => output2, HEX3 => output3);

	process
	begin
		Clk <= '0', '1' after 5 ns;
		wait for 10 ns;  
	end process;

	Reset <= '0', '1' after 10 ns, '0' after 80 ns;
	En <= '0', '1' after 20 ns;
end architecture;
