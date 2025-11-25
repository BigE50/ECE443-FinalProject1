library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu16 is
    port(
        A, B       : in  std_logic_vector(15 downto 0);
        S2, S1, S0 : in  std_logic;
        R          : out std_logic_vector(15 downto 0);
        status     : out std_logic_vector(2 downto 0)   -- [2]=overflow, [1]=zero, [0]=negative
    );
end entity alu16;

architecture structural of alu16 is

    --------------------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------------------
    component adder16
        port(
            A, B : in  std_logic_vector(15 downto 0);
            Cin  : in  std_logic;
            Sum  : out std_logic_vector(15 downto 0);
            Cout : out std_logic
        );
    end component;

    component subtract16
        port(
            A        : in  std_logic_vector(15 downto 0);
            B        : in  std_logic_vector(15 downto 0);
            Diff     : out std_logic_vector(15 downto 0);
            Borrow   : out std_logic;
            Overflow : out std_logic
        );
    end component;

    component multiplier16
        port(
            A, B : in  std_logic_vector(15 downto 0);
            P    : out std_logic_vector(31 downto 0)
        );
    end component;

    component multiplexer16
        port(
            A, B, C, D, E, F, G, H : in  std_logic_vector(15 downto 0);
            sel : in  std_logic_vector(2 downto 0);
            Y   : out std_logic_vector(15 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Internal Signals
    --------------------------------------------------------------------
    signal add_result, sub_result : std_logic_vector(15 downto 0);
    signal mul_result             : std_logic_vector(31 downto 0);
    signal passA, passB           : std_logic_vector(15 downto 0);
    signal zero16, undef16        : std_logic_vector(15 downto 0);
    signal Cout_add, Borrow_sub   : std_logic;
    signal Overflow_add, Overflow_sub : std_logic;
    signal opcode                 : std_logic_vector(2 downto 0);
    signal R_int                  : std_logic_vector(15 downto 0);

begin
    --------------------------------------------------------------------
    -- Combine opcode bits
    --------------------------------------------------------------------
    opcode <= S2 & S1 & S0;
    zero16 <= (others => '0');
    undef16 <= (others => '0');

    --------------------------------------------------------------------
    -- Instantiate arithmetic units
    --------------------------------------------------------------------

    -- ADD (Signed)
    ADD_U: adder16
        port map(
            A    => A,
            B    => B,
            Cin  => '0',
            Sum  => add_result,
            Cout => Cout_add
        );

    -- SUBTRACT (Signed)
    SUB_U: subtract16
        port map(
            A        => A,
            B        => B,
            Diff     => sub_result,
            Borrow   => Borrow_sub,
            Overflow => Overflow_sub
        );

    -- MULTIPLY (Signed)
    MUL_U: multiplier16
        port map(
            A => A,
            B => B,
            P => mul_result
        );

    -- PASSTHROUGHS
    passA <= A;
    passB <= B;

    --------------------------------------------------------------------
    -- 8-to-1 Multiplexer for Output Selection
    --------------------------------------------------------------------
    MUX_U: multiplexer16
        port map(
            A => add_result,             -- 000 = ADD
            B => mul_result(15 downto 0),-- 001 = MULT
            C => passA,                  -- 010 = A
            D => passB,                  -- 011 = B
            E => sub_result,             -- 100 = SUB
            F => undef16,                -- 101 = Undefined ? 0
            G => undef16,                -- 110 = Undefined ? 0
            H => undef16,                -- 111 = Undefined ? 0
            sel => opcode,
            Y => R_int
        );

    --------------------------------------------------------------------
    -- Drive external result port
    --------------------------------------------------------------------
    R <= R_int;

    --------------------------------------------------------------------
    -- STATUS FLAG GENERATION
    --------------------------------------------------------------------
    process(R_int, Overflow_add, Overflow_sub, mul_result, opcode)
    begin
        -- Overflow
        if (opcode = "000") then         -- ADD
            status(2) <= Overflow_add;
        elsif (opcode = "100") then      -- SUB
            status(2) <= Overflow_sub;
        elsif (opcode = "001") then      -- MULT
            if (mul_result(31 downto 16) /= zero16) then
                status(2) <= '1';
            else
                status(2) <= '0';
            end if;
        else
            status(2) <= '0';
        end if;

        -- Zero flag
        if (R_int = zero16) then
            status(1) <= '1';
        else
            status(1) <= '0';
        end if;

        -- Negative flag
        status(0) <= R_int(15);
    end process;

end architecture structural;
