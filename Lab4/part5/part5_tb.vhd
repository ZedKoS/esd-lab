library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part5_tb is
end entity part5_tb;

architecture Behavior of part5_tb is
    component part5 is
        port (
            CLOCK_50 : in std_logic;

            -- Numero di millisecondi prima che si accenda LEDR[0]
            SW   : in std_logic_vector(9 downto 0);

            -- KEY: active-low
            -- KEY[0]: (not) reset; KEY[3]: (not) react
            KEY  : in std_logic_vector(3 downto 0);

            LEDR : out std_logic_vector(0 to 0);

            HEX0 : out std_logic_vector(0 to 6);
            HEX1 : out std_logic_vector(0 to 6);
            HEX2 : out std_logic_vector(0 to 6);
            HEX3 : out std_logic_vector(0 to 6)
        );
    end component;

    signal clock, async_reset, react : std_logic;
    signal led : std_logic_vector(0 to 0);
    signal countdown : unsigned(9 downto 0);

    signal hex0, hex1, hex2, hex3: std_logic_vector(0 to 6);

    signal key : std_logic_vector(3 downto 0);

begin
    key <= (not react, 'U', 'U', not async_reset);

    DUT: part5
        port map (CLOCK_50 => clock, SW => std_logic_vector(countdown), KEY => key, LEDR => led,
            HEX0 => hex0, HEX1 => hex1, HEX2 => hex2, HEX3 => hex3);

    -- 10 ms di attesa prima di accendere il led
    countdown <= to_unsigned(10, countdown'length);

    CLOCK_PROC: process
    begin
        clock <= '0', '1' after 10 ns;
        wait for 20 ns;
    end process CLOCK_PROC;

    async_reset <= '1', '0' after 6 ns, '1' after 40 ms, '0' after 41 ms;

    react <= '0', '1' after 32 ms, '0' after 33 ms;

end architecture Behavior;