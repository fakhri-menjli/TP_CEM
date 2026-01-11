% tp00.m
% 
% Description :
% Ce script calcule les fréquences de résonance d'une cavité parallélépipédique
% en fonction de ses dimensions et des indices de mode (m, n, p).
% 
% Paramètres d'entrée :
% a, b, d : dimensions de la cavité (en mètres)
% max_m, max_n, max_p : valeurs maximales pour les indices de mode m, n, p
% 
% Sortie :
% Affiche les fréquences de résonance pour les modes viables.

clear all;
close all;
clc;

% Constantes physiques
c = 3e8; % Vitesse de la lumière dans le vide (m/s)

% Dimensions de la cavité (en mètres)
a = 3;
b = 3;
d = 3;

% Valeurs maximales pour les indices de mode
max_m = 5;
max_n = 5;
max_p = 5;

% Initialisation d'un cell array pour stocker les résultats
results = {};

% Boucle sur les indices de mode m, n, p
for m = 0:max_m
    for n = 0:max_n
        for p = 0:max_p
            % Condition pour un mode viable (au moins deux indices non nuls)
            if (m~=0 && n~=0) || (m~=0 && p~=0) || (n~=0 && p~=0)
                % Calcul de la fréquence de résonance
                f_mnp = (c / 2) * sqrt((m / a)^2 + (n / b)^2 + (p / d)^2);
                
                % Ajout des résultats au cell array
                results{end+1, 1} = m;
                results{end, 2} = n;
                results{end, 3} = p;
                results{end, 4} = f_mnp / 1e6; % Conversion en MHz
            end
        end
    end
end

% Tri des résultats par fréquence
sorted_results = sortrows(results, 4);

% Affichage des résultats
fprintf('Fr�quences de r�sonance pour une cavit� de %dm x %dm x %dm\n', a, b, d);
fprintf('----------------------------------------------------------\n');
fprintf(' m | n | p | Fr�quence (MHz)\n');
fprintf('----------------------------------------------------------\n');
for i = 1:size(sorted_results, 1)
    fprintf(' %d | %d | %d | %.2f\n', sorted_results{i,1}, sorted_results{i,2}, sorted_results{i,3}, sorted_results{i,4});
end
fprintf('----------------------------------------------------------\n');

