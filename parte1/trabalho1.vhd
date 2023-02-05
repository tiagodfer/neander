library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity trabalho1 is
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
end trabalho1;

architecture behavior of trabalho1 is
    type mem is array (0 to 15) of std_logic_vector(7 downto 0);
    signal PC : std_logic_vector(3 downto 0):= "0000";
    signal RDM : std_logic_vector(7 downto 0);
    signal add : std_logic_vector(3 downto 0);
    signal sub : std_logic_vector(3 downto 0);
    signal mult : std_logic_vector(7 downto 0);
    signal mux_ULA : std_logic_vector(3 downto 0);
    signal comp : std_logic;
    signal Z : std_logic;
    signal ACC : std_logic_vector(3 downto 0);
    signal N : std_logic;
    signal decoder : std_logic_vector(3 downto 0);
    signal RAM : mem := (
        "00000001",
        "00010010",
        "00100011",
        "00110100",
        "01000101",
        "01010110",
        "01100111", 
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
);

begin
    -- PC
    process(clock, reset)
    begin
        if not(reset) = '1' then
            PC <= "0000";
        elsif rising_edge(clock) then
            if count_load = '1' then
                PC <= PC + "0001";
            else
                PC <= RDM(3 downto 0);
            end if;
        end if;
    end process;

    -- RDM
    process(clock, reset)
    begin
        if not(reset) = '1' then
            RDM <= "00000000";
        elsif rising_edge(clock) then
            RDM <= RAM(conv_integer(unsigned(PC)));
        end if;
    end process;

    -- add
    add <= ACC + RDM(3 downto 0);

    -- sub
    sub <= ACC - RDM(3 downto 0);

    -- mult
    mult <= ACC * RDM(3 downto 0);

    -- decoderOut
    dec_out <= decoder;

    -- mux_ULA
    mux_ULA <= RDM(3 downto 0) when RDM(5 downto 4) = "00" else
               add when RDM(5 downto 4) = "01" else
               sub when RDM(5 downto 4) = "10" else
               mult(3 downto 0) when RDM(5 downto 4) = "11" else
               not(RDM(3 downto 0)) + '1' when RDM(3) = '1' else
               not(add) + '1' when add(3) = '1' else
               not(sub) + '1' when sub(3) = '1' else
               not(mult(3 downto 0)) + '1' when mult(3) = '1' else
               "0000";


    -- comp
    comp <= '1' when mux_ULA = "0000" else
            '0';

    -- Z, ACC e N
    process(clock, reset)
    begin
        if not(reset) = '1' then
            Z <= '0';
            ACC <= "0000";
            N <= '0';
        elsif rising_edge(clock) then
            if en_ULA = '1' then
                ACC <= mux_ULA;
                if mux_ULA(3) = '1' then
                    N <= '1';
                else
                    N <= '0';
                end if;
                if comp = '1' then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
            end if;
        end if;
    end process;

    -- NZ e ACC
    Z_out <= Z;
    N_out <= N;
	 ACC_out <= ACC;

    -- decoder
    process(RDM)
    begin
        case RDM(7 downto 4) is
            when "0000" => decoder <= "0000";
            when "0001" => decoder <= "0001";
            when "0010" => decoder <= "0010";
            when "0011" => decoder <= "0011";
            when "0100" => decoder <= "0100";
            when "0101" => decoder <= "0101";
            when "0110" => decoder <= "0110";
            when others => decoder <= "0000";
        end case;
    end process;
end behavior;
