library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity id_tb is
end id_tb;

architecture TB_ARCHITECTURE of id_tb is
	-- Component declaration of the tested unit
	component id
	port(
		instr : in STD_LOGIC_VECTOR(15 downto 0);
		regA : out STD_LOGIC_VECTOR(3 downto 0);
		regB : out STD_LOGIC_VECTOR(3 downto 0);
		regC : out STD_LOGIC_VECTOR(3 downto 0);
		regD : out STD_LOGIC_VECTOR(3 downto 0);
		imm : out STD_LOGIC_VECTOR(7 downto 0);
		ALUsel : out STD_LOGIC_VECTOR(2 downto 0);
		RegWrite : out STD_LOGIC;
		MemWrite : out STD_LOGIC;
		MemRead : out STD_LOGIC;
		immediate : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal instr : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal regA : STD_LOGIC_VECTOR(3 downto 0);
	signal regB : STD_LOGIC_VECTOR(3 downto 0);
	signal regC : STD_LOGIC_VECTOR(3 downto 0);
	signal regD : STD_LOGIC_VECTOR(3 downto 0);
	signal imm : STD_LOGIC_VECTOR(7 downto 0);
	signal ALUsel : STD_LOGIC_VECTOR(2 downto 0);
	signal RegWrite : STD_LOGIC;
	signal MemWrite : STD_LOGIC;
	signal MemRead : STD_LOGIC;
	signal immediate : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : id
		port map (
			instr => instr,
			regA => regA,
			regB => regB,
			regC => regC,
			regD => regD,
			imm => imm,
			ALUsel => ALUsel,
			RegWrite => RegWrite,
			MemWrite => MemWrite,
			MemRead => MemRead,
			immediate => immediate
		);

	-- Add your stimulus here ... 
	
	process
	begin
	
		
        --------------------------------------------------------
        -- Test 1: R-type ADD (opcode 000)
        -- Format: unused|opcode|c|a|b
        -- Example: add r2 = r3 + r4
        -- opcode=000, c=0010, a=0011, b=0100
        --------------------------------------------------------
        instr <= "0000001000110100";
       	wait for 40ns;

        --------------------------------------------------------
        -- Test 2: SUB (opcode 100)
        --------------------------------------------------------
        instr <= "0100000101010110";  -- sub r1 = r5 - r6
        wait for 40 ns;

        --------------------------------------------------------
        -- Test 3: LDI (I-type, opcode 101)
        -- ldi r7, imm(55h)
        --------------------------------------------------------
        instr <= "0101011101010101";
        wait for 40 ns;

        --------------------------------------------------------
        -- Test 4: SH (store halfword)
        --------------------------------------------------------
        instr <= "0" & "110" & "0100" & x"20"; -- store from r4 to address 0x20
        wait for 40 ns;

        --------------------------------------------------------
        -- Test 5: LH (load halfword)
        --------------------------------------------------------
        instr <= "0111010110100000"; -- load into r5 from address 0xA0
        wait for 40 ns;

        --------------------------------------------------------
        -- End simulation
        --------------------------------------------------------
        wait;
    end process;
		

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_id of id_tb is
	for TB_ARCHITECTURE
		for UUT : id
			use entity work.id(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_id;

