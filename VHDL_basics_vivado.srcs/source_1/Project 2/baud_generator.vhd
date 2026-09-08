--- Project Number 2: Uart TX/RX RTL Implementation
--- Author: Bruno Giuliani Gomes
--- Baud Clock generator
library ieee;
use ieee.std_logic_1164.all;

entity baud_generator is
    generic(
        CLK_FREQ  : positive := 100_000_000;
        BAUD_RATE : positive := 115_200
    );
    port(
        -- In
        clk       : in  std_logic;
        reset     : in  std_logic;
        -- Out
        baud_tick : out std_logic
    );
end baud_generator;

architecture rtl of baud_generator is

    constant CLKS_PER_BIT : positive := CLK_FREQ / BAUD_RATE;
    signal count_int : integer range 0 to CLKS_PER_BIT := 0;
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then -- Reset
                count_int <= 0;
                baud_tick <= '0';
            elsif count_int = CLKS_PER_BIT-1 then -- Next Bit Signal
                count_int <= 0;
                baud_tick <= '1';
            else
                count_int <= count_int + 1; -- Default Condition
                baud_tick <= '0';
            end if;

        end if;
    end process;

end architecture;