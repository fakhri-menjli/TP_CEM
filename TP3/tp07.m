% tp07.m
%
% Description :
% Ce script visualise les résultats temporels obtenus avec les simulations
% FDTD pour la cavité vide et la cavité chargée.

clear all;
close all;
clc;

% --- Paramètres pour le vecteur temps ---
% Il est important de recalculer Dt de la même manière que dans les
% scripts de simulation pour assurer la cohérence de l'axe temporel.
c0 = 299792458;
delta = 0.1;
Dt = delta / (c0 * sqrt(3));

% --- Chargement et validation des données ---
if ~exist('result_vide.txt', 'file')
    error('Fichier result_vide.txt introuvable. Exécutez tp06.m pour générer les fichiers de résultats.');
end
E_vide = load('result_vide.txt');

if ~exist('result_chargee.txt', 'file')
    error('Fichier result_chargee.txt introuvable. Exécutez tp06.m pour générer les fichiers de résultats.');
end
E_chargee = load('result_chargee.txt');

Nt = size(E_vide, 1);
temps = (0:Nt-1) * Dt;

% --- Visualisation ---
figure('Name', 'Analyse Temporelle Comparative', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

% Cas de la cavité vide
subplot(2, 1, 1);
plot(temps * 1e9, E_vide); % Temps en nanosecondes pour une meilleure lisibilité
title('Réponse Temporelle de la Cavité Vide');
xlabel('Temps (ns)');
ylabel('Amplitude du Champ E (V/m)');
legend('Ex', 'Ey', 'Ez');
grid on;
axis tight;

% Cas de la cavité chargée
subplot(2, 1, 2);
plot(temps * 1e9, E_chargee); % Temps en nanosecondes
title('Réponse Temporelle de la Cavité Chargée');
xlabel('Temps (ns)');
ylabel('Amplitude du Champ E (V/m)');
legend('Ex', 'Ey', 'Ez');
grid on;
axis tight;

sgtitle('Comparaison des Réponses Temporelles au Point de Sonde');