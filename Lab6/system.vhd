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

begin
  -- CONTROL UNIT
  CONTROL_UNIT: entity work.ControlUnit
  generic map (
    WORD_SIZE => WORD_SIZE
  )
  port map (
    Clock                 => Clock,
    AsyncReset            => AsyncReset,
    Start                 => Start,
    Done                  => Done,
    CS_A                  => CS_A,
    CS_B                  => CS_B,
    Read_A                => Read_A,
    nWrite_A              => nWrite_A,
    Read_B                => Read_B,
    nWrite_B              => nWrite_B,
    A_DataOut             => A_DataOut,
    DataIn_B              => DataIn_B,
    En_AddrCounter        => En_AddrCounter,
    SyncReset_AddrCounter => SyncReset_AddrCounter,
    AddrCounter_Done      => AddrCounter_Done,
    -- Address               => Address,
    PowerAlarm            => PowerAlarm
  );

  -- DATA PATH

  ADDR_COUNTER: entity work.CounterN
  generic map (
    N => ADDRESS_SIZE
  )
  port map (
    Enable     => En_AddrCounter,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    DataLoad   => to_unsigned(0, WORD_SIZE),
    Load       => SyncReset_AddrCounter,
    Overflow   => AddrCounter_Done,
    std_logic_vector(Count) => Address
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
