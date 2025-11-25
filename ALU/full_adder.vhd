library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port (
    A    : in  std_logic;
    B    : in  std_logic;
    Cin  : in  std_logic;
    Sum  : out std_logic;
    Cout : out std_logic
  );
end entity full_adder;

architecture structural of full_adder is
  signal s1, c1, c2 : std_logic;
begin
  HA0: entity work.half_adder
    port map (A => A, B => B, SUM => s1, CARRY => c1);

  HA1: entity work.half_adder
    port map (A => s1, B => Cin, SUM => Sum, CARRY => c2);

  Cout <= c1 or c2 after 10 ns;
end architecture structural;