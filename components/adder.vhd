library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N-bit Adder
entity Adder is
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
end entity;

architecture Behavior of Adder is
  signal result : unsigned(N downto 0);
  signal CarryInNum : std_logic_vector(N downto 0);
begin
  CarryInNum <= (0 => CarryIn, others => '0');
  result <= resize(A, N+1) + resize(B, N+1) + unsigned(CarryInNum);
  Sum <= result(N-1 downto 0);
  CarryOut <= result(N);
end architecture;
