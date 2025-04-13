library ieee;
use ieee.std_logic_1164.all;

-- Simple register

entity Reg is
    generic (N : natural);
	port
    (
        Enable : in std_logic;
        Clock : in std_logic;
        AsyncReset : in std_logic := '0';
        SyncReset  : in std_logic := '0';
        DataIn : in std_logic_vector(N-1 downto 0);
		DataOut : out std_logic_vector(N-1 downto 0)
    );
end Reg;

architecture Behavior of Reg is
begin
	process (Clock, AsyncReset)
    begin
		if AsyncReset = '1' then
			DataOut <= (N-1 downto 0 => '0');
        elsif rising_edge(Clock) then
            if SyncReset = '1' then
                DataOut <= (N-1 downto 0 => '0');
            elsif Enable = '1' then
                DataOut <= DataIn;
            end if;
		end if;
	end process;
end Behavior;