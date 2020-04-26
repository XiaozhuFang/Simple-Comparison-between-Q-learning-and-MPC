function Qnew=improve(Qop,reward,state_i,state_e,input)
[~,Index_i1] = min(abs(state_i(1)-Qop.Q1));
[~,Index_i2] = min(abs(state_i(2)-Qop.Q2));
[~,Index_e1] = min(abs(state_e(1)-Qop.Q1));
[~,Index_e2] = min(abs(state_e(2)-Qop.Q2));
[~,Index_a] = min(abs(input-Qop.Q3));
Qnew=Qop;
Qnew.value(Index_i1,Index_i2,Index_a)= Qnew.value(Index_i1,Index_i2,Index_a)+...
    0.5*(reward+0.95*min(Qop.value(Index_e1,Index_e2,:))-Qop.value(Index_i1,Index_i2,Index_a));
Qnew.value(Index_i1,Index_i2,:)= Qnew.value(Index_i1,Index_i2,:)+...
    0.1*(reward+0.95*min(Qop.value(Index_e1,Index_e2,:))-Qop.value(Index_i1,Index_i2,Index_a));
end