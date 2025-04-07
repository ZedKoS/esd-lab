library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
	generic (NEGATED : boolean := false);
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
			Q <= '1' when NEGATED else '0';
        elsif rising_edge(Clock) then
			if SyncReset = '1' then
				Q <= '1' when NEGATED else '0';
			else
				Q <= D;
			end if;
		end if;
	end process;
end Behavior;