function xdot=msd(t,x,u)
xdot=[0 1; 0 -0.5]*x+[0; 1]*u;
end