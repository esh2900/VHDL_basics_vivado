--- Project Number 2: Uart TX/RX RTL Implementation
--- Author: Bruno Giuliani Gomes
--- Main UART Rx entity
--- Implemented as an Explicit FSM
library ieee;
use ieee.std_logic_1164.all;

entity UART_8N_rx is
    generic(
        CLK_FREQ  : positive := 100_000_000;
        BAUD_RATE : positive := 115_200
    );
    port(
         clk,reset : in std_logic;
         rx : in std_logic;

         message_out : out std_logic_vector(7 downto 0);
         data_valid: out std_logic;
         framing_error : out std_logic
    );

end entity;

architecture rtl of UART_8N_rx is

    type state_type is ( -- FSM States
    IDLE,
    START_CHECK,
    DATA_STREAM,
    STOP_CHECK
    );
    
    -- State Recognition Variables
    signal state : state_type := IDLE;
    signal bit_index : integer range 0 to 8 := 0; -- Checar esse limite
    
    -- RX Signal Syncronizer
    signal rx_meta : std_logic := '1';
    signal rx_sync : std_logic := '1';

    constant CLKS_PER_BIT : positive := CLK_FREQ / BAUD_RATE;
    signal counter : integer range 0 to CLKS_PER_BIT := 0;    


begin

        process(clk)
        begin
            if rising_edge(clk) then
                data_valid <= '0';
                framing_error <='0';
                
                -- rx_sync reduces de risk of metastability on the data, at the cost
                -- of a 2 clock pulses delay, this is useful because the message may come
                -- from a different clock domain in another device and cause instability.
                rx_meta <= rx;
                rx_sync <= rx_meta;

                if (state /= IDLE) then
                    counter <= counter+1;
                end if;

                if (reset='1') then
                    state <= IDLE;
                    bit_index <=0;
                    rx_meta <='1';
                    rx_sync <='1';
                    counter <= 0;
                    message_out <= (others => '0');
                else
                    case state is
                        when IDLE =>
                            if (rx_sync='0') then
                                state <= START_CHECK;
                            end if;
                        
                        when START_CHECK =>
                            if (rx_sync='0' and counter >= CLKS_PER_BIT/2) then 
                                state <= DATA_STREAM; -- Message Arived
                                counter <=0;
                            elsif(counter >= CLKS_PER_BIT/2) then
                                state <= IDLE; -- False Start
                                counter <=0;
                            end if;

                        when DATA_STREAM =>
                            if(counter = CLKS_PER_BIT-1) then
                                message_out(bit_index) <= rx_sync;
                                counter <= 0;

                                if(bit_index=7) then -- Final bit transmitted.
                                bit_index<=0;
                                state <= STOP_CHECK;
                                else
                                    bit_index<=bit_index+1;
                                end if;
                            end if;

                        when STOP_CHECK =>
                            if(counter = CLKS_PER_BIT-1) then
                                counter <= 0;
                                state <= IDLE;
                                if (rx_sync='1') then -- Message Transmisison Sucessfull
                                    data_valid <= '1';
                                else
                                    framing_error <='1';
                                end if;
                            end if;
                    end case;
                end if;

            end if;

        end process;
end architecture;