 library ieee;
use ieee.std_logic_1164.all;

entity adder16 is
  port (
    A    : in  std_logic_vector(15 downto 0);
    B    : in  std_logic_vector(15 downto 0);
    Cin  : in  std_logic;
    Sum  : out std_logic_vector(15 downto 0);
    Cout : out std_logic
  );
end entity adder16;

architecture structural of adder16 is
  -- Carry chain: C(0) is Cin, C(16) is final Cout
  signal C : std_logic_vector(16 downto 0);
begin
  C(0) <= Cin;

  gen_add: for i in 0 to 15 generate
    FAi: entity work.full_adder
      port map (
        A    => A(i),
        B    => B(i),
        Cin  => C(i),
        Sum  => Sum(i),
        Cout => C(i+1)
      );
  end generate gen_add;

  Cout <= C(16);
end architecture structural;