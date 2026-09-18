----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2026 10:29:48 AM
-- Design Name: 
-- Module Name: adder_par - Behavioral
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

entity adder_par is
    Port (a : in std_logic_vector(4 downto 1);
          b : in std_logic_vector(4 downto 1);
          c0 : in std_logic;
          sum : out std_logic_vector(4 downto 1);
          c4 : out std_logic);
end adder_par;

architecture Behavioral of adder_par is
    signal generating : std_logic_vector(4 downto 1);
    signal propagating : std_logic_vector(4 downto 1);
    
    signal gen_not_prep : std_logic_vector(4 downto 1);
begin
    generating <= a nand b;
    propagating <= a nor b;
    gen_not_prep <= generating and not propagating;

    c4 <= (((propagating(4) or (generating(4) and propagating(3)))
                          or (generating(4) and generating(3) and propagating(2)))
                          or (generating(4) and generating(3) and generating(2) and propagating(1)))
                          nor (generating(4) and generating(3) and generating(2) and generating(1) and not c0);
                          
    
    
    sum(1) <= gen_not_prep(1) xor not (not c0);
    sum(2) <= gen_not_prep(2) xor (propagating(1) nor (generating(1) and not c0));
    sum(3) <= gen_not_prep(3) xor ((propagating(2) or (generating(2) and generating(1) and not c0)) 
                                              nor (generating(2) and propagating(1)));
    sum(4) <= gen_not_prep(4) xor (((propagating(3) or (generating(3) and generating(2) and generating(1) and not c0)) 
                                               or (generating(3) and generating(2) and propagating(1)))
                                               nor (generating(3) and propagating(2)));
    
end Behavioral;