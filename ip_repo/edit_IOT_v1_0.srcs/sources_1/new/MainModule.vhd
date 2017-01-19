----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/19/2017 01:21:45 PM
-- Design Name: 
-- Module Name: MainModule - Behavioral
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

entity MainModule is
Port ( 
    clk : in std_logic;
    OP : in  std_logic_vector (31 downto 0);
    input : in std_logic;
    err : out std_logic; --for detecting the motion
    ---
    LightSensor : in STD_LOGIC;
    LightOut : out STD_LOGIC;
    ----
    sensor1 : in std_logic_vector(7 downto 0); --temprature1
    sensor2 : in std_logic_vector(7 downto 0); --temprature2
    sensor3 : in std_logic_vector(7 downto 0); --temprature3
    heater : out STD_LOGIC;
    cooler : out STD_LOGIC
    ----        
);
end MainModule;

-- behavour of mainModule
architecture Behavioral of MainModule is
--initializing the components of mainModule!
-----------------------------------------------------------------
component LightController
    Port ( LightSensor : in STD_LOGIC;
           LightOut : out STD_LOGIC;
           microBlazeCommand : in STD_LOGIC);
end component LightController;
-----------------------------------------------------------------
component TemperatureController
    Port ( sensor1 : in std_logic_vector(7 downto 0);
           sensor2 : in std_logic_vector(7 downto 0);
           sensor3 : in std_logic_vector(7 downto 0);
           DesiredTemperature : in std_logic_vector(7 downto 0);
           heater : out STD_LOGIC;
           cooler : out STD_LOGIC);
end component TemperatureController;
-----------------------------------------------------------------
component imageRecognizerModule
Port (
 input : in std_logic;
 clk : in std_logic;
 enable : in std_logic;
 err : out std_logic
 );
end component imageRecognizerModule;
-----------------------------------------------------------------
------------------------INTERNAL SIGNALS-------------------------
signal desiredTemp : std_logic_vector(7 downto 0);
signal lightMicroBlazeCommand : std_logic;
signal enableSig :std_logic;
-----------------------------------------------------------------
begin
-- port maps
imageRecognizer : imageRecognizerModule port map 
    (input => input ,
     enable => enableSig ,
     err => err ,
     clk => clk);
     
lightController : LightController port map
    (LightSensor => LightSensor ,
     LightOut => LightOut ,
     microBlazeCommand => lightMicroBlazeCommand);
    
temperatureController : TemperatureController port map
    (sensor1 => sensor1,
     sensor2 => sensor2,
     sensor3 => sensor3,
     heater => heater,
     cooler => cooler,
     DesiredTemperature => desiredTemp);

--microblaze commands logic
p1 : process (OP)
begin
    if  OP(31 downto 16) = "00000000"  then--set temperature
        desiredTemp <= OP(15 downto 0);
    elsif  OP(31 downto 16) = "00000001"  then--light on
        lightMicroBlazeCommand <= '1';
    elsif OP(31 downto 16) = "00000010" then--light off
        lightMicroBlazeCommand <= '0';
--    else if OP(31 downto 16) = "00000011" then-- sound detection on        
        --DO NOTHING
--    else if OP(31 downto 16) = "00000100" then-- sound detection off
        --DO NOTHING
    elsif OP(31 downto 16) = "00000101" then-- image detection on
        enableSig <= '1';
    elsif OP(31 downto 16) = "00000110" then-- image detection off
        enableSig <= '1';
--    else
        --DO NOTHING
    end if;
    
end process p1;
    
end Behavioral;
