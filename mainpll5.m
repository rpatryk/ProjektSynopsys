
clear all;
global vector_length;
global thr;
global over_sampling;
global freq;     % 10GHz
global T;        % 0.1ns
global EUI;        % 0.1ns

freq = 10^10;     % 10GHz
T = 1/freq;       % 0.1ns
EUI=T/50;

vector_length=400000;
vector_length2=round(vector_length*EUI*4/T);
thr=0.5;
over_sampling=400;
delay=10;

%time = (0:T/over_sampling:T*vector_length/over_sampling-(T/over_sampling));
%10 bitow sygnalu sterujacego zakres 9.5-10.5 f0=10ghz
%najm. krok 1mhz
%filtr integracyjny biegun 100mhz pasmo te�
%1 IUI - 100 ps
%zmiana napiecia o 1 kod cyfrowy - 1ps

time=zeros(1,vector_length*over_sampling);
for i=2:vector_length*over_sampling
  time(i)=time(i-1)+EUI/over_sampling;
end

clk_ideal=zeros(1,vector_length);

f_clks=zeros(1,vector_length2);
f_clks(1)=1.01*freq;
t_clks=zeros(1,vector_length2);
t_clks(1)=T/EUI*freq/f_clks(1);
t_clks_real=zeros(1,vector_length2);
f_clks_real=zeros(1,vector_length2);

f_vco_start=1*freq;
f_vcos=zeros(1,vector_length2);
f_vcos(1:delay)=f_vco_start;
t_vcos=zeros(1,vector_length2);
t_vcos(1:delay)=T/EUI*freq/f_vco_start;
%t_vcos_real=zeros(1,vector_length2);
%f_vcos_real=zeros(1,vector_length2);

t0=[54,52,50,48,46];
f0=zeros(1,5);
for i=1:5
    f0(i)=T/t0(i)*freq/EUI;
end

t=1;
%zmienna porzadkowa inkrementowana co wykryte zbocze zegara

curr=0;
%curr_sl=0;
%curr_vco=0;
%curr_end=0;%ceil(t_clks(1))+1;
%curr_end_tot=0;
%curr_sl-od kiedy wykrywamy zbocze
%curr-od kiedy dopisujemy
%curr_end_tot-do kiedy dopisujemy
%curr_end-dlugosc zegara dopisywanego

%curr_end_vco=delay*t_vcos(1);
%zbocze vco
slope_in=zeros(1,vector_length2);
slope_out=zeros(1,vector_length2);
%indeksy zboczy zegarow w dziedzinie czasu
slope_in_time=zeros(1,vector_length2);
slope_out_time=zeros(1,vector_length2);
%momenty wystepowania zboczy
t_diff=zeros(1,vector_length2);
%roznice czasu miedzy zboczami
clk1=0;
clk1_out=0;
error=0;

% fprintf('\n-----------------------------------------------------------\n');
% clk_out=zeros(1,vector_length);
% %[clk_out,t_vcos_real(1:ceil(curr_end_vco*EUI/T)),f_vcos_real(1:ceil(curr_end_vco*EUI/T)),clk1,curr_end_vco,j]=clk_gen_f_not_id3(f_vcos(1),0,vector_length,clk1,t0,f0,ceil(curr_end_vco*EUI/T));
[clk_out,t_vcos_real(t),f_vco_real(t),clk1_out,curr_end_vco]=clk_gen_f_not_id5(f_vcos(1),0,vector_length,clk1_out,t0,f0,delay);
%     
fprintf('startowy zegar wyjsciowy wygenerowany do %d\n',curr_end_vco);
%curr_end_vco_prev=curr_end_vco;
% %step_vco=t_vcos_real(1)*3;
% v_dfs=zeros(1,vector_length);                                    %napiecie wyjsciowe detektora fazy
% v_int=zeros(1,acc_size);                                                   %kod napiecia wejsciowego VCO
v_int_num=zeros(1,vector_length);                                %numeryczna wartosc napiecia wyjsciowego integratora
%v_int_num(1)=2^(acc_size-1)+(f_vco_start-freq)/10^6;
%v_int_num!=v_int


while(curr<vector_length&&error==0)%&&t<30)  
    t
    [clk,t_clks_real(t),f_clks_real(t),clk1,curr_end]=clk_gen_f_not_id5(f_clks(1),0,vector_length,clk1,t0,f0,1);
    if(t>1)
        [clk_o,clk_out,clk1_out,clk_ideal,t_clks(t),f_clks(t),t_vcos(t),f_vcos(t+delay),slope_in(t),slope_out(t),slope_in_time(t),slope_out_time(t),t_diff(t),curr,curr_sl,curr_end_tot,curr_vco,curr_end_vco,v_int_num(t),error]=pll(clk,clk_ideal,curr,curr_sl,curr_end,curr_end_tot,clk_out,clk1_out,curr_vco,curr_end_vco,time,v_int_num(t-1),t,slope_in(t-1),slope_out(t-1),t_clks(t),f_clks(t));
    else
        [clk_o,clk_out,clk1_out,clk_ideal,t_clks(t),f_clks(t),t_vcos(t),f_vcos(t+delay),slope_in(t),slope_out(t),slope_in_time(t),slope_out_time(t),t_diff(t),curr,curr_sl,curr_end_tot,curr_vco,curr_end_vco,v_int_num(t),error]=pll(clk,clk_ideal,0,0,curr_end,0,clk_out,clk1_out,0,curr_end_vco,time,0,t,0,0,t_clks(t),f_clks(t));
    end
    t=t+1;
end

% figure
% plot(clk_ideal);
% ylabel('clk in');
% figure
% plot(t_clks(1:t-1));%,1:t,t_clks3(1:t));
% ylabel('t clk');
% % figure
% % plot(t_clks_real(1:vector_length2));%,1:t,t_clks3(1:t));
% % ylabel('t clk real');
figure
plot(slope_in_time(1:t-1),f_clks(1:t-1));
ylabel('f clk');
figure
plot(clk_out)
ylabel('clk out');
figure
plot(t_vcos(1:t-1))
ylabel('t clk out');
% figure
% plot(t_vcos_real(1:round(curr_end_vco*EUI/T)))
% ylabel('t clk out real');
figure
plot(slope_out_time(1:t-1),f_vcos(1:t-1))
ylabel('f vco');
figure
plot(t_diff(1:t-1))
ylabel('t diff');
% figure
% plot(iter(1:t-1))
% ylabel('iteracje wyszukiwania zbocza');