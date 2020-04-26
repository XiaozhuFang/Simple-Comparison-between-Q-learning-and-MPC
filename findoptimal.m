function input=findoptimal(Qop,state,Q3)
[~,Index1] = min(abs(state(1)-Qop.Q1));
[~,Index2] = min(abs(state(2)-Qop.Q2));
[~,Index] = min(Qop.value(Index1,Index2,:));
if rand(1)>0.8
input=Qop.Q3(Index);
else 
input=Qop.Q3(mod(Index+randi([-10 10])-1,Q3)+1);
end
end

