# scam
Symbolic Circuit Analysis with MATLAB

This program allows you to define a circuit with a simple netlist, and then it symbolically solves the system of equations obtained with Modified Nodal Analysis.

A full description can be found at http://lpsa.swarthmore.edu/Systems/Electrical/mna/MNA6.html

scam_mosfetlf.m  adds the ability to perform small signal analysis to circuits with Mosfets. While scam_mosfetHF.m and scam_mosfetLF.m edits the spice file to change a mosfet into the small signal equivalent circuit, HF includes capacitors for High Frequency and LF is low frequency.
