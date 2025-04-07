library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity part5 is
    port (
        CLOCK_50 : in std_logic;

        -- Numero di millisecondi prima che si accenda LEDR[0]
        SW   : in std_logic_vector(9 downto 0);

        -- KEY: active-low
		-- KEY[0]: (not) reset; KEY[3]: (not) react
        KEY  : in std_logic_vector(3 downto 0);

        LEDR : out std_logic_vector(0 to 0);

        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6);
        HEX2 : out std_logic_vector(0 to 6);
        HEX3 : out std_logic_vector(0 to 6)
    );
end entity part5;

architecture Behavior of part5 is
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

    component hexadecimal_ssd_decoder is
        port (
            c : in std_logic_vector(3 downto 0);
            dec : out std_logic_vector(0 to 6)
        );
    end component;

    component DFlipFlop is
        generic (NEGATED : boolean := false);
        port
        (
            D, Clock   : in std_logic;
            AsyncReset : in std_logic := '0';
            SyncReset  : in std_logic := '0';
            Q : out std_logic
        );
    end component;

    type state_t is (WAITING_LED, TIMING, FREEZE);
    signal state : state_t;
    
    signal async_reset, reset_flag, react : std_logic;
    signal ms_timer_done, led_timer_done, reaction_timer_done : std_logic;

    signal enable_digit : std_logic_vector(0 to 4);
    signal enable_led_timer, enable_digit_timer : std_logic;

    signal decimal_digits : std_logic_vector(15 downto 0);
begin
    async_reset <= not KEY(0);
    react <= not KEY(3);

    -- transizioni di stato
    STATE_TRANSITIONS:
    process(CLOCK_50, async_reset)
    begin
        if async_reset = '1' then
            state <= WAITING_LED;
        elsif rising_edge(CLOCK_50) then
            case state is
                when WAITING_LED =>
                    if led_timer_done = '1' then
                        state <= TIMING;
                    else
                        state <= WAITING_LED;
                    end if;
                when TIMING =>
                    if reaction_timer_done = '1' or react = '1' then
                        state <= FREEZE;
                    else
                        state <= TIMING;
                    end if;
                when others => state <= FREEZE;
            end case;
        end if;
    end process;

    -- Calcoli combinatori
    CONTROL:
    process(state, ms_timer_done)
    begin
        enable_led_timer <= '0';
        enable_digit_timer <= '0';
		LEDR(0) <= '0';

        case state is
            when WAITING_LED =>
                enable_led_timer <= ms_timer_done;
            when TIMING =>
				LEDR(0) <= '1';
                enable_digit_timer <= ms_timer_done;
            when FREEZE => null;
        end case;
    end process;

    ResetReg: DFlipFlop
        generic map (NEGATED => true)
        port map (Clock => CLOCK_50, SyncReset => '0', AsyncReset => async_reset, 
            D => '0', Q => reset_flag);

    -- dà un impulso ogni ms
    MsTimer: timer
        generic map (N => 16)
        port map (Enable => '1', Clock => CLOCK_50, AsyncReset => async_reset,
            EndCount => to_unsigned(50_000, 16), LoadEndCount => reset_flag,
            Count => open, Done => open, Wrap => ms_timer_done);
    
    LEDTimer: timer
        generic map (N => SW'length)
        port map (Enable => enable_led_timer, Clock => CLOCK_50, AsyncReset => async_reset,
            EndCount => unsigned(SW), LoadEndCount => reset_flag,
            Count => open, Done => open, Wrap => led_timer_done);
    
    enable_digit(0) <= enable_digit_timer;

    DigitTimers:
    for i in 0 to 3 generate
        DigitTimer: Timer
            generic map (N => 4)
            port map (Enable => enable_digit(i), Clock => CLOCK_50, AsyncReset => async_reset,
                EndCount => to_unsigned(9, 4), LoadEndCount => reset_flag,
                std_logic_vector(Count) => decimal_digits(4*i+3 downto 4*i),
                Done => open, Wrap => enable_digit(i+1));
    end generate;

    reaction_timer_done <= enable_digit(4);

    Display0: hexadecimal_ssd_decoder
        port map (c => decimal_digits(3 downto 0), dec => HEX0);
    Display1: hexadecimal_ssd_decoder
        port map (c => decimal_digits(7 downto 4), dec => HEX1);
    Display2: hexadecimal_ssd_decoder
        port map (c => decimal_digits(11 downto 8), dec => HEX2);
    Display3: hexadecimal_ssd_decoder
        port map (c => decimal_digits(15 downto 12), dec => HEX3);
    
end architecture Behavior;