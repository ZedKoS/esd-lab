library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Counter sincrono a N bit con reset asincrono
entity counterN is
	generic (N : natural);
	port
	(
		Enable, Reset, Clock : in std_logic;
		Overflow : out std_logic;
		Q : buffer unsigned(N-1 downto 0)
	);			
end entity;

architecture Behavior of counterN is
begin
	process (Reset, Clock)
	begin
		-- reset attivo -> resetta Q e overflow
		if Reset = '1' then
			Q <= (others => '0');
			Overflow <= '0';
		-- ogni fronte di salita incremento Q se il counter è abilitato
		elsif rising_edge(Clock) then
			if Enable = '1' then
				if Q = to_unsigned(2**N - 1, N) then
					Overflow <= '1';
				else
					Overflow <= '0';
				end if;

				Q <= Q + 1;
			end if;
		end if;
	end process;
end architecture;