library ieee;
 
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;

 -- Este modulo se encarga de imprimir todo al circuito, es decir
 -- enciende todos los leds del circuito 
 
 
entity GPU is
 
    port(
 
        --
 
        clk : in std_logic;
 
        en  : in std_logic;
 
        rst : in std_logic;
 
        --
 
        racket_1 : in std_logic_vector(7 downto 0);
 
        racket_2 : in std_logic_vector(7 downto 0);
 
        ball_x : in std_logic_vector(7 downto 0);
 
        ball_y : in std_logic_vector(7 downto 0);
 
        end_state : in std_logic;
 
        p1score : in std_logic_vector(2 downto 0);
 
        p2score : in std_logic_vector(2 downto 0);
 
        --
 
        cd : out std_logic_vector(7 downto 0);
 
        cs : out std_logic_vector(7 downto 0);
 
        ls : out std_logic
 
    );
 
end entity;
 
 
 
 
architecture a_GPU of GPU is
 
    type M8x8 is array (7 downto 0) of std_logic_vector(7 downto 0);
 
     
 
    constant initial_cnt : integer range -1 to 7 := 7;
 
    constant initial_sel : std_logic_vector(7 downto 0) := "10000000";
 
     
 
    signal colunes : M8x8;
 
    signal cnt : integer range -1 to 7 := 7;
 
    signal sel : std_logic_vector(7 downto 0);
 
begin

	-- se imprimen las columnas de acuerdo con las coordenadas recibidas
 
    -- Colunes
 
    colunes(7) <= racket_1 when ball_x(7)='0' else (racket_1 or ball_y);
 
    colunes(6) <= ball_y   when ball_x(6)='1' else "00000000";
 
    colunes(5) <= ball_y   when ball_x(5)='1' else "00000000";
 
    colunes(4) <= ball_y   when ball_x(4)='1' else "00000000";
 
    colunes(3) <= ball_y   when ball_x(3)='1' else "00000000";
 
    colunes(2) <= ball_y   when ball_x(2)='1' else "00000000";
 
    colunes(1) <= ball_y   when ball_x(1)='1' else "00000000";
 
    colunes(0) <= racket_2 when ball_x(0)='0' else (racket_2 or ball_y);
 
 
 
 
    process(clk, en)
 
    begin
 
        if rst='1' then
 
            cnt <= initial_cnt;
 
            sel <= initial_sel;
 
        elsif (clk'event and clk='1') and en='1' then
 
            if cnt > -1 then
 
                cnt <= cnt - 1;
 
                sel <= '0' & sel(7 downto 1);
 
            else
 
                cnt <= initial_cnt;
 
                sel <= initial_sel;
 
            end if;
 
        else
 
            cnt <= cnt;
 
            sel <= sel;
 
        end if;
 
    end process;
 
 
 
 
    cd <= (not (p1score&"00"&p2score)) when cnt=-1 and rst='0' else
 
          (not colunes(cnt))           when rst='0' else
 
          "11111111";
 
    cs <= sel when rst='0' else "00000000";
 
    ls <= '1' when cnt=-1 else '0';
 
 
 
 
end architecture;