library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_tb is
end entity;

architecture Behavior of filter_tb is
    constant WORD_SIZE : natural := 8;

    signal Clock, AsyncReset, SyncReset : std_logic;
    signal Start, Done : std_logic;

    signal Error : signed(WORD_SIZE-1-1 downto 0);
    signal Turn : std_logic;
    
    signal DataIn_B : std_logic_vector(WORD_SIZE-1 downto 0);

    signal PowerAlarm : std_logic;

begin
    DUT: entity work.Filter
    generic map (
      WORD_SIZE => WORD_SIZE
    )
    port map (
      Clock      => Clock,
      AsyncReset => AsyncReset,
      Start      => Start,
      Done       => Done,
      SyncReset  => SyncReset,
      Error_In   => std_logic_vector(Error),
      Turn_In    => Turn,
      DataOut    => DataIn_B,
      PowerAlarm => PowerAlarm
    );

    CLOCK_PROC: process
    begin
        Clock <= '1', '0' after 5 ns;
        wait for 10 ns;
    end process CLOCK_PROC;

    AsyncReset <= '0', '1' after 13 ns, '0' after 18 ns;
    SyncReset <= '0', '1' after 127 ns, '0' after 133 ns;

    Start <= '1' after 27.5 ns, '0' after 97.5 ns, '1' after 113 ns, '0' after 123 ns, '1' after 197 ns, '0' after 203 ns;

    Error <= to_signed(56, WORD_SIZE-1), to_signed(20, WORD_SIZE-1) after 117 ns, to_signed(10, WORD_SIZE-1) after 203 ns;
    Turn <= '0';
end architecture;
