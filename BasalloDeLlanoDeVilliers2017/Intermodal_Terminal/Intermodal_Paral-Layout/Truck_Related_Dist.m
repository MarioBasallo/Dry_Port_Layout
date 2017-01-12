function Dist = Truck_Related_Dist(M, N, L, W, l, e, v, h)

d5 = (1/2)*(1/M)*(W*e + v);
d6 = (M-1)*((4*M + 7)*v + 4*e*W*(M+1))/(12*M);

d1 = ( ((L+3)*L - 1)*l + 3*h )/(3*(L+2));
d2 = (L+1)*(3*h + l +2*l*L)/(3*(L+2));
d3 = (1/N)*(1/2)*(d1 + d2);
d4 = ((N^2) - 1)*(l*L + h)/(3*N);

Dist = d3 + d4 + d5 +d6;

end