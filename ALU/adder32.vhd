library ieee;
use ieee.std_logic_1164.all;

entity adder32 is
  port (
    A    : in  std_logic_vector(31 downto 0);
    B    : in  std_logic_vector(31 downto 0);
    Cin  : in  std_logic;
    Sum  : out std_logic_vector(31 downto 0);
    Cout : out std_logic
  );
end entity adder32;

architecture structural of adder32 is
  signal C : std_logic_vector(32 downto 0) := (others => '0');
begin
  C(0) <= Cin;

  gen_fa: for i in 0 to 31 generate
    FAi: entity work.full_adder
      port map (
        A    => A(i),
        B    => B(i),
        Cin  => C(i),
        Sum  => Sum(i),
        Cout => C(i+1)
      );
  end generate;

  Cout <= C(32);
end architecture structural;
