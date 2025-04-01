LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY part3 IS
	port (SW : in std_logic_vector(1 downto 0); --sw0 for reset_n, sw1 for input
			KEY : in std_logic_vector(0 downto 0); --key0 for manual clock
			LEDR : out std_logic_vector(9 downto 0)); --ledr9 for output, ledr0-8 for state output
END part3;

ARCHITECTURE Behavior OF part3 IS
	
	signal SyncReset, z, w, Clock : std_logic;
	
	TYPE State_type IS (A, B, C, D, E, F, G, H, I);
	SIGNAL y_Q, Y_D : State_type; -- y_Q is present state, y_D is next state
	
BEGIN

	SyncReset <= not SW(0);
	Clock <= KEY(0);
	w <= SW(1);
	
	state_table: PROCESS (w, y_Q)
	BEGIN
		CASE y_Q IS
		--start
		WHEN A => 
			IF (w = '0') THEN 
				Y_D <= B;
			ELSE 
				Y_D <= F;
			END IF;
		--zeros branch
		when B =>
		  if (w = '0') then
			Y_D <= C;
		  else
			Y_D <= F;
		  end if;
		when C =>
		  if (w = '0') then
			Y_D <= D;
		  else
			Y_D <= F;
		  end if;
		when D =>
		  if (w = '0') then
			Y_D <= E;
		  else
			Y_D <= F;
		  end if;
		when E =>
		  if (w = '0') then
			Y_D <= E;
			--z <= '1'; 
		  else
			Y_D <= F;
		  end if;
		 --ones branch
		 when F =>
		  if (w = '1') then
			Y_D <= G;
		  else
			Y_D <= B;
		  end if;
		when G =>
		  if (w = '1') then
			Y_D <= H;
		  else
			Y_D <= B;
		  end if;
		when H =>
		  if (w = '1') then
			Y_D <= I;
		  else
			Y_D <= B;
		  end if;
		when I =>
		  if (w = '1') then
			Y_D <= I;
			--z <= '1'; 
		  else
			Y_D <= B;
		  end if;
		END CASE;
	END PROCESS;
	
	state_flipflops : PROCESS (Clock)
	BEGIN
		if clock'event and clock='1' then
			if syncReset = '1' then
				y_Q <= A;
			end if;
		end if;
	END PROCESS;
END Behavior;
