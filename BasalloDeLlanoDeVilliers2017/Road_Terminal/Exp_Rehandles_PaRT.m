function [R, Hbar] = Exp_Rehandles_PaRT(M, N, W, L, H, f, tau)

if rem(W,2) == 0 || W == 1

    if W == 1
        
        fb = f/(M*N*L);
        
        x = 0:H;
        Prob = ( 1/sum( ((fb*tau).^(0:H))./factorial(0:H) ) )*(((fb*tau).^x)./factorial(x));
        R = ((1:H) - 1)*Prob(2:end)';
        
        X = (0:H)*Prob';
        Hbar = X/ceil(X/H);
    else
        
        fb = f/(2*M*N*L);
        
        x = 0:W*H/2;
        Prob = ( 1/sum( ((fb*tau).^(0:W*H/2))./factorial(0:W*H/2) ) )*(((fb*tau).^x)./factorial(x));
        R = 2*((1:W*H/2) - 1)*Prob(2:end)';
        
        X = (0:W*H/2)*Prob';
        Hbar = X/ceil(X/H);
    end

else
    
    fb = f/(2*M*N*L);
    
    W1 = W-1;
    x = 0:W1*H/2;
    Prob = ( 1/sum( ((fb*tau).^(0:W1*H/2))./factorial(0:W1*H/2) ) )*(((fb*tau).^x)./factorial(x));
    R1 = 2*((1:W1*H/2) - 1)*Prob(2:end)';
    
    X = (0:W1*H/2)*Prob';
    Hbar1 = X/ceil(X/H);
    
    W2 = W+1;
    x = 0:W2*H/2;
    Prob = ( 1/sum( ((fb*tau).^(0:W2*H/2))./factorial(0:W2*H/2) ) )*(((fb*tau).^x)./factorial(x));
    R2 = 2*((1:W2*H/2) - 1)*Prob(2:end)';
    
    X = (0:W2*H/2)*Prob';
    Hbar2 = X/ceil(X/H);
    
    R = 0.5*(R1 + R2);
    Hbar = 0.5*(Hbar1 + Hbar2);
end

end