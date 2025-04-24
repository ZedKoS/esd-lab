library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity system_tb is
end entity;

architecture Behavior of system_tb is
  constant WORD_SIZE : natural := 8;
  constant ADDRESS_SIZE : natural := 4;

  signal AsyncReset, Clock, Start, Done, PowerAlarm : std_logic;
  signal DataIn : std_logic_vector(7 downto 0);

  type mem_array_t is array (natural range <>) of std_logic_vector(WORD_SIZE-1 downto 0);
  file MEM_A_FILE : text open read_mode is "MEM_A.txt";

begin
    DUT : entity work.ControlSystem
    generic map (
      WORD_SIZE => WORD_SIZE,
      ADDRESS_SIZE => ADDRESS_SIZE
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
        Clock <= '1', '0' after 5 ns;
        wait for 10 ns;
    end process;

    AsyncReset <= '0', '1' after 2 ns, '0' after 3 ns;

    Start <= '0', '1' after 15 ns, '0' after 1.8 us;
    
    READ_MEM_A: process
      variable line_in : line;
      variable value : integer;
    begin
        wait for 25 ns;

        while not endfile(MEM_A_FILE) loop
            readline(MEM_A_FILE, line_in);
            read(line_in, value);
            DataIn <= std_logic_vector(to_signed(value, WORD_SIZE));  -- convert to signed vector
            wait for 10 ns;
        end loop;

        wait;  -- end process
    end process READ_MEM_A;

end architecture;