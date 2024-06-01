library ieee;
 
use ieee.std_logic_1164.all;
 
library work;
 
use work.pong_package.all;
 
entity PongFPGA is
 
port(
 
n_rst : in std_logic := '0';
 
 
clk_50M : in std_logic := '0';
 
player_1_up_bt, player_1_down_bt : in std_logic := '1';
 
player_2_up_bt, player_2_down_bt : in std_logic := '1';
 
video_data : out std_logic_vector(7 downto 0);
 
video_sel  : out std_logic_vector(7 downto 0);
 
score_sel  : out std_logic;
 
led_5, led_4, led_2 : out std_logic
 
);
 
end entity;

architecture a_PongFPGA of PongFPGA is
 
signal rst, end_state : std_logic; -- reset y bandera de final de juego
 
signal en_sel : std_logic_vector(1 downto 0); -- enable de velocidad de bola
 
signal master_en, en_1k5Hz, en_24Hz, en_12Hz, en_6Hz, en_3Hz : std_logic; --reloj
 
signal deboucing_en, racket_en : std_logic; -- 
 
signal rnd_4 : std_logic_vector(3 downto 0); --numero random
 
signal ball_en, ball_clear, ball_tx : std_logic; --banderas de la pelota
 
signal pbx, pby : std_logic_vector(7 downto 0); -- coordenadas de la pelota
 
signal inc_S1, inc_S2 : std_logic; -- banderas para generar puntos
 
signal score_1, score_2 : std_logic_vector(2 downto 0); -- puntos
 
signal player_1_up, player_1_down, racket_1_l, racket_1_r : std_logic; -- controles
 
signal racket_1 : std_logic_vector(7 downto 0); -- coordenada raqueta 
 
signal player_2_up, player_2_down, racket_2_l, racket_2_r : std_logic; -- controles
 
signal racket_2 : std_logic_vector(7 downto 0); -- coordenada raqueta 
 
signal v_data : std_logic_vector(7 downto 0); -- coordenadas para dibujar en la matriz
 
signal v_sel : std_logic_vector(7 downto 0);
 
signal s_sel : std_logic; -- impresion a leds de puntaje
 
begin
 
rst <= not n_rst;
 
master_en <= not end_state;
 
deboucing_en <= en_24Hz;
 
racket_en <= en_12Hz and master_en;
 
ball_en <= en_3Hz    when en_sel="00" else
 
en_6Hz    when en_sel="01" else
 
en_6Hz    when en_sel="10" else
 
en_12Hz   when en_sel="11" else '0';
 
-- Enable Source
 
ClkEnSrc0: ClkEnSrc port map(
 
clk_50M   => clk_50M,
 
rst       => rst,
 
en        => '1',
 
en_1k5Hz  => en_1k5Hz,
 
en_24Hz   => en_24Hz,
 
en_12Hz   => en_12Hz,
 
en_6Hz    => en_6Hz,
 
en_3Hz    => en_3Hz
 
);
 
-- RNG
 
RNG0: RNG port map(
 
clk    => clk_50M,
 
rst    => rst,
 
rnd    => rnd_4
 
);
 
-- Ball
 
BALL0 : Ball port map(
 
en         => ball_en and master_en,
 
clk        => clk_50M,
 
rst        => rst,
 
ball_clear => ball_clear,
 
tx         => ball_tx,
 
rnd_4      => rnd_4,
 
pbx        => pbx,
 
pby        => pby
 
);
 
-- Player 1
 
P1UD : Debouncing port map(
 
inpt       => not player_1_up_bt,
 
rst        => rst,
 
clk        => clk_50M,
 
en         => deboucing_en,
 
outp       => player_1_up
 
);
 
P1DD : Debouncing port map(
 
inpt       => not player_1_down_bt,
 
rst        => rst,
 
clk        => clk_50M,
 
en         => deboucing_en,
 
outp       => player_1_down
 
);
 
 
RACKET1: Racket port map(
 
clk    => clk_50M,
 
rst    => rst,
 
en     => racket_en,
 
l      => racket_1_l,
 
r      => racket_1_r,
 
q      => racket_1
 
);
 
