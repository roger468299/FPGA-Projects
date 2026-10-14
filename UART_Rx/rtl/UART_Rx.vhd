library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Rx is
    generic(
        g_CLKS_PER_BIT : integer := 217
    );
    port(
        i_Clk       : in std_logic;
        i_Rx_Serial : in std_logic;
        o_Rx_DV     : out std_logic;
        o_Rx_Byte   : out std_logic_vector(7 downto 0)
    );

end entity UART_Rx;

architecture RTL of UART_Rx is

    type t_SM_Main is (IDLE, RX_START_BIT, RX_DATA_BITS, RX_STOP_BIT, CLEANUP);
    signal r_SM_Main : t_SM_Main := IDLE; -- Signal keeps track of the current state

    signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT - 1 := 0;
    signal r_Bit_Index : integer range 0 to 7 := 0;
    signal r_Rx_Byte   : std_logic_vector(7 downto 0) := (others => '0');
    signal r_Rx_DV     : std_logic := '0';

begin

    process (i_Clk)
    begin
        if rising_edge(i_Clk) then

            case r_SM_Main is

                when IDLE =>
                    r_Rx_DV     <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;

                    if i_Rx_Serial = '0' then
                        r_SM_Main <= RX_START_BIT; -- Start bit detected
                    else
                        r_SM_Main <= IDLE;
                    end if;

                when RX_START_BIT =>
                    if r_Clk_Count = (g_CLKS_PER_BIT -1) / 2 then -- Align to the middle of the start bit
                        if i_Rx_Serial = '0' then
                            r_Clk_Count <= 0;
                            r_SM_Main <= RX_DATA_BITS;
                        else
                            r_SM_Main <= IDLE;
                        end if;
                    else
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main   <= RX_START_BIT;
                    end if;
                
                -- Sample data after waiting for g_CLKS_PER_BIT - 1
                when RX_DATA_BITS =>
                    if r_Clk_Count < g_CLKS_PER_BIT - 1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= RX_DATA_BITS;
                    else
                        r_Clk_Count <= 0;
                        r_Rx_Byte(r_Bit_Index) <= i_Rx_Serial;

                        -- Check if all bits have been received
                        if r_Bit_Index < 7 then
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= RX_DATA_BITS;
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main <= RX_STOP_BIT;
                        end if;
                    end if;

                when RX_STOP_BIT =>
                    if r_Clk_Count < g_CLKS_PER_BIT - 1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= RX_STOP_BIT;
                    else
                        r_Rx_DV <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main <= CLEANUP;
                    end if;
                    
                when CLEANUP =>
                    r_SM_Main <= IDLE;
                    r_Rx_DV   <= '0';

                when others =>
                    r_SM_Main <= IDLE;
                end case;
            end if;
        end process;

        o_Rx_DV   <= r_Rx_DV;
        o_Rx_Byte <= r_Rx_Byte;

    end architecture RTL;



                


