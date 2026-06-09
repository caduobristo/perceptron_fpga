library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_counter is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

        addr     : out unsigned(6 downto 0);
        done     : out std_logic
    );
end entity;

architecture rtl of address_counter is

    signal addr_reg     : unsigned(6 downto 0) := (others => '0');
    signal done_reg     : std_logic := '0';

    signal delay_count  : integer range 0 to 2 := 0;
    signal waiting_done : std_logic := '0';

begin

    process(clk)
    begin

        if rising_edge(clk) then

            if reset = '1' then

                addr_reg     <= (others => '0');
                done_reg     <= '0';
                delay_count  <= 0;
                waiting_done <= '0';

            elsif done_reg = '0' then

                if waiting_done = '0' then

                    if addr_reg = 127 then

                        waiting_done <= '1';
                        delay_count  <= 0;

                    else

                        addr_reg <= addr_reg + 1;

                    end if;

                else

                    if delay_count = 1 then

                        done_reg <= '1';

                    else

                        delay_count <= delay_count + 1;

                    end if;

                end if;

            end if;

        end if;

    end process;

    addr <= addr_reg;
    done <= done_reg;

end architecture;