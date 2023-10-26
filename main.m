import serial.*
import serialport.*
import antenna.*
import conf.*

%Checking Connected Ports
disp("Checking Connected Ports")
port=[];
ports = serialportlist;
for i = ports(1,:)
    disp('Port Found')
    port=[port i]
end

%Select the Serial Port
port_num = input('Enter the port number to communicate:');
sel_port=port(1,port_num);

%Open the selected Serial Port
disp('Communicating to Port')
try
    c=serialport(sel_port,9600);
    disp('Port Opened Sucessfully')
catch
    disp('Port Open Failure')
end
delete(c);

%Set Voltage and IRS Array Size
v1=0.6;
R1=2;
C1=2;
disp('Setting Board Voltage')
antenna.VolatageSet1(v1,R1,C1)
disp('Board Voltage Set Sucessfully')
disp('Loading Board Data from excel File')
antenna.AntennaLoad(R1,C1)
disp('Board Default Data Loaded Sucessfully')

%Spectrum Analyzer
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


%starting BPSO
disp('Starting BPSO')
num_particles = 2;  
num_dimensions = 20; 
max_iterations = 4;

%BPSO
particles = randi([0, 1], num_particles , num_dimensions);
velocities=zeros(num_particles, num_dimensions);
personal_best_positions = particles;
personal_best_fitness=zeros(num_dimensions);
global_best_position =zeros(num_dimensions, num_dimensions);
global_best_fitness = inf;
for j=1:max_iterations
    for i=1:num_particles
        velocities(i)=velocities(i),randi([0, 1], num_dimensions, num_dimensions);
        velocities(i) = max(min(velocities(i), 1), 0);
        particles(i) = xor(particles(i), velocities(i));
        fitness=antenna.AntennaLoadPSO(particles(i));
        fprintf(fieldFox, 'CALC:MARK:Y?');
        marker_y_value = fscanf(fieldFox, '%f');
        disp(marker_y_value);
        fitness = marker_y_value;
        if fitness<personal_best_fitness(i)
            personal_best_positions(i) = particles(i);
            personal_best_fitness(i) = fitness;
        elseif fitness < global_best_fitness
            global_best_position = particles(i);
            global_best_fitness = fitness;
        end
        power = [power, fitness];
    end
end
global_best_position; global_best_fitness;
disp('BPSO Run Sucessfull');
x=1:length(power);
%plot
plot(x,power);
title('plot')
