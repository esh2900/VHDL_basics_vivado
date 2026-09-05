-- Traffica Light Simulation, first FSM implementation, just for understanding the basics
library ieee;
use ieee.std_logic_1164.all;

entity traffic_light is
    port(
        -- In
        clk,rst: in std_logic;

        -- Out
        red_light:out std_logic;
        yellow_light: out std_logic;
        green_light: out std_logic
    );
end entity;


architecture rtl of traffic_light is
    
    type light_state is(RED,YELLOW,GREEN);
    signal current_state : light_state := RED;
    signal counter_q: std_logic_vector(3 downto 0);

begin

    light_timer : entity work.counter_4bits
        port map(
            clk => clk,
            rst => rst,
            q => counter_q
        );

    process(clk)
    begin

        if rising_edge(clk) then
        
            if rst='1' then
                current_state <= RED;

            elsif counter_q = "1111" then -- State Transition
                case current_state is
                    when RED => 
                        current_state <= GREEN;
                    WHEN YELLOW =>
                        current_state <= RED;
                    WHEN GREEN =>
                        current_state <= YELLOW;
                end case;
            end if;
        
        end if;


    end process;

    red_light <= '1' when current_state = RED else '0';
    yellow_light <= '1' when current_state = YELLOW else '0';
    green_light <= '1' when current_state = GREEN else '0';

end architecture;