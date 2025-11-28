library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	port(
		clk	 : in std_logic;
		we	 : in std_logic;
		ad	 : in std_logic_vector(7 downto 0);
		D	 : in std_logic_vector(15 downto 0);
		Dout : out std_logic_vector(15 downto 0)
	);
end RAM;

architecture behavioral of RAM is

type mem_t is array (0 to 255) of std_logic_vector(15 downto 0);
signal mem : mem_t := (others => (others => '0'));	 

signal reg_out : std_logic_vector(15 downto 0) := (others => '0');

begin
	
	process(clk)
		variable index : integer;	 
	begin  
		if rising_edge(clk) then
			index := to_integer(unsigned(ad));
			
			if we = '1' then
				mem(index) <= D;
			end if;
			
			reg_out <= mem(index);
		end if;
	end process;
	
	Dout <= reg_out;
	
end behavioral;
	
