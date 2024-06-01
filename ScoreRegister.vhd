library ieee;
 
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
 
 -- En esta funcion se registran los puntos. El jugador que llegue primero a los 7
 -- puntos es el ganador
 
 
entity ScoreRegister is
 
    port(
 
        rst : in std_logic;
 
        clk : in std_logic;
 
        en  : in std_logic;
 
        inc_S1 : in std_logic; -- senales que indican si alguno de los jugadores
										 -- genero un punto
 
        inc_S2 : in std_logic;
 
        q1 : out std_logic_vector(2 downto 0);
 
        q2 : out std_logic_vector(2 downto 0)
 
    );
 
end entity;
 
 
 
 
architecture a_ScoreRegister of ScoreRegister is
 
    constant ZERO : unsigned(2 downto 0) := to_unsigned(0, 3);
 
    signal Score1, Score2 : unsigned(2 downto 0) := ZERO;
 
begin
 
    process(clk, rst)
 
    begin
 
        if rst='1' then
 
            Score1 <= ZERO;
 
            Score2 <= ZERO;
 
        elsif (clk'event and clk='1') and en='1' then
 
            if inc_S1='1' then
 
                Score1 <= Score1 + 1;
 
            else
 
                Score1 <= Score1;
 
            end if;
 
            if inc_S2='1' then
 
                Score2 <= Score2 + 1;
 
            else
 
                Score2 <= Score2;
 
            end if;
 
        else
 
            Score1 <= Score1;
 
            Score2 <= Score2;
 
        end if;
 
    end process;
 
    q1 <= std_logic_vector(Score1);
 
    q2 <= std_logic_vector(Score2);
 
end architecture;