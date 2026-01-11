%%%%%%%%%%%%%%%%
% Fonction FDTD
%%%%%%%%%%%%%%%%%
%function [] = foncFDTD02(time)
clear all
close all
clc

max_time  = 1500;
max_space = 501;
%alpha       = 0.5;

% Definition des constantes
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0   = 120*pi;

% Definition des discretisations
L = 0.5;
dz = 0.001;   % pas spatial
alpha=1; % User requested alpha = 1
dt = alpha*sqrt(eps0*mu0).*dz;
%dt = 3.2e-11;
alphaE = 1./eps0 .* dt./dz;
alphaH = 1./mu0 .* dt./dz;

% Initialisation des champs E et H
% dimension en H = dimension en E - 1 du au schema
% conditions aux limites imposees ici pour E(1) et E(max_space)
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% Largeur du pulse de la source
%spread = 12;
spread=1.6e-10;
center_problem_space = 3; % spatial : at E(2), z=0.001m
t0 = 400*dt;

% Remarque : E est 1/2 pas de temps derriere
% car le pulse est introduit dans le probleme
% entre les boucles sur E et H

% Only need to store values from previous time step for alpha=1 ABCs
E_low_prev = 0;
E_high_prev = 0;

epsr = 4;
dielec_start_z = 0.200;
dielec_end_z = 0.500;

dielec_deb = round(dielec_start_z / dz) + 1;
dielec_fin = round(dielec_end_z / dz) + 1;

alphaEdielec = zeros(max_space, 1);

% Calculate alphaEdielec based on dielectric presence
for u = 1:max_space
    if (u >= dielec_deb && u <= dielec_fin)
        alphaEdielec(u) = alphaE / epsr;
    else
        alphaEdielec(u) = alphaE;
    end
    
end
for u=1:max_space
    if (u>=dielec_deb & u<=dielec_fin)
        alphaEdielec(u) = alphaE./epsr;
    else
        alphaEdielec(u) = alphaE;
    end
end

% Boucle exterieure temporelle
for n = 1:max_time
    
    % Store E(2) and E(max_space-1) before they are updated in this time step (they are E(2)^(n-1) and E(max_space-1)^(n-1))
    E_low_prev = E(2);
    E_high_prev = E(max_space-1);
    
    % Boucle interieure sur le champ E
    for k= 2:(max_space-1)
        % Using alphaEdielec which accounts for dielectric
        E(k) = E(k) + alphaEdielec(k)*(H(k-1)-H(k));
    end
    %% En théorie : définir les CL sue champ E
    % E(1) = 0;
    % E(max_space)=0;
    % Hard source
    pulse = exp(-((n*dt - t0)/spread)^2);
    % Hard Source coupée à n = 60
    if n < 600
        E(center_problem_space) = pulse;
    end
    
    % Apply Magic Time-Step ABCs for alpha=1
    E(1) = E_low_prev;
    E(max_space) = E_high_prev;
    
    % Boucle interieure sur le champ H
    for j= 1:(max_space-1)
        H(j) = H(j) - alphaH * (E(j+1)-E(j));
    end
    % Trace et progression de l'onde electrique
    if mod(n, 10) == 0
        figure(1)
        plot([0:max_space-1]*dz,E)
        axis([0 (max_space)*dz -1.1 1.1])
        % Legendes et titre pour la figure
        title('Simulation FDTD du champ electrique')
        xlabel('z (position en espace) [m]')
        ylabel('E_x [V/m]')
        pause(0.001)
    end
end % Fin de la boucle temporelleend % Fin de la boucle temporelle

% Traces des champs electrique et magnetique au temp maximum
figure(2)
subplot(2,1,1)
plot([0.5:max_space-1.5]*dz,H,'r')
title(['Simulation du champ magnetique a t=' num2str(n*dt*1e9) 'ns'])
ylabel('H_y [A/m]')
xlabel('z (position en espace) [m]')
axis([0*dz (max_space)*dz -1.1./Z0 1.1./Z0])
subplot(2,1,2)
plot([0:max_space-1]*dz,E,'g')
title(['Simulation du champ electrique a t=' num2str(n*dt*1e9) 'ns'])
ylabel('E_x [V/m]')
xlabel('z (position en espace) [m]')
axis([0*dz (max_space)*dz -1.1 1.1])


%end % Fin de la fonction
