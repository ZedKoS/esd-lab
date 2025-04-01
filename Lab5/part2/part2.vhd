library ieee;
use ieee.std_logic_1164.all;

entity part2 is
	port (SW : in std_logic_vector(1 downto 0); --sw0 for reset_n, sw1 for input
			KEY : in std_logic_vector(0 downto 0); --key0 for manual clock
			LEDR : out std_logic_vector(9 downto 0)); --ledr9 for output, ledr0-8 for state output
end entity;

architecture Beh of part2 is

component DFlipFlop is
	port
    (
        D, Clock   : in std_logic;
        AsyncReset : in std_logic := '0';
        SyncReset  : in std_logic := '0';
		  Q : out std_logic
    );
end component;

signal SyncReset, z, w, Clock : std_logic;
signal y, D_vec : std_logic_vector(8 downto 0);

begin
	SyncReset <= not SW(0);
	Clock <= KEY(0);
	w <= SW(1);
	z <= y(4) or y(8);
	LEDR(8 downto 0) <= y;
	LEDR(9) <= z;

	A : DFlipFlop port map (D => '1', Clock => Clock, syncReset => syncreset, Q => y(0));

	D_vec(1) <= (y(0) and not w) xor ((y(1) or y(2) or y(3) or y(4)) or ((y(5) and not w) or (y(6) and not w) or (y(7) and not w) or (y(8) and not w)));
	B : DFlipFlop port map (D => D_vec(1), Clock => Clock, syncReset => SyncReset, Q => y(1));
	
	D_vec(2) <= y(1) and not w;
	C : DFlipFlop port map (D => D_vec(2), Clock => Clock, syncReset => SyncReset, Q => y(2));

	D_vec(3) <= y(2) and not w;
	D : DFlipFlop port map (D => D_vec(3), Clock => Clock, syncReset => SyncReset, Q => y(3));
	
	D_vec(4) <= (y(3) and not w) or (y(4) and not w);
	E : DFlipFlop port map (D => D_vec(4), Clock => Clock, syncReset => SyncReset, Q => y(4));

	D_vec(5) <= (y(0) and w) xor ((y(5) or y(6) or y(7) or y(8)) or ((y(1) and w) or (y(2) and w) or (y(3) and w) or (y(4) and w)));
	F : DFlipFlop port map (D => D_vec(5), Clock => Clock, syncReset => SyncReset, Q => y(5));

	D_vec(6) <= y(5) and w;
	G : DFlipFlop port map (D => D_vec(6), Clock => Clock, syncReset => SyncReset, Q => y(6));

	D_vec(7) <= y(6) and w;
	H : DFlipFlop port map (D => D_vec(7), Clock => Clock, syncReset => SyncReset, Q => y(7));
	
	D_vec(8) <= (y(7) and w) or (y(8) and w);
	I : DFlipFlop port map (D => D_vec(8), Clock => Clock, syncReset => SyncReset, Q => y(8));
	
end architecture;