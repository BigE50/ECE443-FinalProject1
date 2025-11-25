library ieee;
use ieee.std_logic_1164.all;

entity subtract16 is
  port (
    A        : in  std_logic_vector(15 downto 0);
    B        : in  std_logic_vector(15 downto 0);
    Diff     : out std_logic_vector(15 downto 0);
    Borrow   : out std_logic;
    Overflow : out std_logic
  );
end entity subtract16;

architecture structural of subtract16 is
  signal Bbar    : std_logic_vector(15 downto 0);
  signal Cout    : std_logic;
  signal Diff_i  : std_logic_vector(15 downto 0);  -- internal copy of Diff
begin
  -- Invert B (each NOT has 10 ns delay)
  gen_inv: for i in 0 to 15 generate
    Bbar(i) <= not B(i) after 10 ns;
  end generate;

  -- A + (~B) + 1
  U_ADD: entity work.adder16
    port map (
      A    => A,
      B    => Bbar,
      Cin  => '1',
      Sum  => Diff_i,   -- write to internal signal
      Cout => Cout
    );

  -- Drive the output port from the readable internal signal
  Diff <= Diff_i;

  -- Flags (each gate w/ 10 ns delay if your spec requires)
  Borrow   <= not Cout after 10 ns;
  Overflow <= (A(15) xor B(15)) and (A(15) xor Diff_i(15)) after 10 ns;
end architecture structural;
