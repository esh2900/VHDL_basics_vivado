--- VHDL PROJETO 1: CLA Sum 32 Bits ---
--  Author: Bruno Giuliani Gomes
--  Description: Default addition for timing and hardware usage comparison

library ieee;
use ieee.numeric_bit.all;

entity default_addition is
    generic(
        N : positive := 32
    );
    port (
        A, B          : in  bit_vector(N-1 downto 0);
        
        R             : out bit_vector(N-1 downto 0);
        Cout          : out bit; -- Carry-out; indicates overflow for N-bit unsigned addition
        overflow_flag : out bit -- Checks overflow on signed numbers (2 complement)
    );
end default_addition;


architecture main of default_addition is

    signal sum_ext : unsigned(N downto 0);
    signal R_int   : bit_vector(N-1 downto 0);

begin

    -- Adds an extra bit co capture the carry
    sum_ext <= unsigned('0' & A) + unsigned('0' & B);

    R_int <= bit_vector(sum_ext(N-1 downto 0));

    R <= R_int;

    -- Carry out for unsigned overflow
    Cout <= sum_ext(N);

    -- Signed sum overflow detection
    overflow_flag <= ((not A(N-1)) and (not B(N-1)) and R_int(N-1)) or
                     (A(N-1) and B(N-1) and (not R_int(N-1)));

end architecture;