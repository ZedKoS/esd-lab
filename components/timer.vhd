library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic (N : natural);
    port (
        Enable, Clock, AsyncReset : in std_logic;
        EndCount : in unsigned(N-1 downto 0);
        LoadEndCount : in std_logic;
        Count : buffer unsigned(N-1 downto 0);
        Done : buffer std_logic;
        Wrap : buffer std_logic
    );
end entity Timer;

architecture Behavior of timer is
    signal loaded_end_count : unsigned(N-1 downto 0);
begin
    Done <= '1' when Count = loaded_end_count else '0';
    Wrap <= Done and Enable;

    TIMER_PROC: process(Clock, AsyncReset)
    begin
        if AsyncReset = '1' then
            loaded_end_count <= to_unsigned(0, N);
            Count <= to_unsigned(0, N);

        elsif rising_edge(Clock) then
            if (Wrap or LoadEndCount) = '1' then
                Count <= to_unsigned(0, N);
                
                if LoadEndCount = '1' then
                    loaded_end_count <= EndCount;
                end if;
            elsif Enable = '1' then
                Count <= Count + 1;
            end if;
        end if;
    end process TIMER_PROC;
end architecture Behavior;
