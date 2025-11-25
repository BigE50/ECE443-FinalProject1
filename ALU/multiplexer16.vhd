library ieee;
use ieee.std_logic_1164.all;

entity multiplexer16 is
    Port (
        A, B, C, D, E, F, G, H : in  STD_LOGIC_VECTOR(15 downto 0);
        sel : in  STD_LOGIC_VECTOR(2 downto 0);
        Y   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end multiplexer16;

architecture behavioral of multiplexer16 is
begin
    process (A, B, C, D, E, F, G, H, sel)
    begin
        case sel is
            when "000" => Y <= A; -- ADD
            when "001" => Y <= B; -- SUB
            when "010" => Y <= C; -- MUL
            when "011" => Y <= D; -- AND
            when "100" => Y <= E; -- OR
            when "101" => Y <= F; -- XOR
            when "110" => Y <= G; -- NOT
            when others => Y <= H; -- ZERO
        end case;
    end process;
end behavioral;
