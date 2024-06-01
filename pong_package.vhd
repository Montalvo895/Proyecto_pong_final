library ieee;
 
use ieee.std_logic_1164.all;
 
 
 -- se juntan todas las funciones para luego llamarlas en el toplevel entity
 
package pong_package is
 
     
 
    component Debouncing is
 
        port(
 
            inpt        : in  std_logic;
 
            rst        : in  std_logic;
 
            clk        : in  std_logic;
 
            en            : in  std_logic;
 
            outp        : out std_logic
 
        );
 
    end component;
 
     
 
    component Racket is
 
        port(
 
            clk, rst, en, l, r : in std_logic;
 
            q : out std_logic_vector(7 downto 0)
 
        );
 
    end component;
 
 
 
 
    component Ball is
 
        port(
 
            en : in std_logic;
 
            clk : in std_logic;
 
            rst : in std_logic;
 
            ball_clear : in std_logic;
 
            tx  : in std_logic;
 
            rnd_4 : in std_logic_vector(3 downto 0);
 
             
 
            pbx : out std_logic_vector(7 downto 0);
 
            pby : out std_logic_vector(7 downto 0)
 
        );
 
    end component;
 
 
 
 
    component RNG is
 
        port(
 
            clk : in std_logic;
 
            rst : in std_logic;
 
            rnd : out std_logic_vector(3 downto 0)
 
        );
 
    end component;
 
     
 
    component ClkEnSrc is
 
        port(
 
            clk_50M : in std_logic;
 
            rst : in std_logic;
 
            en : in std_logic;
 
            en_1k5Hz : out std_logic;
 
            en_24Hz : out std_logic;
 
            en_12Hz  : out std_logic;
 
            en_6Hz  : out std_logic;
 
            en_3Hz  : out std_logic
 
        );
 
    end component;
 
 
 
 
    component ScoreRegister is
 
        port(
 
            rst : in std_logic;
 
            clk : in std_logic;
 
            en  : in std_logic;
 
            inc_S1 : in std_logic;
 
            inc_S2 : in std_logic;
 
            q1 : out std_logic_vector(2 downto 0);
 
            q2 : out std_logic_vector(2 downto 0)
 
        );
 
    end component;
 
     
 
    component Control is
 
        port(
 
            -- Control
 
            clk : in std_logic;
 
            en  : in std_logic;
 
            rst : in std_logic;
 
            en_sel : out std_logic_vector(1 downto 0);
 
            end_state : out  std_logic;
 
            -- Racket
 
            racket_1 : in std_logic_vector(7 downto 0);
 
            racket_2 : in std_logic_vector(7 downto 0);
 
            -- Ball
 
            pbx, pby : in std_logic_vector(7 downto 0);
 
            ball_tx : out std_logic;
 
            ball_clear : out std_logic;
 
            -- Score
 
            score1, score2 : in std_logic_vector(2 downto 0);
 
            inc1, inc2 : out std_logic
 
        );
 
    -- en_sel
 
    end component;
 
     
 
    component GPU is
 
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
 
    end component;
 
     
 
end package;