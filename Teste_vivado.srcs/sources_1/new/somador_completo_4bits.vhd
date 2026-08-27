----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2026 16:06:57
-- Design Name: 
-- Module Name: somador_completo_4bits - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity somador_completo_4bits is
    port(
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        Cin  : in  std_logic;

        S    : out std_logic_vector(3 downto 0);
        Cout : out std_logic
    );
end somador_completo_4bits;


architecture Behavioral of somador_completo_4bits is

    signal resultado : unsigned(4 downto 0);

begin

    resultado <= ('0' & unsigned(A)) +
                 ('0' & unsigned(B)) +
                 unsigned'("0000" & Cin);

    S    <= std_logic_vector(resultado(3 downto 0));
    Cout <= resultado(4);

end Behavioral;
