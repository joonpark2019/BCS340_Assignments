function output = turn_into_num(input)
    l = length(input);
    output = 0;
    for i=1:l
        output = output + input(i)*10^(i-1);
    end
end