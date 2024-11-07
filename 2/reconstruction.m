function out = reconstruction(f,q,name) 
tic;
load('parameters_kerr2.mat');
load('PINN.mat');
load(name);

% Swmeanerr = Swmeanerr1;
% Swmean = dlarray(Swmean,"CB");
Swmeanerr = dlarray(Swmeanerr,"CB");
hydraulic_parameters = define_hydraulic_parameters();

f=dlarray(f,"BC");
q=dlarray(q,"BC");

X = dlarray(0,"CB");

i = length(k_act);
% k_est(i) = k_act(i);
k_esterr(i) = k_act(i);
% Pc_end(i)=dlarray(0,"BC");
Pc_enderr(i)=dlarray(0,"BC");
% Pe(i)=hydraulic_parameters.alpha./sqrt(k_est(i));
Peerr(i)=hydraulic_parameters.alpha./sqrt(k_esterr(i));
% SwBC(i)=(Pc_end(i)./Pe(i)).^(-hydraulic_parameters.m);
SwBCerr(i)=(Pc_enderr(i)./Peerr(i)).^(-hydraulic_parameters.m);
% while abs(SwBC(i)-Swmean(i))>1e-5
%     Pc_end(i) = Pe(i).*Swmean(i).^(-1/hydraulic_parameters.m);
%     
%     SwBC(i)=(Pc_end(i)./Pe(i)).^(-hydraulic_parameters.m);
% end

while abs(SwBCerr(i)-Swmeanerr(i))>1e-5
    Pc_enderr(i) = Peerr(i).*Swmeanerr(i).^(-1/hydraulic_parameters.m);
   
    SwBCerr(i)=(Pc_enderr(i)./Peerr(i)).^(-hydraulic_parameters.m);
end

for i=length(Swmean)-1:-1:1
%     k_est(i) = model_k(parameters_k,f,q,SwBC(i+1),Swmean(i),log(k_est(i+1)),numLayers_k);
    k_esterr(i) = model_k(parameters_k,f,q,SwBCerr(i+1),Swmeanerr(i),log(k_esterr(i+1)),numLayers_k);
%     Pe(i)=hydraulic_parameters.alpha./sqrt(k_est(i));
    Peerr(i)=hydraulic_parameters.alpha./sqrt(k_esterr(i));

%     Sw_Sim2= model_Uw(parameters_Sw,X,f,k_est(i+1).*9.869233e-12.*24.*3600 ...
%             ,SwBC(i+1),q,numLayers_Pw);
    Sw_Simerr2= model_Uw(parameters_Sw,X,f,k_esterr(i+1).*9.869233e-12.*24.*3600 ...
            ,SwBCerr(i+1),q,numLayers_Pw);
    
%     PC_BC2 = Pe(i+1).*Sw_Sim2(1).^(-1/hydraulic_parameters.m);
    PC_BC2err = Peerr(i+1).*Sw_Simerr2(1).^(-1/hydraulic_parameters.m);

%     SwBC(i) = (PC_BC2./Pe(i)).^(-hydraulic_parameters.m);
    SwBCerr(i) = (PC_BC2err./Peerr(i)).^(-hydraulic_parameters.m);

%        if SwBC(i)>0.999
%             SwBC(i) = dlarray(0.999,"CB");
%        end

       if SwBCerr(i)>0.999
            SwBCerr(i) = dlarray(0.999,"CB");
       end

end

% kef=1;%harmmean(k_act)/harmmean(k_esterr);
  kef=harmmean(k_act)/harmmean(k_esterr);

 MRE_K = 100*mean(abs(((k_act(1:end-1))-(k_esterr(1:end-1))')./(k_act(1:end-1))));
 MRE_K=round(MRE_K,2);
 R2=1-(MRE_K/100).^2;
 R2=100*round(R2,4);

% plot(log(k_est(1:end-1)),'r-',LineWidth=3)
% hold on
% figure()
% 
% plot(log(kef*k_esterr(1:end-1)),log(k_act(1:end-1)),'*',log(kef*k_esterr(1:end-1)),log(kef*k_esterr(1:end-1)))
% % hold on
% % plot(log(k_act(1:end-1)),'b--',LineWidth=2)
% % 
% % 
% % % legend('Estimated', 'Actual')
% % legend('Estimated', 'Actual')
%  xlabel('Estimated (log[mD])')
%  ylabel('Act (log [mD])')
%  xlim([0 10])
%  ylim([0 10])
%  title("ER, f=75 %, Q=0.1 md^{-1}, R^2 = " + R2 + "%")
%  axis equal
% % %  title("f=50 %, Q=0.03 md^{-1}")



figure()
plot(log(kef*k_esterr(1:end-1)),'r-',LineWidth=2)
hold on
plot(log(k_act(1:end-1)),'b--',LineWidth=2)


% legend('Estimated', 'Actual')
legend('Estimated', 'Actual')
xlabel('slice no')
ylabel('log [mD]')
% xlim([100 150])
title("ER, f=75 %, Q=0.1 md^{-1}, MRE = " + MRE_K + "%")
%  title("f=50 %, Q=0.03 md^{-1}")


toc;
end

