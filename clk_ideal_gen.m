<<<<<<< HEAD
function clk_ideal=clk_ideal_gen(input_vector_length,over_sampling)


clk_ideal= zeros(1,input_vector_length*over_sampling);

for j=1:input_vector_length-1
    if mod(j,2) == 1
        for i=1:over_sampling
            clk_ideal(j*over_sampling+i) = 1;
        end
    end
end


=======
function clk_ideal=clk_ideal_gen(input_vector_length,over_sampling)


clk_ideal= zeros(1,input_vector_length*over_sampling);

for j=1:input_vector_length-1
    if mod(j,2) == 1
        for i=1:over_sampling
            clk_ideal(j*over_sampling+i) = 1;
        end
    end
end


>>>>>>> febce030b53dc95bef6c4cac9866ba7a890f07a8
end