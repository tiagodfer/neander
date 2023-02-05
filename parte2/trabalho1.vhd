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
        Z_out : out std_logic;
        N_out : out std_logic;
		  ACC_out : out std_logic_vector (3 downto 0);
        dec_out : out std_logic_vector(3 downto 0)
    );
end trabalho1;

architecture behavior of trabalho1 is
    component LUT_ULA is
        port(
            input_1  : in std_logic_vector(3 downto 0);
            input_2  : in std_logic_vector(3 downto 0);
            ULA_sel   : in std_logic_vector(1 downto 0);
            output_1 : out std_logic_vector(3 downto 0)
            );
    end component;
type mem is array (0 to 15) of std_logic_vector(7 downto 0);
signal PC : std_logic_vector(3 downto 0):= "0000";
signal RDM : std_logic_vector(7 downto 0);
signal add : std_logic_vector(3 downto 0);
signal sub : std_logic_vector(3 downto 0);
signal mult : std_logic_vector(7 downto 0); -- lembrar de fazer o resize
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
    "01000100",
    "01010110",
    "01100111", 
    "00000000",
    -- "00000000",
    -- "00000000",
    -- "00000000",
    -- "00000000",
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
-- LUT_ULA
    inst_ULA: LUT_ULA port map(
        input_1 => ACC,
        input_2 => RDM(3 downto 0),
        ULA_sel => RDM(5 downto 4),
        output_1 => mux_ULA
    );
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

    -- decoderOut
    dec_out <= decoder;

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
    Z_out <= Z;
    N_out <= N;

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

-- make an explanation of the code here