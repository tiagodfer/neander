library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity tb_top is
end entity;

architecture behavior of tb_top is
    component top_trabalho1 is
        port(
            clock : in std_logic
        );
    end component;

    signal clock_sg : std_logic := '0';
begin
    top_inst : top_trabalho1 port map(
        clock => clock_sg
    );
    clock_sg <= not clock_sg after 5 ns;
end behavior;