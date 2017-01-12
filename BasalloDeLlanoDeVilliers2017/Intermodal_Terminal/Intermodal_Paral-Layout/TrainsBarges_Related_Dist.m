function Dist = TrainsBarges_Related_Dist(A, N, L, l, v, h)

% Expected vertcal distance
Vdist = 0.5*v + A;

% Expected horizontal distance
d1 = ( ((L+3)*L - 1)*l + 3*h )/(3*(L+2));
d2 = (L+1)*(3*h + l +2*l*L)/(3*(L+2));
d3 = (1/N)*(1/2)*(d1 + d2);
d4 = ((N^2) - 1)*(l*L + h)/(3*N);
Hdist = 2*(d3 + d4);

% Total expected distance
Dist = Vdist + Hdist;

end