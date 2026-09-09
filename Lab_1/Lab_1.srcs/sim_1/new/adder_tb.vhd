----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2026 10:36:03 AM
-- Design Name: 
-- Module Name: adder_tb - Sim
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_tb is
--  Port ( );
end adder_tb;

architecture Sim of adder_tb is
    signal clk : std_logic;
    
    signal a : std_logic_vector(4 downto 1);
    signal b : std_logic_vector(4 downto 1);
    signal c0 : std_logic;
    
    signal sum : std_logic_vector(4 downto 1);
    signal c4 : std_logic;
begin
    uut : entity work.adder_cons
    port map (
    a => a,
    b => b,
    c0 => c0,
    sum => sum,
    c4 => c4);
    
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    process
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(i, 4));
                b <= std_logic_vector(to_unsigned(j, 4));
                wait until rising_edge(clk);
            end loop;
        end loop;
    end process;
    
    c0_process : process
    begin
        c0 <= '0';
        wait for 5110 ns;
        c0 <= '1';
        wait;
    end process;

end Sim;
