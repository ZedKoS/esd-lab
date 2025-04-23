library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filter is
  generic (
    WORD_SIZE : natural
  );
  port (
    Clock, AsyncReset, SyncReset : in std_logic;

    Start : in  std_logic;
    Done  : out std_logic;

    A_DataOut : in std_logic_vector(WORD_SIZE-1 downto 0);
    DataIn_B  : out std_logic_vector(WORD_SIZE-1 downto 0);

    PowerAlarm : out std_logic
  );
end entity;

architecture Behavior of Filter is
  type state_t is (IDLE, ADD_A1, ADD_A2, ADD_B1, ADD_B2, SAVE_PREV, CONVERT, FINISHED);
  -- Lo stato della macchina completo è composto da (state, Turn)
  signal state : state_t;

  signal Turn  : std_logic;
  signal Load_Turn : std_logic;

  -- Registro di lavoro che contiene E[i-1] e poi E[i]
  signal Error : signed(WORD_SIZE-1-1 downto 0);
  signal Load_Error : std_logic;

  signal Acc : signed(Error'length+6-1 downto 0);
  signal Load_Acc : std_logic;
  signal ScaledW : signed(Acc'length-1 downto 0);

  signal Sum : signed(Acc'length-1 downto 0);
  signal negate : std_logic;

  signal Load_PowerAlarm, D_PowerAlarm : std_logic;

  signal SyncReset_Acc : std_logic;
  signal SyncReset_StateRegs : std_logic;

begin
  -- DATA PATH

  ERROR_REG: entity work.Reg
  generic map (
    N => WORD_SIZE-1
  )
  port map (
    Enable          => Load_Error,
    Clock           => Clock,
    AsyncReset      => AsyncReset,
    SyncReset       => SyncReset_StateRegs,
    DataIn          => A_DataOut(WORD_SIZE-1 downto 1),
    signed(DataOut) => Error
  );

  TURN_REG: entity work.Reg
  generic map (
    N => 1
  )
  port map (
    Enable     => Load_Turn,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => SyncReset_StateRegs,
    DataIn     => A_DataOut(0 downto 0),
    DataOut(0) => Turn
  );

  POWERALARM_REG: entity work.Reg
  generic map (
    N => 1
  )
  port map (
    Enable     => Load_PowerAlarm,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => SyncReset_StateRegs,
    DataIn(0)  => D_PowerAlarm,
    DataOut(0) => PowerAlarm
  );

  ACC_REG: entity work.Reg
  generic map (
    N => Acc'length
  )
  port map (
    Enable          => Load_Acc,
    Clock           => Clock,
    AsyncReset      => AsyncReset,
    SyncReset       => SyncReset_Acc,
    DataIn          => std_logic_vector(Sum),
    signed(DataOut) => Acc
  );

  ADDER: entity work.Adder
  generic map (
    N => Acc'length
  )
  port map (
    A           => unsigned(Acc),
    B           => unsigned(ScaledW),
    CarryIn     => negate,
    signed(Sum) => Sum,
    CarryOut    => open
  );

  -- STATES

  FILTER_STATE_TRANSITION: process(Clock, AsyncReset)
  begin
    if AsyncReset = '1' then
      state <= IDLE;

    elsif rising_edge(Clock) then
      if SyncReset = '1' then
        state <= IDLE;
      else
        case state is
          when IDLE =>
            if Start = '1' then
              state <= ADD_A1;
            end if;

          when ADD_A1 =>
            state <= ADD_A2;

          when ADD_A2 =>
            state <= SAVE_PREV;
          
          when SAVE_PREV =>
            state <= ADD_B1;

          when ADD_B1 =>
            state <= ADD_B2;
          
          when ADD_B2 =>
            state <= CONVERT;
          
          when CONVERT =>
            state <= FINISHED;
          
          when FINISHED =>
            if Start = '0' then
              state <= IDLE;
            end if;
        end case;
      end if;
    end if;
  end process FILTER_STATE_TRANSITION;

  FILTER_STATE_CONTROL: process(state, Turn, Error, Acc, AsyncReset, SyncReset)
    variable power_raw : signed(Acc'length-3-1 downto 0);
    variable power : signed(WORD_SIZE-1 downto 0);
    variable overflow_check : std_logic;
  begin
    Load_Error <= '0';
    Load_Turn <= '0';
    Load_Acc <= '0';
    Load_PowerAlarm <= '0';

    negate <= '0';
    SyncReset_StateRegs <= SyncReset;
    SyncReset_Acc <= SyncReset;
    ScaledW <= to_signed(0, ScaledW'length);
    Done <= '0';

    case state is
      when IDLE =>
        SyncReset_Acc <= '1';
        Load_Turn <= '1';
      
      when ADD_A1 | ADD_B1 =>
        Load_Acc <= '1';
        if Turn = '0' then
          ScaledW <= shift_left(resize(Error, ScaledW'length), 4);
        else
          ScaledW <= shift_left(resize(Error, ScaledW'length), 3);
        end if;

      when ADD_A2 =>
        Load_Acc <= '1';
        negate <= '1';
        if Turn = '0' then
          ScaledW <= not(shift_left(resize(Error, ScaledW'length), 1));
        else
          ScaledW <= not(resize(Error, ScaledW'length));
        end if;
      
      when ADD_B2 =>
        Load_Acc <= '1';
        ScaledW <= shift_left(resize(Error, ScaledW'length), 1);

      when SAVE_PREV =>
        Load_Error <= '1';

      when CONVERT =>
        Load_PowerAlarm <= '1';
        power_raw := resize(shift_right(Acc, 3), power_raw'length);
        
        overflow_check := (power_raw(power_raw'high) xor power_raw(power_raw'high-2)) or (power_raw(power_raw'high-1) xor power_raw(power_raw'high-2));
        D_PowerAlarm <= overflow_check;

        if overflow_check = '1' then
          if power_raw(power_raw'high) = '0' then
            power := to_signed(2**(power'length-1) - 1, power'length);
          else
            power := to_signed(-2**(power'length-1), power'length);
          end if;

          DataIn_B <= std_logic_vector(power);
        else
          DataIn_B <= std_logic_vector(resize(power_raw, WORD_SIZE));
        end if;

      when FINISHED =>
        Done <= '1';

    end case;
  end process FILTER_STATE_CONTROL;

end architecture;
