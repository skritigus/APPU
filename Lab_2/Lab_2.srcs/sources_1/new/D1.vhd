----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/04/2026 01:20:02 AM
-- Design Name: 
-- Module Name: D1 - Behavioral
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

entity D1 is
    Port (d : in std_logic;
          clk : in std_logic;
          r : in std_logic;
          q : out std_logic;
          not_q : out std_logic);
end D1;

architecture Behavioral of D1 is
    signal data : std_logic;
begin
    process(clk, r)
    begin
        if (r  = '0') then
            data <= '0';
        elsif(falling_edge(clk)) then
            data <= d;
        end if;
    end process;
    
    q <= data;
    not_q <= not data;

end Behavioral;
