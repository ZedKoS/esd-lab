library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_tb is
end entity;

architecture Behavior of filter_tb is
    constant WORD_SIZE : natural := 8;

    signal Clock, AsyncReset : std_logic;
    signal Start, Done : std_logic;

    signal A_DataOut : std_logic_vector(WORD_SIZE-1 downto 0);
    signal Error : signed(A_DataOut'length-1-1 downto 0);
    signal Turn : std_logic;
    
    signal DataIn_B : std_logic_vector(WORD_SIZE-1 downto 0);

    signal PowerAlarm : std_logic;

begin
    A_DataOut(7 downto 1) <= std_logic_vector(Error);
    A_DataOut(0) <= Turn;

    DUT: entity work.Filter
    generic map (
      WORD_SIZE => WORD_SIZE
    )
    port map (
      Clock      => Clock,
      AsyncReset => AsyncReset,
      Start      => Start,
      Done       => Done,
      A_DataOut  => A_DataOut,
      DataIn_B   => DataIn_B,
      PowerAlarm => PowerAlarm
    );

    CLOCK_PROC: process
    begin
        Clock <= '1', '0' after 5 ns;
        wait for 10 ns;
    end process CLOCK_PROC;

    AsyncReset <= '0', '1' after 13 ns, '0' after 18 ns;

    Start <= '1' after 27.5 ns, '0' after 97.5 ns;

    Error <= to_signed(-10, WORD_SIZE-1);
    Turn <= '1';
end architecture;
