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
use std.textio.all;
use ieee.std_logic_textio.all;

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
    signal a : std_logic_vector(4 downto 1);
    signal b : std_logic_vector(4 downto 1);
    signal c0 : std_logic;
    
    signal sum : std_logic_vector(4 downto 1);
    signal c4 : std_logic;

begin
    uut_par : entity work.adder_par
    port map (
    a => a,
    b => b,
    c0 => c0,
    sum => sum,
    c4 => c4);
    
--    process
--    begin
--    for i in 0 to 1 loop   
--            for j in 0 to 15 loop
--                for k in 0 to 15 loop
--                    a <= std_logic_vector(to_unsigned(j, 4));
--                    b <= std_logic_vector(to_unsigned(k, 4));
--                    wait for 20 ns;
--                end loop;
--            end loop;
        
--        c0 <= not c0;
--    end loop;
--    end process;

    process
        file text_file : text;
        variable file_status : file_open_status;
        variable text_line : line;
        variable v_a : std_logic_vector(4 downto 1);
        variable v_b : std_logic_vector(4 downto 1);
        variable v_c0 : std_logic;
        variable v_expected_sum : std_logic_vector(4 downto 1);
        variable v_expected_c4 : std_logic;
        variable line_counter : natural := 1;
        variable error_counter : integer := 0;
        variable is_line_valid : boolean;
        
        procedure safe_read(text_line : inout line; 
                            value : out std_logic; 
                            valid_flag : inout boolean) is
            variable is_data_valid : boolean;
        begin
            read(text_line, value, is_data_valid);
            valid_flag := valid_flag and is_data_valid;
        end procedure;
    
        procedure safe_read(text_line : inout line; 
                            value : out std_logic_vector; 
                            valid_flag : inout boolean) is
            variable is_data_valid : boolean;
        begin
            read(text_line, value, is_data_valid);
            valid_flag := valid_flag and is_data_valid;
        end procedure;
        
    begin
    
        file_open(file_status, text_file, "/home/skritigus/7_sem/APPU/Lab_3/adder_test_file.txt", read_mode);
    
        if file_status = open_ok then
            report "File opened successfully";
        else
            report "Can't open file" severity failure;
            wait;
        end if;
        
        readline(text_file, text_line);
            
        while not endfile(text_file) loop
            readline(text_file, text_line);
            line_counter := line_counter + 1;
            is_line_valid := true;
            
            safe_read(text_line, v_c0, is_line_valid);
            safe_read(text_line, v_a, is_line_valid);
            safe_read(text_line, v_b, is_line_valid);
            safe_read(text_line, v_expected_c4, is_line_valid);
            safe_read(text_line, v_expected_sum, is_line_valid);
            
--            assert is_line_valid
--            report "Vector data is corrupted" severity error;
            
            if not is_line_valid then
                report  "[Line " & natural'image(line_counter) &
                "]: Vector data is corrupted" severity error;
                error_counter := error_counter + 1;
                next;
            end if;
            
            a <= v_a;
            b <= v_b;
            c0 <= v_c0;
            wait for 20 ns;
            
--            assert sum_par = v_expected_sum and c4_par = v_expected_c4
--            report "[Line " & natural'image(line_counter) & 
--            "]: expected: c4 = " & std_logic'image(v_expected_c4) &
--            ", sum = " & to_hstring(v_expected_sum) &
--            "; result: c4 = " & std_logic'image(c4_par) &
--            ", sum = " & to_hstring(sum_par) severity error;

            if sum /= v_expected_sum or c4 /= v_expected_c4 then
                report "[Line " & natural'image(line_counter) &
                "]: expected: c4 = " & std_logic'image(v_expected_c4) &
                ", sum = " & to_hstring(v_expected_sum) &
                "; result: c4 = " & std_logic'image(c4) &
                ", sum = " & to_hstring(sum) severity error;
                error_counter := error_counter + 1;
            end if;
            
        end loop;
        
        if error_counter > 0 then
            report "Adder is defective. Overall errors: " &
            integer'image(error_counter) severity error;
        else
            report "Adder works fine";
        end if;
        
        file_close(text_file);
        wait;
    end process;

end Sim;
