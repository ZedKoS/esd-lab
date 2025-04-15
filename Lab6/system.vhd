library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlSystem is
  generic (
    WORD_SIZE: natural := 8;
    ADDRESS_SIZE: natural := 10
  );

  port (
    AsyncReset : in std_logic;
    Clock   : in  std_logic;
    Start   : in  std_logic;
    Done    : out std_logic;
    DataIn  : in  std_logic_vector(WORD_SIZE-1 downto 0);
    PowerAlarm : out std_logic
  );
end entity;

architecture Behavior of ControlSystem is
  -- Chip select delle memorie
  signal CS_A, CS_B : std_logic;
  signal Read_A, nWrite_A, Read_B, nWrite_B: std_logic;
  signal A_DataOut, DataIn_B: std_logic_vector(WORD_SIZE-1 downto 0);

  signal En_AddrCounter, SyncReset_AddrCounter, AddrCounter_Done : std_logic;
  signal Address : std_logic_vector(WORD_SIZE-1 downto 0);

  signal Start_Filter, Filter_Done : std_logic;

  type state_t is (IDLE, FILL_MEM_A, FILTER, FREEZE);
  signal state : state_t;
  
begin

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
            state <= FREEZE;
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
    CS_A <= '0'; CS_B <= '0';
    Read_A <= '0'; Read_B <= '0';
    nWrite_A <= '1'; nWrite_B <= '1';

    En_AddrCounter <= '0'; SyncReset_AddrCounter <= '0';
    Start_Filter <= '0';
    Done <= '0';

    case state is
      when IDLE =>
        SyncReset_AddrCounter <= '1';

      when FILL_MEM_A =>
        CS_A <= '1';
        nWrite_A <= '0';
        En_AddrCounter <= '1';

      when FILTER =>
        Start_Filter <= '1';

        CS_A <= '1';
        Read_A <= '1';

        CS_B <= '1';
        nWrite_B <= '0';
      
      when FREEZE =>
        Done <= '1';
    end case;
  end process STATE_CONTROL;

  -- DATA PATH

  ADDR_COUNTER: entity work.CounterN
  generic map (
    N => ADDRESS_SIZE
  )
  port map (
    Enable     => En_AddrCounter,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    DataLoad   => unsigned(0, WORD_SIZE),
    Load       => SyncReset_AddrCounter,
    Overflow   => AddrCounter_Done,
    Count      => Address
  );

  MEM_A: entity work.Memory
  generic map (
    WORD_SIZE    => WORD_SIZE,
    ADDRESS_SIZE => ADDRESS_SIZE
  )
  port map (
    Clock      => Clock,
    ChipSelect => CS_A,
    Read       => Read_A,
    nWrite     => nWrite_A,
    DataIn     => DataIn,
    DataOut    => A_DataOut,
    Address    => Address
  );

  FILTER: entity work.Filter
  generic map (
    WORD_SIZE => WORD_SIZE
  )
  port map (
    Start      => Start_Filter,
    Done       => Filter_Done,
    A_DataOut  => A_DataOut,
    DataIn_B   => DataIn_B,
    PowerAlarm => PowerAlarm
  );
  
  MEM_B: entity work.Memory
  generic map (
    WORD_SIZE    => WORD_SIZE,
    ADDRESS_SIZE => ADDRESS_SIZE
  )
  port map (
    Clock      => Clock,
    ChipSelect => CS_B,
    Read       => Read_B,
    nWrite     => nWrite_B,
    DataIn     => DataIn_B,
    DataOut    => open,
    Address    => Address
  );
end architecture;
