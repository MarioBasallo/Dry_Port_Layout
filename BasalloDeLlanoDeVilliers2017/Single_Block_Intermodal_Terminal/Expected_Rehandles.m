function [R, Hbar] = Expected_Rehandles(W, L, H, f, tau)

fb = f/L;

x = 0:W*H;
Prob = ( 1/sum( ((fb*tau).^(0:W*H))./factorial(0:W*H) ) )*(((fb*tau).^x)./factorial(x));
R = ((1:W*H) - 1)*Prob(2:end)';

X = (0:W*H)*Prob';
Hbar = X/ceil(X/H);

end