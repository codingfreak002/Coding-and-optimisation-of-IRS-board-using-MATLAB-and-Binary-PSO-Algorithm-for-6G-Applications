classdef antenna
    methods (Static)
        function VolatageSet1(data,row_b,column_b)
            VolatageCommand = [0x7E 0x0A 0x06 0xAB 0x61];
            DATA=(round(data/0.00625)-39);
            VolatageCommand(1,5)=DATA;
            for i = (0:(row_b*column_b)-1)
                VolatageCommand(1,2)=10+i;
                readdata=port.data_write(VolatageCommand,true);
                    if readdata(1,1)==DATA
                        disp('Board Voltage data Loaded');
                    else
                        disp('Board Voltage data NOT Loaded');
                   end
             end
        end
        function z=Antennaconcatenate(data_load)
            AntennaCommand= [0x7E 0x0D 0x12 0xAA 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00];
            position = 4;
            data     = 0;
            bit = mod(1:100,8);
            data = bitor(data,data_load(1,1));
            data=bitsll(data,7);
            if (bit ==7)
                AntennaCommand(1,position+1)=data;
                data = 0;
                position = position +1;
            end
            z=AntennaCommand;
        end
        function AntennaLoad(row_b,column_b)
            board=dataread.boarddata(row_b,column_b);
            for i=(1:20)
                for j=(1:20)
                    z=antenna.Antennaconcatenate(board(i,j));
                    if i==(10|20)|| j==(10|20)                    
                        for k=(0:3)
                            z(1,2)=10+k;
                            readdata=port.data_write(z, 1);
                             if numel(readdata)==100
                                 disp('Board Data Loaded');
                             else
                                 disp('Board Data NOT Loaded');
                             end
                        end
                    end
                end
             end
        end

        function fitness=AntennaLoadPSO(particle)            
            board = randi([0,1],[4, 100]);
            for i = 1:100
                b1=(1:4);
                b2=(1:100);
                p1=i;
                p2=i;
                board(1,1)=particle(1,1);
            end

            for i = 1:1
                z=antenna.Antennaconcatenate(board(1,i));
                z(1,2)=10+i;
                readdata=port.data_write(z, 1);

                if length(readdata)==100
                    print('Board Data Loaded')
                else
                    disp('Board Data NOT Loaded')
                end
            end
            fitness=randi([0,100],1);
            return ;
        end
    end
end