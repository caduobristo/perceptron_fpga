library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_counter is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        processing : in  std_logic;

        sample_id  : in  unsigned(2 downto 0);

        addr       : out unsigned(9 downto 0);
        done       : out std_logic
    );
end entity;

architecture rtl of address_counter is

    signal sample_addr  : unsigned(6 downto 0) := (others => '0');
    signal base_addr    : unsigned(9 downto 0);

    signal done_reg     : std_logic := '1';
    signal active       : std_logic := '0';
    signal processing_d : std_logic := '0';

    signal delay_count  : integer range 0 to 2 := 0;
    signal waiting_done : std_logic := '0';

begin

    -- sample_id * 128
    base_addr <= resize(sample_id, 10) sll 7;

    process(clk)
    begin

        if rising_edge(clk) then
            processing_d <= processing;

            if reset = '1' then

                sample_addr  <= (others => '0');
                done_reg     <= '1';
                active       <= '0';
                delay_count  <= 0;
                waiting_done <= '0';

            else
                -- Detecta borda de subida de processing
                if processing = '1' and processing_d = '0' then
                    sample_addr  <= (others => '0');
                    done_reg     <= '0';
                    active       <= '1';
                    delay_count  <= 0;
                    waiting_done <= '0';
                elsif active = '1' then
                    if done_reg = '0' then
                        if waiting_done = '0' then
                            if sample_addr = 127 then
                                waiting_done <= '1';
                                delay_count <= 0;
                            else
                                sample_addr <= sample_addr + 1;
                            end if;
                        else
                            if delay_count = 1 then
                                done_reg <= '1';
                                active   <= '0';
                            else
                                delay_count <= delay_count + 1;
                            end if;
                        end if;
                    end if;
                end if;

            end if;

        end if;

    end process;

    addr <= base_addr + resize(sample_addr, 10);

    done <= done_reg;

end architecture;