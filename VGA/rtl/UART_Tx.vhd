library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Tx is
    generic(
        g_CLKS_PER_BIT : integer := 217
    );
    port(
        i_Clk       : in std_logic;
        i_Tx_DV     : in  std_logic;
        i_Tx_Byte   : in  std_logic_vector(7 downto 0);
        o_Tx_Active : out std_logic; 
        o_Tx_Serial : out std_logic;
        o_Tx_Done   : out std_logic
    );
end entity UART_Tx;

architecture RTL of UART_Tx is

    type t_SM_Main is (IDLE, TX_START_BIT, TX_DATA_BITS, TX_STOP_BIT, CLEANUP);
    signal r_SM_Main : t_SM_Main := IDLE;

    signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT - 1 := 0;
    signal r_Bit_Index : integer range 0 to 7 := 0;
    signal r_Tx_Data   : std_logic_vector(7 downto 0) := (others => '0');
    signal r_Tx_Done   : std_logic := '0';

begin
    process(i_Clk)
    begin
        if rising_edge(i_Clk) then

            case r_SM_Main is
                when IDLE =>
                    o_Tx_Active <= '0';
                    o_Tx_Serial <= '1';
                    r_Tx_Done   <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;

                    if i_Tx_DV = '1' then
                        r_Tx_Data <= i_Tx_Byte;
                        r_SM_Main <= TX_START_BIT;
                    else
                        r_SM_Main <= IDLE;
                    end if;

                -- Send out start bit '0'    
                when TX_START_BIT =>
                    o_Tx_Active <= '1';
                    o_Tx_Serial <= '0';

                    -- Wait g_CLKS_PER_SEC - 1 clock cycles for start bit to finish
                    if r_Clk_Count < g_CLKS_PER_BIT - 1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= TX_START_BIT;
                    else
                        r_Clk_Count <= 0;
                        r_SM_Main <= TX_DATA_BITS;
                    end if;

                -- Wait g_CLKS_PER_SEC - 1 clock cycles for data bits to finish
                when TX_DATA_BITS =>
                    o_Tx_Serial <= r_Tx_Data(r_Bit_Index);

                    if r_Clk_Count < g_CLKS_PER_BIT - 1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= TX_DATA_BITS;
                    else
                        r_Clk_Count <= 0;

                        -- Check if all bits have been sent
                        if r_Bit_Index < 7 then
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= TX_DATA_BITS;
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main <= TX_STOP_BIT;
                        end if;
                    end if;

                -- Send out stop bit. Stop bit = 1
                when TX_STOP_BIT =>
                    o_Tx_Serial <= '1';

                    if r_Clk_Count < g_CLKS_PER_BIT - 1 then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= TX_STOP_BIT;
                    else
                    r_Tx_Done   <= '1';
                    r_Clk_Count <= 0;
                    r_SM_Main <= CLEANUP;
                    end if;

                when CLEANUP =>
                    o_Tx_Active <= '0';
                    r_Tx_Done   <= '1';
                    r_SM_Main   <= IDLE;
            
                end case;
            end if;
        end process;

        o_Tx_Done <= r_Tx_Done;

    end architecture RTL;
