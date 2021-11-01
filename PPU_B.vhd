---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity PPU_B is
  Port (
    a      :  in  std_logic_vector(1 downto 0);
    b      :  in  std_logic_vector(2 downto 0);
    PP    : out std_logic_vector(3 downto 0)
);
end PPU_B;



--architecture Behavioral of PPU_B is

--signal and0_a : std_logic;
--signal and0_b : std_logic;

--signal and1_a : std_logic;
--signal and1_b : std_logic;

--signal and2_a : std_logic;
--signal and2_b : std_logic;

--signal carry : std_logic_vector(1 downto 0) := (others =>'0');

--begin

--and0_a  <=a(1) and b(0);
--and0_b  <=a(0) and b(1);
--and1_a  <=a(1) and b(1);
--and1_b  <=a(0) and b(2);
--and2_a  <=a(1) and b(2);



--		PP(0) 	<= and0_a xor and0_b xor '0';
--		carry(0) <= (and0_a and and0_b);



--		PP(1) 	<= and1_a xor and1_b xor carry(0);
--		carry(1) <= (and1_a and and1_b) or (carry(0) and (and1_a OR and1_b));



--		PP(2) 	<= and2_a xor carry(1);
--		PP(3) <= (and2_a and '0') or (carry(1) and and2_a);


--end Behavioral;




architecture Behavioral of PPU_B is


signal input : std_logic_vector(4 downto 0) := (others => '0');
signal output : std_logic_vector(3 downto 0) := (others => '0');

begin

input <= a & b;

proc: process(input)

  begin
     case input is
        when "00000" => output <= "0000";
         when "00001" => output <= "0000";
         when "00010" => output <= "0000";
         when "00011" => output <= "0000";
         when "00100" => output <= "0000";
         when "00101" => output <= "0000";
         when "00110" => output <= "0000";
         when "00111" => output <= "0000";
         when "01000" => output <= "0000";
         when "01001" => output <= "0000";
         when "01010" => output <= "0001";
         when "01011" => output <= "0001";
         when "01100" => output <= "0010";
         when "01101" => output <= "0010";
         when "01110" => output <= "0011";
         when "01111" => output <= "0011";
         when "10000" => output <= "0000";
         when "10001" => output <= "0001";
         when "10010" => output <= "0010";
         when "10011" => output <= "0011";
         when "10100" => output <= "0100";
         when "10101" => output <= "0101";
         when "10110" => output <= "0110";
         when "10111" => output <= "0111";
         when "11000" => output <= "0000";
         when "11001" => output <= "0001";
         when "11010" => output <= "0011";
         when "11011" => output <= "0100";
         when "11100" => output <= "0110";
         when "11101" => output <= "0111";
         when "11110" => output <= "1001";
         when "11111" => output <= "1010";
	     when others => NULL;
     end case;
end process proc;

    PP   <= output;


end Behavioral;