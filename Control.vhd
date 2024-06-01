library ieee;
 
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
 
 -- esta es la funcion que controla casi todas las funciones del juego, pues detecta
 -- colisiones entre la raqueta y la pelota, decide si un jugador puntua, cambia la
 -- velocidad de la pelota y detecta si el juego termino. 
 
 
entity Control is
 
    port(
 
        -- Control
 
        clk : in std_logic;
 
        en  : in std_logic;
 
        rst : in std_logic;
 
        en_sel : out std_logic_vector(1 downto 0); -- variable para control de velocidad
 
        end_state : out  std_logic; -- bandera de fin de juego
 
        -- Racket
 
        racket_1 : in std_logic_vector(7 downto 0);
 
        racket_2 : in std_logic_vector(7 downto 0);
 
        -- Ball
 
        pbx, pby : in std_logic_vector(7 downto 0);
 
        ball_tx : out std_logic; -- bandera para definir cambio de direccion de pelota
 
        ball_clear : out std_logic; -- bandera para  desaparecer pelota
 
        -- Score
 
        score1, score2 : in std_logic_vector(2 downto 0);
 
        inc1, inc2 : out std_logic -- bandera para puntos de cada jugador
 
    );
 
-- en_sel
 
end entity;
 
 
 
 
architecture a_Control of Control is
 
    signal p1_uscore, p2_uscore, max_score : unsigned(2 downto 0);
 
    signal p1_scored, p2_scored : std_logic;
 
    signal r1_bounce, r2_bounce : std_logic;
 
    signal end_game : std_logic;
 
begin
 
    p1_uscore <= unsigned(score1);
 
    p2_uscore <= unsigned(score2);
 
    max_score <= p1_uscore when p1_uscore > p2_uscore else p2_uscore;
 
 
 
 
    p1_scored <= pbx(0);
 
    p2_scored <= pbx(7);
 
 
 
		-- logica para definir si la pelota le pego a una raqueta o no.
		-- revisa si las coordenadas entre la raqueta y la pelota son uno
		-- cuando la pelota esta justo al borde de donde se mueve la raqueta
    r1_bounce <= '1' when pbx(6)='1' and (pby and racket_1)/="00000000" else '0';
 
    r2_bounce <= '1' when pbx(1)='1' and (pby and racket_2)/="00000000" else '0';
 
 
 
		-- termina el juego si el valor maximo de puntos se logro por alguno de los 
		-- dos jugadores
    end_game <= '1' when max_score>=to_unsigned(7, 3) else '0';
 
 
 
		-- aqui se revisa los puntos del jugador con mayor puntaje y define 
		-- la velocidad de la pelota de acuerdo con el numero
    en_sel <= "00" when max_score < 2 else 
 
              "01" when max_score < 4 else
 
              "10" when max_score < 5 else
 
              "11" when max_score < 7 else
 
              "--";
 
 
 
 
    end_state <= end_game;
 
    ball_tx <= r1_bounce or r2_bounce;
 
    ball_clear <= p1_scored or p2_scored;
 
    inc1 <= p1_scored;
 
    inc2 <= p2_scored;
 
end architecture;