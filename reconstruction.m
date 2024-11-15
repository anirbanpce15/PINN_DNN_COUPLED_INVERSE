function K = reconstruction(f,q,name) 
tic;
load('parameters_kerr2.mat');
load('PINN.mat');
load(name);

% Swmeanerr = Swmeanerr1;
% Swmean = dlarray(Swmean,"CB");
Swmeanerr(1:end-1) = dlarray(Swmeanerr(1:end-1)./(1+normrnd(0,0.01,50,1)),"CB");
hydraulic_parameters = define_hydraulic_parameters();

f=dlarray(f,"BC");
q=dlarray(q,"BC");

X = dlarray(0,"CB");

i = length(k_act);
k_esterr(i) = k_act(i);

Pc_enderr(i)=dlarray(0,"BC");

Peerr(i)=hydraulic_parameters.alpha./sqrt(k_esterr(i));

SwBCerr(i)=(Pc_enderr(i)./Peerr(i)).^(-hydraulic_parameters.m);

while abs(SwBCerr(i)-Swmeanerr(i))>1e-5
    Pc_enderr(i) = Peerr(i).*Swmeanerr(i).^(-1/hydraulic_parameters.m);
   
    SwBCerr(i)=(Pc_enderr(i)./Peerr(i)).^(-hydraulic_parameters.m);
end

for i=length(Swmean)-1:-1:1
    k_esterr(i) = model_k(parameters_k,f,q,SwBCerr(i+1),Swmeanerr(i),log(k_esterr(i+1)),numLayers_k);
    Peerr(i)=hydraulic_parameters.alpha./sqrt(k_esterr(i));
    Sw_Simerr2= model_Uw(parameters_Sw,X,f,k_esterr(i+1).*9.869233e-12.*24.*3600 ...
            ,SwBCerr(i+1),q,numLayers_Pw);
    PC_BC2err = Peerr(i+1).*Sw_Simerr2(1).^(-1/hydraulic_parameters.m);
    SwBCerr(i) = (PC_BC2err./Peerr(i)).^(-hydraulic_parameters.m);


       if SwBCerr(i)>0.999
            SwBCerr(i) = dlarray(0.999,"CB");
       end

end


  kef=harmmean(k_act(1:end-1))/harmmean(k_esterr(1:end-1));
  k_esterr(1:end-1)=kef*k_esterr(1:end-1);

 MRE_K = 100*mean(abs(log((k_act(1:end-1))-(k_esterr(1:end-1))')./(k_act(1:end-1))));
 MRE_K=round(MRE_K,2);
%  R2=1-(MRE_K/100).^2;
%  R2=100*round(R2,4);


% figure()
% plot(log(k_esterr(1:end-1)),'r-',LineWidth=2)
% hold on
% plot(log(k_act(1:end-1)),'b--',LineWidth=2)
% legend('Estimated', 'Actual')
%  xlabel('slice no')
%  ylabel('(log [mD])')
%  title("ER, f=75 %, Q=0.1 md^{-1}, MRE = " + MRE_K + "%")
K=k_esterr;

 end
 
