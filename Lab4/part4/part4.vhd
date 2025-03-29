library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part4 is
	port (CLOCK_50 : in std_logic; --board clock
			SW : in std_logic_vector(1 downto 0); --sw0 reset, sw1 enable
			HEX0 : out std_logic_vector(0 to 6)); --display
end entity;

architecture Behavior of part4 is
	component Timer is
		generic (N : natural);
		port (
			Enable, Clock, AsyncReset : in std_logic;
			EndCount : in unsigned(N-1 downto 0);
			Count : buffer unsigned(N-1 downto 0);
			Done : buffer std_logic;
			Wrap : buffer std_logic
		);
	end component;

	component counterN is
		generic (N : natural);
		port
		(
			Enable, Clear, Clock : in std_logic;
			Overflow : out std_logic;
			Q : buffer unsigned(N-1 downto 0)
		);			
	end component;
	
	component hexadecimal_ssd_decoder is
		port (c : in std_logic_vector(3 downto 0);
			  dec : out std_logic_vector(0 to 6));
	end component;
	
	signal Reset, En : std_logic;
	signal inc_digit : std_logic;
	signal digit : std_logic_vector(3 downto 0);

begin
	Reset <= SW(0);
	En <= SW(1);

	TIM: timer
		generic map (N => 26)
		port map (Enable => En, Clock => CLOCK_50, AsyncReset => Reset,
			EndCount => to_unsigned(50_000_000, 26), Done => open, Wrap => inc_digit, Count => open);
	
	SecCounter: timer
		generic map (N => 4)
		port map (Enable => inc_digit, Clock => CLOCK_50, AsyncReset => Reset,
			EndCount => to_unsigned(9, 4), Done => open, Wrap => open, std_logic_vector(Count) => digit);
	
	-- Lo utilizziamo con cifre 0-9 anche se supporta 0-15
	Display: hexadecimal_ssd_decoder
		port map (c => digit, dec => HEX0);
end architecture;