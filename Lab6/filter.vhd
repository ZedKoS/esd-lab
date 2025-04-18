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

    PowerAlarm : buffer std_logic
  );
end entity;

architecture Behavior of Filter is
  type state_t is (IDLE, ADD_A1, ADD_A2, ADD_B1, ADD_B2, SAVE_PREV, CONVERT, FINISHED);
  -- Lo stato della macchina completo è composto da (state, Turn)
  signal state : state_t;

  signal Data  : std_logic_vector(WORD_SIZE-1 downto 0);
  signal Turn  : std_logic;

  -- Registro di lavoro che contiene E[i-1] e poi E[i]
  signal Error : signed(WORD_SIZE-1-1 downto 0);
  signal Load_Error : std_logic;

  signal Acc : signed(Error'length+6-1 downto 0);
  signal ScaledW : signed(Acc'length-1 downto 0);

  signal Sum : signed(Acc'length-1 downto 0);
  signal negate : std_logic;

begin
  -- DATA PATH

  ERROR_AND_TURN_REG: entity work.Reg
  generic map (
    N => WORD_SIZE
  )
  port map (
    Enable     => Load_Error,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => SyncReset,
    DataIn     => A_DataOut,
    DataOut    => Data
  );

  Error <= signed(Data(Error'length-1 downto 0));
  Turn <= Data(0);

  ACC_REG: entity work.Reg
  generic map (
    N => Acc'length
  )
  port map (
    Enable     => '1',
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => SyncReset,
    DataIn     => std_logic_vector(Sum),
    signed(DataOut)    => Acc
  );

  ADDER: entity work.Adder
  generic map (
    N => Acc'length
  )
  port map (
    A        => unsigned(Acc),
    B        => unsigned(ScaledW),
    CarryIn  => negate,
    signed(Sum)      => sum,
    CarryOut => open
  );

  -- STATES

  FILTER_STATE_TRANSITION: process(Clock, AsyncReset)
  begin
    if AsyncReset = '1' then
      state <= IDLE;

    elsif rising_edge(Clock) then
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
  end process FILTER_STATE_TRANSITION;

  FILTER_STATE_CONTROL: process(state, Turn)
    variable p : signed(Acc'length-3-1 downto 0);
    variable power : signed(WORD_SIZE-1 downto 0);
  begin
    Load_Error <= '0';
    negate <= '0';
    Done <= '0';

    case state is
      when IDLE =>
        null;
      
      when ADD_A1 | ADD_B1 =>
        if Turn = '0' then
          ScaledW <= shift_left(resize(Error, ScaledW'length), 4);
        else
          ScaledW <= shift_left(resize(Error, ScaledW'length), 3);
        end if;

      when ADD_A2 =>
        negate <= '1';
        if Turn = '0' then
          ScaledW <= not(shift_left(resize(Error, ScaledW'length), 1));
        else
          ScaledW <= not(resize(Error, ScaledW'length));
        end if;
      
      when ADD_B2 =>
        ScaledW <= shift_left(resize(Error, ScaledW'length), 1);

      when SAVE_PREV =>
        Load_Error <= '1';

      when CONVERT =>
        p := resize(shift_right(Acc, 3), p'length);
        
        PowerAlarm <= (not (p(p'high) xor p(p'high-2))) and (not (p(p'high-1) xor p(p'high-2)));

        if PowerAlarm = '1' then
          if p(p'high) = '0' then
            power := to_signed(2**(power'length-1) - 1, power'length);
          else
            power := to_signed(-2**(power'length-1), power'length);
          end if;

          DataIn_B <= std_logic_vector(power);
        else
          DataIn_B <= std_logic_vector(resize(p, WORD_SIZE));
        end if;

      when FINISHED =>
        Done <= '1';

    end case;
  end process FILTER_STATE_CONTROL;

end architecture;
