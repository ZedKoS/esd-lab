library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_tb is
end entity;

architecture Behavior of timer_tb is
    component Timer is
        generic (N : natural);
        port (
            Enable, Clock, AsyncReset : in std_logic;
            EndCount : in unsigned(N-1 downto 0);
            LoadEndCount : in std_logic;
            Count : buffer unsigned(N-1 downto 0);
            Done : buffer std_logic;
            Wrap : buffer std_logic
        );
    end component Timer;
    
    signal Clock, Enable, AsyncReset, LoadEndCount : std_logic;
    signal Done, Wrap : std_logic;
    signal Count : unsigned(7 downto 0);

begin
    DUT: Timer
        generic map (N => 8)
        port map (Enable => Enable, Clock => Clock, AsyncReset => AsyncReset,
            EndCount => to_unsigned(10, 8), LoadEndCount => LoadEndCount,
            Count => Count, Done => Done, Wrap => Wrap);
    
    CLOCK_PROC: process
    begin
        Clock <= '0', '1' after 10 ns;
        wait for 20 ns;
    end process CLOCK_PROC;

    AsyncReset <= '1', '0' after 43 ns;
    Enable <= '1';
    LoadEndCount <= '0', '1' after 22 ns, '0' after 33 ns, '1' after 45 ns, '0' after 55 ns;
end architecture Behavior;