library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end entity;

architecture Beh of memory_tb is
component Memory is
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
end component;
signal clock, ChipSelect, Read, nWrite : std_logic;
signal DataIn, DataOut, Address : std_logic_vector(3 downto 0);
begin
    mem : Memory generic map (word_size => 4, address_size => 4) port map (
        Clock => clock, 
        ChipSelect => ChipSelect,
        Read => read,
        nWrite => nWrite,
        DataIn => DataIn,
        DataOut => DataOut,
        Address => Address
        );
    CLK_PROC:
    process
    begin
        clock <= '1', '0' after 5 ns;
        wait for 10 ns;
    end process;
    ChipSelect <= '0', '1' after 7 ns, '0' after 39 ns, '1' after 42 ns;
    nWrite <= '0';
    Read <= '1';
    DataIn <= "1010", "0101" after 8 ns, "1100" after 26 ns, "0011" after 44 ns;
    Address <= "0000", "0001" after 6 ns, "0101" after 24 ns, "1111" after 41 ns, "0001" after 43 ns;
end architecture;