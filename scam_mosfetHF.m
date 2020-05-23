% This file takes as input a filename (in the variable fname) that
% describes a circuit in netlist format (similar to SPICE), and then
% performs a symbolic analysis of the circuit using Modified Nodal Analysis
% (MNA).  A full description of MNA and how to use this code is at:
% http://lpsa.swarthmore.edu/Systems/Electrical/mna/MNA1.html
%
% Written by Erik Cheever, Swarthmore College, 2019
% echeeve1@swarthmore.edu

fprintf('\nStarted -- please be patient.\n\n');

%% Print out the netlist (a file describing the circuit with one circuit
% per line.
fprintf('Netlist:');
type(fname)
fid = fopen(fname);
fileIn=textscan(fid,'%s %s %s %s %s %s');  % Read file (up to 6 items per line
% Split each line into 6 columns, the meaning of the last 3 columns will
% vary from element to element.  The first item is always the name of the
% circuit element and the second and third items are always node numbers.
fclose(fid);

nLines = length(fileIn{1});  % Number of lines in file (or elements in circuit).
% Here we wish to add a small signal model of the Mosfet
% For the low frequency model that doesn't take the body 
% effect into account:
% mosfet index
mInd=cellfun(@(x) x(1)=='M',fileIn{1});
nMos=find(~mInd);
legnMos=length(nMos);
MosInd=find(mInd);
legMos=length(MosInd);
%There are 4 arguments per Mosfet instance and up to 6 arguments per instance
MosFile=cellfun(@(x) x(nMos),fileIn,'UniformOutput',false);
%{
Converts The Mosfet Instance:
M1   D S G B
To:
Cgs1 G S
Cgd1 G D
Gm1  D S G S
R01  D S
%}


for k1=1:legMos
    %Cgs first:
    %Name First:
    j=(k1-1)*4+legnMos;
    rename=cellfun(@(x) x(2:end),fileIn{1}(MosInd(k1)));
    MosFile{1}(k1+j)={['Cgs',rename]};
    MosFile{2}(k1+j) = fileIn{4}(MosInd(k1));   % Get the two node numbers
    MosFile{3}(k1+j) = fileIn{3}(MosInd(k1));
    MosFile{4}(k1+j) = {''};
    MosFile{5}(k1+j) = {''};
    MosFile{6}(k1+j) = {''};
    %Cgd next:
    MosFile{1}(k1+1+j)={['Cgd',rename]};
    MosFile{2}(k1+1+j) = fileIn{4}(MosInd(k1));   % Get the two node numbers
    MosFile{3}(k1+1+j) = fileIn{2}(MosInd(k1));
    MosFile{4}(k1+1+j) = {''};
    MosFile{5}(k1+1+j) = {''};
    MosFile{6}(k1+1+j) = {''};
    %Gm next:
    MosFile{1}(k1+2+j)={['Gm',rename]};
    MosFile{2}(k1+2+j) = fileIn{2}(MosInd(k1));   % Get the two node numbers
    MosFile{3}(k1+2+j) = fileIn{3}(MosInd(k1));
    MosFile{4}(k1+2+j) = fileIn{4}(MosInd(k1));
    MosFile{5}(k1+2+j) = fileIn{3}(MosInd(k1));
    MosFile{6}(k1+2+j) = {''};
    %R0 next:
    MosFile{1}(k1+3+j)={['Ro',rename]};
    MosFile{2}(k1+3+j) = fileIn{2}(MosInd(k1));   % Get the two node numbers
    MosFile{3}(k1+3+j) = fileIn{3}(MosInd(k1));	
    MosFile{4}(k1+3+j) = {''};
    MosFile{5}(k1+3+j) = {''};
    MosFile{6}(k1+3+j) = {''};
end
fname1=['fMosName',fname];
fid = fopen(fname1,'wt');
[nrows,ncols] = size(MosFile{1});
for row = 1:nrows
    dummy=cellfun(@(x) x(row),MosFile);
    fprintf(fid,'%s    %s %s %s %s %s\n',dummy{1,:});
end
fclose(fid);