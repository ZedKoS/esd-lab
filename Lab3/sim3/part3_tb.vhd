library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part3_tb is
end entity;

architecture beh of part3_tb is
	component part3 is
		port (
			A, B : in signed(63 downto 0);
			clock, resetn : in std_logic;
			S : out signed(63 downto 0);
			overflow : out std_logic
		);
	end component;
 
	signal inputA, inputB, sum : signed(63 downto 0);
	signal resetn, ck, overflow : std_logic;
	
begin	
	DUT: part3 port map (A => inputA, B => inputB, S => sum, clock => ck, resetn => resetn, overflow => overflow);
	
	resetn <= '0', '1' after 12 ns;
	process
	begin
		ck <= '0', '1' after 5 ns;
		wait for 10 ns;
	end process;
	
	process
	begin
		wait for 3 ns;
		for i in 0 to 64 loop
			inputA <= to_signed(i, 64);
			inputB <= to_signed(i*2 + 1, 64);
			wait for 10 ns;
		end loop;
	end process;
end architecture;

configuration Use_RCA_tb of part3_tb is
	for beh
		for DUT: part3
			use configuration work.Use_RCA;
		end for;
	end for;
end configuration;

configuration Use_CSA_tb of part3_tb is
	for beh
		for DUT: part3
			use configuration work.Use_CSA;
		end for;
	end for;
end configuration;
