-- ============================================================
-- Testbench: CLA vs Ripple Carry Adder vs Default Addition
-- Made with Help of AI tool
-- ============================================================
entity tb_adders is
end entity;


architecture simulation of tb_adders is

    constant WIDTH : positive := 32; -- Bit Length of the added numbers


    ------------------------------------------------------------
    -- Common inputs
    ------------------------------------------------------------

    signal A : bit_vector(WIDTH-1 downto 0) := (others => '0');
    signal B : bit_vector(WIDTH-1 downto 0) := (others => '0');


    ------------------------------------------------------------
    -- CLA outputs
    ------------------------------------------------------------

    signal R_cla                    : bit_vector(WIDTH-1 downto 0);
    signal carry_flag_cla           : bit;
    signal signed_overflow_flag_cla : bit;


    ------------------------------------------------------------
    -- Ripple Adder outputs
    ------------------------------------------------------------

    signal R_ripple        : bit_vector(WIDTH-1 downto 0);
    signal Cout_ripple     : bit;
    signal Overflow_ripple : bit;


    ------------------------------------------------------------
    -- Default A+B outputs
    ------------------------------------------------------------

    signal R_default        : bit_vector(WIDTH-1 downto 0);
    signal Cout_default     : bit;
    signal Overflow_default : bit;


begin


    ------------------------------------------------------------
    -- CLA
    ------------------------------------------------------------

    DUT_CLA : entity work.cla_Nblocks

        generic map(
            K => WIDTH,
            N => 8
        )

        port map(
            A                    => A,
            B                    => B,
            carry_flag           => carry_flag_cla,
            signed_overflow_flag => signed_overflow_flag_cla,
            R                    => R_cla
        );


    ------------------------------------------------------------
    -- RIPPLE CARRY ADDER
    ------------------------------------------------------------

    DUT_RIPPLE : entity work.ripple_adder

        generic map(
            N => WIDTH
        )

        port map(
            A             => A,
            B             => B,
            R             => R_ripple,
            Cout          => Cout_ripple,
            overflow_flag => Overflow_ripple
        );


    ------------------------------------------------------------
    -- DEFAULT VHDL ADDITION
    ------------------------------------------------------------

    DUT_DEFAULT : entity work.default_addition

        generic map(
            N => WIDTH
        )

        port map(
            A             => A,
            B             => B,
            R             => R_default,
            Cout          => Cout_default,
            overflow_flag => Overflow_default
        );


    ------------------------------------------------------------
    -- TEST PROCESS
    ------------------------------------------------------------

    stimulus : process
    begin


        --------------------------------------------------------
        -- TEST 1
        -- Simple addition
        --
        -- 1 + 1 = 2
        --------------------------------------------------------

        A <= x"00000001";
        B <= x"00000001";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 1 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 1 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 1 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 1 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 1 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 1 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- TEST 2
        -- Unsigned carry
        --
        -- 4294967295 + 1
        --
        -- FFFFFFFF
        --        +1
        -- ----------
        -- 100000000
        --
        -- R     = 00000000
        -- Carry = 1
        --------------------------------------------------------

        A <= x"FFFFFFFF";
        B <= x"00000001";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 2 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 2 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 2 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 2 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 2 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 2 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- TEST 3
        -- Positive signed overflow
        --
        -- 2147483647 + 1
        --
        -- 7FFFFFFF + 00000001
        --
        -- Signed:
        -- +2147483647 + 1
        --
        -- R = 80000000 = -2147483648
        --
        -- signed overflow = 1
        --------------------------------------------------------

        A <= x"7FFFFFFF";
        B <= x"00000001";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 3 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 3 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 3 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 3 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 3 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 3 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- TEST 4
        -- Normal signed negative addition
        --
        -- -1000 + (-5000) = -6000
        --
        -- -1000 = FFFFFC18
        -- -5000 = FFFFEC78
        -- -6000 = FFFFE890
        --
        -- signed overflow = 0
        --------------------------------------------------------

        A <= x"FFFFFC18";
        B <= x"FFFFEC78";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 4 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 4 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 4 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 4 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 4 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 4 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- TEST 5
        -- Negative signed overflow
        --
        -- -2147483648 + (-1)
        --
        -- 80000000 + FFFFFFFF
        --
        -- Result wraps to:
        -- 7FFFFFFF
        --
        -- signed overflow = 1
        --------------------------------------------------------

        A <= x"80000000";
        B <= x"FFFFFFFF";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 5 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 5 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 5 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 5 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 5 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 5 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- TEST 6
        -- Zero
        --
        -- 0 + 0 = 0
        --------------------------------------------------------

        A <= x"00000000";
        B <= x"00000000";

        wait for 10 ns;


        assert R_cla = R_default
            report "TEST 6 ERROR: CLA result differs from Default"
            severity error;

        assert R_ripple = R_default
            report "TEST 6 ERROR: Ripple result differs from Default"
            severity error;


        assert carry_flag_cla = Cout_default
            report "TEST 6 ERROR: CLA carry differs from Default"
            severity error;

        assert Cout_ripple = Cout_default
            report "TEST 6 ERROR: Ripple carry differs from Default"
            severity error;


        assert signed_overflow_flag_cla = Overflow_default
            report "TEST 6 ERROR: CLA signed overflow differs from Default"
            severity error;

        assert Overflow_ripple = Overflow_default
            report "TEST 6 ERROR: Ripple signed overflow differs from Default"
            severity error;



        --------------------------------------------------------
        -- END OF SIMULATION
        --------------------------------------------------------

        report "ALL ADDER TESTS COMPLETED SUCCESSFULLY"
            severity note;

        wait;

    end process;


end architecture;