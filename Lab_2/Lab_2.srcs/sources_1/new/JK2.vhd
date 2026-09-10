----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/04/2026 01:30:24 AM
-- Design Name: 
-- Module Name: D2 - Behavioral
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

entity JK2 is
    Port (j : in std_logic;
          k : in std_logic;
          clk : in std_logic;
          not_q : out std_logic);
end JK2;

architecture Behavioral of JK2 is
    signal data : std_logic;
begin
    process(clk)
    begin
        if(falling_edge(clk)) then
            data <= (j and not data) or (data and not k);
        end if;
    end process;

    not_q <= not data;
    
end Behavioral;
