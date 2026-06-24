library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_decoder is
    port (
        result    : in  std_logic;
        pronto    : in  std_logic;
        sample_id : in  std_logic_vector(2 downto 0);
        hex0      : out std_logic_vector(7 downto 0);
        hex1      : out std_logic_vector(7 downto 0);
        hex2      : out std_logic_vector(7 downto 0);
        hex3      : out std_logic_vector(7 downto 0);
        hex4      : out std_logic_vector(7 downto 0);
        hex5      : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of display_decoder is
    signal seg_digit : std_logic_vector(7 downto 0);
begin
    -- Decodifica o sample_id para o display
    process(sample_id)
    begin
        case sample_id is
            when "000" => seg_digit <= x"C0"; -- 0
            when "001" => seg_digit <= x"F9"; -- 1
            when "010" => seg_digit <= x"A4"; -- 2
            when "011" => seg_digit <= x"B0"; -- 3
            when "100" => seg_digit <= x"99"; -- 4
            when "101" => seg_digit <= x"92"; -- 5
            when "110" => seg_digit <= x"82"; -- 6
            when "111" => seg_digit <= x"F8"; -- 7
            when others => seg_digit <= x"FF";
        end case;
    end process;

    -- Decodifica a saída do display baseado no pronto e result
    process(pronto, result, seg_digit)
    begin
        if pronto = '1' then
            if result = '0' then
                -- Display "GrAvE"
                hex5 <= x"FF"; -- Space
                hex4 <= x"82"; -- G
                hex3 <= x"AF"; -- r
                hex2 <= x"88"; -- A
                hex1 <= x"E3"; -- u (for V)
                hex0 <= x"86"; -- E
            else
                -- Display "AgUdO"
                hex5 <= x"FF"; -- Space
                hex4 <= x"88"; -- A
                hex3 <= x"82"; -- G
                hex2 <= x"C1"; -- U
                hex1 <= x"A1"; -- d
                hex0 <= x"C0"; -- O
            end if;
        else
            -- Display "SEL - X"
            hex5 <= x"92"; -- S
            hex4 <= x"86"; -- E
            hex3 <= x"C7"; -- L
            hex2 <= x"BF"; -- -
            hex1 <= x"FF"; -- Space
            hex0 <= seg_digit; -- sample_id
        end if;
    end process;
end architecture;
