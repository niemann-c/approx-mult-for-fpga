---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use ieee.math_real.all;
 use STD.textio.all;
use ieee.std_logic_textio.all;



 
ENTITY AprrMult8b_tb IS
generic(
	WIDTH 			: positive := 8;
	NUMBER_OF_TEST_VECTORS : positive := 2**16
);
END AprrMult8b_tb;
 
ARCHITECTURE behavior OF AprrMult8b_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ApprMult8b
     PORT(
         factor_a : IN  std_logic_vector(WIDTH - 1 downto 0);
         factor_b : IN  std_logic_vector(WIDTH - 1 downto 0);
         product : OUT  std_logic_vector(2* WIDTH - 1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
signal clk : std_logic;
   signal factor_a : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
   signal factor_b : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

 	--Outputs
   signal product : std_logic_vector(2 * WIDTH - 1 downto 0);

   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
	constant	HIGHEST_VALUE		: integer	:=	(2**WIDTH) -1;
 
signal correct_product : unsigned(2 * WIDTH - 1 downto 0);
signal Error_Distance : signed(2 * WIDTH downto 0);
signal ED_Accumulate : signed(2 * WIDTH + INTEGER(CEIL(LOG2(REAL(NUMBER_OF_TEST_VECTORS)))) downto 0) := (others => '0');	
signal MeanED 	: real := 0.0;
signal NormED	: real := 0.0;

signal Relative_ED : real := 0.0;


	function to_string(value : std_logic_vector) return string is
		variable l : line;
	begin
		write(l, to_bitVector(value), right, 0);
		return l.all;
	end to_string;

signal input_vector_sig : std_logic_vector(2* WIDTH - 1 downto 0) := (others => '0');

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ApprMult8b PORT MAP (
          factor_a => factor_a,
          factor_b => factor_b,
          product => product
   );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process


RandomGenProc : process
variable input_vector : std_logic_vector(2* WIDTH - 1 downto 0) := (others => '0');
begin

wait for 500 ps;
  for i in 0 to NUMBER_OF_TEST_VECTORS-1 loop
factor_a	<= input_vector(2*WIDTH-1 downto WIDTH);
factor_b	<= input_vector(WIDTH-1 downto 0);
input_vector_sig <= input_vector;
--assert false report "zufallswert:"  & to_string(DataSlv) & "\n" severity note;
wait for CLK_period;
input_vector := std_logic_vector(unsigned(input_vector)+1);
	end loop;
assert false report "Intended to stop simulation" severity failure;	
--wait;		
end process;
 

check_proc: process(clk)
	variable correct_product_var 	: unsigned(2 * WIDTH - 1 downto 0);
	variable Error_Distance_var 	: signed(2 * WIDTH downto 0);
	--variable ED_Accumulate_var 	: real := 0.0;
	variable MeanED_var 		: real := 0.0;
	variable NormED_var		: real := 0.0;

	file test_result      : text open write_mode is "test_result.txt";
	variable row          : line;

begin



	if rising_edge(clk) then
		correct_product_var	:= unsigned(factor_a) * unsigned(factor_b);
		Error_Distance_var 	:=  signed('0' & product) - signed('0' & std_logic_vector(correct_product_var));
		ED_Accumulate		<= ED_Accumulate + Error_Distance_var;	--Achtung, verschiedene Bitlängen, wird wahrscheinlich nicht funktionieren
--		if product /= std_logic_vector(unsigned(factor_a) * unsigned(factor_b)) then
--			assert false report "Fehler_entdeckt" severity note;
--		end if;
		--wirte data to logfile
		write(row, factor_a, right, WIDTH);
		write(row, string'("; "));
		write(row, factor_b, right, WIDTH);
		write(row, string'("; "));
        	write(row, product, right, 2 * WIDTH);
		write(row, string'("; "));
		write(row, std_logic_vector(correct_product_var), right, 2 * WIDTH+1);
		writeline(test_result, row);
	end if;
	correct_product <= correct_product_var;
	Error_Distance	<= Error_Distance_var;
	if TO_INTEGER(correct_product_var) /= 0 then 
		Relative_ED	<= REAL(TO_INTEGER(Error_Distance_var))/REAL(TO_INTEGER(correct_product_var));
	else
		Relative_ED	<= REAL(TO_INTEGER(Error_Distance_var));
	end if;

	
	
      
end process;


END;
