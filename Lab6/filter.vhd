library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filter is
  generic (
    WORD_SIZE : natural
  );
  port (
    Clock, AsyncReset : in std_logic;

    Start : in  std_logic;
    Done  : out std_logic;

    Error : in signed(WORD_SIZE-2 downto 0);
    Turn  : in std_logic;
    DataIn_B : out std_logic_vector(WORD_SIZE-1 downto 0);

    PowerAlarm : out std_logic
  );
end entity;

architecture Behavior of Filter is
  type state_t is (IDLE, ADD_A1, ADD_A2, ADD_B1, ADD_B2, CONVERT, FINISHED);
  signal state : state_t;

  -- Registro di lavoro che contiene E[i-1] e poi E[i]
  signal W : signed(WORD_SIZE-2 downto 0);
  signal Load_W : std_logic;

begin
  ERROR_PREV_DELAY: entity work.Reg
  generic map (
    N => WORD_SIZE
  )
  port map (
    Enable     => Load_W,
    Clock      => Clock,
    AsyncReset => AsyncReset,
    SyncReset  => '0',
    DataIn     => Error,
    DataOut    => W
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
            state <= ADD_A1;
          end if;

        when ADD_A1 =>
          state <= ADD_A2;

        when ADD_A2 =>
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
  end process STATE_TRANSITION;

end architecture;
