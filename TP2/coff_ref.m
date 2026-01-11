eps_r0 = 1;
eps_r1 = 4;  

sqrt_eps0 = sqrt(eps_r0);
sqrt_eps1 = sqrt(eps_r1);

R = (sqrt_eps0 - sqrt_eps1) / (sqrt_eps0 + sqrt_eps1);
T = (2 * sqrt_eps0) / (sqrt_eps0 + sqrt_eps1);

fprintf('Coefficient de reflection R = %.4f\n', R);
fprintf('Coefficient de transmission T = %.4f\n', T);