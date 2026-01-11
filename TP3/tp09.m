% tp09.m
% 
% Description :
% Ce script charge les données fréquentielles, visualise les spectres, 
% identifie les fréquences de résonance et analyse l'influence du 
% diélectrique.

clear all;
close all;
clc;

% --- Chargement des données spectrales ---
if ~exist('spectre_vide.mat', 'file')
    error('Fichier spectre_vide.mat introuvable. Exécutez tp08.m pour le générer.');
end
load('spectre_vide.mat'); % Charge freq_vide et spectre_vide

if ~exist('spectre_chargee.mat', 'file')
    error('Fichier spectre_chargee.mat introuvable. Exécutez tp08.m pour le générer.');
end
load('spectre_chargee.mat'); % Charge freq_chargee et spectre_chargee


% --- Paramètres d'analyse ---
f_min = 80e6;  % 80 MHz
f_max = 150e6; % 150 MHz
seuil_dB = -50; % Seuil en dB pour la détection de pics

% --- Visualisation Comparative ---
figure('Name', 'Analyse Fréquentielle Comparative', 'NumberTitle', 'off', 'Position', [100, 100, 900, 600]);

% Conversion des spectres en dB
spectre_vide_dB = 20*log10(spectre_vide);
spectre_chargee_dB = 20*log10(spectre_chargee);

plot(freq_vide / 1e6, spectre_vide_dB, 'b-', 'DisplayName', 'Cavité vide');
hold on;
plot(freq_chargee / 1e6, spectre_chargee_dB, 'r-', 'DisplayName', 'Cavité chargée');
hold off;

% Mise en forme du graphique
xlim([f_min/1e6 f_max/1e6]);
ylim([-60 5]); % Ajuster si nécessaire pour bien voir les pics
title('Spectre de Fréquence du Champ Électrique (80-150 MHz)');
xlabel('Fréquence (MHz)');
ylabel('Amplitude Normalisée (dB)');
legend('show', 'Location', 'northwest');
grid on;

% --- Identification et Affichage des Fréquences de Résonance ---
[pks_vide, locs_vide] = findpeaks(spectre_vide_dB, freq_vide/1e6, 'MinPeakHeight', seuil_dB, 'MinPeakDistance', 0.5);
[pks_chargee, locs_chargee] = findpeaks(spectre_chargee_dB, freq_chargee/1e6, 'MinPeakHeight', seuil_dB, 'MinPeakDistance', 0.5);

% Filtrage des pics dans la plage de fréquences
locs_vide = locs_vide(locs_vide >= f_min/1e6 & locs_vide <= f_max/1e6);
locs_chargee = locs_chargee(locs_chargee >= f_min/1e6 & locs_chargee <= f_max/1e6);

% Affichage dans la console
fprintf('Fréquences de résonance identifiées pour la CAVITÉ VIDE (%.0f-%.0f MHz, seuil > %.0f dB):\n', f_min/1e6, f_max/1e6, seuil_dB);
fprintf('---------------------------------------------------------------------------------\n');
fprintf('%.2f MHz\n', locs_vide);
fprintf('---------------------------------------------------------------------------------\n\n');

fprintf('Fréquences de résonance identifiées pour la CAVITÉ CHARGÉE (%.0f-%.0f MHz, seuil > %.0f dB):\n', f_min/1e6, f_max/1e6, seuil_dB);
fprintf('----------------------------------------------------------------------------------\n');
fprintf('%.2f MHz\n', locs_chargee);
fprintf('----------------------------------------------------------------------------------\n');

% Ajout des pics sur le graphique
hold on;
plot(locs_vide, pks_vide, 'bo', 'MarkerFaceColor', 'b', 'DisplayName', 'Pics (vide)');
plot(locs_chargee, pks_chargee, 'r^', 'MarkerFaceColor', 'r', 'DisplayName', 'Pics (chargée)');
hold off;

% ======================================================================
% Analyse et Interprétation des Résultats
% ======================================================================
% 1. Validation des Résultats :
%    Les spectres présentent des pics de résonance clairs, ce qui est le comportement
%    attendu d''une cavité résonnante excitée par une source large bande.
% 
% 2. Influence du Diélectrique :
%    a) Décalage des Fréquences : On observe un décalage systématique des pics de
%       résonance de la cavité chargée (en rouge) vers les basses fréquences
%       par rapport à la cavité vide (en bleu). Ceci est conforme à la théorie :
%       l''introduction d''un matériau de permittivité eps_r > 1 augmente la
%       permittivité effective du milieu, ce qui diminue la fréquence de 
%       résonance (f ∝ 1/√ε).
% 
%    b) Augmentation de la Densité Modale : Comme conséquence directe du décalage,
%       le nombre de modes (pics) dans la bande de fréquence [80, 150 MHz] 
%       est plus élevé pour la cavité chargée. Cela confirme que l''introduction
%       d''une charge diélectrique augmente la densité modale de la cavité.
%       Ceci est un point crucial en test CEM, car une densité modale élevée
%       est requise pour atteindre une bonne uniformité de champ statistique.
% ======================================================================