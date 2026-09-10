----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/05/2026 06:45:16 PM
-- Design Name: 
-- Module Name: counter_tb - Behavioral
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

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Sim of counter_tb is
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

    stim_proc: process
    begin
        cclr_n  <= '0';
        wait for 30 ns;
        cclr_n  <= '1';
        wait for CLK_PERIOD;

        data_in <= x"A";
        load_n  <= '0';
        wait for CLK_PERIOD;
        load_n  <= '1';
        wait for CLK_PERIOD;

        updown   <= '1';
        enp_n <= '0';
        ent_n <= '0';
        wait for CLK_PERIOD * 5; 
        
        updown <= '0';
        wait for CLK_PERIOD * 3; 
        
        enp_n <= '1';
        wait for CLK_PERIOD * 3;
        enp_n <= '0';
        wait for CLK_PERIOD * 2;

        g_n <= '1';
        wait for CLK_PERIOD * 2;
        g_n <= '0';
        wait for CLK_PERIOD;

        cclr_n <= '0';
        wait for 7 ns;
        cclr_n <= '1';
        wait for CLK_PERIOD * 2;

        wait;
    end process;

end Sim;
