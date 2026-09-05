--- 4 bit counter implementation
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity counter_4bits is
    port(
        -- In
        clk, rst : in std_logic;
        
        -- Out
        q : out std_logic_vector(3 downto 0)
    );
end counter_4bits;

architecture rtl of counter_4bits is

    signal count : unsigned(3 downto 0) :="0000";

begin

    process(clk) -- Sensível a alteração do Clock
    begin
        if rising_edge(clk) then -- Só altera o estado durante o rising edge
            
            if rst = '1' then
                count <= "0000";
            else
                count <= count+1; 
            end if;

        end if;
    
    end process;

    q <= std_logic_vector(count);

end architecture;