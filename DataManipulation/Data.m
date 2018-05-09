file = fopen('parsed_data.txt', 'r');
cnt = 1;
P = [];
t = [];

while 1
    
    try
        
        tline = fgetl(file);
        c = eval(tline);
        P = [P, c{1}'];
        if c{2} == 1
            t = [t, [0;1]];
        else
            t = [t, [1;0]];
        end
        

        cnt = cnt + 1;
    
    catch 
        clear c
        clear tline
        clear cnt
        clear file
        clear exception
        break
       
    end

end
