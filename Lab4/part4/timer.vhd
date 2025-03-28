library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (N : natural);
    port (
        Enable, Clock, Clear : in std_logic;
        EndCount : in unsigned(N-1 downto 0);
        Count : buffer unsigned(N-1 downto 0);
        Done : buffer std_logic
    );
end entity timer;

architecture Behavior of timer is
	component counterN is
        generic (N : natural);
        port
        (
            Enable, Reset, Clock : in std_logic;
            Overflow : out std_logic;
            Q : buffer unsigned(N-1 downto 0)
        );			
	end component;

    component flipflop IS
        port (D, Clock, Resetn : in std_logic;
            Q : out std_logic);
    end component;

    signal clear_or_wrap : std_logic;
    signal sync_reset : std_logic;

begin
    SyncReset: flipflop
        port map (D => clear_or_wrap, Clock => Clock, Resetn => '1', Q => sync_reset);

    Counter: counterN
        generic map (N => N)
        port map (Enable => Enable, Reset => sync_reset, Clock => Clock, Overflow => open, Q => Count);
    
    Done <= '1' when Count = EndCount else '0';
    clear_or_wrap <= Clear or (Done and Enable);

end architecture Behavior;