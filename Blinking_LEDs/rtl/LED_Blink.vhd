library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Blink is
    generic(
        g_COUNT_1Hz  : integer;
        g_COUNT_5Hz  : integer;
        g_COUNT_10Hz : integer;
        g_COUNT_20Hz : integer);
    
    port(
        i_Clk   : in  std_logic;
        o_LED_1 : out std_logic;
        o_LED_2 : out std_logic;
        o_LED_3 : out std_logic;
        o_LED_4 : out std_logic);

end LED_Blink;

architecture RTL of LED_Blink is

    -- Counters
    signal r_COUNT_1Hz  : integer range 0 to g_COUNT_1Hz;
    signal r_COUNT_5Hz  : integer range 0 to g_COUNT_5Hz;
    signal r_COUNT_10Hz : integer range 0 to g_COUNT_10Hz;
    signal r_COUNT_20Hz : integer range 0 to g_COUNT_20Hz;

    signal r_Toggle_1Hz  : std_logic := '0';
    signal r_Toggle_5Hz  : std_logic := '0';
    signal r_Toggle_10Hz : std_logic := '0';
    signal r_Toggle_20Hz : std_logic := '0';

begin
    -- Wire outputs to LEDs
    o_LED_1 <= r_Toggle_1Hz;
    o_LED_2 <= r_Toggle_5Hz;
    o_LED_3 <= r_Toggle_10Hz;
    o_LED_4 <= r_Toggle_20Hz;

    process (i_Clk) is
        begin
            if rising_edge(i_Clk) then
                if r_COUNT_1Hz = g_COUNT_1Hz then
                    r_Toggle_1Hz <= not r_Toggle_1Hz;
                    r_COUNT_1Hz <= 0;
                else
                    r_COUNT_1Hz <= r_COUNT_1Hz + 1;
                end if;
            end if;
        end process;


    process (i_Clk) is
        begin
            if rising_edge(i_Clk) then
                if r_COUNT_5Hz = g_COUNT_5Hz then
                    r_Toggle_5Hz <= not r_Toggle_5Hz;
                    r_COUNT_5Hz <= 0;
                else
                    r_COUNT_5Hz <= r_COUNT_5Hz + 1;
                end if;
            end if;
        end process;
        
        
    process (i_Clk) is
        begin
            if rising_edge(i_Clk) then
                if r_COUNT_10Hz = g_COUNT_10Hz then
                    r_Toggle_10Hz <= not r_Toggle_10Hz;
                    r_COUNT_10Hz <= 0;
                else
                    r_COUNT_10Hz <= r_COUNT_10Hz + 1;
                end if;
            end if;
        end process;
        
        
    process (i_Clk) is
        begin
            if rising_edge(i_Clk) then
                if r_COUNT_20Hz = g_COUNT_20Hz then
                    r_Toggle_20Hz <= not r_Toggle_20Hz;
                    r_COUNT_20Hz <= 0;
                else
                    r_COUNT_20Hz <= r_COUNT_20Hz + 1;
                end if;
            end if;
        end process;    

    end architecture RTL;

