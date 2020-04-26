clear all

Ac=[ 0 1; 0 -0.5]
Bc=[ 0 ;1]
Cc= [1 0];
Dc=[0];
ssdis=c2d(ss(Ac,Bc,Cc,Dc),0.1)
Ad=ssdis.A;
Bd=ssdis.B;
Cd=ssdis.C;
Dd=ssdis.D;
Q=[1 0; 0 0.01];
R=[1]
     model = LTISystem('A', Ad , 'B', Bd, 'C', Cd, 'D', Dd, 'Ts', 2);
% Control constraints
    model.u.min= [-Inf];
    model.u.max= [Inf];
% State constraints
    model.x.min=[-1;-0.3;];
    model.x.max=[1;0.3];
% Cost function
    model.x.penalty = QuadFunction(diag([1 0.01]));
    model.u.penalty = QuadFunction(diag([1]));
% Horizon
    N=20; 
% Generate MPC Controller
x0 = [1;0];   
ctrl = MPCController(model,N)
Xall=x0;
Tall=0;
Uall=[0];
time=zeros(100,1);
Cost=0
state=x0;
for i= 1:1000
xnow= Xall(:,end);
tic; 
 u = ctrl.evaluate(xnow); 
  Cost=Cost+state'*Q*state+u*R*u;
 execTime = toc;
Uall=[Uall u*ones(1,100)];
time(i)=execTime;
 h=0.2;
 Ts=2;
 [T,X]=ode45(@(t,x)msd(t,x,u),[0:0.01/100:0.01],Xall(:,end));
 Xall=[Xall X(2:end,:)'];
 state=Xall(:,end);

end


subplot(2,1,1)
plot([0:0.0001:10],Xall(1,:),[0:0.0001:10],Xall(2,:),'LineWidth',2)
 xlabel('time(s)')
ylabel('state x')
yline(-0.3,'--')
legend('x1','x2','constraint')
subplot(2,1,2)
plot([0.0001:0.0001:10],Uall(2:end),'LineWidth',2)
xlabel('time(s)')
ylabel('input u')
