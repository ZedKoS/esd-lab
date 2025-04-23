library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_tb is
end entity;
architecture Behavior of system_tb is

component ControlSystem is
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
end component;

begin
end architecture;