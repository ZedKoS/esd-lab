library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Counter sincrono a N bit con reset asincrono
entity CounterN is
	generic (N : natural);
	port
	(
		Enable, Clock : in std_logic;
        AsyncReset : in std_logic := '0';
        DataLoad : in unsigned(N-1 downto 0) := to_unsigned(0, N);
        Load : in std_logic;
		Overflow : out std_logic;
		Count : buffer unsigned(N-1 downto 0)
	);			
end entity;

architecture Behavior of CounterN is
begin
	process (Clock, AsyncReset)
	begin
		if AsyncReset = '1' then
			Count <= (others => '0');
			Overflow <= '0';

		elsif rising_edge(Clock) then
            if Load = '1' then
                Count <= DataLoad;
			elsif Enable = '1' then
				if Count = to_unsigned(2**N - 1, N) then
					Overflow <= '1';
				else
					Overflow <= '0';
				end if;

				Count <= Count + 1;
			end if;
		end if;
	end process;
end architecture;
