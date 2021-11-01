---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity IO_Register8b is
  generic(
  WIDTH   : positive := 8
);
Port (
  clk     : in std_logic;
  fact_a  : in std_logic_vector(WIDTH - 1 downto 0);
  fact_b  : in std_logic_vector(WIDTH - 1 downto 0);
  prod    : out std_logic_vector(2 * WIDTH - 1 downto 0)
 );
end IO_Register8b;

architecture Behavioral of IO_Register8b is

 signal fact_a_reg  :  std_logic_vector(WIDTH - 1 downto 0);
 signal fact_b_reg  :  std_logic_vector(WIDTH - 1 downto 0);
 signal next_prod   :  std_logic_vector(2 * WIDTH - 1 downto 0);
 
 component ApprMult8b is

   Port (
     factor_a  : in std_logic_vector(WIDTH - 1 downto 0);
     factor_b  : in std_logic_vector(WIDTH - 1 downto 0);
     product    : out std_logic_vector(2 * WIDTH - 1 downto 0)
    );
 end component;
  
 
begin

mult_inst : ApprMult8b
  Port map(
    factor_a  => fact_a_reg,
    factor_b  => fact_b_reg,
    product    => next_prod
   );



reg_proc : process(clk)
    begin
        if rising_edge(clk) then
                fact_a_reg <= fact_a;
                fact_b_reg <= fact_b;
                prod <= next_prod;
        end if;        
    end process;

end Behavioral;
