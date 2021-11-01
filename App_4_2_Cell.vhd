---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity App_4_2_Cell is
port(
    a       : in std_logic;
    b       : in std_logic;
    c       : in std_logic;
    d       : in std_logic;
    out_l   : out std_logic;
    out_h   : out std_logic
    );
end App_4_2_Cell;

architecture Behavioral of App_4_2_Cell is

signal input    : std_logic_vector(3 downto 0);
signal output   : std_logic_vector(1 downto 0);

begin

input <= a & b & c & d;

proc: process(input)

  begin
     case input is
       when "0000" => output <= "00";
       when "0001" => output <= "01";
       when "0010" => output <= "01";
       when "0011" => output <= "10";
       when "0100" => output <= "01";
       when "0101" => output <= "10";
       when "0110" => output <= "10";
       when "0111" => output <= "11";
       when "1000" => output <= "01";
       when "1001" => output <= "10";
       when "1010" => output <= "10";
       when "1011" => output <= "11";
       when "1100" => output <= "10";
       when "1101" => output <= "11";
       when "1110" => output <= "11";
       when "1111" => output <= "11";
	when others => NULL;
     end case;
end process proc;

    out_l   <= output(0);
    out_h   <= output(1);



end Behavioral;
