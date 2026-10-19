-- All test patterns are being generated all the time, i_Pattern signal determines which pattern is displayed
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Test_Pattern_Gen is
    generic (
        g_VIDEO_WIDTH : integer := 3;
        g_TOTAL_COLS : integer  := 800;
        g_TOTAL_ROWS : integer  := 525;
        g_ACTIVE_COLS : integer := 640;
        g_ACTIVE_ROWS : integer := 480
    );
    port (
        i_Clk     : in std_logic;
        i_Pattern : in std_logic_vector(3 downto 0);
        i_HSync   : in std_logic;
        i_VSync   : in std_logic;

        o_HSync     : out std_logic := '0';
        o_VSync     : out std_logic := '0';
        o_Red_Video : out std_logic_vector(g_VIDEO_WIDTH - 1 downto 0);
        o_Grn_Video : out std_logic_vector(g_VIDEO_WIDTH - 1 downto 0);
        o_Blu_Video : out std_logic_vector(g_VIDEO_WIDTH - 1 downto 0)
    );
end entity Test_Pattern_Gen;

architecture RTL of Test_Pattern_Gen is

    component Sync_To_Count is
        generic (
            g_TOTAL_COLS : integer;
            g_TOTAL_ROWS : integer
        );
        port (
        i_Clk   : in std_logic;
        i_HSync : in std_logic;
        i_VSync : in std_logic;

        o_HSync     : out std_logic;
        o_VSync     : out std_logic;
        o_Col_Count : out std_logic_vector(9 downto 0);
        o_Row_Count : out std_logic_vector(9 downto 0)
    );
    end component Sync_To_Count;

    signal w_VSync : std_logic;
    signal w_HSync : std_logic;

    -- Create a type that contains all test patterns
    -- Patterns have 16 indexes (0 to 15) and can be g_VIDEO_WIDTH bits wide
    type t_Patterns is array (0 to 15) of std_logic_vector(g_VIDEO_WIDTH - 1 downto 0);
    signal Pattern_Red : t_Patterns;
    signal Pattern_Grn : t_Patterns;
    signal Pattern_Blu : t_Patterns;

    signal w_Col_Count : std_logic_vector(9 downto 0);
    signal w_Row_Count : std_logic_vector(9 downto 0);

    signal w_Bar_Width  : integer range 0 to g_ACTIVE_COLS / 8;
    signal w_Bar_Select : integer range 0 to 7; -- Colour bars

