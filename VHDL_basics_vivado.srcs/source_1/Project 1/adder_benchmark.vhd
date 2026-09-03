-- Benchmark Structure for comparing the 3 adders architecture
-- Made with help of AI

library ieee;
use ieee.std_logic_1164.all;

entity adder_benchmark is

    generic(
        WIDTH      : positive := 32;
        CLA_BLOCK  : positive := 8;

        -- 0 = CLA
        -- 1 = Ripple
        -- 2 = Default A+B
        ADDER_TYPE : integer := 0
    );

    port(
        clk : in std_logic;

        A : in bit_vector(WIDTH-1 downto 0);
        B : in bit_vector(WIDTH-1 downto 0);

        R                    : out bit_vector(WIDTH-1 downto 0);
        carry_flag           : out bit;
        signed_overflow_flag : out bit
    );

end entity;


architecture main of adder_benchmark is

    ------------------------------------------------------------
    -- Input registers
    ------------------------------------------------------------

    signal A_reg : bit_vector(WIDTH-1 downto 0);
    signal B_reg : bit_vector(WIDTH-1 downto 0);


    ------------------------------------------------------------
    -- Combinational outputs from selected adder
    ------------------------------------------------------------

    signal R_comb        : bit_vector(WIDTH-1 downto 0);
    signal carry_comb    : bit;
    signal overflow_comb : bit;


begin


    ------------------------------------------------------------
    -- INPUT AND OUTPUT REGISTERS
    ------------------------------------------------------------

    registers : process(clk)
    begin

        if rising_edge(clk) then

            -- Inputs
            A_reg <= A;
            B_reg <= B;

            -- Outputs
            R                    <= R_comb;
            carry_flag           <= carry_comb;
            signed_overflow_flag <= overflow_comb;

        end if;

    end process;


    ------------------------------------------------------------
    -- CLA
    ------------------------------------------------------------

    GEN_CLA : if ADDER_TYPE = 0 generate

        DUT : entity work.cla_Nblocks

            generic map(
                K => WIDTH,
                N => CLA_BLOCK
            )

            port map(
                A                    => A_reg,
                B                    => B_reg,
                R                    => R_comb,
                carry_flag           => carry_comb,
                signed_overflow_flag => overflow_comb
            );

    end generate GEN_CLA;


    ------------------------------------------------------------
    -- RIPPLE CARRY
    ------------------------------------------------------------

    GEN_RIPPLE : if ADDER_TYPE = 1 generate

        DUT : entity work.ripple_adder

            generic map(
                N => WIDTH
            )

            port map(
                A             => A_reg,
                B             => B_reg,
                R             => R_comb,
                Cout          => carry_comb,
                overflow_flag => overflow_comb
            );

    end generate GEN_RIPPLE;


    ------------------------------------------------------------
    -- DEFAULT A+B
    ------------------------------------------------------------

    GEN_DEFAULT : if ADDER_TYPE = 2 generate

        DUT : entity work.default_addition

            generic map(
                N => WIDTH
            )

            port map(
                A             => A_reg,
                B             => B_reg,
                R             => R_comb,
                Cout          => carry_comb,
                overflow_flag => overflow_comb
            );

    end generate GEN_DEFAULT;


end architecture;