library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity trabalho1_FSM is

    port(
        clock: in std_logic;
        reset: in std_logic;
        count_load: out std_logic;
        en_ULA : out std_logic;
        Z_out : in std_logic;
        N_out : in std_logic;
        dec_out : in std_logic_vector(3 downto 0)
    );
end entity;

architecture behavior of trabalho1_FSM is
type state_name is (PCpp, ULA, jmp);
signal state : state_name; 
signal next_state : state_name;
begin
    process(clock, reset)
    begin
        if reset = '0' then
            state <= PCpp;
        elsif rising_edge(clock) then
            state <= next_state;
        end if;
    end process;

    process(state, dec_out, Z_out, N_out)
    begin
        case state is
            when PCpp =>
                if dec_out = "0000" or dec_out = "0001" or dec_out = "0010" or dec_out = "0011" then
                    next_state <= ULA;
                elsif dec_out = "0100" or (dec_out = "0101" and Z_out = '1') or (dec_out = "0110" and N_out = '1') then
                    next_state <= jmp;
                else
                    next_state <= PCpp;
                end if;
            when ULA =>
                if dec_out = "0000" or dec_out = "0001" or dec_out = "0010" or dec_out = "0011" then
                    next_state <= ULA;
                elsif dec_out = "0100" or (dec_out = "0101" and Z_out = '1') or (dec_out = "0110" and N_out = '1') then
                    next_state <= jmp;
                else
                    next_state <= PCpp;
                end if;
            when jmp =>
                if dec_out = "0000" or dec_out = "0001" or dec_out = "0010" or dec_out = "0011" then
                    next_state <= ULA;
                else
                    next_state <= PCpp;
                end if;
            end case;
    end process;

    process(next_state)
    begin
        case next_state is
            when PCpp =>
                --reset <= '1';
                count_load <= '1';
            when ULA =>
                --reset <= '1';
                en_ULA <= '1';
            when jmp =>
                --reset <= '1';
                count_load <= '0';
                en_ULA <= '0';
        end case;
    end process;
end behavior;
