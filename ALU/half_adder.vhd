library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
  port (
    A     : in  std_logic;
    B     : in  std_logic;
    SUM   : out std_logic;
    CARRY : out std_logic
  );
end entity;

architecture structural of half_adder is
  signal nA, nB   : std_logic;
  signal t1, t2   : std_logic;
begin
  nA <= not A after 10 ns;
  nB <= not B after 10 ns;

  t1 <= A  and nB after 10 ns;
  t2 <= nA and B after 10 ns;

  SUM <= t1 or t2 after 10 ns;

  CARRY <= A and B after 10 ns;
end architecture;