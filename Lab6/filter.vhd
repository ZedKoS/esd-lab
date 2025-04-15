library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filter is
  generic (
    WORD_SIZE : natural
  );
  port (
    Start : in  std_logic;
    Done  : out std_logic;

    A_DataOut : in  std_logic_vector(WORD_SIZE-1 downto 0);
    DataIn_B  : out std_logic_vector(WORD_SIZE-1 downto 0);

    PowerAlarm : out std_logic
  );
end entity;

architecture Behavior of Filter is
begin
  -- TODO: everything.
end architecture;
