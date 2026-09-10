-- UART RX Testbench
-- Tests:
--   1. Valid UART frame
--   2. Framing error
--   3. False start bit
--   4. Back-to-back frames
--   5. Reset

library ieee;
use ieee.std_logic_1164.all;

entity tb_UART_8N_rx is
end entity;


architecture simulation of tb_UART_8N_rx is

    constant CLK_FREQ_TB  : positive := 100_000_000;
    constant BAUD_RATE_TB : positive := 115_200;

    -- 100 MHz -> 10 ns
    constant CLK_PERIOD : time := 10 ns;

    -- Same integer division used by the DUT
    constant CLKS_PER_BIT_TB : positive :=
        CLK_FREQ_TB / BAUD_RATE_TB;

    -- 868 clocks * 10 ns = 8.68 us
    constant BIT_PERIOD : time :=
        CLK_PERIOD * CLKS_PER_BIT_TB;


    -- DUT inputs
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal rx    : std_logic := '1';


    -- DUT outputs
    signal message_out   : std_logic_vector(7 downto 0);
    signal data_valid    : std_logic;
    signal framing_error : std_logic;


    -- Testbench monitoring
    signal valid_count : integer := 0;
    signal error_count : integer := 0;

    signal last_valid_byte :
        std_logic_vector(7 downto 0) := (others => '0');


begin


    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------

    dut : entity work.UART_8N_rx
        generic map (
            CLK_FREQ  => CLK_FREQ_TB,
            BAUD_RATE => BAUD_RATE_TB
        )
        port map (
            clk           => clk,
            reset         => reset,
            rx            => rx,
            message_out   => message_out,
            data_valid    => data_valid,
            framing_error => framing_error
        );


    ------------------------------------------------------------------
    -- Clock Generator
    ------------------------------------------------------------------

    clk <= not clk after CLK_PERIOD / 2;


    ------------------------------------------------------------------
    -- Monitor
    --
    -- Keeps track of data_valid and framing_error pulses.
    -- This allows the stimulus process to check the results even
    -- after the one-clock pulses have disappeared.
    ------------------------------------------------------------------

    monitor : process(clk)
    begin

        if rising_edge(clk) then

            if data_valid = '1' then
                valid_count <= valid_count + 1;
                last_valid_byte <= message_out;
            end if;

            if framing_error = '1' then
                error_count <= error_count + 1;
            end if;

        end if;

    end process;


    ------------------------------------------------------------------
    -- Main Stimulus Process
    ------------------------------------------------------------------

    stimulus : process


        --------------------------------------------------------------
        -- Send one UART 8N1 frame
        --
        -- UART:
        --
        -- IDLE = 1
        -- START = 0
        -- D0 ... D7 (LSB first)
        -- STOP
        --------------------------------------------------------------

        procedure send_uart_frame (
            signal rx_line : out std_logic;
            constant data  : in  std_logic_vector(7 downto 0);
            constant stop_bit : in std_logic
        ) is
        begin

            -- Start bit
            rx_line <= '0';
            wait for BIT_PERIOD;

            -- Data bits: LSB first
            for i in 0 to 7 loop

                rx_line <= data(i);
                wait for BIT_PERIOD;

            end loop;

            -- Stop bit
            rx_line <= stop_bit;
            wait for BIT_PERIOD;

            -- Return line to idle
            rx_line <= '1';

        end procedure;


        variable valid_before : integer;
        variable error_before : integer;


    begin


        --------------------------------------------------------------
        -- Initial Reset
        --------------------------------------------------------------

        report "TESTBENCH START";

        rx <= '1';
        reset <= '1';

        wait for 5 * CLK_PERIOD;

        wait until rising_edge(clk);

        reset <= '0';

        wait for 5 * CLK_PERIOD;


        --------------------------------------------------------------
        -- TEST 1
        -- Valid frame: 0x9A = 10011010
        --------------------------------------------------------------

        report "TEST 1: Valid frame 0x9A";

        valid_before := valid_count;
        error_before := error_count;

        send_uart_frame(
            rx,
            x"9A",
            '1'
        );

        -- Allow monitor to capture final pulse
        wait for 10 * CLK_PERIOD;

        assert valid_count = valid_before + 1
            report "ERROR: data_valid was not generated"
            severity error;

        assert error_count = error_before
            report "ERROR: framing_error generated for valid frame"
            severity error;

        assert last_valid_byte = x"9A"
            report "ERROR: Received byte does not match 0x9A"
            severity error;

        wait for BIT_PERIOD;


        --------------------------------------------------------------
        -- TEST 2
        -- Framing Error
        --
        -- Stop bit intentionally sent as 0
        --------------------------------------------------------------

        report "TEST 2: Framing error";

        valid_before := valid_count;
        error_before := error_count;

        send_uart_frame(
            rx,
            x"A5",
            '0'
        );

        wait for 10 * CLK_PERIOD;

        assert valid_count = valid_before
            report "ERROR: Invalid frame generated data_valid"
            severity error;

        assert error_count = error_before + 1
            report "ERROR: framing_error was not detected"
            severity error;

        wait for BIT_PERIOD;


        --------------------------------------------------------------
        -- TEST 3
        -- False Start
        --
        -- RX goes low for less than half a bit.
        --------------------------------------------------------------

        report "TEST 3: False start";

        valid_before := valid_count;
        error_before := error_count;

        rx <= '0';

        wait for BIT_PERIOD / 4;

        rx <= '1';

        -- Give RX enough time to reject the false start
        wait for BIT_PERIOD;

        assert valid_count = valid_before
            report "ERROR: False start generated data_valid"
            severity error;

        assert error_count = error_before
            report "ERROR: False start generated framing_error"
            severity error;

        wait for BIT_PERIOD;


        --------------------------------------------------------------
        -- TEST 4
        -- Back-to-back UART frames
        --------------------------------------------------------------

        report "TEST 4: Back-to-back frames";

        valid_before := valid_count;
        error_before := error_count;

        send_uart_frame(
            rx,
            x"55",
            '1'
        );

        -- No additional idle period:
        -- immediately send another frame

        send_uart_frame(
            rx,
            x"AA",
            '1'
        );

        wait for 10 * CLK_PERIOD;

        assert valid_count = valid_before + 2
            report "ERROR: Back-to-back reception failed"
            severity error;

        assert error_count = error_before
            report "ERROR: framing_error during back-to-back frames"
            severity error;

        assert last_valid_byte = x"AA"
            report "ERROR: Last received byte should be 0xAA"
            severity error;

        wait for BIT_PERIOD;


        --------------------------------------------------------------
        -- TEST 5
        -- Reset
        --------------------------------------------------------------

        report "TEST 5: Reset";

        reset <= '1';

        wait for 3 * CLK_PERIOD;

        assert message_out = x"00"
            report "ERROR: message_out not cleared by reset"
            severity error;

        assert data_valid = '0'
            report "ERROR: data_valid active during reset"
            severity error;

        assert framing_error = '0'
            report "ERROR: framing_error active during reset"
            severity error;

        reset <= '0';

        wait for BIT_PERIOD;


        --------------------------------------------------------------
        -- End
        --------------------------------------------------------------

        report "ALL UART RX TESTS COMPLETED";

        wait;

    end process;


end architecture;