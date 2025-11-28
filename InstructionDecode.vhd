library ieee; 
use ieee.std_logic_1164.all;

entity ID is
	port(
	instr	: in std_logic_vector(15 downto 0);	   
	
	
	regA  	: out std_logic_vector(3 downto 0);
	regB 	: out std_logic_vector(3 downto 0);
	regC	: out std_logic_vector(3 downto 0);
	regD    : out std_logic_vector(3 downto 0);
	
	imm		: out std_logic_vector(7 downto 0);
	
	ALUsel	  : out std_logic_vector(2 downto 0);
	RegWrite  : out std_logic;
	MemWrite  : out std_logic;
	MemRead	  : out std_logic;
	immediate : out std_logic
	
	);
end entity ID;

architecture behavioral of ID is 
	signal opcode : std_logic_vector(2 downto 0);
begin
	opcode <= instr(14 downto 12);
	regC 	<= instr(11 downto 8);
	regA 	<= instr(7 downto 4);
	regB 	<= instr(3 downto 0);
	regD	<= instr(11 downto 8);
	imm		<= instr(7 downto 0);
	
process(instr, opcode)
begin
	case opcode is
		when "000" => --add
		ALUSel	<= "000";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0';
		
		when "001" => --mult
		ALUSel	<= "001";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0';
		
		when "010" =>  --PA
		ALUSel	<= "010";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0';
		
		when "011" => --PB
		ALUSel	<= "011";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0';
		
		when "100" => --Sub
		ALUSel	<= "100";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0';	
		
		when "101" => --ldi
		ALUSel	<= "000";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '1';
		
		when "110" =>  --sh
		ALUSel	<= "000";
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '1';
		immediate <= '1';
		
		when "111" => --lh
		ALUSel	<= "000";
		RegWrite <= '1';
		MemRead  <= '1';
		MemWrite <= '0';
		immediate <= '1';
		
		when others =>
		RegWrite <= '0';
		MemRead  <= '0';
		MemWrite <= '0';
		immediate <= '0'; 
		ALUSel <= "000";
	end case;
end process;
	
end architecture;
