---------------------------------------------------------------------------------------
----    Author: Christoph Niemann
----    Email: christoph.niemann@uni-rostock.de
----    This code is free to use under MIT Licence
----    If you use this code please cite:
----          C. Niemann, M. Rethfeldt and D. Timmermann, "Approximate Multipliers for Optimal Utilization of FPGA Resources," 2021 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems (DDECS), 2021, pp. 23-28, doi: 10.1109/DDECS52668.2021.9417027.
----------------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ApprMult8b is
    generic(
        MULT_WIDTH : positive := 8
    );
    port(
      factor_a  :    in  std_logic_vector(MULT_WIDTH-1 downto 0);
      factor_b  :    in  std_logic_vector(MULT_WIDTH-1 downto 0);
      product   :    out std_logic_vector(2*MULT_WIDTH -1 downto 0)
    );
end ApprMult8b;

architecture Behavioral of ApprMult8b is


    component PPU_A is
      Port (
        a  	    : in  std_logic_vector(1 downto 0);
        b  	    : in  std_logic_vector(2 downto 0);
        PP      : out std_logic_vector(3 downto 0)
      );
    end component;
    
    component PPU_B is
      Port (
        a  	    : in  std_logic_vector(1 downto 0);
        b  	    : in  std_logic_vector(2 downto 0);
        PP      : out std_logic_vector(3 downto 0)
      );
    end component;

    component app_4_2_cell is
      port(
        a       : in  std_logic;
        b       : in  std_logic;
        c       : in  std_logic;
        d       : in  std_logic;
        out_l   : out std_logic;
        out_h   : out std_logic
      );
    end component;
    
    component FA is 
       port(
        a       : in  std_logic;
        b       : in  std_logic;
        c_in    : in  std_logic;
        sum     : out std_logic;
        c_out   : out std_logic
      );
    end component;



type sum_array_type is array(0 to MULT_WIDTH+1) of std_logic_vector(MULT_WIDTH downto 0);
type compression_array_type is array(0 to 12) of std_logic_vector(2*MULT_WIDTH+1 downto 0);

type final_CS_type is array(0 to 1) of std_logic_vector(2*MULT_WIDTH - 1 downto 0);
signal final_CS : final_CS_type := (others => (others =>'0'));

type sig_4_2_comp_type is array(0 to 3) of std_logic_vector(2 * MULT_WIDTH - 1 downto 0);
signal sig_4_2_comp : sig_4_2_comp_type := (others => (others =>'0'));


signal compression_sum_array : compression_array_type := (others => (others => '0'));


signal debug_product_var_signal : unsigned(2*MULT_WIDTH+1 downto 0) := (others => '0');

signal final_add_carry : std_logic_vector(2*MULT_WIDTH - 1 downto 1) := (others => '0');


begin

----------------------------------------------------------
--  Variablen-Nomenklatur:
--      -i gibt die Reihe an
--      -k gibt die Spalte an
----------------------------------------------------------


                                    
-----------------------------------------------------------
--------        PPUs        -------------------------------
-----------------------------------------------------------

    PPU_A_row0_0 : PPU_A
        port map(a => factor_a(2*0+1 downto 2*0), b => factor_b(2 downto 0), PP => compression_sum_array(0)(2*0+3 downto 2*0));

     PPU_A_row0_1 : PPU_A
        port map(a => factor_a(2*1+1 downto 2*1), b => factor_b(2 downto 0), PP => compression_sum_array(1)(2*1+3 downto 2*1));
        
     PPU_A_row0_2 : PPU_A
        port map(a => factor_a(2*2+1 downto 2*2), b => factor_b(2 downto 0), PP => compression_sum_array(0)(2*2+3 downto 2*2));
        
      PPU_A_row0_3 : PPU_A
             port map(a => factor_a(7 downto 6), b => factor_b(2 downto 0), PP => compression_sum_array(1)(9 downto 6));
        

      PPU_B0 : PPU_B
            port map(a => factor_a(2*0+1 downto 2*0), b => factor_b(4 downto 2), PP => compression_sum_array(0+2)(2*0+3+3 downto 2*0+3));

      PPU_B1 : PPU_B
            port map(a => factor_a(2*1+1 downto 2*1), b => factor_b(4 downto 2), PP => compression_sum_array(1+2)(2*1+3+3 downto 2*1+3));

      PPU_B2 : PPU_B
            port map(a => factor_a(2*2+1 downto 2*2), b => factor_b(4 downto 2), PP => compression_sum_array(2)(2*2+3+3 downto 2*2+3));

      PPU_Be3 : PPU_B
            port map(a => factor_a(7 downto 6), b => factor_b(4 downto 2), PP => compression_sum_array(3)(12 downto 9));


      PPU_A_row1_0 : PPU_A
            port map(a => factor_a(2*0+1 downto 2*0), b => factor_b(7 downto 5), PP => compression_sum_array(4)(2*0+3+5 downto 2*0+5));
        
      PPU_A_row1_1 : PPU_A
            port map(a => factor_a(2*1+1 downto 2*1), b => factor_b(7 downto 5), PP => compression_sum_array(5)(2*1+3+5 downto 2*1+5));
          
      PPU_A_row1_2 : PPU_A
            port map(a => factor_a(2*2+1 downto 2*2), b => factor_b(7 downto 5), PP => compression_sum_array(4)(2*2+3+5 downto 2*2+5));
  
       PPU_A_row1_3 : PPU_A
            port map(a => factor_a(7 downto 6), b => factor_b(7 downto 5), PP => compression_sum_array(5)(14 downto 11));

        compression_sum_array(6)(8)    <=factor_a(1) and factor_b(7);
        compression_sum_array(6)(10)   <=factor_a(3) and factor_b(7);
        compression_sum_array(6)(12)   <=factor_a(5) and factor_b(7);
        compression_sum_array(6)(14)   <=factor_a(7) and factor_b(7);



