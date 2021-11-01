# Approximate Multipliers for Optimal Utilization of FPGA Resources

These are the Sources for the approximate multiplier proposed in "Approximate Multipliers for Optimal Utilization of FPGA Resources" by Christoph Niemann et al., published on DDECS2021 Conference.
Link to publication on IEEE: https://ieeexplore.ieee.org/document/9417027 
Please cite this publication, if you use any of the sources. 

List of Files:
|File|Description|
|-----|----|
| ApprMult8b.vhd: | main file of the proposed approximate multiplier |
|  IO_Register8b.vhd | is the main file to synthesize the multiplier as pipeline stage (i.e. with registers at its inputs and outputs - that way one gets a realistic timing report from Xilinx Vivado) |
|AprrMult8b_tb.vhd     |  A simple testbench. It runs an exhaustive test over all possible input vectors and writes the inputs and outputs to a logfile: "test_result.txt". The Values are organized in columns. Thus, each line contains the following results of one specific input vector combination: "factor_a factor_b approximate product exact product"  |
|  const.xdc   | Constraints that we used for synthesis   |
|  PPU_A.vhd   |  partial product unit A  |
|  PPU_B.vhd   |  partial product unit B  |
|  App_4_2_Cell.vhd   | the approximate 4:2 compressor   |
|  FA.vhd   | a straight foreward full adder cell   |



					
