function Dist = TrainsBarges_Related_Distance(A, N, W, v, e)

d5 = (1/N)*(1/2)*(e*W + v);
d6 = (N-1)*((4*N + 7)*v + 4*e*W*(N+1))/(12*N);

HDist = 2*(d5 + d6);
VDist = A;

Dist = HDist + VDist;

end