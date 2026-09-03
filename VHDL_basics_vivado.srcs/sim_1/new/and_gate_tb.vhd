library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate_tb is
end and_gate_tb;

architecture Behavioral of and_gate_tb is

    signal A : STD_LOGIC := '0';
    signal B : STD_LOGIC := '0';
    signal Y : STD_LOGIC;

begin

    -- Conecta o testbench à porta AND
    DUT: entity work.and_gate
        port map (
            A => A,
            B => B,
            Y => Y
        );

    -- Gera os sinais de teste
    stimulus: process
    begin

        A <= '0';
        B <= '0';
        wait for 10 ns;

        A <= '0';
        B <= '1';
        wait for 10 ns;

        A <= '1';
        B <= '0';
        wait for 10 ns;

        A <= '1';
        B <= '1';
        wait for 10 ns;

        wait;

    end process;

end Behavioral;