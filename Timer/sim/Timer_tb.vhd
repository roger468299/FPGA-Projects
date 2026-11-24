library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer_tb is
end entity Timer_tb;

architecture sim of Timer_tb is
    
    -- Slow down the clock to speed up simulation time
    constant Clock_Frequency : integer := 10; -- 10MHz
    constant Clock_Period    : time    := 1000 ms / Clock_Frequency;

    signal i_Clk     : std_logic := '1';
    signal n_Rst     : std_logic := '0';
    signal o_Seconds : integer;
    signal o_Minutes : integer;
    signal o_Hours   : integer;

begin

    -- Unit Under Test (UUT)
    i_Tick : entity work.Timer
    generic map(Clock_Frequency => Clock_Frequency)
    port map(
    i_Clk     => i_Clk,
    n_Rst     => n_Rst,
    o_Seconds => o_Seconds,
    o_Minutes => o_Minutes,
    o_Hours   => o_Hours
    );

    -- Process for generating clock signal
    i_Clk <= not i_Clk after Clock_Period / 2;

    -- Testbench sequence
    process is
        begin
            wait until rising_edge(i_Clk);
            wait until rising_edge(i_Clk);

            -- Take UUT out of reset
            n_Rst <= '1';

            wait;
        end process;
    end architecture;