-- Player 2
 
P2UD : Debouncing port map(
 
inpt       => not player_2_up_bt,
 
rst        => rst,
 
clk        => clk_50M,
 
en         => deboucing_en,
 
outp       => player_2_up
 
);
 
P2DD : Debouncing port map(
 
inpt       => not player_2_down_bt,
 
rst        => rst,
 
clk        => clk_50M,
 
en         => deboucing_en,
 
outp       => player_2_down
 
);
 
 
RACKET2: Racket port map(
 
clk    => clk_50M,
 
rst    => rst,
 
en     => racket_en,
 
l      => racket_2_l,
 
r      => racket_2_r,
 
q      => racket_2
 
);
 
-- Score
 
SREG0: ScoreRegister port map(
 
rst       => rst,
 
clk       => clk_50M,
 
en        => ball_en,
 
inc_S1    => inc_S1,
 
inc_S2    => inc_S2,
 
q1        => score_1,
 
q2        => score_2
 
);
 
-- Control
 
CTRL0: Control port map (
 
clk            => clk_50M,
 
en             => en_1k5Hz,
 
rst            => rst,
 
en_sel         => en_sel,
 
end_state      => end_state,
 
racket_1       => racket_1,
 
racket_2       => racket_2,
 
pbx            => pbx,
 
pby            => pby,
 
ball_tx        => ball_tx,
 
ball_clear     => ball_clear,
 
score1         => score_1,
 
score2         => score_2,
 
inc1           => inc_S1,
 
inc2           => inc_S2
 
);
 
-- en_sel
 
-- GPU
 
GPU0: GPU port map(
 
clk       => clk_50M,
 
en        => en_1k5Hz,
 
rst       => rst,
 
racket_1  => racket_1,
 
racket_2  => racket_2,
 
ball_x    => pbx,
 
ball_y    => pby,
 
end_state => end_state,
 
p1score   => score_1,
 
p2score   => score_2,
 
cd        => v_data,
 
cs        => v_sel,
 
ls        => s_sel
 
);
 
-- Racket 1 Player IA MUX
 
racket_1_l <=   player_1_up;   

 
racket_1_r <=   player_1_down; 
 
-- Racket 2 Player IA MUX
 
racket_2_l <=   player_2_up;   
 
 
racket_2_r <=   player_2_down; 
 
-- LEDs
 
led_4 <= master_en;
 
-- Output a matriz y leds
 
video_data(7) <= 'Z' when v_data(7)='1' else '0';
 
video_data(6) <= 'Z' when v_data(6)='1' else '0';
 
video_data(5) <= 'Z' when v_data(5)='1' else '0';
 
video_data(4) <= 'Z' when v_data(4)='1' else '0';
 
video_data(3) <= 'Z' when v_data(3)='1' else '0';
 
video_data(2) <= 'Z' when v_data(2)='1' else '0';
 
video_data(1) <= 'Z' when v_data(1)='1' else '0';
 
video_data(0) <= 'Z' when v_data(0)='1' else '0';
 
video_sel(7)  <= '1' when v_sel(7)='1'  else 'Z';
 
video_sel(6)  <= '1' when v_sel(6)='1'  else 'Z';
 
video_sel(5)  <= '1' when v_sel(5)='1'  else 'Z';
 
video_sel(4)  <= '1' when v_sel(4)='1'  else 'Z';
 
video_sel(3)  <= '1' when v_sel(3)='1'  else 'Z';
 
video_sel(2)  <= '1' when v_sel(2)='1'  else 'Z';
 
video_sel(1)  <= '1' when v_sel(1)='1'  else 'Z';
 
video_sel(0)  <= '1' when v_sel(0)='1'  else 'Z';
 
score_sel     <= '1' when s_sel='1'     else 'Z';
 
end architecture;