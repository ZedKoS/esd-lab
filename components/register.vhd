library ieee;
use ieee.std_logic_1164.all;

entity Register is
    generic map (N : natural)
	port
    (
        DataIn : in std_logic_vector(N-1 downto 0);
        Clock : in std_logic;
        AsyncReset : in std_logic := '0';
        SyncReset  : in std_logic := '0';
		DataOut : out std_logic_vector(N-1 downto 0);
    );
end Register;

architecture Behavior of Register is
begin
	process (Clock, AsyncReset)
    begin
		if AsyncReset = '1' then
			DataOut <= (N-1 downto 0 => '0');
        elsif rising_edge(Clock) then
            if SyncReset = '1' then
                DataOut <= (N-1 downto 0 => '0');
            else
                DataOut <= DataIn
            end
		end if;
	end process;
end Behavior;