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

architecture Behavioral of counter is
    component D1 
        Port (d : in std_logic;
              clk : in std_logic;
              r : in std_logic;
              q : out std_logic;
              not_q : out std_logic);
     end component;
     
     component D2 
        Port (d : in std_logic;
              clk : in std_logic;
              not_q : out std_logic);
     end component;
     
     signal data1 : std_logic_vector(3 downto 0);
     signal data2 : std_logic_vector(3 downto 0);
     signal not_data2 : std_logic_vector(3 downto 0);
     signal not_cck : std_logic;
     signal not_rck : std_logic;
     signal d_not_cclr : std_logic;
     signal reg_out : std_logic_vector(3 downto 0);
     signal not_g : std_logic;
     signal not_rc : std_logic;
     signal d_not_rc : std_logic;
     signal internal_q : std_logic_vector(3 downto 0);
     signal not_updown : std_logic;
     signal d_not_updown : std_logic;
     signal not_load : std_logic;
     signal d_not_load : std_logic;
     signal not_ent : std_logic;
     signal internal_data : std_logic_vector(3 downto 0);
     signal enp_and : std_logic;
     signal mux_out : std_logic_vector(3 downto 0);
     
begin
    not_cck <= not cck;
    not_rck <= not rck;
    d_not_cclr <= not (not cclr);
    not_rc <= not rc;
    d_not_rc <= not not_rc;
    not_g <= not g;
    not_updown <= not updown;
    d_not_updown <= not not_updown;
    not_load <= not load;
    d_not_load <= not not_load;
    not_ent <= not ent;
    enp_and <= not not_load and not enp and not ent;
    
    
    GEN_REG : for i in 0 to 3 generate
        FF1_inst : entity work.D1
            port map (d => data1(i),
                      clk => not_cck,
                      r => d_not_cclr,
                      q => data2(i),
                      not_q => not_data2(i));
          
        FF2_inst : entity work.D2
            port map (d => data2(i),
                      clk => not_rck,
                      not_q => reg_out(i));    
    end generate GEN_REG;
    
    output_proc : process(reg_out, not_data2, not_rc, d_not_rc)
    begin
        for i in 0 to 3 loop
            internal_q(i) <= (reg_out(i) and d_not_rc) nor (not_rc and not_data2(i));
        end loop;
    end process;
    
    input_proc : process(data, d_not_load)
    begin
        for i in 0 to 3 loop
            internal_data(i) <= d_not_load nor data(i);
        end loop;
    end process;
    
    mux_updown_proc : process(not_updown, d_not_updown, data2, not_data2)
    begin
        for i in 0 to 3 loop
            mux_out(i) <=  (data2(i) and not_updown) nor (d_not_updown and not_data2(i));
        end loop;
    end process;
    
    data1(0) <= ((data2(0) and enp_and) 
                or (not enp_and and d_not_load and not_data2(0))) 
                nor internal_data(0);
    data1(1) <= ((data2(1) and enp_and and mux_out(0)) 
                or ((not enp_and or not mux_out(0)) and d_not_load and not_data2(1))) 
                nor internal_data(1);
    data1(2) <= ((data2(2) and enp_and and mux_out(0) and mux_out(1)) 
                or ((not enp_and or not mux_out(0) or not mux_out(1)) and d_not_load and not_data2(2))) 
                nor internal_data(2);
    data1(3) <= ((data2(3) and enp_and and mux_out(0) and mux_out(1) and mux_out(2)) 
                or ((not enp_and or not mux_out(0) or not mux_out(1) or not mux_out(2)) and d_not_load and not_data2(3))) 
                nor internal_data(3);
    
    
    rco <= (mux_out(0) and mux_out(1) and mux_out(2) and mux_out(3)) nand not_ent;
    q <= internal_q when not_g = '1' else "ZZZZ";

end Behavioral;
