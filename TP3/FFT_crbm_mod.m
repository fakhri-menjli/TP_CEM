function [Freq, FFT_E] = FFT_crbm_mod(pas_de_temps, nom_fichier)
% Fonction visant à déterminer la FFT pour diverses valeurs de champ E
% Modifiée pour prendre le nom de fichier en argument et retourner les résultats

% Charger les données
a1 = load(nom_fichier);

% Récupérer les paramètres
nb_shoot = size(a1, 1);     % nb d'itération en temps

% Récupération des composantes en champs E
Ex = a1(:,1);
Ey = a1(:,2);
Ez = a1(:,3);

clear a1;

% Vecteur de temps
tt = (0:pas_de_temps:(nb_shoot-1)*pas_de_temps);

% Calcul des differentes Transformees de Fourier
tfin = nb_shoot * pas_de_temps;   % Temps total
Discret = 0:nb_shoot-1;
Freq = Discret / tfin;
fen = max(Freq);

% Calcul sur chaque composante
FFT_Ex = abs(fft(Ex, nb_shoot));
FFT_Ey = abs(fft(Ey, nb_shoot));
FFT_Ez = abs(fft(Ez, nb_shoot));

% Calcul du champ total
FFT_E = sqrt(FFT_Ex.^2 + FFT_Ey.^2 + FFT_Ez.^2);

% Normalisation
FFT_E = FFT_E / max(FFT_E);

Freq = Freq';
end
