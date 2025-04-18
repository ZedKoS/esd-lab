library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter4 is
	port (En, Clr, Clk : in std_logic;
			Q : buffer std_logic_vector(3 downto 0);
			outputCarry : out std_logic);
end entity;

architecture Behavior of counter4 is
	component flipflop IS
	PORT (D, Clock, Resetn : IN STD_LOGIC;
		Q : OUT STD_LOGIC);
	END component;
	
	signal nClr : std_logic;
	signal Enable_Vec : std_logic_vector(0 to 4);
	signal Toggle : std_logic_vector(0 to 3);
	
begin
	nClr <= not Clr;
	Enable_Vec(0) <= En;
	
	DFF_loop : 
	for i in 0 to 3 generate
		DFF : flipflop port map (D => Toggle(i), Clock => Clk, Resetn => nClr, Q => Q(i));
		Toggle(i) <= Enable_Vec(i) xor Q(i);
		Enable_Vec(i+1) <= Enable_Vec(i) and Q(i);
	end generate;
	
	outputCarry <= Enable_Vec(4);
end architecture;