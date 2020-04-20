/************************************************************************
Add Round Key

Anthony Nepomuceno and Tyler Mongoven, Spring 2020
Po-Han Huang, Spring 2017
Joe Meng, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AddRoundKey (
  input logic [127:0] key,
  input logic [127:0] in,
  output logic [127:0] out
  );

  assign out = in ^ key; // out = in XOR key

endmodule // AddRoundKey
