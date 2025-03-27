library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Counter sincrono a N bit
entity counterN is
	generic (N : natural);
	port
	(
		En, Clr, Clk : in std_logic;
		overflow : out std_logic;
		Q : buffer unsigned(N-1 downto 0)
	);			
end entity;

architecture Behavior of counterN is
begin
	process(Clr, clk)
	begin
		-- clear attivo -> resetta Q e overflow
		if Clr = '1' then
			Q <= (others => '0');
			overflow <= '0';
		-- ogni fronte di salita incremento Q se il counter è abilitato
		elsif rising_edge(Clk) then
			if En = '1' then
				if Q = to_unsigned(2**N - 1, N) then
					overflow <= '1';
				else
					overflow <= '0';
				end if;

				Q <= Q + 1;
			end if;
		end if;
	end process;
end architecture;