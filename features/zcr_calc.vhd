library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zcr_calc is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;

        done       : in  std_logic;

        sample_in  : in  signed(7 downto 0);

        zcr_out    : out unsigned(15 downto 0)
    );
end entity;

architecture rtl of zcr_calc is

    signal last_sample  : signed(7 downto 0) := (others => '0');
    signal zcr_count    : unsigned(15 downto 0) := (others => '0');
    signal first_sample : std_logic := '1';

begin

    process(clk)
    begin

        if rising_edge(clk) then

            if reset = '1' then

                last_sample  <= (others => '0');
                zcr_count    <= (others => '0');
                first_sample <= '1';

            elsif done = '0' then

                if first_sample = '1' then

                    last_sample  <= sample_in;
                    first_sample <= '0';

                else

                    if sample_in(7) /= last_sample(7) then
                        zcr_count <= zcr_count + 1;
                    end if;

                    last_sample <= sample_in;

                end if;

            end if;

        end if;

    end process;

    zcr_out <= zcr_count;

end architecture;