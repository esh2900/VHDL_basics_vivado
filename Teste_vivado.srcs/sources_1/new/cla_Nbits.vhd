--- VHDL PROJETO 1: CLA Sum 32 Bits ---
--  Author: Bruno Giuliani Gomes
--  Description: Sums the N bits of a block in a CLA Adder

entity cla_Nbits is
    generic (
        N : positive := 8 -- Defines de CLA block_size
    );
    port(
        A,B :in bit_vector (N-1 downto 0);
        Cin :in bit;

        R : out bit_vector (N-1 downto 0);
        G_block,P_block : out bit;
        Cout : out bit
    );
end cla_Nbits;


architecture main of cla_Nbits is

    signal G: bit_vector (N-1 downto 0);
    signal P: bit_vector (N-1 downto 0);
    signal C: bit_vector (N downto 0);

begin

    C(0) <= Cin;
    sum:for i in 0 to N-1 generate
        
        -- G/P Logic
        G(i) <= A(i) and B(i);
        P(i) <= A(i) xor B(i);
        
        -- Carry Logic
        C(i+1) <= G(i) or (P(i) and C(i));

        -- Sum Logic
        R(i) <= (A(i) xor B(i)) xor C(i);
    
    end generate sum;
    
    -- Block Output Logic
    G_block <= G(N-1);
    P_block <= P(N-1);
    Cout <= C(N);

end architecture;

