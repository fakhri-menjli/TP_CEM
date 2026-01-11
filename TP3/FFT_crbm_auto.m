function [Freq, FFT_E] = FFT_crbm_auto(pas_de_temps, nom_fichier)
% ======================================================================
% FFT_crbm_auto.m
%
% Description :
% Fonction modifiée pour calculer la FFT des données temporelles du champ E.
% Prend le nom du fichier en argument pour une exécution automatisée et
% retourne les vecteurs de fréquence et de spectre.
% ======================================================================

% --- Chargement des données ---
if ~exist(nom_fichier, 'file')
    error('Fichier de résultats "%s" introuvable.', nom_fichier);
end
a1 = load(nom_fichier);

% --- Récupération des paramètres ---
nb_shoot = size(a1, 1); % Nombre d'itérations temporelles

% --- Récupération des composantes du champ E ---
Ex = a1(:,1);
Ey = a1(:,2);
Ez = a1(:,3);
clear a1;

% --- Calcul de la Transformée de Fourier ---
t_total = nb_shoot * pas_de_temps;
Freq = (0:nb_shoot-1) / t_total;

% Calcul de la FFT pour chaque composante et normalisation
% On normalise par N/2 pour obtenir l'amplitude physique (sauf pour DC et Nyquist)
FFT_Ex = abs(fft(Ex)) / nb_shoot;
FFT_Ey = abs(fft(Ey)) / nb_shoot;
FFT_Ez = abs(fft(Ez)) / nb_shoot;

% --- Calcul du module du champ total ---
FFT_E = sqrt(FFT_Ex.^2 + FFT_Ey.^2 + FFT_Ez.^2);

% On ne garde que la première moitié du spectre (symétrie de la FFT)
Freq = Freq(1:floor(nb_shoot/2));
FFT_E = FFT_E(1:floor(nb_shoot/2));
FFT_E(2:end) = FFT_E(2:end) * 2; % On multiplie par 2 pour conserver l'énergie

end
