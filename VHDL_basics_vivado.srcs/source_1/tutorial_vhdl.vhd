-- Classes de Objetos

-- constant nome_da_constante : tipo := valor;
-- signal <name> : <type> := <default_value>;
-- variable
-- file
 

-- Aplicação Constant:
entity incrementador is
    port(
        data_in : in integer; -- (Integer é um número de 32-Bits por padrão)
        data_out: out integer
        );
end incrementador;

architecture main of incrementador is

    constant valor : integer := 3;

begin

    data_out <= data_in+valor;

end main;