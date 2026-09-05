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

    signal cclk        : std_logic := '0';
    signal rclk        : std_logic := '0';
    signal clr_n      : std_logic := '1';
    signal load_n     : std_logic := '1';
    signal enp_n      : std_logic := '1';
    signal ent_n      : std_logic := '1'; 
    signal u_d        : std_logic := '1';
    signal rc     : std_logic := '1';
    signal g_n        : std_logic := '0';
    signal data_in    : std_logic_vector(3 downto 0) := (others => '0');

    signal q_out      : std_logic_vector(3 downto 0);
    signal rco_n      : std_logic;

begin

    -- 1. Инстанцирование тестируемого устройства (DUT)
    -- Примечание: Убедитесь, что имена портов совпадают с вашей моделью SN74LS697
    uut : entity work.counter
        port map (
            cck     => cclk,
            rck => rclk,
            cclr   => clr_n,
            load  => load_n,
            enp   => enp_n,
            ent   => ent_n,
            updown     => u_d,
            rc  => rc,
            g     => g_n,
            data       => data_in,
            q       => q_out,
            rco   => rco_n
        );

    -- 2. Генератор тактового сигнала
    clk_process : process
    begin
        cclk <= '0';
        rclk <= '0';
        wait for CLK_PERIOD / 2;
        cclk <= '1';
        rclk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 3. Процесс генерации стимулов
    stim_proc: process
    begin
        -- Инициализация и сброс
        clr_n  <= '0';
        wait for 30 ns;
        clr_n  <= '1';
        wait for CLK_PERIOD;

        -- -------------------------------------------------------------
        -- Тест 1: Синхронная параллельная загрузка значения 0xAB (171)
        -- -------------------------------------------------------------
        data_in <= x"A";
        load_n  <= '0';
        wait for CLK_PERIOD;
        load_n  <= '1';
        wait for CLK_PERIOD;

        -- -------------------------------------------------------------
        -- Тест 2: Инкремент (счет вверх, U_D = '1')
        -- -------------------------------------------------------------
        u_d   <= '1';
        enp_n <= '0';
        ent_n <= '0';
        wait for CLK_PERIOD * 5; -- Считаем 5 тактов

        -- -------------------------------------------------------------
        -- Тест 3: Декремент (счет вниз, U_D = '0')
        -- -------------------------------------------------------------
        u_d <= '0';
        wait for CLK_PERIOD * 3; -- Считаем 3 такта назад

        -- -------------------------------------------------------------
        -- Тест 4: Проверка работы запрета счета (ENP / ENT)
        -- -------------------------------------------------------------
        enp_n <= '1'; -- Пауза счета
        wait for CLK_PERIOD * 3;
        enp_n <= '0'; -- Возобновление счета
        wait for CLK_PERIOD * 2;

        -- -------------------------------------------------------------
        -- Тест 5: Управление выходом через z-состояние (G_N)
        -- -------------------------------------------------------------
        g_n <= '1'; -- Выходы Q должны перейти в 'Z'
        wait for CLK_PERIOD * 2;
        g_n <= '0'; -- Включение выходов
        wait for CLK_PERIOD;

        -- -------------------------------------------------------------
        -- Тест 6: Асинхронный сброс во время работы
        -- -------------------------------------------------------------
        clr_n <= '0';
        wait for 7 ns; -- Асинхронное действие независимо от CLK
        clr_n <= '1';
        wait for CLK_PERIOD * 2;

        -- Завершение симуляции
        wait;
    end process;

end Sim;
