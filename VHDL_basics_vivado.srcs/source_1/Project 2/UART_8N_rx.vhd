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
         framing_error : out std_logic;

    );

end entity;



architecture rtl of UART_8N_rx is

    signal baud_reset : std_logic :='0';
    signal baud_tick : std_logic;


begin

    baud_generator_signal : entity work.baud_generator
        generic map(
            CLK_FREQ => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        ),
        port map(
            clk => clk,
            reset => baud_reset,
            baud_tick => baud_tick
        );

    
        process(clk)
        begin
            
            if rising_edge(clk) then



            end if;

        end process;

end architecture;