% Fonction visant à déterminer la FFT pour diverses valeurs de champ E
function FFT_crbm(pas_de_temps)
% Parametres d'entree :

tic

% Choix du fichier d'entrée et lecture des données
[fa ra]=uigetfile('*', 'Chargement du fichier d''entree');
namea=[ra fa];
a1(:,:)=load(namea);

% Récupérer les paramètres
taille=size(a1);         % nb total de lignes dans le fichier
nb_shoot=size(a1,1);     % nb d'itération en temps


% Récupération des composantes en champs E
Ex=a1(:,1);
Ey=a1(:,2);
Ez=a1(:,3);

clear a1;

% Composante mise a zero
% nb_shoot=it_fin;
% Ex(end:it_fin)=0;
% Ey(end:it_fin)=0;
% Ez(end:it_fin)=0;
% Vecteur de temps
tt=[0:pas_de_temps:(nb_shoot-1)*pas_de_temps];

% Calcul des differentes Transformees de Fourier
tfin=nb_shoot*pas_de_temps;   % Temps total
Discret=[0:nb_shoot-1];
Freq=Discret/tfin;
fen=max(Freq);
delta_fen=Freq(2)-Freq(1);

% Calcul sur chaque composante
FFT_Ex=(abs(fft(Ex(:)/(2*fen),nb_shoot)));
FFT_Ey=(abs(fft(Ey(:)/(2*fen),nb_shoot)));
FFT_Ez=(abs(fft(Ez(:)/(2*fen),nb_shoot)));

% Calcul du champ total FFT_P(numero_point_ZL,freq) = FFT_P(:,:)
FFT_E=sqrt(abs(FFT_Ex.*FFT_Ex + FFT_Ey.*FFT_Ey + FFT_Ez.*FFT_Ez));

Freq=Freq';
size(FFT_E)
figure
plot(Freq,FFT_Ex)

toc
end % Fin de la fonction

