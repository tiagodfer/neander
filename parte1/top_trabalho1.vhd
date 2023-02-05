library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity top_trabalho1 is
    port(
        clock : in std_logic;
		  reset : in std_logic;
		  N     : out std_logic;
		  Z     : out std_logic;
		  ACC   : out std_logic_vector (3 downto 0)
    );
end entity;

architecture behavior of top_trabalho1 is
    component trabalho1 is
        port(
            clock: in std_logic;
            reset: in std_logic;
            count_load: in std_logic;
            en_ULA : in std_logic;
			ACC_out : out std_logic_vector (3 downto 0);
            Z_out : out std_logic;
            N_out : out std_logic;
            dec_out : out std_logic_vector(3 downto 0)
        );
    end component;

    component trabalho1_fsm is
        port(
            clock: in std_logic;
            reset: in std_logic;
            count_load: out std_logic;
            en_ULA : out std_logic;
            Z_out : in std_logic;
            N_out : in std_logic;
            dec_out : in std_logic_vector(3 downto 0)
        );
    end component;
    signal count_load, en_ULA, Z_out, N_out : std_logic;
    signal dec_out : std_logic_vector(3 downto 0);
begin
    trabalho1_inst : trabalho1 port map(
        clock => clock,
        reset => reset,
        count_load => count_load,
        en_ULA => en_ULA,
		  ACC_out => ACC,
        Z_out => Z_out,
        N_out => N_out,
        dec_out => dec_out
    );
    trabalho1_fsm_inst : trabalho1_fsm port map(
        clock => clock,
        reset => reset,
        count_load => count_load,
        en_ULA => en_ULA,
        Z_out => Z_out,
        N_out => N_out,
        dec_out => dec_out
    );

	 N <= N_out;
	 Z <= Z_out;
end architecture;