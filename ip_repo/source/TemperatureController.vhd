----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2016 04:42:32 PM
-- Design Name: 
-- Module Name: TemperatureController - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TemperatureController is
    Port ( sensor1 : in std_logic_vector(15 downto 0);
           sensor2 : in std_logic_vector(15 downto 0);
           sensor3 : in std_logic_vector(15 downto 0);
           DesiredTemperature : in std_logic_vector(15 downto 0);
           heater : out STD_LOGIC;
           cooler : out STD_LOGIC);
end TemperatureController;

architecture Behavioral of TemperatureController is
------------------------------------------------------------------
signal t : std_logic_vector(15 downto 0);
signal compare1 : boolean;
signal compare2 : boolean;
signal compare3 : boolean;
------------------------------------------------------------------
begin
    compare1 <= sensor1 > sensor2;
    compare2 <= sensor2 > sensor3;
    compare3 <= sensor1 > sensor3;

    p1 : process(sensor1 , sensor2 , sensor3)
    begin 

        --finding the middle temperature!
        if (compare1 = true) then
            if (compare3 = true) then
                if (compare2 = true) then
                    t <= sensor2;
                else
                    t <= sensor3;                    
                end if;
            else
                t<= sensor1;
            end if;
        else
            if (compare3 = true) then
                t<=sensor1;
            else
                if (compare2 = true) then
                    t <=sensor3;
                else
                    t <=sensor2;
                end if;
            end if;
        end if;
                
    end process;
    
    p2 : process(t)
    begin
        --enabling cooler or heater based on some calculations! 
        if t < DesiredTemperature - "0000000000000100" then --4
            heater <= '1';
            cooler <= '0';
        elsif t < DesiredTemperature + "0000000000000010" and t > DesiredTemperature - "0000000000000010" then
            heater <= '0';
            cooler <= '0';
        elsif t > DesiredTemperature + "0000000000000100" then
            heater <= '0';
            cooler <= '1';
        end if;
    end process;
end Behavioral;
