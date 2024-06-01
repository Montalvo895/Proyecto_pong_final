library ieee;
 
use ieee.std_logic_1164.all;
 
 -- Esta fucion se encarga de controlar la raqueta. En esta funcion se controla
 -- la posicion de la raqueta mediante los inputs del usuario. L "left" R "Right. 
 
 
entity Racket is
 
    port(
 
        clk, rst, en, l, r : in std_logic;
 
        q : out std_logic_vector(7 downto 0) -- vector posicion de la raqueta. 
 
    );
 
end entity;
 
 
 
 
architecture a_Racket of Racket is
 
    signal data : std_logic_vector(7 downto 0) := "00111000"; -- posicion inicial de la raqueta
 
begin
 
    process(clk, rst)
 
    begin
 
        if rst='1' then
 
            data <= "00111000";
 
        elsif (clk'event and clk='1') and en='1' then
 
            if l='1' and r='0' and data(7)='0' then
 
                data <= data(6 downto 0) & '0'; -- funcion para correr el vector una vez hacia la izquierda
 
            elsif l='0' and r='1' and data(0)='0' then
 
                data <= '0' & data(7 downto 1); -- funcion para correr el vector una vez hacia la derecha
 
            else
 
                data <= data; -- se queda quieta la raqueta
 
            end if;
 
        else
 
            data <= data;
 
        end if;
 
    end process;
 
    q <= data;
 
end architecture;