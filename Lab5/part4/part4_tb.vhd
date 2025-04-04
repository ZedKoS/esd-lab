library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part5_tb is
end entity part5_tb;

architecture Behavior of part5_tb is
    component part5 is
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
    DUT: part5 port map (CLOCK_50 => clock, KEY => key,
        HEX0 => hexs(0), HEX1 => hexs(1), HEX2 => hexs(2), HEX3 => hexs(3), HEX4 => hexs(4), HEX5 => hexs(5));

    CLOCK_PROC: process
    begin
        clock <= '0', '1' after 10 ns;
        wait for 20 ns;
    end process CLOCK_PROC;

    sync_reset <= '1', '0' after 15 ns, '1' after 12000 ms;
end architecture Behavior;
