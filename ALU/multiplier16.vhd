library ieee;
use ieee.std_logic_1164.all;

entity multiplier16 is
  port (
    A : in  std_logic_vector(15 downto 0);
    B : in  std_logic_vector(15 downto 0);
    P : out std_logic_vector(31 downto 0)
  );
end entity multiplier16;

architecture structural of multiplier16 is
  subtype slv16 is std_logic_vector(15 downto 0);
  subtype slv32 is std_logic_vector(31 downto 0);
  type slv16_array is array (0 to 15) of slv16;
  type slv32_array is array (0 to 15) of slv32;

  signal row : slv16_array;
  signal PP  : slv32_array;
  signal SUM : slv32_array;
  signal Cdummy : std_logic_vector(15 downto 0); 
begin
  gen_rows: for i in 0 to 15 generate
    gen_and: for j in 0 to 15 generate
      row(i)(j) <= A(j) and B(i) after 10 ns;
    end generate;
  end generate;

  gen_pp: for i in 0 to 15 generate
    PP(i) <= (31 downto i+16 => '0') & row(i) & (i-1 downto 0 => '0');
  end generate;

  SUM(0) <= PP(0);

  gen_add: for k in 1 to 15 generate
    A32k: entity work.adder32
      port map (
        A    => SUM(k-1),
        B    => PP(k),
        Cin  => '0',
        Sum  => SUM(k),
        Cout => Cdummy(k)  
      );
  end generate;

  -- Final product
  P <= SUM(15);
end architecture structural;
