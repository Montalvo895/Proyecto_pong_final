library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
 -- generador de numeros 'random' fibonacci. 
 
entity RNG is
    port(
        clk : in std_logic;
        rst : in std_logic;
        rnd : out std_logic_vector(3 downto 0)
    );
end entity;
 
architecture a_RNG of RNG is
    signal X  : std_logic_vector(15 downto 0) := "1001001001000101";
    signal X0: std_logic;
begin
     
    X0 <= X(15) xor (X(13) xor (X(12) xor X(10)));
     
    process(clk, rst)
    begin
        if rst='1' then
            X <= "1001001001000101";
        elsif (clk'event and clk='1') then
            X <= X(14 downto 0) & X0;
        else
            X <= X;
        end if;
    end process;
     
    rnd <= X(3 downto 0);
     
end architecture;