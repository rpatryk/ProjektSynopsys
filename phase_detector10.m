function v_df_ret=phase_detector10(data,data_prev,slope,mode)
if(data(1)==1)
    if(data(2)==1)
        d1=3;
    else
        d1=1;
    end
else
    if(data(2)==1)
        d1=-1;
    else
        d1=-3;
    end
end
if(data_prev(1)==1)
    if(data_prev(2)==1)
        d2=3;
    else
        d2=1;
    end
else
    if(data_prev(2)==1)
        d2=-1;
    else
        d2=-3;
    end
end
%if(mode==0) %dane
% if(d1==3&&d2==-3||d1==1&&d2==-1)
%     if(slope==1)
%         v_df_ret=1;
%     else
%         v_df_ret=-1;
%     end
% elseif(d1==-3&&d2==3||d1==-1&&d2==1)
%     if(slope==1)
%         v_df_ret=-1;
%     else
%         v_df_ret=1;
%     end
% else
%     v_df_ret=0;%v_df_prev;
% end
% else
if(d1==3&&d2==-3)
    if(slope==1)
        v_df_ret=1;
    else
        v_df_ret=-1;
    end
elseif(d1==-3&&d2==3)
    if(slope==1)
        v_df_ret=-1;
    else
        v_df_ret=1;
    end
else
    v_df_ret=0;%v_df_prev;
end
% end
    