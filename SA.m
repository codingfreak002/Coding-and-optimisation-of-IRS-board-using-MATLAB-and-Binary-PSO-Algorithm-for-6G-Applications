fieldFox = visa('agilent', 'USB0::0x2A8D::0x5C18::MY60511064::INSTR');

fopen(fieldFox);
disp('Spectrum analyzer connected');

fieldFox.timeout = 1000;

fprintf(fieldFox, '*CLS');

disp('Instrument information');

fprintf(fieldFox,'*IDN?');
idn = fscanf(fieldFox);
disp(idn);

fprintf(fieldFox, 'INST:SEL ''SA'';*OPC?');
fprintf(fieldFox, '*OPC?');  

fprintf(fieldFox, 'INST:SEL?');
selectedInst = fscanf(fieldFox,'%f');

disp('Instrument set to spectrum analyzer mode');
disp(selectedInst);

startFreq = 5E9;
stopFreq = 6.0E9;
numpoints = 41;
bw = 300E3;

fprintf(fieldFox, ['SENS:FREQ:START ' num2str(startFreq)]);
fprintf(fieldFox, ['SENS:FREQ:STOP ' num2str(stopFreq)]);
fprintf(fieldFox, ['SENS:SWE:POIN ' num2str(numpoints)]);
fprintf(fieldFox, ['SENS:BAND:RES ' num2str(bw)]);

fprintf(fieldFox, 'CALC:MARK:ACT');

fprintf(fieldFox, 'CALC:MARK:Y?');
marker_y_value = fscanf(fieldFox, '%f');
disp(marker_y_value);

for i = 1:20
    fprintf(fieldFox, 'CALC:MARK:Y?');
    marker_y_value = fscanf(fieldFox, '%f');
    disp(marker_y_value);
end

fprintf(fieldFox, '*CLS');
fclose(fieldFox);
delete(fieldFox);
