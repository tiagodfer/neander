library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity tb_topo is
end entity;

architecture behavior of tb_topo is
    component top_trabalho1 is
        port(
         clock : in std_logic;
			reset : in std_logic
        );
    end component;

    signal clock_sg : std_logic := '0';
	 signal reset_sg : std_logic := '1';
begin
    top_inst : top_trabalho1 port map(
        clock => clock_sg,
		reset => reset_sg
    );
	 reset_sg <= '0' after 5 ns;
    clock_sg <= not clock_sg after 10 ns;
end behavior;