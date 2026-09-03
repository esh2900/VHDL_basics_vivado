--- VHDL PROJETO 1: CLA Sum 32 Bits ---
--  Author: Bruno Giuliani Gomes
--  Description: Implements a Ripple Adder sum for comparison with the CLA.


entity ripple_adder is
    generic(
        N:positive :=32
    );
    port (
        A, B          : in  bit_vector(N-1 downto 0);
        
        R             : out bit_vector(N-1 downto 0);
        Cout          : out bit; -- Carry-out; indicates overflow for N-bit unsigned addition
        overflow_flag : out bit -- Checks overflow on signed numbers (2 complement)
    );

end entity;


architecture main of ripple_adder is

    signal C: bit_vector (N downto 0);
    signal R_int   : bit_vector(N-1 downto 0);

begin

    C(0) <='0';
    Cout <= C(N);
    overflow_flag <= ((not A(N-1)) and (not B(N-1)) and R_int(N-1)) or
                     (A(N-1) and B(N-1) and (not R_int(N-1)));

    R <= R_int;

    addition:for i in 0 to N-1 generate
            
       R_int(i)   <= (A(i) xor B(i)) xor C(i);
       C(i+1) <= (A(i) and B(i)) or (B(i) and C(i)) or (A(i) and C(i));

    end generate addition;
    
    

end architecture;