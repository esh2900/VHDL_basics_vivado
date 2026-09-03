----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2026 15:35:12
-- Design Name: 
-- Module Name: somador_pfixo_4bit - Behavioral
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


entity somador_pfixo_4bit is
  Port ( 
        Aint,Adec : in std_logic_vector(3 downto 0);
        Bint,Bdec : in std_logic_vector(3 downto 0);
        Rint,Rdec : out std_logic_vector(3 downto 0)
  );
end somador_pfixo_4bit;

architecture Behavioral of somador_pfixo_4bit is
    signal carry_frac : std_logic; -- Servirá como carry da parte decimal para a inteira
begin

    FRAC_DEC : entity work.somador_completo_4bits
        port map(
            A => Adec,
            B => Bdec,
            Cin => '0',
            S => Rdec,
            Cout => carry_frac
        );


    FRAC_INT : entity work.somador_completo_4bits
        port map(
            A => Aint,
            B => Bint,
            Cin => carry_frac,
            S => Rint,
            Cout => open
        );

end Behavioral;
