library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_tb is
end entity;
architecture Behavior of system_tb is

component ControlSystem is
  generic (
    WORD_SIZE: natural := 8;
    ADDRESS_SIZE: natural := 10
  );

  port (
    AsyncReset : in std_logic;
    Clock   : in  std_logic;
    Start   : in  std_logic;
    Done    : out std_logic;
    DataIn  : in  std_logic_vector(WORD_SIZE-1 downto 0);
    PowerAlarm : out std_logic
  );
end component;
signal AsyncReset, Clock, Start, Done, PowerAlarm : std_logic;
signal DataIn : std_logic_vector(7 downto 0);
begin
    CNTRL : ControlSystem generic map (8, 10) port map(
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
    AsyncReset <= '0', '1' after 2 ns, '0' after 3 ns, '1' after 81 ns, '0' after 82 ns;
    Start <= '0', '1' after 4 ns, '0' after 61 ns;
    DataIn <= "00000000", "10101010" after 6 ns, "01010101" after 16 ns, "11111111" after 26 ns, "11110000" after 31 ns, "00001111" after 46 ns;
end architecture;