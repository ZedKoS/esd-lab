library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_tb is
end entity;

architecture Behavior of system_tb is
  signal AsyncReset, Clock, Start, Done, PowerAlarm : std_logic;
  signal DataIn : std_logic_vector(7 downto 0);
begin
    CNTRL : entity work.ControlSystem
    generic map (
      WORD_SIZE => 8,
      ADDRESS_SIZE => 3
    )
    port map (
        ASyncreset => ASyncreset,
        Clock => Clock,
        Start => Start,
        Done => Done,
        DataIn => DataIn,
        PowerAlarm => PowerAlarm
    );

    CLK_PROC:
    process
    begin
        Clock <= '0', '1' after 5 ns;
        wait for 10 ns;
    end process;

    AsyncReset <= '0', '1' after 2 ns, '0' after 3 ns;

    Start <= '0', '1' after 13 ns;
    DataIn <= "00000000", "10101010" after 6 ns, "01010101" after 16 ns, "11111111" after 26 ns, "11110000" after 31 ns, "00001111" after 46 ns;
end architecture;