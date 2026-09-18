----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2026 07:32:01 PM
-- Design Name: 
-- Module Name: JK2_tb - Sim
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

entity JK2_tb is
--  Port ( );
end JK2_tb;

architecture Sim of JK2_tb is
    constant CLK_PERIOD : time := 20 ns;

    signal j : std_logic;
    signal k : std_logic;
    signal clk : std_logic;
    signal q_n : std_logic;
begin
    uut : entity work.JK2
        port map (
          j => j,
          k => k,
          clk => clk,
          q_n => q_n
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    process
    begin
        j <= '1';
        k <= '1';
        wait for CLK_PERIOD / 2;
        
        k <= '0';
        wait for CLK_PERIOD;
        
        j <= '0';
        k <= '1';
        wait for CLK_PERIOD;
        
        j <= '1';
        wait;
    end process;
end Sim;
