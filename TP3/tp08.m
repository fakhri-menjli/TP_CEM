% tp08.m
% 
% Description : 
% Ce script utilise la fonction automatisée FFT_crbm_auto.m pour 
% transformer les résultats temporels en données fréquentielles et
% sauvegarde les spectres obtenus.

clear all;
close all;
clc;

% --- Paramètres ---
c0 = 299792458;
delta = 0.1;
Dt = delta / (c0 * sqrt(3));

% --- Traitement pour la cavité vide ---
fprintf('Traitement FFT pour la cavité vide...\n');
[freq_vide, spectre_vide] = FFT_crbm_auto(Dt, 'result_vide.txt');
save('spectre_vide.mat', 'freq_vide', 'spectre_vide');
fprintf('Spectre de la cavité vide sauvegardé dans spectre_vide.mat\n');

% --- Traitement pour la cavité chargée ---
fprintf('\nTraitement FFT pour la cavité chargée...\n');
[freq_chargee, spectre_chargee] = FFT_crbm_auto(Dt, 'result_chargee.txt');
save('spectre_chargee.mat', 'freq_chargee', 'spectre_chargee');
fprintf('Spectre de la cavité chargée sauvegardé dans spectre_chargee.mat\n');

% --- Message final ---
fprintf('\nLes deux spectres ont été calculés et sauvegardés.\n');