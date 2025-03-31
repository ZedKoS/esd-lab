--Write a VHDL file that instantiates the 9 flip-flops and specifies the logic expressions 
--that drive the flip-flop input ports.
--Use only simple assignment statements in your VHDL code to specify the logic feeding the flip-flops.
--Note that the one-hot code enables you to derive these expressions by inspection. 
--Use the toggle switch SW0 on the Altera DE1-SOC board as an active-low synchronous reset input for the FSM,
--use SW1 as the w input, and the push button KEY0 as the clock input which is applied manually.
--Use the red LED LEDR9 as the output z, and assign the state flip-flop outputs to the red LEDs LEDR8 to LEDR0
library ieee;
use ieee.std_logic_1164.all;

entity lab5part1 is
	port (SW : in std_logic_vector(1 downto 0); --sw0 for reset_n, sw1 for input
			KEY : in std_logic_vector(0 downto 0); --key0 for manual clock
			LEDR : out std_logic_vector(9 downto 0)); --ledr9 for output, ledr0-8 for state output
end entity;

architecture Beh of lab5part1 is

component DFlipFlop is
	port
    (
        D, Clock   : in std_logic;
        AsyncReset : in std_logic := '0';
        SyncReset  : in std_logic := '0';
		  Q : out std_logic
    );
end component;

signal ASyncReset, z, w, Clock : std_logic;
signal Q : std_logic_vector(8 downto 0);

begin
	ASyncReset <= not SW(0);
	Clock <= KEY(0);
	w <= SW(1);
	z <= Q(4) or Q(8);
	LEDR(8 downto 0) <= Q;
	LEDR(9) <= z;
	
	A : DFlipFlop port map (D => Q(1) and Q(2) and Q(3) and Q(4) and Q(5) and Q(6) and Q(7) and Q(8),
								Clock => Clock, AsyncReset => ASyncReset, Q => Q(0));
	B : DFlipFlop port map (
		D => (Q(0) and not w) or (Q(5) and not w) or (Q(6) and not w) or (Q(7) and not w) or (Q(8) and not w),
								Clock => Clock, AsyncReset => ASyncReset, Q => Q(1));
	C : DFlipFlop port map (D => Q(1) and not w, Clock => Clock, AsyncReset => ASyncReset, Q => Q(2));
	D : DFlipFlop port map (D => Q(2) and not w, Clock => Clock, AsyncReset => ASyncReset, Q => Q(3));
	E : DFlipFlop port map (D => (Q(3) and not w) or (Q(4) and not w), Clock => Clock, AsyncReset => ASyncReset, Q => Q(4));
	F : DFlipFlop port map (
		D => (Q(0) and w) or (Q(1) and w) or (Q(2) and w) or (Q(3) and w) or (Q(4) and w), 
								Clock => Clock, AsyncReset => ASyncReset, Q => Q(5));
	G : DFlipFlop port map (D => Q(5) and w, Clock => Clock, AsyncReset => ASyncReset, Q => Q(6));
	H : DFlipFlop port map (D => Q(6) and w, Clock => Clock, AsyncReset => ASyncReset, Q => Q(7));
	I : DFlipFlop port map (D => (Q(7) and w) or (Q(8) and w), Clock => Clock, AsyncReset => ASyncReset, Q => Q(8));
	
end architecture;