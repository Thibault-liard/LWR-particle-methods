%%Construction of (t,x)->u^n(t,x) an approximate solution of Burgers equation with initial data u_0.
close all
%%Parameter 
a=-3; b=4; T=1; %u^n(t,x) with  x\in [a,b] and t\in[0,T]. 
%u_min=0; u_max=1;  % u_min \leq u_0 \leq u_min.
lambda_max=1;
N=500; %number of discretization points in space  (x_0=a, N-1 points,x_N=b)
M=200;
Delta_x=(b-a)/N; %space step
Delta_t=T/M; %time step
alpha=0.7;
eps=2*Delta_t;  %CFL condition to force particles to pass through [-epsilon,epsilon] (when max u=min u =1) 
 
%%Construction of an approximate function u_0^n of u_0
   
    U_discr=zeros(M+1,N+1);
    X_discr=zeros(M+1,N+1);
    for j=1:N+1
        X_discr(1,j)=a+(j-1)*Delta_x;
    end
   
    
    
i=0;
for j=1:N
    i=i+1;
    U_discr(1,i)=(1/Delta_x)*integral(@(x)(u_1(x)),a+(j-1)*Delta_x,a+j*Delta_x);
end 
U_discr(:,end)=U_discr(1,end-1);

 %plot(X_discr(1,:),  U_discr(1,:)) 
 





%%Construction of an approximate function u^n+1 of u_0 via u^n

for n=1:M
    X_discr(n+1,end)=X_discr(n,end)+Delta_t*(v(U_discr(n,end))*vaphi(X_discr(n,end),eps,alpha));
    for k=1:N
   X_discr(n+1,end-k)=X_discr(n,end-k)+Delta_t*(v(U_discr(n,end-k))*vaphi(X_discr(n,end-k),eps,alpha));
   U_discr(n+1,end-k)=((X_discr(1,end-k+1)-X_discr(1,end-k))*U_discr(1,end-k))/(X_discr(n+1,end-k+1)-X_discr(n+1,end-k));
    end 
end 
figure
plot(X_discr(:,:),0:Delta_t:T)
  



%%Plotting of the solution u^n over [a,b] at time tn=n \Delta_t.
figure
plot(a:0.01:b,U_f(1,a:0.01:b,X_discr,U_discr),'r')
hold on 
plot(a:0.01:b,U_f(M+1,a:0.01:b,X_discr,U_discr),'b--')
%hold on
%plot(a:0.01:b,U_f(M,a:0.01:b,a,N,Delta_x,Ufinal),'b')

% %%%%Animation
% k=1;
% 
% for n=0:M
%    
%     ls=num2str(k);
%     namefile=['GodunovSolT_',ls];
%     k=k+1;
%     XX=a:0.01:b;
%    YY=U_f(n,a:0.01:b,a,N,Delta_x,Ufinal);
%    GodunovSolT=[XX',YY'];
%    %SolT=[[final_boundaries,final_boundaries(end)+1]',final_densities'];
%    save(fullfile('Animations',namefile), 'GodunovSolT', '-ascii')
% end  



function y=U_f(n,x,X_discr,U_discr) %plotting function
y=zeros(1,length(x));
for i=1:length(x)
for j=1:length(X_discr(n,:))-1
if (X_discr(n,j)<=x(i))&& (x(i)<X_discr(n,j+1))
    y(i)=U_discr(n,j);
elseif x(i)<X_discr(n,1) 
    y(i)=U_discr(n,1);
elseif X_discr(n,end)<x(i)
    y(i)=U_discr(n,end);
end
end 
end
end 



