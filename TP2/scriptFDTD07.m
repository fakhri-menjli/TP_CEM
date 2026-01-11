% scriptFDTD07.m
% Simulation of a 1D reverberant cavity

% --- Initialization
clear all;
close all;

% --- Parameters
L = 2;                  % Domain length (m)
dz = 0.01;              % Spatial step (m)
max_space = round(L/dz) + 1; % Number of spatial points

% --- Physical constants
c0 = 3e8;               % Speed of light in vacuum (m/s)
mu0 = 4*pi*1e-7;        % Permeability of vacuum (H/m)
eps0 = 1/(c0^2*mu0);    % Permittivity of vacuum (F/m)

% --- Time parameters
dt = 0.95 * dz / c0;    % Time step (using alpha=0.95 for stability)
max_time = 3000;        % Number of time iterations

% --- Source parameters
source_pos = round(max_space / 2); % Source at the center
f_source = 150e6;       % Source frequency (Hz)

% --- Probe
probe_pos = round(0.35/dz);
E_probe = zeros(1, max_time);
time_axis = (1:max_time) * dt;

% --- FDTD coefficients
alphaE = dt / (eps0 * dz);
alphaH = dt / (mu0 * dz);

% --- Field arrays initialization
E = zeros(1, max_space);
H = zeros(1, max_space - 1);

% --- Main FDTD loop
for n = 1:max_time
    % --- Update H field
    H = H + alphaH * (E(2:max_space) - E(1:max_space-1));

    % --- Update E field
    E(2:max_space-1) = E(2:max_space-1) + alphaE * (H(2:max_space-1) - H(1:max_space-2));

    % --- Source (sinusoidal)
    pulse = sin(2 * pi * f_source * n * dt);
    E(source_pos) = E(source_pos) + pulse; % Soft source

    % --- PEC Boundary Conditions (E=0 at boundaries)
    E(1) = 0;
    E(max_space) = 0;

    % --- Record field at probe
    E_probe(n) = E(probe_pos);

    % --- Visualization (optional, plotting at certain steps)
    if mod(n, 50) == 0
        figure(1);
        plot((0:max_space-1)*dz, E);
        title(['E-field at n = ', num2str(n)]);
        xlabel('z (m)');
        ylabel('E [V/m]');
        ylim([-2 2]); % Set fixed y-axis for better visualization
        drawnow;
    end
end

% --- Plotting the probed field
figure(2);
plot(time_axis, E_probe);
title(['E-field at z = ', num2str(probe_pos*dz), ' m']);
xlabel('Time (s)');
ylabel('E [V/m]');
grid on;