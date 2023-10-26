classdef conf
    methods (Static)
        function j=start(sel_port)
            j=serial(sel_port);
        end
        function device=retrieve(~)
            d=conf.start(serialportlist("all"));
            device=fopen(d);
        end
        function j=off(~)
            j=fclose(conf.start(serialportlist("all")));
        end
    end
end

