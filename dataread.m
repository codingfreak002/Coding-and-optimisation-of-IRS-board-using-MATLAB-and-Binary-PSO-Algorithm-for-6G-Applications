classdef dataread
    methods (Static)
        function d=boarddata(row_b,column_b)
            df = readmatrix('data.xlsx');
            board=df;
            
            for b_row = (1:row_b)
                for b_column = (1:column_b)
                    for i=1:1
                        board=board; %[board df(floorDiv((10+b_row*10),i),rem((10+b_column*10),i)+1)]
                        
                        d=board;
                    end
                    d=board;                         
                end
            end
            d=board;
        end
    end
end
        

