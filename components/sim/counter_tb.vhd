library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity;

architecture Beh of counter_tb is
component CounterN is
	generic (N : natural);
	port
	(
		Enable, Clock : in std_logic;
        AsyncReset : in std_logic := '0';
        DataLoad : in unsigned(N-1 downto 0) := to_unsigned(0, N);
        Load : in std_logic;
		Overflow : out std_logic;
		Count : buffer unsigned(N-1 downto 0)
	);			
end component;
signal clock, Enable, AsyncReset, Load, Overflow : std_logic;
signal DataLoad, Count : unsigned(3 downto 0);
begin
    CLK_PROC:
    process
    begin
        clock <= '1', '0' after 5 ns;
        wait for 10 ns;
    end process;
    AsyncReset <= '0', '1' after 1 ns, '0' after 2 ns;
    Enable <= '0', '1' after 4 ns, '0' after 29 ns, '1' after 44 ns;
    DataLoad <= "0111";
    Load <= '1', '0' after 12 ns;
    cntr : CounterN generic map (N=>4) port map (
        Enable => Enable,
        Clock => Clock,
        AsyncReset => AsyncReset,
        DataLoad => DataLoad,
        Load => Load,
        Overflow => Overflow,
        Count => Count
    );
end architecture;