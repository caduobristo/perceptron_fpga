library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity energy_calc is
    port(
        clk        : in std_logic;
        reset      : in std_logic;

        done       : in std_logic;

        sample_in  : in signed(7 downto 0);

        energy_out : out unsigned(31 downto 0)
    );
end entity;

architecture rtl of energy_calc is

    signal energy_acc : unsigned(31 downto 0) := (others => '0');

    -- Aguarda a latência da ROM
    signal processing_enable : std_logic := '0';
    signal startup_counter   : integer range 0 to 2 := 0;

begin

    process(clk)

        variable square : signed(15 downto 0);

    begin

        if rising_edge(clk) then

            if reset = '1' then

                energy_acc <= (others => '0');

                processing_enable <= '0';
                startup_counter   <= 0;

            else

                -- Espera 2 clocks após o reset
                if processing_enable = '0' then

                    if startup_counter = 1 then

                        processing_enable <= '1';

                    else

                        startup_counter <= startup_counter + 1;

                    end if;

                -- Processamento normal
                elsif done = '0' then

                    square := sample_in * sample_in;

                    energy_acc <= energy_acc +
                        resize(unsigned(square), 32);

                end if;

            end if;

        end if;

    end process;

    energy_out <= energy_acc;

end architecture;