----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/04/2026 12:57:33 AM
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity counter is
     Port (g : in std_logic;
           rc : in std_logic;
           rck : in std_logic;
           cclr : in std_logic;
           updown : in std_logic;
           load : in std_logic;
           enp : in std_logic;
           ent : in std_logic;
           cck : in std_logic;
           data : in std_logic_vector(3 downto 0);
           q : out std_logic_vector(3 downto 0);
           rco : out std_logic);
end counter;

architecture RTL of counter is     
    signal cck_n : std_logic;
    signal rck_n : std_logic;
    
    signal cnt_in : std_logic_vector(3 downto 0);
    signal cnt_out : std_logic_vector(3 downto 0);
    signal cnt_out_n : std_logic_vector(3 downto 0);
    signal cnt_in_n : std_logic_vector(3 downto 0);
    
    signal reg_out_n : std_logic_vector(3 downto 0);
    signal internal_q : std_logic_vector(3 downto 0);
        
    signal updown_n : std_logic;
    signal updown_n_buffered : std_logic;
    
    signal rc_n : std_logic;
    signal rc_n_buffered : std_logic;
    
    signal load_n : std_logic;
    signal load_n_buffered : std_logic;
    signal data_in_n : std_logic_vector(3 downto 0);
    
    signal cclr_n_buffered : std_logic;
    signal g_n : std_logic;
    signal ent_n : std_logic;
    signal cnt_en : std_logic;
    signal mux_updown : std_logic_vector(3 downto 0);
     
begin
    cck_n <= not cck;
    rck_n <= not rck;
    
    rc_n <= not rc;
    rc_n_buffered <= not rc_n;
    
    updown_n <= not updown;
    updown_n_buffered <= not updown_n;
    
    load_n <= not load;
    load_n_buffered <= not load_n;
    
    cclr_n_buffered <= not (not cclr);
    g_n <= not g;
    ent_n <= not ent;
    cnt_en <= not load_n and not enp and not ent;
    cnt_in_n <= not cnt_in;
    
    GEN_REG : for i in 0 to 3 generate
        FF1_inst : entity work.JK1
            port map (j => cnt_in(i),
                      k => cnt_in_n(i),
                      clk => cck_n,
                      r => cclr_n_buffered,
                      q => cnt_out(i),
                      not_q => cnt_out_n(i));
          
        FF2_inst : entity work.JK2
            port map (j => cnt_out(i),
                      k => cnt_out_n(i),
                      clk => rck_n,
                      not_q => reg_out_n(i));    
    end generate GEN_REG;
    
    output_proc : process(reg_out_n, cnt_out_n, rc_n, rc_n_buffered)
    begin
        for i in 0 to 3 loop
            internal_q(i) <= (reg_out_n(i) and rc_n_buffered) nor (rc_n and cnt_out_n(i));
        end loop;
    end process;
    
    input_proc : process(data, load_n_buffered)
    begin
        for i in 0 to 3 loop
            data_in_n(i) <= load_n_buffered nor data(i);
        end loop;
    end process;
    
    mux_updown_proc : process(updown_n, updown_n_buffered, cnt_out, cnt_out_n)
    begin
        for i in 0 to 3 loop
            mux_updown(i) <=  (cnt_out(i) and updown_n) nor (updown_n_buffered and cnt_out_n(i));
        end loop;
    end process;
    
    cnt_in(0) <= ((cnt_out(0) and cnt_en) 
                or (not cnt_en and load_n_buffered and cnt_out_n(0))) 
                nor data_in_n(0);
    cnt_in(1) <= ((cnt_out(1) and cnt_en and mux_updown(0)) 
                or ((not cnt_en or not mux_updown(0)) and load_n_buffered and cnt_out_n(1))) 
                nor data_in_n(1);
    cnt_in(2) <= ((cnt_out(2) and cnt_en and mux_updown(0) and mux_updown(1)) 
                or ((not cnt_en or not mux_updown(0) or not mux_updown(1)) and load_n_buffered and cnt_out_n(2))) 
                nor data_in_n(2);
    cnt_in(3) <= ((cnt_out(3) and cnt_en and mux_updown(0) and mux_updown(1) and mux_updown(2)) 
                or ((not cnt_en or not mux_updown(0) or not mux_updown(1) or not mux_updown(2)) and load_n_buffered and cnt_out_n(3))) 
                nor data_in_n(3);
    
    
    rco <= (mux_updown(0) and mux_updown(1) and mux_updown(2) and mux_updown(3)) nand ent_n;
    q <= internal_q when g_n = '1' else "ZZZZ";

end RTL;
