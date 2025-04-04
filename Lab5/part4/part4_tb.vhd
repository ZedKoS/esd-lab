library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part4_tb is
end entity part4_tb;

architecture Behavior of part4_tb is
    component part4 is
        generic (TICK_TIME : natural);
        port (
            CLOCK_50 : in std_logic;

            -- KEY[0]: active-low sync reset
            KEY  : in std_logic_vector(0 to 0);

            HEX0 : out std_logic_vector(0 to 6);
            HEX1 : out std_logic_vector(0 to 6);
            HEX2 : out std_logic_vector(0 to 6);
            HEX3 : out std_logic_vector(0 to 6);
            HEX4 : out std_logic_vector(0 to 6);
            HEX5 : out std_logic_vector(0 to 6)
        );
    end component;

    signal clock, sync_reset : std_logic;

    type tape_t is array(natural range <>) of std_logic_vector;
    signal hexs : tape_t(5 downto 0)(0 to 6);

    signal key : std_logic_vector(0 to 0);

begin
    key(0) <= not sync_reset;
    DUT: part4
        generic map (TICK_TIME => 50)
        port map (CLOCK_50 => clock, KEY => key,
            HEX0 => hexs(0), HEX1 => hexs(1), HEX2 => hexs(2), HEX3 => hexs(3), HEX4 => hexs(4), HEX5 => hexs(5));

    CLOCK_PROC: process
    begin
        clock <= '0', '1' after 10 ns;
        wait for 20 ns;
    end process CLOCK_PROC;

    sync_reset <= '0', '1' after 7 ns, '0' after 25 ns, '1' after 12 us, '0' after 13 us;
end architecture Behavior;
