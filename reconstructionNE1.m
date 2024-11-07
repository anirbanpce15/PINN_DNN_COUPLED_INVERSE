function K = reconstructionNE1(f,q,name) 
tic;
load('parameters_kerr2.mat');
load('PINN.mat');
load(name);
Swmean=[];
Swmean = Swmeanerr;
% Swmean = dlarray(Swmean,"CB");
Swmean(1:end-1) = dlarray(Swmean(1:end-1),"CB");
hydraulic_parameters = define_hydraulic_parameters();

f=dlarray(f,"BC");
q=dlarray(q,"BC");

X = dlarray(0,"CB");

i = length(k_act);
k_est(i) = k_act(i);

Pc_end(i)=dlarray(0,"BC");

Pe(i)=hydraulic_parameters.alpha./sqrt(k_est(i));

SwBC(i)=(Pc_end(i)./Pe(i)).^(-hydraulic_parameters.m);

while abs(SwBC(i)-Swmean(i))>1e-5
    Pc_end(i) = Pe(i).*Swmean(i).^(-1/hydraulic_parameters.m);
   
    SwBC(i)=(Pc_end(i)./Pe(i)).^(-hydraulic_parameters.m);
end

for i=length(Swmean)-1:-1:1
    k_est(i) = model_k(parameters_k,f,q,SwBC(i+1),Swmean(i),log(k_est(i+1)),numLayers_k);
    Pe(i)=hydraulic_parameters.alpha./sqrt(k_est(i));
    Sw_Sim= model_Uw(parameters_Sw,X,f,k_est(i+1).*9.869233e-12.*24.*3600 ...
            ,SwBC(i+1),q,numLayers_Pw);
    PC_BC2 = Pe(i+1).*Sw_Sim(1).^(-1/hydraulic_parameters.m);
    SwBC(i) = (PC_BC2./Pe(i)).^(-hydraulic_parameters.m);


       if SwBC(i)>0.999
            SwBC(i) = dlarray(0.999,"CB");
       end

end

%   kef=1;
  kef=harmmean(k_act(1:end-1))/harmmean(k_est(1:end-1));
  k_est(1:end-1)=kef*k_est(1:end-1);

 MRE_K = 100*mean(abs((log(k_act(1:end-1))-(log(k_est(1:end-1)))')./(log(k_act(1:end-1)))));
 MRE_K=round(MRE_K,2);
 R2=1-(MRE_K/100).^2;
 R2=100*round(R2,4);
xx=linspace(0,1,50);

figure()
plot(xx,log(k_est(1:end-1)),'r-',LineWidth=2)
hold on
plot(xx,log(k_act(1:end-1)),'b--',LineWidth=2)
legend('Estimated', 'Actual')
 xlabel('X*')
 ylabel('(ln(k) [mD])')
 f=100*f;
 title_str = sprintf("f=%d %% Q=%.2f md^{-1}, MRE = %.2f%%", f, q, MRE_K);
 title(title_str);


 K=k_est;

 end

