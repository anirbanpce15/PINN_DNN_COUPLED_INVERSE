f=input('give the function f:\n:');

 a=input('give the value of a\n:');
 b=input('give the value of b\n:');
 n=input('give the iteration of n:\n');
 Tol=input('give the Tolearnce:\n');

if f(a)*f(b)<0
    for i=1:n
    c=(a+b)/2;
    disp(i) 
    disp(c) 
    
    if abs(c-b)<Tol|| abs(c-a)<Tol
        break
    end
    if f(c)*f(a)<0
    b=c;
    elseif f(c)*f(b)<0
        a=c;
    end
    

    end
else
disp('There is wrong a or b');
end