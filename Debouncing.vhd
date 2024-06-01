library ieee;
 
use ieee.std_logic_1164.all;
 
 
 -- se usa una funcion de debouncing para asegurar que no hayan errores al presionar
 -- alguno de los botones de control de jugdor 
 
entity Debouncing is
 
    port(
 
        inpt        : in  std_logic;
 
        rst        : in  std_logic;
 
        clk        : in  std_logic;
 
        en            : in  std_logic;
 
        outp        : out std_logic
 
    );
 
end entity;
 
 
 
 
architecture a_Debouncing of Debouncing is
 
    signal state : std_logic := '0';
 
    signal pulse_detector : std_logic := '0';
 
begin
 
    process(rst, clk)
 
    begin
 
        if rst='1' then
 
            state <= '0';
 
        elsif (clk'event and clk='1') and en='1' then
 
            state <= inpt;
 
        else
 
            state <= state;
 
        end if;
 
    end process;
 
    outp <= state;
 
end architecture;