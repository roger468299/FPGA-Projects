library ieee;
use ieee.std_logic_1164.all;

entity UART_Rx_7seg_Top is
    port(
        i_Clk : in std_logic;
        
        -- UART Rx Data
        i_UART_Rx : in std_logic;
        
        -- Segment1 is upper digit, segment2 lower digit
        o_Segment1_A    : out std_logic;
        o_Segment1_B    : out std_logic;
        o_Segment1_C    : out std_logic;
        o_Segment1_D    : out std_logic;
        o_Segment1_E    : out std_logic;
        o_Segment1_F    : out std_logic;
        o_Segment1_G    : out std_logic;
        o_Segment2_A    : out std_logic;
        o_Segment2_B    : out std_logic;
        o_Segment2_C    : out std_logic;
        o_Segment2_D    : out std_logic;
        o_Segment2_E    : out std_logic;
        o_Segment2_F    : out std_logic;
        o_Segment2_G    : out std_logic
    );
end entity UART_Rx_7seg_Top;

architecture RTL of UART_Rx_7seg_Top is

    signal w_Rx_DV : std_logic;
    signal w_Rx_Byte : std_logic_vector(7 downto 0);

    signal w_Segment1_A : std_logic;
    signal w_Segment1_B : std_logic;
    signal w_Segment1_C : std_logic;
    signal w_Segment1_D : std_logic;
    signal w_Segment1_E : std_logic;
    signal w_Segment1_F : std_logic;
    signal w_Segment1_G : std_logic;
    signal w_Segment2_A : std_logic;
    signal w_Segment2_B : std_logic;
    signal w_Segment2_C : std_logic;
    signal w_Segment2_D : std_logic;
    signal w_Segment2_E : std_logic;
    signal w_Segment2_F : std_logic;
    signal w_Segment2_G : std_logic;

begin
    UART_Rx_Inst : entity work.UART_Rx
        generic map (
            g_CLKS_PER_BIT => 217)
        port map (
            i_Clk => i_Clk,
            i_Rx_Serial => i_UART_Rx,
            o_Rx_DV => w_Rx_DV,
            o_Rx_Byte => w_Rx_Byte);

    Seven_seg1_Inst : entity work.Binary_To_7Segment
        port map (
            i_Clk => i_Clk,
            i_Binary_Num => w_Rx_Byte(7 downto 4),
            o_Segment_A => w_Segment1_A,
            o_Segment_B => w_Segment1_B,
            o_Segment_C => w_Segment1_C,
            o_Segment_D => w_Segment1_D,
            o_Segment_E => w_Segment1_E,
            o_Segment_F => w_Segment1_F,
            o_Segment_G => w_Segment1_G
        );

    o_Segment1_A <= not w_Segment1_A;
    o_Segment1_B <= not w_Segment1_B;
    o_Segment1_C <= not w_Segment1_C;
    o_Segment1_D <= not w_Segment1_D;
    o_Segment1_E <= not w_Segment1_E;
    o_Segment1_F <= not w_Segment1_F;
    o_Segment1_G <= not w_Segment1_G;

 Seven_seg2_Inst : entity work.Binary_To_7Segment
        port map (
            i_Clk => i_Clk,
            i_Binary_Num => w_Rx_Byte(3 downto 0),
            o_Segment_A => w_Segment2_A,
            o_Segment_B => w_Segment2_B,
            o_Segment_C => w_Segment2_C,
            o_Segment_D => w_Segment2_D,
            o_Segment_E => w_Segment2_E,
            o_Segment_F => w_Segment2_F,
            o_Segment_G => w_Segment2_G
        );

    o_Segment2_A <= not w_Segment2_A;
    o_Segment2_B <= not w_Segment2_B;
    o_Segment2_C <= not w_Segment2_C;
    o_Segment2_D <= not w_Segment2_D;
    o_Segment2_E <= not w_Segment2_E;
    o_Segment2_F <= not w_Segment2_F;
    o_Segment2_G <= not w_Segment2_G;
    
end architecture RTL;
