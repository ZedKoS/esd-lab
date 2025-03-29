library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic (N : natural);
    port (
        Enable, Clock, AsyncReset : in std_logic;
        EndCount : in unsigned(N-1 downto 0);
        Count : buffer unsigned(N-1 downto 0);
        Done : buffer std_logic;
        Wrap : buffer std_logic
    );
end entity Timer;

architecture Behavior of timer is
	component CounterN is
        generic (N : natural);
        port
        (
            Enable, Clock : in std_logic;
            AsyncReset : in std_logic := '1';
            DataLoad : in unsigned(N-1 downto 0) := to_unsigned(0, N);
            Load : in std_logic;
            Overflow : out std_logic;
            Count : buffer unsigned(N-1 downto 0)
        );			
	end component;

    component DFlipFlop is
        port
        (
            D, Clock   : in std_logic;
            AsyncReset : in std_logic := '0';
            SyncReset  : in std_logic := '0';
            Q : out std_logic
        );
    end component;

begin
    Done <= '1' when Count = EndCount else '0';
    Wrap <= Done and Enable;

    Counter: CounterN
        generic map (N => N)
        port map (Enable => Enable, Clock => Clock, AsyncReset => AsyncReset,
            Load => Wrap, DataLoad => to_unsigned(0, N), Overflow => open, Count => Count);

end architecture Behavior;
