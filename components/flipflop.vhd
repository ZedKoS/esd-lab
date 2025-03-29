library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
	port
    (
        D, Clock   : in std_logic;
        AsyncReset : in std_logic := '0';
        SyncReset  : in std_logic := '0';
		Q : out std_logic
    );
end DFlipFlop;

architecture Behavior of DFlipFlop is
begin
	process (Clock, AsyncReset)
    begin
		if AsyncReset = '1' then
			Q <= '0';
        elsif rising_edge(Clock) then
			Q <= D and not SyncReset;
		end if;
	end process;
end Behavior;