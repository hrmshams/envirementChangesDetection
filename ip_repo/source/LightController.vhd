----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2016 11:22:11 PM
-- Design Name: 
-- Module Name: LightController - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LightController is
    Port ( LightSensor : in STD_LOGIC;
           LightOut : out STD_LOGIC;
           microBlazeCommand : in STD_LOGIC);
end LightController;

architecture Behavioral of LightController is

begin
    p1 : process (microBlazeCommand , LightSensor)
    begin
        if microBlazeCommand = '1' then
            if LightSensor = '1' then
                LightOut <= '0';
            else
                LightOut <= '1';
            end if;     
        else
            lightOut <= '0';
        end if;
    end process;

end Behavioral;
