library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic(Clock_Frequency : integer);
    port(
        i_Clk     : in std_logic;
        n_Rst     : in std_logic;
        o_Seconds : out integer;
        o_Minutes : out integer;
        o_Hours   : out integer
    );
end entity Timer;

architecture RTL of Timer is 

    -- Signal for counting clock period
    signal Ticks : integer;

begin
    process(i_Clk) is
        begin
            if rising_edge(i_Clk) then

                -- If negative reset signal is active
                if n_Rst = '0' then
                    Ticks     <= 0;
                    o_Seconds <= 0;
                    o_Minutes <= 0;
                    o_Hours   <= 0;

                else
                    -- True once every second
                    if Ticks = Clock_Frequency - 1 then
                        Ticks <= 0;
                        
                        -- True once every minute
                        if o_Seconds = 59 then
                            o_Seconds <= 0;
                            
                            -- True once every hour
                            if o_Minutes = 59 then
                                o_Minutes <= 0;
                                
                                -- True once every day
                                if o_Hours = 23 then
                                    o_Hours <= 0;
                                else
                                    o_Hours <= o_Hours + 1;
                                end if;

                            else
                                o_Minutes <= o_Minutes + 1;
                            end if;

                        else
                            o_Seconds <= o_Seconds + 1;
                        end if;
                    
                    else
                        Ticks <= Ticks + 1;
                    end if;
                end if;
            end if;
        end process;
    
    end architecture RTL;
