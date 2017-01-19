----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2016 02:56:10 PM
-- Design Name: 
-- Module Name: imageRecognizerModule - Behavioral
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
use work.devider.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity imageRecognizerModule is
Port (
 input : in std_logic;
 clk : in std_logic;
 enable : in std_logic;
 err : out std_logic
 );
end imageRecognizerModule;

architecture Behavioral of imageRecognizerModule is
--------------------------------STATES-----------------------------------------
type states is (s0 , s1 , s2 , s3 , s4 , s5 , s6 , s7 , gettingPixels ,
 e0 , e1 , e2 , e3 , e4 , e5 , e6 , e7 , endOfImage , imagesComparing);
signal curState : states := s0;
----------------------pixel and digit and imageNumebr--------------------------
signal pixelCounter : integer range 0 to 1001 := 0; --a counter of piexls!
signal digitCounter : integer range 0 to 7 := 0; --a counter of digits!
signal imageNumber : integer range 0 to 1 := 0;
-----------------------------sum and average-----------------------------------
signal sum : std_logic_vector (18 downto 0) := "0000000000000000000";
--type averageArray is array (1 downto 0) of std_logic_vector (7 downto 0); --this is Correct!?
signal average1 : std_logic_vector (7 downto 0) := "00000000"; --is this correct?!
signal average2 : std_logic_vector (7 downto 0) := "00000000";
-------------------------------------------------------------------------------

begin
------this is the process for changing the states!-------
p1 : process (clk)
begin
    if (rising_edge(clk) and enable = '1') then
        case  curState is
        when s0 => 
            if input = '1' then
            curState <= s1;
            else
            curState <= s0;
            end if;
        when s1 => 
            if input = '1' then
            curState <= s2;
            else
            curState <= s0;
            end if;
        when s2 => 
            if input = '1' then
            curState <= s3;
            else
            curState <= s0;
            end if;
        when s3 => 
            if input = '1' then
            curState <= s4;
            else
            curState <= s0;
            end if;
        when s4 => 
            if input = '1' then
            curState <= s5;
            else
            curState <= s0;
            end if;
        when s5 => 
            if input = '1' then
            curState <= s6;
            else
            curState <= s0;
            end if;
        when s6 => 
            if input = '1' then
            curState <= s7;
            else
            curState <= s0;
            end if;
        when s7 => 
            if input = '1' then
            curState <= gettingPixels;
            else
            curState <= s0;
            end if;
        when gettingPixels => 
            if pixelCounter = 1000 and digitCounter = 7 then --the condition is important!
            curState <= e0;
            else
            curState <= curState;
            end if;
        when e0 =>
            if input = '0' then
            curState <= e1;
            else
            curState <= e0;
            end if ;
        when e1 =>
            if input = '0' then
            curState <= e2;
            else
            curState <= e0;
            end if ;
        when e2 =>
            if input = '0' then
            curState <= e3;
            else
            curState <= e0;
            end if ;
        when e3 =>
            if input = '0' then
            curState <= e4;
            else
            curState <= e0;
            end if ;
        when e4 =>
            if input = '0' then
            curState <= e5;
            else
            curState <= e0;
            end if ;
        when e5 =>
            if input = '0' then
            curState <= e6;
            else
            curState <= e0;
            end if ;
        when e6 =>
            if input = '0' then
            curState <= e7;
            else
            curState <= e0;
            end if ;
        when e7 =>
            if input = '0' then
            curState <= endOfImage;
            else
            curState <= e0;
            end if ;
        when endOfImage =>
            if imageNumber = 1 then
                curState <= imagesComparing;
            else
                curState <= s0;
            end if;
        when imagesComparing =>
            curState <= s0;    
        when others => curState <= curState ; --------------IS THIS CORRECT?!
        
        end case;
    end if ;
end process p1;
------------------------------END OF PROCESS P1------------------------------------


------- process p1 : this is the main process for changing the output -------------
p2 : process (clk)

----------------------- VARIABLES -------------------------------
--this is a variable that saves 8 bits of a pixel!
variable pixel : std_logic_vector (7 downto 0) := "00000000"; -- a pixel that has 8 bits!
variable calculatedAverage : std_logic_vector(7 downto 0) := "00000000"; --
variable greaterAverage : std_logic_vector (7 downto 0)  := "00000000";--for comparing two averages we must select the greater average as Denominator;
variable averagesDiffrence : std_logic_vector(7 downto 0) := "00000000"; --
variable averagesDiffrenceMul : std_logic_vector(14 downto 0) := "000000000000000"; --
variable comparingResult : std_logic_vector(6 downto 0) := "0000000"; --
---------------------- CONSTANTS --------------------------------
constant imagePixelsNumber : std_logic_vector(18 downto 0) := "0000000001111101001";
constant hundred : std_logic_vector(6 downto 0) := "1100100";
constant five : std_logic_vector(6 downto 0) := "0000101";
-----------------------------------------------------------------
begin
  if (rising_edge(clk) and enable = '1') then
  
    case curState is
    when gettingPixels => 
        --in any conditions this assignment must be happened! (just pixel is a variable!)
        pixel(digitCounter) := input;
        
        --if the number is completed (in previous clock!)! 
        if digitCounter = 7 then --this means it is the last bit of the pixel!
            sum <= sum + pixel;
            digitCounter <= 0;
            pixelCounter <= pixelCounter + 1;
        else
          digitCounter <= digitCounter + 1;          
        end if;
    
    when endOfImage =>
        --setting zero values to counter signals
        pixelCounter <= 0;
        digitCounter <= 0;
        
        --calculating the average!
        calculatedAverage := devide (sum , imagePixelsNumber , 8); --the second argument is 1001    
            --selecting the approriate average signal and changing the number of image
            if imageNumber = 0 then
                average1 <= calculatedAverage;
                imageNumber <= 1;
            else
                average2 <= calculatedAverage;
                imageNumber <= 1;
            end if;
            
        sum <= "0000000000000000000";

    when imagesComparing =>
        --calculating this expresion : (|avg2 - avg1|*100/greaterAverage)
            --getting the greater average for using in denominator of the deduction!!
        if average1 > average2 then 
            greaterAverage := average1;
            averagesDiffrence := average1 - average2;
        else
            greaterAverage := average2;
            averagesDiffrence := average2 - average1;
        end if;
        
        averagesDiffrenceMul := (averagesDiffrence * hundred); --the second argument is 100 in binary!
        comparingResult := devide (averagesDiffrenceMul , greaterAverage , 7); --the result is less than 100 so we set 7 bits for result !
        if  comparingResult > five then -- 5 in binary
            err <= '1'; -- ^_^
        else
            err <= '0';
        end if;
        
    when others =>
        err <= '0';
    end case;
    
  end if;
end process p2;
-----------------------------END OF PROCESS P2-----------------------------------

end Behavioral;
    
