function Dist = Truck_Related_Distance(M, N, L, W, l, e, v, h)

% Expected horizontal distance
d5 = (1/2)*(1/N)*(W*e + v);
d6 = (N-1)*((4*N + 7)*v + 4*e*W*(N+1))/(12*N);

% Expected vertical distance
d1 = ( ((L+3)*L - 1)*l + 3*h )/(3*(L+2));
d2 = (L+1)*(3*h + l +2*l*L)/(3*(L+2));
d3 = (1/M)*(1/2)*(d1 + d2);
d4 = ((M^2) - 1)*(l*L + h)/(3*M);

Dist = (d3 + d4) + (d5 +d6);

end