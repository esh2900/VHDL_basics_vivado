-- Data 21/08/2026
-- Desc: Somador de 4 bits

entity somador_4bits is
    port(
        a,b : in integer range 0 to 15;
        s : out integer range 0 to 15
        );
end somador_4bits;


architecture behavior of somador_4bits is
begin
    s <= a+b;
end behavior;