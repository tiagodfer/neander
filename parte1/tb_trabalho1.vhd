library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity tb_trabalho1 is

end entity;
architecture behavior of tb_trabalho1 is
component trabalho1 is
    port(
        clock: in std_logic;
        reset: in std_logic;
        count_load: in std_logic;
        en_ULA : in std_logic;
        Z_out : out std_logic;
        N_out : out std_logic;
        dec_out : out std_logic_vector(3 downto 0)
    );
end component;
signal clock_sg, reset_sg, count_load_sg, en_ULA_sg: std_logic:= '0';
signal Z_out_sg, N_out_sg : std_logic:= '0';
signal dec_out_sg : std_logic_vector(3 downto 0):= "0000";

begin
    inst_top: trabalho1
    port map(
        clock => clock_sg,
        reset => reset_sg,
        count_load => count_load_sg,
        en_ULA => en_ULA_sg,
        Z_out => Z_out_sg,
        N_out => N_out_sg,
        dec_out => dec_out_sg
    );
clock_sg <= not clock_sg after 5 ns;
    process
    begin
        wait for 0 ns;
        reset_sg <= '1';
        count_load_sg <= '1';
        wait for 5 ns;
        en_ula_sg <= '1';
        wait for 50 ns;
        count_load_sg <= '0';
        wait;
    end process;
end behavior;


