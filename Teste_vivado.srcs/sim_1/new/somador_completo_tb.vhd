----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2026 22:32:23
-- Design Name: 
-- Module Name: somador_completo_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity somador_completo_tb is
--  Port ( );
end somador_completo_tb;

architecture Behavioral of somador_completo_tb is
    signal a  : bit := '0';
    signal b  : bit := '0';
    signal ci : bit := '0';

    signal z  : bit;
    signal co : bit;

begin

-- Instância do circuito que será testado
    DUT : entity work.somador_completo
        port map (
            a  => a,
            b  => b,
            ci => ci,
            z  => z,
            co => co
        );

    -- Geração dos sinais de teste
    stimulus : process
    begin

        a <= '0'; b <= '0'; ci <= '0';
        wait for 10 ns;

        a <= '0'; b <= '0'; ci <= '1';
        wait for 10 ns;

        a <= '0'; b <= '1'; ci <= '0';
        wait for 10 ns;

        a <= '0'; b <= '1'; ci <= '1';
        wait for 10 ns;

        a <= '1'; b <= '0'; ci <= '0';
        wait for 10 ns;

        a <= '1'; b <= '0'; ci <= '1';
        wait for 10 ns;

        a <= '1'; b <= '1'; ci <= '0';
        wait for 10 ns;

        a <= '1'; b <= '1'; ci <= '1';
        wait for 10 ns;

        wait;

    end process;

end Behavioral;