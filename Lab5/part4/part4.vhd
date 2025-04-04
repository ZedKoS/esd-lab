library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part4 is
    port (
        CLOCK_50 : in std_logic;
        -- KEY[0]: active-low sync reset
        KEY : in std_logic_vector(0 to 0);

        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(0 to 6)
    );
end entity part4;

architecture Behaviour of part4 is
    component Reg is
        generic (N : natural);
        port
        (
            DataIn : in std_logic_vector(N-1 downto 0);
            Enable : in std_logic;
            Clock : in std_logic;
            AsyncReset : in std_logic := '0';
            SyncReset  : in std_logic := '0';
            DataOut : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component Timer is
        generic (N : natural);
        port (
            Enable, Clock, AsyncReset : in std_logic;
            EndCount : in unsigned(N-1 downto 0);
            LoadEndCount : in std_logic;
            Count : buffer unsigned(N-1 downto 0);
            Done : buffer std_logic;
            Wrap : buffer std_logic
        );
    end component;


    signal SyncReset : std_logic;

    type state_t is (WR_0, WR_1, WR_2, WR_3, WR_4, WR_5, SCROLL);
    signal state, state_next : state_t;

    -- impulso inviato una volta al secondo dal timer
    signal tick : std_logic;

    type tape_t is array(natural range <>) of std_logic_vector;
    signal letters_in : tape_t(5 downto 0)(0 to 6);
    signal letters_out : tape_t(5 downto 0)(0 to 6);

begin
    SyncReset <= not KEY(0);

    ONE_SEC_TIMER: Timer
        generic map (N => 26)
        port map (Enable => '1', Clock => CLOCK_50, AsyncReset => '0',
            EndCount => to_unsigned(50_000_000, 26), LoadEndCount => SyncReset,
            Count => open, Done => open, Wrap => tick);
    
    STATE_TABLE: process(state)
    begin
        case state is
            when WR_0 => state_next <= WR_1;
            when WR_1 => state_next <= WR_2;
            when WR_2 => state_next <= WR_3;
            when WR_3 => state_next <= WR_4;
            when WR_4 => state_next <= WR_5;
            when WR_5 | SCROLL => state_next <= SCROLL;
        end case;
    end process;

    STATE_EVOLVE: process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if SyncReset = '1' then
                state <= WR_0;
            elsif tick = '1' then
                state <= state_next;
            end if;
        end if;
    end process;

    STATE_COMB: process(state, letters_out(5))
    begin
        case state is
            when WR_0 =>
                letters_in(0) <= "1001000"; -- H
            when WR_1 =>
                letters_in(0) <= "0110000"; -- E
            when WR_2 | WR_3 =>
                letters_in(0) <= "1110001"; -- L
            when WR_4 =>
                letters_in(0) <= "0000001"; -- O
            when WR_5 =>
                letters_in(0) <= "1111111"; -- _
            when SCROLL =>
                letters_in(0) <= letters_out(5);
        end case;
    end process;

    REGS:
    for i in 0 to 5 generate
        LETTERS: Reg
            generic map (N => 7)
            port map (Enable => tick, Clock => CLOCK_50, SyncReset => SyncReset, AsyncReset => '0',
                DataIn => letters_in(i), DataOut => letters_out(i));
        
        CONNECT_REGS:
        if i /= 5 generate
            letters_in(i + 1) <= letters_out(i);
        end generate;
    end generate;

    HEX0 <= letters_out(0);
    HEX1 <= letters_out(1);
    HEX2 <= letters_out(2);
    HEX3 <= letters_out(3);
    HEX4 <= letters_out(4);
    HEX5 <= letters_out(5);
end architecture Behaviour;