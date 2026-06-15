library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity neuron is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;

        done        : in  std_logic;

		  zcr_in      : in  unsigned(15 downto 0);
        energy_in   : in  unsigned(31 downto 0);

        result      : out std_logic;
        score_out   : out signed(31 downto 0)
    );
end entity;

architecture rtl of neuron is

    constant W1   : integer := -63;
    constant W2   : integer := 95;
    constant BIAS : integer := -507;

    signal score_reg : signed(31 downto 0) := (others => '0');

begin

    process(clk)

        variable energy_v : signed(31 downto 0);
        variable zcr_v    : signed(31 downto 0);

        variable term1    : signed(31 downto 0);
        variable term2    : signed(31 downto 0);
        variable score_v  : signed(31 downto 0);

    begin

        if rising_edge(clk) then

            if reset = '1' then

                score_reg <= (others => '0');
                result <= '0';

            elsif done = '1' then

                energy_v :=
						 resize(
							  signed(
									shift_right(energy_in, 14)
							  ),
							  32
						 );

                zcr_v :=
                    resize(
                        signed('0' & zcr_in),
                        32
                    );

                term1 :=
                    resize(
                        to_signed(W1, 32) *
                        energy_v,
                        32
                    );

                term2 :=
                    resize(
                        to_signed(W2, 32) *
                        zcr_v,
                        32
                    );

                score_v :=
                    term1 +
                    term2 +
                    to_signed(BIAS, 32);

                score_reg <= score_v;

                if score_v >= 0 then
                    result <= '1';  -- Agudo
                else
                    result <= '0';  -- Grave
                end if;

            end if;

        end if;

    end process;

    score_out <= score_reg;

end architecture;