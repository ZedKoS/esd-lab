library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
  generic (
    WORD_SIZE : natural
  );
  port (
    Clock, AsyncReset : in std_logic;
    Start : in  std_logic;
    Done  : out std_logic;

    -- Chip select delle memorie
    CS_A, CS_B : out std_logic;
    Read_A, nWrite_A, Read_B, nWrite_B: out std_logic;

    A_DataOut : in  std_logic_vector(WORD_SIZE-1 downto 0); 
    DataIn_B  : out std_logic_vector(WORD_SIZE-1 downto 0);

    En_AddrCounter, SyncReset_AddrCounter : out std_logic;
    AddrCounter_Done : in std_logic;
    Address : in std_logic_vector(WORD_SIZE-1 downto 0);

    PowerAlarm : out std_logic
  );
end entity;

architecture Behavior of ControlUnit is
  type state_t is (IDLE, FILL_MEM_A, FILTER, WRITE_MEM_B, FREEZE);
  signal state : state_t;

  signal Start_Filter, SyncReset_Filter, Filter_Done  : std_logic;

begin
  -- FILTERING

  FILTER_INST: entity work.Filter
  generic map (
    WORD_SIZE => WORD_SIZE
  )
  port map (
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => SyncReset_Filter,
    Start      => Start_Filter,
    Done       => Filter_Done,
    A_DataOut  => A_DataOut,
    DataIn_B   => DataIn_B,
    PowerAlarm => PowerAlarm
  );

  -- STATES

  STATE_TRANSITION: process(Clock, AsyncReset)
  begin
    if AsyncReset = '1' then
      state <= IDLE;

    elsif rising_edge(Clock) then
      case state is
        when IDLE =>
          if Start = '1' then
            state <= FILL_MEM_A;
          end if;

        when FILL_MEM_A =>
          if AddrCounter_Done = '1' then
            state <= FILTER;
          end if;

        when FILTER =>
          if Filter_Done = '1' then
            state <= WRITE_MEM_B;
          end if;
        
        when WRITE_MEM_B =>
          if AddrCounter_Done = '1' then
            state <= FREEZE;
          else
            state <= FILTER;
          end if;

        when FREEZE =>
          if Start = '0' then
            state <= IDLE;
          end if;
        
        when others =>
          state <= IDLE;
      end case;
    end if;
  end process STATE_TRANSITION;

  STATE_CONTROL: process(state)
  begin
    SyncReset_AddrCounter <= '0';
    SyncReset_Filter <= '0';

    CS_A <= '0'; CS_B <= '0';
    Read_A <= '0'; Read_B <= '0';
    nWrite_A <= '1'; nWrite_B <= '1';

    En_AddrCounter <= '0';
    Start_Filter <= '0';
    Done <= '0';

    case state is
      when IDLE =>
        SyncReset_AddrCounter <= '1';
        SyncReset_Filter <= '1';

      when FILL_MEM_A =>
        CS_A <= '1';
        nWrite_A <= '0';
        En_AddrCounter <= '1';

      -- il contatore è già azzerato a causa dell'overflow
      when FILTER =>
        Start_Filter <= '1';

        CS_A <= '1';
        Read_A <= '1';

      when WRITE_MEM_B =>
        -- incrementa il contatore
        En_AddrCounter <= '1';

        -- riporta il filtro in IDLE
        Start_Filter <= '0';

        CS_B <= '1';
        nWrite_B <= '0';
      
      when FREEZE =>
        Done <= '1';

    end case;
  end process STATE_CONTROL;
end architecture;