--------------------------------------------------------------------------------------------
----------------------------Compression-Tree------------------------------------------------
--------------------------------------------------------------------------------------------



sig_4_2_comp(0)(6 downto 0)<=compression_sum_array(0)(6 downto 0);
sig_4_2_comp(1)(4 downto 2)<=compression_sum_array(1)(4 downto 2);
sig_4_2_comp(1)(6)<=compression_sum_array(1)(6);
sig_4_2_comp(2)(4 downto 3)<=compression_sum_array(2)(4 downto 3);
sig_4_2_comp(1)(5)<=compression_sum_array(3)(5);

fa_5 : FA  
   port map(a => compression_sum_array(1)(5), b => compression_sum_array(2)(5), c_in => compression_sum_array(4)(5), sum => sig_4_2_comp(2)(5), c_out => sig_4_2_comp(2)(6));
		  
fa_6 : FA  
   port map(a => compression_sum_array(2)(6), b => compression_sum_array(3)(6), c_in => compression_sum_array(4)(6), sum => sig_4_2_comp(3)(6), c_out    => sig_4_2_comp(2)(7));


comp_4_2 : app_4_2_cell 
    port map(a => compression_sum_array(0)(7), b => compression_sum_array(3)(7), c => compression_sum_array(4)(7), d => compression_sum_array(5)(7), out_l => sig_4_2_comp(3)(7), out_h => sig_4_2_comp(0)(8));

sig_4_2_comp(0)(7)<=compression_sum_array(2)(7);
sig_4_2_comp(1)(7)<=compression_sum_array(1)(7);
                
comp_8_0 : app_4_2_cell 
    port map(a => compression_sum_array(3)(8), b => compression_sum_array(4)(8), c => compression_sum_array(5)(8), d => compression_sum_array(6)(8), out_l => sig_4_2_comp(1)(8), out_h => sig_4_2_comp(0)(9));
 
 sig_4_2_comp(2)(8) <= compression_sum_array(1)(8);
 sig_4_2_comp(3)(8) <= compression_sum_array(2)(8);
                    
                    
fa9_0 : FA  
         port map(a => compression_sum_array(1)(9), b => compression_sum_array(2)(9), c_in => compression_sum_array(3)(9), sum => sig_4_2_comp(1)(9), c_out => sig_4_2_comp(0)(10));

sig_4_2_comp(2)(9) <= compression_sum_array(4)(9);
sig_4_2_comp(3)(9) <= compression_sum_array(5)(9);

fa10_0 : FA
         port map(a => compression_sum_array(2)(10), b => compression_sum_array(3)(10), c_in => compression_sum_array(4)(10), sum => sig_4_2_comp(1)(10), c_out => sig_4_2_comp(1)(11));

sig_4_2_comp(2)(10) <= compression_sum_array(5)(10);
sig_4_2_comp(3)(10) <= compression_sum_array(6)(10);
sig_4_2_comp(2)(11) <= compression_sum_array(4)(11);
sig_4_2_comp(3)(11) <= compression_sum_array(5)(11);
sig_4_2_comp(0)(12 downto 11)<=compression_sum_array(3)(12 downto 11);
sig_4_2_comp(1)(12)<=compression_sum_array(4)(12);
sig_4_2_comp(0)(14 downto 13)<=compression_sum_array(5)(14 downto 13);
sig_4_2_comp(1)(14)<=compression_sum_array(6)(14);
sig_4_2_comp(2)(12) <= compression_sum_array(5)(12);
sig_4_2_comp(3)(12) <= compression_sum_array(6)(12);

comp_stage_FA : for m in 3 to 5 generate 
    comp_FA : FA 
        port map(
            a       =>sig_4_2_comp(0)(m),
            b       =>sig_4_2_comp(1)(m),
            c_in    =>sig_4_2_comp(2)(m),
            sum     =>final_CS(0)(m),
            c_out   =>final_CS(1)(m+1)
            );
end generate comp_stage_FA;

comp_stage : for m in 6 to 12 generate 
    comp_4_2 : app_4_2_cell 
        port map(
            a       =>sig_4_2_comp(0)(m),
            b       =>sig_4_2_comp(1)(m),
            c       =>sig_4_2_comp(2)(m),
            d       =>sig_4_2_comp(3)(m),
            out_l   =>final_CS(0)(m),
            out_h   =>final_CS(1)(m+1)
            );
end generate comp_stage;

final_CS(0)(2 downto 0)<=sig_4_2_comp(0)(2 downto 0);
final_CS(1)(2)<=sig_4_2_comp(1)(2);
final_CS(0)(13) <= sig_4_2_comp(0)(13);                                
final_CS(0)(14) <= sig_4_2_comp(0)(14);                
final_CS(1)(14) <= sig_4_2_comp(1)(14);
--------------------------------------------------------------------------------------------------
product(2*MULT_WIDTH - 1 downto 2) <= std_logic_vector(unsigned(final_CS(0)(2*MULT_WIDTH - 1 downto 2))+unsigned(final_CS(1)(2*MULT_WIDTH - 1 downto 2)));--+add_ones(2*MULT_WIDTH - 1 downto 0));
product(1 downto 0) <= final_CS(0)(1 downto 0);

end Behavioral;
