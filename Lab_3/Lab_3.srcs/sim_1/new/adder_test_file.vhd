----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2026 04:30:51 PM
-- Design Name: 
-- Module Name: adder_test_file - Sim
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
use std.textio.ALL;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_test_file is
--  Port ( );
end adder_test_file;

architecture Sim of adder_test_file is  
    signal a : std_logic_vector(4 downto 1);
    signal b : std_logic_vector(4 downto 1);
    signal c0 : std_logic;
    
    signal sum_par : std_logic_vector(4 downto 1);
    signal c4_par : std_logic;
    signal sum_cons : std_logic_vector(4 downto 1);
    signal c4_cons : std_logic;
    
    file text_file : text;
begin
    
    uut_cons : entity work.adder_cons
    port map (
    a => a,
    b => b,
    c0 => c0,
    sum => sum_cons,
    c4 => c4_cons);
    
    uut_par : entity work.adder_par
    port map (
    a => a,
    b => b,
    c0 => c0,
    sum => sum_par,
    c4 => c4_par);
    
    process
        variable file_status : file_open_status;
        variable text_line : line;
      
        procedure write_row is
        begin
            write(text_line, c0);
            write(text_line, string'("   "));
            write(text_line, a);
            write(text_line, ' ');
            write(text_line, b);
            write(text_line, string'("     "));
            write(text_line, c4_par);
            write(text_line, string'("   "));
            write(text_line, sum_par);
            writeline(text_file, text_line);
        end procedure;
      
    begin
        
    file_open(file_status, text_file, "/home/skritigus/7_sem/APPU/Lab_3/adder_test_file.txt", write_mode);
     
    if file_status = open_ok then
        report "File created successfully";
    else 
        report "Can't create file" severity failure;
        wait;
    end if; 
        
    write(text_line, string'("c0  a    b        c4  sum"));                     
    writeline(text_file, text_line); 
    
    c0 <= '0';
       
    for i in 0 to 1 loop   
        for j in 0 to 15 loop
            for k in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(j, 4));
                b <= std_logic_vector(to_unsigned(k, 4));
                wait for 20 ns;
                write_row;
                
            end loop;
        end loop;
        
        c0 <= not c0;
    end loop;
    
    c0 <= 'Z';
    a <= "ZZZZ";
    b <= "ZZZZ";
    wait for 20 ns;
    write_row;
    
    c0 <= 'U';
    a <= "UUUU";
    b <= "UUUU";
    wait for 20 ns;
    write_row;
    
    c0 <= 'X';
    a <= "XXXX";
    b <= "XXXX";
    wait for 20 ns;
    write_row;
        
    file_close(text_file);
    wait;
    end process;
end Sim;
