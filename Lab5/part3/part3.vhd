library ieee;
use ieee.std_logic_1164.all;

entity part3 is
	port (SW : in std_logic_vector(1 downto 0); --sw0 for reset_n, sw1 for input
			KEY : in std_logic_vector(0 downto 0); --key0 for manual clock
			LEDR : out std_logic_vector(9 downto 0)); --ledr9 for output, ledr0-8 for state output
end part3;

architecture Behavior of part3 is
	
	signal SyncReset, Clock : std_logic;

	-- z: output; w: input
	signal z, w : std_logic;
	
	type State_type is (A, B, C, D, E, F, G, H, I);
	signal y, y_next : State_type;
	
begin
	SyncReset <= not SW(0);
	Clock <= KEY(0);
	w <= SW(1);
	
	state_table: process (w, y)
	begin
		case y is
			--start
			when A =>
				if w = '0' then
					y_next <= B;
				else
					y_next <= F;
				end IF;

			-- zeros branch
			when B =>
				if w = '0' then
					y_next <= C;
				else
					y_next <= F;
				end if;

			when C =>
				if w = '0' then
					y_next <= D;
				else
					y_next <= F;
				end if;

			when D =>
				if w = '0' then
					y_next <= E;
				else
					y_next <= F;
				end if;

			when E =>
				if w = '0' then
					y_next <= E;
					--z <= '1'; 
				else
					y_next <= F;
				end if;

			-- ones branch
			when F =>
				if w = '1' then
					y_next <= G;
				else
					y_next <= B;
				end if;

			when G =>
				if w = '1' then
					y_next <= H;
				else
					y_next <= B;
				end if;

			when H =>
				if w = '1' then
					y_next <= I;
				else
					y_next <= B;
				end if;

			when I =>
				if w = '1' then
					y_next <= I;
					--z <= '1'; 
				else
					y_next <= B;
				end if;
		end case;
	end process;
	
	state_flipflops : process (Clock)
	begin
		if rising_edge(Clock) then
			if SyncReset = '1' then
				y <= A;
			else
				y <= y_next;
			end if;
		end if;
	end process;

	z <= '1' when y = E OR y = I else '0';

	LEDR(9) <= z;
	LEDR(8) <= '1' when y = A else '0';
	LEDR(7) <= '1' when y = B else '0';
	LEDR(6) <= '1' when y = C else '0';
	LEDR(5) <= '1' when y = D else '0';
	LEDR(4) <= '1' when y = E else '0';
	LEDR(3) <= '1' when y = F else '0';
	LEDR(2) <= '1' when y = G else '0';
	LEDR(1) <= '1' when y = H else '0';
	LEDR(0) <= '1' when y = I else '0';
end Behavior;
