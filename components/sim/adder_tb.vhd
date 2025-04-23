library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end entity;

architecture Behavior of adder_tb is
component Adder is
  generic (
    N : natural
  );
  port (
    A : in unsigned(N-1 downto 0);
    B : in unsigned(N-1 downto 0);
    CarryIn : in std_logic;

    Sum : out unsigned(N-1 downto 0);
    CarryOut : out std_logic
  );
end component;
signal A, B, Sum : unsigned(3 downto 0);
signal CarryIn, CarryOut : std_logic;
begin
    ADD: adder generic map (4) port map(
        A => A,
        B => B,
        CarryIn => CarryIn,
        Sum => Sum,
        CarryOut => CarryOut
    );
    A <= "0000", "0101" after 5 ns, "1010" after 10 ns, "1111" after 15 ns;
    B <= "0000", "1010" after 7.5 ns, "1010" after 12.5 ns, "1111" after 17.5 ns;
    CarryIn <= '0', '1' after 2.5 ns, '0' after 4.5 ns, '1' after 18 ns;
end architecture;