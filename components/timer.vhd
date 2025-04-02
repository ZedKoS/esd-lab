library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic (N : natural);
    port (
        Enable, Clock, AsyncReset : in std_logic;
        EndCount : in unsigned(N-1 downto 0);
        LoadEndCount : in std_logic;
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

    component Reg is
        generic (N : natural);
        port
        (
            DataIn : in std_logic_vector(N-1 downto 0);
            Clock : in std_logic;
            AsyncReset : in std_logic := '0';
            SyncReset  : in std_logic := '0';
            DataOut : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal loaded_end_count : unsigned(N-1 downto 0);

begin
    SyncEndCount: Reg
        generic map (N => N)
        port map (DataIn => EndCount, Enable => LoadEndCount, Clock => Clock, DataOut => loaded_end_count);

    Done <= '1' when Count = EndCount else '0';
    Wrap <= Done and Enable;

    Counter: CounterN
        generic map (N => N)
        port map (Enable => Enable, Clock => Clock, AsyncReset => AsyncReset,
            Load => Wrap, DataLoad => to_unsigned(0, N), Overflow => open, Count => Count);

end architecture Behavior;
