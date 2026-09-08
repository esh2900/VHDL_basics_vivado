--- Project Number 2: Uart TX/RX RTL Implementation
--- Author: Bruno Giuliani Gomes
--- Main UART Tx entity
library ieee;
use ieee.std_logic_1164.all;

entity UART_8N_tx is
    generic(
        CLK_FREQ : positive := 100_000_000;
        BAUD_RATE : positive := 115_200
    );
    port(
        -- In
        clk,reset : in std_logic;
        start : in std_logic;
        message_reader : in std_logic_vector(7 downto 0);

        -- Out
        tx : out std_logic;
        busy : out std_logic;
        done : out std_logic
    );
end entity;


architecture rtl of UART_8N_tx is

    signal done_int, busy_int: std_logic;
    
    signal message : std_logic_vector(9 downto 0);
    signal baud_tick: std_logic;
    signal current_bit: integer range 0 to 10 := 0;

begin

    done <= done_int;
    busy <= busy_int;

    baud_generator_signal : entity work.baud_generator
            generic map (
                CLK_FREQ => CLK_FREQ,
                BAUD_RATE => BAUD_RATE
            )
            port map(
                clk => clk,
                baud_tick => baud_tick
            );

    process(clk)
    begin        

        if rising_edge(clk) then
            if (start='1' and busy_int='0') then -- Start Transmission
                message <= '1' & message_reader & '0';
                current_bit <=0;
                busy_int <='1';
                done_int <= '0'; -- (??) porquê isso

            elsif (busy_int='0') then -- Idling
                done_int <='0';
                tx <='1';
            elsif(current_bit=10 and baud_tick='1') then -- End Transmission
                done_int <='1';
                busy_int <='0';
            elsif (busy_int='1' and baud_tick='1') then -- Transmitting
                current_bit <= current_bit+1;
                tx <= message(current_bit);
            end if;
        end if;

    end process;

end architecture;