library ieee;
use ieee.std_logic_1164.all;

entity multiplexer_gates is
  port (
    A : in  std_logic;
    B : in  std_logic;
    S : in  std_logic;
    Y : out std_logic
  );
end entity multiplexer_gates;

architecture structural of multiplexer_gates is
  signal nS, t1, t2 : std_logic;
begin
  nS <= not S;        -- inverter
  t1 <= A and nS;     -- pass A when S=0
  t2 <= B and S;      -- pass B when S=1
  Y  <= t1 or t2;     -- OR results
end architecture structural;
