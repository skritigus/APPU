----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 01:41:34 AM
-- Design Name: 
-- Module Name: counter_test_file - Sim
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_test_file is
--  Port ( );
end counter_test_file;

architecture Sim of counter_test_file is
    constant CLK_PERIOD : time := 20 ns;

    signal cclk : std_logic := '0';
    signal rclk : std_logic := '0';
    
    signal cclr_n : std_logic := '1';
    signal enp_n : std_logic := '1';
    signal ent_n : std_logic := '1'; 
    signal updown : std_logic := '1';
    signal rc : std_logic := '1';
    signal g_n : std_logic := '0';
    
    signal load_n : std_logic := '1';
    signal data_in : std_logic_vector(3 downto 0) := (others => '0');

    signal q_out : std_logic_vector(3 downto 0);
    signal rco_n : std_logic;

begin

    uut : entity work.counter
        port map (
            cck => cclk,
            rck => rclk,
            cclr => cclr_n,
            load => load_n,
            enp => enp_n,
            ent => ent_n,
            updown => updown,
            rc => rc,
            g => g_n,
            data => data_in,
            q => q_out,
            rco => rco_n
        );

    clk_process : process
    begin
        cclk <= '0';
        rclk <= '0';
        wait for CLK_PERIOD / 2;
        cclk <= '1';
        rclk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    process
        file text_file : text;
        variable text_line : line;
        variable file_status : file_open_status;
        
        procedure write_row is
        begin
            write(text_line, cclr_n);
            write(text_line, string'("    "));
            write(text_line, enp_n);
            write(text_line, string'("   "));
            write(text_line, ent_n);
            write(text_line, string'("   "));
            write(text_line, updown);
            write(text_line, string'("   "));
            write(text_line, rc);
            write(text_line, string'("   "));
            write(text_line, g_n);
            write(text_line, string'("  "));
            write(text_line, load_n);
            write(text_line, string'("    "));
            write(text_line, data_in);
            write(text_line, string'("   "));
            write(text_line, q_out);
            write(text_line, string'("  "));
            write(text_line, rco_n);
            writeline(text_file, text_line);
        end procedure;
        
        procedure record_result(amount : in integer) is
        begin
            for i in 0 to amount loop
                wait for CLK_PERIOD;
                write_row;
            end loop;
        end procedure;
        
    begin
        file_open(file_status, text_file, "/home/skritigus/7_sem/APPU/Lab_3/counter_test_file.txt", write_mode);
        
        if file_status = open_ok then
            report "File created successfully";
        else 
            report "Can't create file" severity failure;
            wait;
        end if;
        
        write(text_line, string'("cclr enp ent u/d r/c g  load data   q     rco"));
        writeline(text_file, text_line);
        
        cclr_n <= '0';
        record_result(1);
        
        data_in <= x"A";
        cclr_n <= '1';
        load_n <= '0';
        record_result(1);

        load_n <= '1';
        data_in <= x"0";
        updown <= '1';
        enp_n <= '0';
        ent_n <= '0';
        record_result(16);
        
        updown <= '0';
        record_result(16);
        
        enp_n <= '1';
        record_result(3);
        
        ent_n <= '1';
        record_result(3);

        g_n <= '1';
        record_result(2);
        
        g_n <= '0';
        wait for CLK_PERIOD;
        write_row;

        cclr_n <= '0';
        record_result(1);
        
        cclr_n <= 'U';
        data_in <= "UUUU";
        g_n <= 'U';
        enp_n <= 'U';
        ent_n <= 'U';
        updown <= 'U';
        rc <= 'U';
        load_n <= 'U';
        record_result(1);
        
        cclr_n <= 'X';
        data_in <= "XXXX";
        g_n <= 'X';
        enp_n <= 'X';
        ent_n <= 'X';
        updown <= 'X';
        rc <= 'X';
        load_n <= 'X';
        record_result(1);
        
        cclr_n <= 'Z';
        data_in <= "ZZZZ";
        g_n <= 'Z';
        enp_n <= 'Z';
        ent_n <= 'Z';
        updown <= 'Z';
        rc <= 'Z';
        load_n <= 'Z';
        record_result(1);

        wait;
    end process;
end Sim;
