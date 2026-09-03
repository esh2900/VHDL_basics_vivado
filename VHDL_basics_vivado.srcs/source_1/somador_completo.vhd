-- Data 21/08/2026
-- Desc: Somador Completo

entity somador_completo is
    port(
        a,b,ci : in bit;
        z,co : out bit );
    end somador_completo;

architecture behavior of somador_completo is
begin

    z <= (a xor b) xor ci;
    co <= (a and b) or (b and ci) or (a and ci);

end architecture;