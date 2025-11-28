library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity alu16_tb is
end alu16_tb;

architecture TB_ARCHITECTURE of alu16_tb is
	-- Component declaration of the tested unit
	component alu16
	port(
		A : in STD_LOGIC_VECTOR(15 downto 0);
		B : in STD_LOGIC_VECTOR(15 downto 0);
		S2 : in STD_LOGIC;
		S1 : in STD_LOGIC;
		S0 : in STD_LOGIC;
		R : out STD_LOGIC_VECTOR(15 downto 0);
		status : out STD_LOGIC_VECTOR(2 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal A : STD_LOGIC_VECTOR(15 downto 0);
	signal B : STD_LOGIC_VECTOR(15 downto 0);
	signal S2 : STD_LOGIC;
	signal S1 : STD_LOGIC;
	signal S0 : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal R : STD_LOGIC_VECTOR(15 downto 0);
	signal status : STD_LOGIC_VECTOR(2 downto 0);

	-- Add your code here ...
	constant clk_period : time := 2000 ns;


begin

	-- Unit Under Test port map
	UUT : alu16
		port map (
			A => A,
			B => B,
			S2 => S2,
			S1 => S1,
			S0 => S0,
			R => R,
			status => status
		);

	-- Add your stimulus here ... 
	--------------------------------------------------------------------
    -- Test Process
    --------------------------------------------------------------------
    stim_proc: process
        variable R_int : integer;
    begin
        report "========== STARTING ALU FUNCTIONAL TEST ==========";

        ----------------------------------------------------------------
        -- Test 1: ADD (000)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(12,16));
        B <= std_logic_vector(to_signed(-5,16));
        S2 <= '0'; S1 <= '0'; S0 <= '0';  -- opcode = 000
        wait for clk_period; 
        R_int := to_integer(signed(R));
        report "ADD (12 + -5) = " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 2: MULT (001)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(6,16));
        B <= std_logic_vector(to_signed(-3,16));
        S2 <= '0'; S1 <= '0'; S0 <= '1';  -- opcode = 001
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "MULT (6 * -3) = " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 3: PASS A (010)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(-10,16));
        B <= std_logic_vector(to_signed(8,16));
        S2 <= '0'; S1 <= '1'; S0 <= '0';  -- opcode = 010
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "PASS A (-10) = " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 4: PASS B (011)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(2,16));
        B <= std_logic_vector(to_signed(9,16));
        S2 <= '0'; S1 <= '1'; S0 <= '1';  -- opcode = 011
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "PASS B (9) = " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 5: SUB (100)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(7,16));
        B <= std_logic_vector(to_signed(10,16));
        S2 <= '1'; S1 <= '0'; S0 <= '0';  -- opcode = 100
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "SUB (7 - 10) = " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 6: UNDEFINED (101)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(5,16));
        B <= std_logic_vector(to_signed(5,16));
        S2 <= '1'; S1 <= '0'; S0 <= '1';  -- opcode = 101
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "UNDEFINED (101) ? " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 7: UNDEFINED (110)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(3,16));
        B <= std_logic_vector(to_signed(3,16));
        S2 <= '1'; S1 <= '1'; S0 <= '0';  -- opcode = 110
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "UNDEFINED (110) ? " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        ----------------------------------------------------------------
        -- Test 8: UNDEFINED (111)
        ----------------------------------------------------------------
        A <= std_logic_vector(to_signed(1,16));
        B <= std_logic_vector(to_signed(1,16));
        S2 <= '1'; S1 <= '1'; S0 <= '1';  -- opcode = 111
        wait for clk_period;
        R_int := to_integer(signed(R));
        report "UNDEFINED (111) ? " & integer'image(R_int) &
               " | status: Overflow=" & std_logic'image(status(2)) &
               " Zero=" & std_logic'image(status(1)) &
               " Negative=" & std_logic'image(status(0));

        report "========== SIMULATION COMPLETE ==========";
        wait;
    end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_alu16 of alu16_tb is
	for TB_ARCHITECTURE
		for UUT : alu16
			use entity work.alu16(structural);
		end for;
	end for;
end TESTBENCH_FOR_alu16;

