library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 -- En estaparte del codigo se hara un divisor de reloj para generar
 -- senales de reloj que sean mas lentas. Estas señales se usan para 
 -- poder accelerar y desacelerar el juego de acuerdo a la necesidad
entity ClkEnSrc is
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
end entity;
 
architecture a_ClkEnSrc of ClkEnSrc is
    constant ZERO : unsigned(23 downto 0) := to_unsigned(0, 24);
    signal cnt : unsigned(23 downto 0);
begin
    process(clk_50M, rst)
    begin
        if rst = '1' then
            cnt <= ZERO;
        elsif (clk_50M'event and clk_50M='1') and en='1' then
            if cnt < 16777215 then
                cnt <= cnt + 1;
            else
                cnt <= ZERO;
            end if;
        else
            cnt <= cnt;
        end if;
    end process;
	-- para obtener los valores que necesitamos, se hizo un calculo del n-esimo bit
	-- que produjera la senal necesaria para nuestra aplicacion. Esto a partir de la
	-- velocidad propuesta por el oscilador interno de la FPGA
    en_1k5Hz  <= '1' when (cnt(15 downto 0))=32768   else '0';    -- 1k526Hz    2^-16
    en_24Hz   <= '1' when (cnt(20 downto 0))=1048576 else '0';     -- 23.842Hz    2^-21
    en_12Hz   <= '1' when (cnt(21 downto 0))=2097152 else '0';     -- 11.921Hz    2^-22
    en_6Hz    <= '1' when (cnt(22 downto 0))=4194304 else '0';      --  5.960Hz    2^-23
    en_3Hz    <= '1' when (cnt(23 downto 0))=8388608 else '0';      --  2.980Hz    2^-24
end architecture;