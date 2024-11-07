hist(log(k_act))
[a,b] = hist(log(k_act));
a = a./(51);
bar(b,a)
xlabel('ln(k)')
ylabel('frequency')