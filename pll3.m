
function [clk_o,clk_out,clk1_out,t_vco,f_vco,curr_end_vco,v_int_num,error]=pll3(clk_out,clk1_out,curr_end_vco,v_int_num,data,data_prev,slope_in,t)%clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,v_int_num,t,slope_in_prev,slope_out_prev,t_clk,f_clk,data,slope_sampled)

global vector_length;
global freq;     % 10GHz
global acc_size;
global nonsignificant_bits;

f_vco_start=1*freq;
acc_size=14;
nonsignificant_bits=acc_size-10;
% kps=ones(1,vector_length2);
% kps=kps*32;
% ki=1;

error=0;
curr_end_vco_prev=curr_end_vco;

fprintf('odebrane dane to: %d, %d, %d',data(1),slope_in,data(2));
v_df=0;
if(t>1)
    v_df=phase_detector10(data,data_prev,slope_in);
end

if(t>1)
    [v_int,v_int_num]=integrate9(v_df,v_int_num,32,1);
else
    [v_int,v_int_num]=integrate9(v_df,2^(acc_size-1)+(f_vco_start-freq)/10^6,32,1);
end
f_vco=freq_change6(v_int);

[clk_o,t_vco,~,clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vco,curr_end_vco_prev,vector_length,clk1_out,1);
fprintf('wygenerowano zegar od %d do %d z cz. %f GHz, clk1=%f\n',curr_end_vco_prev+1,curr_end_vco,f_vco/10^9,clk1_out);

clk_out(curr_end_vco_prev+1:curr_end_vco)=clk_o;
if(curr_end_vco>=vector_length)
    error=1;
end
fprintf('\n-----------------------------------------------------------\n');