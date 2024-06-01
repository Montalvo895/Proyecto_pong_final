library ieee;
 
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
 
 -- Esta funcion se encarga de modificar el movimiento de la pelota. Tambien es
 -- la funcion que elige la posicion inicila de la pelota al iniciar ua ronda
 
 
entity Ball is
 
    port(
 
        en : in std_logic;
 
        clk : in std_logic;
 
        rst : in std_logic;
 
        ball_clear : in std_logic;
 
        tx  : in std_logic;
 
        rnd_4 : in std_logic_vector(3 downto 0); -- valor random para iniciar
 
         
 
        pbx : out std_logic_vector(7 downto 0); -- coordenadas de la pelota
 
        pby : out std_logic_vector(7 downto 0)
 
    );
 
end entity;
 
 
 
 
architecture a_ball of ball is
 
    signal ball_x : std_logic_vector(7 downto 0) := "00001000"; -- vector posicion
 
    signal ball_y : std_logic_vector(7 downto 0) := "00010000";
 
    signal x_dir : std_logic := '0'; -- direccion en 'x' y 'y'
 
    signal y_dir : std_logic := '0';
 
begin
 
    process(clk, rst)
 
    begin
 
        if rst='1' then
 
            ball_y <= "000" & rnd_4(3) & (not rnd_4(3)) & "000";
 
            ball_x <= "000" & rnd_4(2) & (not rnd_4(2)) & "000";
 
            y_dir <= rnd_4(1);
 
            x_dir <= rnd_4(0);
 
        elsif (clk'event and clk='1') and en='1' then
 
            if ball_clear='1' then -- inicializacion de la pelota segun rnd
				-- para la drireccion y la posicion. La posicion inicial esta
				-- limitada a los 4 bits del centro
 
                ball_y <= "000" & rnd_4(3) & (not rnd_4(3)) & "000";
 
                ball_x <= "000" & rnd_4(2) & (not rnd_4(2)) & "000";
 
                y_dir <= rnd_4(1);
 
                x_dir <= rnd_4(0);
 
            else
 
                if tx='1' then
 
                    x_dir <= not x_dir;
 
                    if x_dir='1' then -- codigo para controlar el moviemiento de
						  -- la pelota. Es un logica parecida a la del moviemiento de
						  -- la raqueta pues es solo concatenar un bit a los
						  -- extremos del vector dependiendo de la direccion que tiene
 
                        ball_x <= ball_x(6 downto 0) & '0';
 
                    else
 
                        ball_x <= '0' & ball_x(7 downto 1);
 
                    end if;
 
                else
 
                    if ((ball_x(6) and not x_dir) or (ball_x(1) and x_dir))='1' then
						  -- codigo para cambio de direccion de la pelota cuando colisiona
						  -- contra las paredes de la matriz
 
                        x_dir <= not x_dir;
 
                    end if;
 
                    if x_dir='1' then
 
                        ball_x <= '0' & ball_x(7 downto 1);
 
                    else
 
                        ball_x <= ball_x(6 downto 0) & '0';
 
                    end if;
 
                end if;
 
                if ((ball_y(6) and not y_dir) or (ball_y(1) and y_dir))='1' then
 
                    y_dir <= not y_dir;
 
                end if;
 
                if y_dir='1' then
 
                    ball_y <= '0' & ball_y(7 downto 1);
 
                else
 
                    ball_y <= ball_y(6 downto 0) & '0';
 
                end if;
 
            end if;
 
        end if;
 
    end process;
 
    pbx <= ball_x; -- coordenadas de salida de la pelota 
 
    pby <= ball_y;
 
end architecture;