begin

    Sync_To_Count_Inst : Sync_To_Count
        generic map (
        g_TOTAL_COLS => g_TOTAL_COLS,
        g_TOTAL_ROWS => g_TOTAL_ROWS
    )
    port map (
        i_Clk => i_Clk,
        i_HSync => i_HSync,
        i_VSync => i_VSync,
        o_HSync => w_HSync,
        o_VSync => w_VSync,
        o_Col_Count => w_Col_Count,
        o_Row_Count => w_Row_Count
    );

    -- Register syncs to allign with output data
    process(i_Clk) is
        begin
            if rising_edge(i_Clk) then
                o_VSync <= w_VSync;
                o_HSync <= w_HSync;
            end if;
        end process;
    
    Pattern_Red(0) <= (others => '0');
    Pattern_Grn(0) <= (others => '0');
    Pattern_Blu(0) <= (others => '0');
    
    -- All red pattern
    Pattern_Red(1) <= (others => '1') when (to_integer(unsigned(w_Col_Count)) < g_ACTIVE_COLS and 
                                            to_integer (unsigned(w_Row_Count)) < g_ACTIVE_ROWS) else (others => '0');
                                
    Pattern_Grn(1) <= (others => '0');
    Pattern_Blu(1) <= (others => '0');

    -- All green pattern
    Pattern_Red(2) <= (others => '0');
                                
    Pattern_Grn(2) <= (others => '1') when (to_integer(unsigned(w_Col_Count)) < g_ACTIVE_COLS and 
                                            to_integer (unsigned(w_Row_Count)) < g_ACTIVE_ROWS) else (others => '0');

    Pattern_Blu(2) <= (others => '0');

    -- All purple pattern
    Pattern_Red(3) <= (others => '1') when (to_integer(unsigned(w_Col_Count)) < g_ACTIVE_COLS and 
                                            to_integer (unsigned(w_Row_Count)) < g_ACTIVE_ROWS) else (others => '0');
                                
    Pattern_Grn(3) <= (others => '0');

    Pattern_Blu(3) <= (others => '1') when (to_integer(unsigned(w_Col_Count)) < g_ACTIVE_COLS and 
                                            to_integer (unsigned(w_Row_Count)) < g_ACTIVE_ROWS) else (others => '0');

    -- White/Black checkerboard
    Pattern_Red(4) <= (others => '1') when (w_Col_Count(5) = '0' xor w_Row_Count(5) = '1') else (others => '0');

    Pattern_Grn(4) <= Pattern_Red(4);
    Pattern_Blu(4) <= Pattern_Red(4);

    -- Colour bars
    w_Bar_Width <= g_ACTIVE_COLS / 8;
  
    w_Bar_Select <= 0 when unsigned(w_Col_Count) < w_Bar_Width*1 else
                    1 when unsigned(w_Col_Count) < w_Bar_Width*2 else
                    2 when unsigned(w_Col_Count) < w_Bar_Width*3 else
                    3 when unsigned(w_Col_Count) < w_Bar_Width*4 else
                    4 when unsigned(w_Col_Count) < w_Bar_Width*5 else
                    5 when unsigned(w_Col_Count) < w_Bar_Width*6 else
                    6 when unsigned(w_Col_Count) < w_Bar_Width*7 else
                    7;
    
    Pattern_Red(5) <= (others => '1') when (w_Bar_Select = 4 or w_Bar_Select = 5 or
                                          w_Bar_Select = 6 or w_Bar_Select = 7) else
                    (others => '0');

    Pattern_Grn(5) <= (others => '1') when (w_Bar_Select = 2 or w_Bar_Select = 3 or
                                          w_Bar_Select = 6 or w_Bar_Select = 7) else
                    (others => '0');
    
    Pattern_Blu(5) <= (others => '1') when (w_Bar_Select = 1 or w_Bar_Select = 3 or
                                          w_Bar_Select = 5 or w_Bar_Select = 7) else
                    (others => '0');

    -- Black and white border
    Pattern_Red(6) <= (others => '1') when (to_integer(unsigned(w_Row_Count)) <= 1 or
                                          to_integer(unsigned(w_Row_Count)) >= g_ACTIVE_ROWS - 1 - 1 or
                                          to_integer(unsigned(w_Col_Count)) <= 1 or
                                          to_integer(unsigned(w_Col_Count)) >= g_ACTIVE_COLS - 1 - 1) else
                    (others => '0');

    Pattern_Grn(6) <= Pattern_Red(6);
    Pattern_Blu(6) <= Pattern_Red(6);

    -- Select between different patterns
    process(i_Clk) is
        begin
            if rising_edge(i_Clk) then
                case i_Pattern is
                    when "0000" =>
                    o_Red_Video <= Pattern_Red(0);
                    o_Grn_Video <= Pattern_Grn(0);
                    o_Blu_Video <= Pattern_Blu(0);
                    when "0001" =>
                    o_Red_Video <= Pattern_Red(1);
                    o_Grn_Video <= Pattern_Grn(1);
                    o_Blu_Video <= Pattern_Blu(1);
                    when "0010" =>
                    o_Red_Video <= Pattern_Red(2);
                    o_Grn_Video <= Pattern_Grn(2);
                    o_Blu_Video <= Pattern_Blu(2);
                    when "0011" =>
                    o_Red_Video <= Pattern_Red(3);
                    o_Grn_Video <= Pattern_Grn(3);
                    o_Blu_Video <= Pattern_Blu(3);
                    when "0100" =>
                    o_Red_Video <= Pattern_Red(4);
                    o_Grn_Video <= Pattern_Grn(4);
                    o_Blu_Video <= Pattern_Blu(4);
                    when "0101" =>
                    o_Red_Video <= Pattern_Red(5);
                    o_Grn_Video <= Pattern_Grn(5);
                    o_Blu_Video <= Pattern_Blu(5);
                    when "0110" =>
                    o_Red_Video <= Pattern_Red(6);
                    o_Grn_Video <= Pattern_Grn(6);
                    o_Blu_Video <= Pattern_Blu(6);
                    when others =>
                    o_Red_Video <= Pattern_Red(0);
                    o_Grn_Video <= Pattern_Grn(0);
                    o_Blu_Video <= Pattern_Blu(0);
                    end case;
                end if;
            end process;
        
        end architecture RTL;

      

      
