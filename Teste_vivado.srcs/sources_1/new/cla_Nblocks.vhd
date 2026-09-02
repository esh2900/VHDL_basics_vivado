--- VHDL PROJETO 1: CLA Sum 32 Bits ---
--  Author: Bruno Giuliani Gomes
--  Description: Joins N cla blocks into a big adder circuit

entity cla_NBlocks is
    generic(
        K: positive := 32; -- Bits in the numbers I want to add
        N: positive := 8 -- Defines the internal cla_Nbits architecture
    );
    port(
        A,B : in bit_vector(K-1 downto 0);

        carry_flag : out bit; -- Can chek overflow on unsigned numbers
        signed_overflow_flag : out bit; -- Checks overflow on signed numbers (2 complement)
        R: out bit_vector(K-1 downto 0)
    );
end cla_Nblocks;


architecture main of cla_NBlocks is

    constant M : positive := K/N; 
    signal C_block : bit_vector(M downto 0);
    signal R_int : bit_vector(K-1 downto 0); -- To allow internal usage of R in overflow

begin
    -- Check and Overflow/Carriy handling
    assert K mod N = 0 -- Checks for the possibility of building the adder properly
        report "K must be divisible by N"
        severity failure;

    R <= R_int;
    C_block(0) <= '0'; -- Initial block has no carry.
    carry_flag <= C_block(M); -- Final carry or possible overflow.
    -- Signed overflow: same-sign operands producing a result with opposite sign
    signed_overflow_flag <= ((not A(K-1)) and (not B(K-1)) and R_int(K-1)) or
                     (A(K-1) and B(K-1) and (not R_int(K-1)));


    -- Block Sum
    CLA_adder:for i in 0 to (M-1) generate

        CLA_block: entity work.cla_Nbits
            generic map (
                N => N
            )
            port map(
                -- In cla_Nbits
                A => A((i+1)*N-1 downto i*N),
                B => B((i+1)*N-1 downto i*N),
                Cin => C_block(i),

                -- Out cla_Nbits
                R => R_int((i+1)*N-1 downto i*N),                
                G_block => open,
                P_block => open,
                Cout => C_block(i+1)
            );
    end generate CLA_adder;

end architecture;
