% scriptFDTD06.m
% Simulation of a plane wave through a dielectric slab

% --- Initialization
clear all;
close all;

% --- Parameters
L = 0.5;                % Domain length (m)
dz = 0.001;             % Spatial step (m)
max_space = round(L/dz) + 1; % Number of spatial points

% --- Dielectric parameters
eps_r = 2.2;            % Relative permittivity of the slab
dielec_deb = round(0.250/dz); % Start of the slab
dielec_fin = round(0.350/dz); % End of the slab

% --- Physical constants
c0 = 3e8;               % Speed of light in vacuum (m/s)
mu0 = 4*pi*1e-7;        % Permeability of vacuum (H/m)
eps0 = 1/(c0^2*mu0);    % Permittivity of vacuum (F/m)

% --- Time parameters
% "magic time step" for perfect absorption
dt = dz / (2 * c0);
max_time = 900;        % Number of time iterations

% --- Source parameters (Gaussian pulse)
spread = 1.6e-10;
t0 = 40 * dt;
source_pos = 2;         % Source position at z=0.001 (E(2))

% --- FDTD coefficients
alphaE = dt / (eps0 * dz);
alphaH = dt / (mu0 * dz);

% Initialize dielectric-dependent coefficient array
alphaEdielec = ones(1, max_space) * alphaE;
for u = dielec_deb:dielec_fin
    alphaEdielec(u) = alphaE / eps_r;
end

% --- Field arrays initialization
E = zeros(1, max_space);
H = zeros(1, max_space - 1);

% --- "magic time step" variables initialization
Eleft1 = 0;
Eleft2 = 0;
Eright1 = 0;
Eright2 = 0;

% --- Main FDTD loop
for n = 1:max_time
    % --- Update H field
    H = H + alphaH * (E(2:max_space) - E(1:max_space-1));

    % --- Update E field
    E(2:max_space-1) = E(2:max_space-1) + alphaEdielec(2:max_space-1) .* (H(2:max_space-1) - H(1:max_space-2));

    % --- Source
    pulse = exp(-((n*dt - t0)/spread)^2);
    E(source_pos) = E(source_pos) + pulse;

    % --- Absorbing Boundary Conditions ("magic time step")
    E(1) = Eleft2;
    Eleft2 = Eleft1;
    Eleft1 = E(2);

    E(max_space) = Eright2;
    Eright2 = Eright1;
    Eright1 = E(max_space-1);

    % --- Visualization (optional, plotting at certain steps)
    if mod(n, 100) == 0
        figure(1);
        plot((0:max_space-1)*dz, E);
        hold on;
        line([dielec_deb*dz, dielec_deb*dz], ylim, 'color', 'g');
        line([dielec_fin*dz, dielec_fin*dz], ylim, 'color', 'g');
        hold off;
        title(['E-field at n = ', num2str(n)]);
        xlabel('z (m)');
        ylabel('E [V/m]');
        drawnow;
    end
end

% --- Calculation of R and T
R_theory = (1 - sqrt(eps_r)) / (1 + sqrt(eps_r));
T_theory = 2 / (1 + sqrt(eps_r));

disp(['Theoretical R: ', num2str(R_theory)]);
disp(['Theoretical T: ', num2str(T_theory)]);