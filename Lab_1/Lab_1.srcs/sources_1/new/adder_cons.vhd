----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2026 01:16:24 PM
-- Design Name: 
-- Module Name: adder_cons - Behavioral
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

entity adder_cons is
    Port (a : in std_logic_vector(4 downto 1);
          b : in std_logic_vector(4 downto 1);
          c0 : in std_logic;
          sum : out std_logic_vector(4 downto 1);
          c4 : out std_logic);
end adder_cons;

architecture Behavioral of adder_cons is
begin
    process(a, b, c0)
        variable v_generating : std_logic_vector(4 downto 1);
        variable v_propogating : std_logic_vector(4 downto 1);
        variable v_gen_not_prop : std_logic_vector(4 downto 1);
        variable v_sum : std_logic_vector(4 downto 1);
        variable v_c4 : std_logic;
    begin
        for i in 1 to 4 loop
            v_generating(i) := a(i) nand b(i);
            v_propogating(i) := a(i) nor b(i);
            v_gen_not_prop(i) := v_generating(i) and not v_propogating(i);
        end loop;
        
        v_c4 := (((v_propogating(4) or (v_generating(4) and v_propogating(3)))
                          or (v_generating(4) and v_generating(3) and v_propogating(2)))
                          or (v_generating(4) and v_generating(3) and v_generating(2) and v_propogating(1)))
                          nor (v_generating(4) and v_generating(3) and v_generating(2) and v_generating(1) and not c0);
                          
        v_sum(1) := v_gen_not_prop(1) xor not (not c0);
        v_sum(2) := v_gen_not_prop(2) xor (v_propogating(1) nor (v_generating(1) and not c0));
        v_sum(3) := v_gen_not_prop(3) xor ((v_propogating(2) or (v_generating(2) and v_generating(1) and not c0)) 
                                                  nor (v_generating(2) and v_propogating(1)));
        v_sum(4) := v_gen_not_prop(4) xor (((v_propogating(3) or (v_generating(3) and v_generating(2) and v_generating(1) and not c0)) 
                                                   or (v_generating(3) and v_generating(2) and v_propogating(1)))
                                                   nor (v_generating(3) and v_propogating(2)));
        
        sum <= v_sum;
        c4  <= v_c4;
    end process;
end Behavioral;
