library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity nbitcounter is
	generic (N : integer := 2); --default two bit counter
	port (En, Clr, Clk : in std_logic;
			Q : buffer std_logic_vector(N-1 downto 0));
end entity;

architecture Behavior of nbitcounter is
	component flipflop IS
	PORT (D, Clock, Resetn : IN STD_LOGIC;
		Q : OUT STD_LOGIC);
	END component;
	
	signal Clrn : std_logic;
	signal Enable_Vec : std_logic_vector(0 to N);
	signal Toggle : std_logic_vector(0 to N-1);
	
begin
	Clrn <= not Clr;
	Enable_Vec(0) <= En;
	
	DFF_loop : 
	for i in 0 to N-1 generate
		DFF : flipflop port map (D => Toggle(i), Clock => Clk, Resetn => Clrn, Q => Q(i));
		Toggle(i) <= Enable_Vec(i) xor Q(i);
		Enable_Vec(i+1) <= Enable_Vec(i) and Q(i);
	end generate;
end architecture;