% clear all
A=[0 1;0 0]
B=[0;1]
C=[1 0;0 1];
D=[0]
Q=[1 0; 0 0.01];
R=[1]
N=[0; 0];
[K,P] = lqrsol(A,B,Q,R,N)
% impulse(ss(A-B*K,B,C,D))

ssd=c2d(ss(A,B,C,D),0.01)
Ad=ssd.A
Bd=ssd.B
Cd=ssd.C
Dd=ssd.D
state=[1;0]
Tstep=1000;
prec=100;
tl=zeros(Tstep*prec,1);
yl=zeros(Tstep*prec,2);
state=[1;0];
input=-K*state;
Time=0;
Cost=0
In=zeros(Tstep*prec,1);
for i=1:Tstep
[t,y]=ode45(@(t,x)msd(t,x,input),[0:0.01/prec:0.01],state);
Cost=Cost+state'*Q*state+input*R*input;
t(1,:)=[];
y(1,:)=[];
tl((i-1)*prec+1:i*prec)=t+Time;
Time=t(end)+Time;
yl((i-1)*prec+1:i*prec,:)=y;
state=y(end,:)';
input=-K*state;
In((i-1)*prec+1:i*prec)=input*ones(1,prec);
end
plot(tl,yl(:,1)); hold on

%e1 figure
% figure(1)
% subplot(211)
% plot(tl,yl(:,1),tl,yl(:,2),e1,e2(:,1),'--',e1,e2(:,2),'--','LineWidth',2)
% xlabel('time(s)')
% ylabel('state x')
% legend('x1','x2','x1','x2')
% subplot(212)
% plot(tl,In,e1,e3,'--','LineWidth',2)
% xlabel('time(s)')
% ylabel('input u')
%

%%
clear all
A=[0 1;0 -0.5];
B=[0;1];
C=[1 0;0 1];
D=[0];
Q=[1 0; 0 0.01];
R=[1];
N=[0; 0];
[K,P] = lqrsol(A,B,Q,R,N);
ssd=c2d(ss(A,B,C,D),0.1);
Ad=ssd.A;
Bd=ssd.B;
Cd=ssd.C;
Dd=ssd.D;
state=[1;0]
Tstep=100;
prec=20;


Q1=100;
Q2=50;
Q3=50;
Qop.value=1*ones(Q1,Q2,Q3);
Qop.Q1=linspace(-1,1,Q1);
Qop.Q2=linspace(-1,1,Q2);
Qop.Q3=linspace(-1,1,Q3);
for k=1:Q1
Qop.value(k,:,:)=ones(Q2,Q3)*abs(Qop.Q1(k))+1;
end    
ite=5000;
Los=zeros(ite,1);
minLos=200;
for epoch=1:ite 
    epoch
    tl=zeros(Tstep*prec,1);
    yl=zeros(Tstep*prec,2);
    state=[rand(1);0];
    Time=0;
    input=-K*state;
    Cost=0;
    In=zeros(Tstep,1);
    for i=1:Tstep
        [t,y]=ode45(@(t,x)msd(t,x,input),[0:0.1/prec:0.1],state);
        Cost=Cost+state'*Q*state+input*R*input;
        t(1,:)=[];


        y(1,:)=[];
        tl((i-1)*prec+1:i*prec)=t+Time;
        Time=t(end)+Time;
        yl((i-1)*prec+1:i*prec,:)=y;
        reward= state'*Q*state+input*R*input;
        if abs(state(2))>0.3
            reward=reward+50;
        end

        Qop=improve(Qop,reward,state,y(end,:)',input);
        state=y(end,:)';
        input=findoptimal(Qop,state,Q3);
        In(i)=input;
    end
    Los(epoch)=Cost;
    if mod(epoch,1000)==0
        tl=zeros(Tstep*prec,1);
        yl=zeros(Tstep*prec,2);
        state=[1;0];
        Time=0;
        input=-K*state;
        Cost=0;
        In=zeros(Tstep,1);
        for i=1:Tstep
            [t,y]=ode45(@(t,x)msd(t,x,input),[0:0.1/prec:0.1],state);
            Cost=Cost+state'*Q*state+input*R*input;
            t(1,:)=[];
            y(1,:)=[];
            tl((i-1)*prec+1:i*prec)=t+Time;
            Time=t(end)+Time;
            yl((i-1)*prec+1:i*prec,:)=y;
            reward= state'*Q*state+input*R*input;
            state=y(end,:)';
            input=findoptimal_greedy(Qop,state,Q3);
            In(i)=input;
        end
        figure(1)
        plot(tl,yl(:,1),'LineWidth',2); hold on;
        ylim([-1,1])
    end
end
figure(2)
mesh(mean(Qop.value,3))
xlabel('x_1')
ylabel('x_2')
zlabel('Q')


figure(3)
plot(Los/10)
xlabel('experiments time')
ylabel('Experimental cost')
ylim([0 10])

Tstep=100
tl=zeros(Tstep*prec,1);
yl=zeros(Tstep*prec,2);
state=[1;0];
Time=0;
input=-K*state;
Cost=0;
In=zeros(Tstep,1);

for i=1:Tstep
    
[t,y]=ode45(@(t,x)msd(t,x,input),[0:0.1/prec:0.1],state);
Cost=Cost+state'*Q*state+input*R*input;
t(1,:)=[];


y(1,:)=[];
tl((i-1)*prec+1:i*prec)=t+Time;
Time=t(end)+Time;
yl((i-1)*prec+1:i*prec,:)=y;
reward= state'*Q*state+input*R*input;

Qop=improve(Qop,reward,state,y(end,:)',input);
state=y(end,:)';
input=findoptimal_greedy(Qop,state,Q3);
% input=Instore(i)

In(i)=input;
end
figure(4)
  plot(tl(1:i*prec),yl(1:i*prec,1),tl(1:i*prec),yl(1:i*prec,2),'LineWidth',2)
  ylim([-1,1])
  xlabel('times(s)')
  ylabel('state x')
    legend('x_1','x_2')



