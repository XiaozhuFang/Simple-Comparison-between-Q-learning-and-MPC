function input=findoptimal_greedy(Qop,state,Q3)
[~,Index1] = min(abs(state(1)-Qop.Q1));
[~,Index2] = min(abs(state(2)-Qop.Q2));
[~,Index] = min(Qop.value(Index1,Index2,:));
input=Qop.Q3(Index);

end