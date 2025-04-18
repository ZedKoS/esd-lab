library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Register-file memory
-- Sync write, Async read
entity Memory is
  generic (
    WORD_SIZE : natural;
    ADDRESS_SIZE : natural
  );
  port (
    Clock : in std_logic;

    -- Abilita operazioni di Read/Write solo se la memoria è selezionata
    ChipSelect : in std_logic;

    Read  : in std_logic;
    nWrite : in std_logic;

    DataIn  : in  std_logic_vector(WORD_SIZE-1 downto 0);
    DataOut : out std_logic_vector(WORD_SIZE-1 downto 0);
    Address : in  std_logic_vector(ADDRESS_SIZE-1 downto 0)
  );
end entity;

architecture Behavior of Memory is
    type reg_file_t is array(0 to 2**ADDRESS_SIZE-1) of std_logic_vector(WORD_SIZE-1 downto 0);
    signal reg_file : reg_file_t;

    signal addr : natural;

begin
    addr <= to_integer(unsigned(Address));

    DataOut <= reg_file(addr) when Read = '1' and ChipSelect = '1'
        else (WORD_SIZE-1 downto 0 => '0');

    MEM: process(Clock) 
    begin
        if rising_edge(Clock) then
            if nWrite = '0' and ChipSelect = '1' then
                reg_file(addr) <= DataIn;
            end if;
        end if;
    end process MEM;
end architecture;