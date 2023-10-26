classdef port
    properties
        x=sequenceInputLayer(999)
    end
    methods (Static)
        function y=data_write(commandload,dataload)
            data=[];
            crc=sum(commandload);
            crc =  -(crc) ;
            crc = mod(crc,256);
            commandload = [commandload crc];
            disp("data sent")
            value_write=(commandload);
            j=serialport((serialportlist("all")),9600);
            write(j,(value_write),"uint8");
            
            recived_data = read(j,120,"uint8")
            delete(j);
            %ecived_data=system('ulimit -t 120; ./run_my_simulation');            
            for i = recived_data(1,:)
                data = [data i];
            end
            if dataload==true  
                y=data;
            end
        end
    end
end