---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity FA is 
   port(
        a		: in    std_logic;
        b		: in    std_logic;
        c_in	: in    std_logic;
        sum		: out   std_logic;
        c_out	: out   std_logic
		  );
end FA;


architecture behavior of FA is
	begin
		sum 	<= a xor b xor c_in;
		c_out <= (a and b) or (c_in and (a OR b));
end behavior;


