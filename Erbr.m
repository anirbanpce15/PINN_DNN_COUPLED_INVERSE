function out=Erbr(name)
load(name);
for i=1:length(k_act)-1
    kmax(i)=max(K(:,i));
    kmin(i)=min(K(:,i));
    kkk(i)=mean(K(:,i));
end
kmax=kmax';
kmin=kmin';
kkk=kkk';
X=linspace(0,1,50);
stderr=0.005*(kmax-kmin);
errorbar(X,log(kkk(1:end-1)),stderr,'r-',Linewidth=2)
hold on
plot(X,log(k_act(1:end-1)), 'b--', Linewidth=2)

legend('Estimated', 'Actual')
xlabel('Slice no')
ylabel('k log[mD]')
ylim([0 12])
end