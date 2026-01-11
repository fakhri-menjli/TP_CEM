function [Ets]=FDTD()

% ======================================================================
% PARTIE 1 : Initialisation
% ======================================================================

% ----------------------------------------------------------------------
% Constantes physiques
% ----------------------------------------------------------------------
eps0 = 8.8541878e-12;         % Permittivité du vide
mu0  = 4e-7 * pi;             % Perméabilité du vide
c0   = 299792458;             % Vitesse de la lumière dans le vide

% ----------------------------------------------------------------------
% Paramètres de la simulation
% ----------------------------------------------------------------------
% Dimensions de la cavité (en mètres)
Lx = 3.; Ly = 3.; Lz = 3.; 
% Nombre de cellules dans chaque direction
Nx =  30; Ny =  30; Nz =  30; 

% Dimensions inverses des cellules
Cx = Nx / Lx;                 
Cy = Ny / Ly;
Cz = Nz / Lz;
% Nombre d'itérations temporelles
Nt = 400;                     
% Pas de temps
%Dt = 1/(c0*norm([Cx Cy Cz])); 
Dt=1e-10;

% ----------------------------------------------------------------------
% Allocation mémoire pour les champs électromagnétiques
% ----------------------------------------------------------------------
Ex = zeros(Nx  , Ny+1, Nz+1);
Ey = zeros(Nx+1, Ny  , Nz+1);
Ez = zeros(Nx+1, Ny+1, Nz  );
Hx = zeros(Nx+1, Ny  , Nz  );
Hy = zeros(Nx  , Ny+1, Nz  );
Hz = zeros(Nx  , Ny  , Nz+1);

% ----------------------------------------------------------------------
% Initialisation des propriétés du matériau (permittivité et conductivité)
% ----------------------------------------------------------------------
EPS_X = eps0*ones(Nx  , Ny+1, Nz+1);
SIGMA_X = zeros(Nx  , Ny+1, Nz+1);
EPS_Y = eps0*ones(Nx+1, Ny  , Nz+1);
SIGMA_Y = zeros(Nx+1, Ny  , Nz+1);
EPS_Z = eps0*ones(Nx+1, Ny+1, Nz  );
SIGMA_Z = zeros(Nx+1, Ny+1, Nz  );

% ----------------------------------------------------------------------
% Insertion d'un diélectrique (valeurs initiales)
% ----------------------------------------------------------------------
epsrx=1.0;
epsry=1.0;
epsrz=1.0;
EPS_X(20:25,20:21,20)=epsrx*eps0;
EPS_Y(20:25,20:21,20)=epsry*eps0;
EPS_Z(20:25,20:21,20)=epsrz*eps0;

% ----------------------------------------------------------------------
% Coefficients pour la mise à jour du champ électrique
% ----------------------------------------------------------------------
KE0X=(2*EPS_X-SIGMA_X*Dt)./(2*EPS_X+SIGMA_X*Dt);
KE1X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt));
KE0Y=(2*EPS_Y-SIGMA_Y*Dt)./(2*EPS_Y+SIGMA_Y*Dt);
KE1Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt));
KE0Z=(2*EPS_Z-SIGMA_Z*Dt)./(2*EPS_Z+SIGMA_Z*Dt);
KE1Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt));

% ----------------------------------------------------------------------
% Allocation mémoire pour les signaux temporels
% ----------------------------------------------------------------------
Et = zeros(Nt,3);

% ----------------------------------------------------------------------
% Paramètres de la source (gaussienne)
% ----------------------------------------------------------------------
% Position de la source
xi=6;
yi=6;
zi=6;
% Paramètres temporels de la source
t0=8.761e-009;
sigma=2e-009;
nfin=93;
% Position de la sonde
xo=6;
yo=11;
zo=6;


% ======================================================================
% PARTIE 2 : Boucle temporelle FDTD
% ======================================================================
tic
for n = 1:Nt;
  n
  % --------------------------------------------------------------------
  % Mise à jour du champ magnétique H
  % --------------------------------------------------------------------
  Hx = Hx + (Dt/mu0)*((Ey(:,:,2:Nz+1)-Ey(:,:,1:Nz))*Cz ...
                    - (Ez(:,2:Ny+1,:)-Ez(:,1:Ny,:))*Cy);
  Hy = Hy + (Dt/mu0)*((Ez(2:Nx+1,:,:)-Ez(1:Nx,:,:))*Cx ...
                    - (Ex(:,:,2:Nz+1)-Ex(:,:,1:Nz))*Cz);
  Hz = Hz + (Dt/mu0)*((Ex(:,2:Ny+1,:)-Ex(:,1:Ny,:))*Cy ...
                    - (Ey(2:Nx+1,:,:)-Ey(1:Nx,:,:))*Cx);

  % --------------------------------------------------------------------
  % Insertion de la source ponctuelle
  % --------------------------------------------------------------------
  if (n<=nfin)
    source_ponctuelle = exp(-(n*Dt-t0)*(n*Dt-t0)/sigma/sigma);
    Ex(xi,yi,zi) = source_ponctuelle;
    Ey(xi,yi,zi) = source_ponctuelle;
    Ez(xi,yi,zi) = source_ponctuelle;
  end
  
  % --------------------------------------------------------------------
  % Mise à jour du champ électrique E
  % --------------------------------------------------------------------
  Ex(:,2:Ny,2:Nz) = KE0X(:,2:Ny,2:Nz).*Ex(:,2:Ny,2:Nz) + ...
      KE1X(:,2:Ny,2:Nz).*(Hz(:,2:Ny,2:Nz)-Hz(:,1:Ny-1,2:Nz))*Cy ...
     - KE1X(:,2:Ny,2:Nz).*(Hy(:,2:Ny,2:Nz)-Hy(:,2:Ny,1:Nz-1))*Cz;
  Ey(2:Nx,:,2:Nz) = KE0Y(2:Nx,:,2:Nz).*Ey(2:Nx,:,2:Nz) + ...
      KE1Y(2:Nx,:,2:Nz).*(Hx(2:Nx,:,2:Nz)-Hx(2:Nx,:,1:Nz-1))*Cz ...
     - KE1Y(2:Nx,:,2:Nz).*(Hz(2:Nx,:,2:Nz)-Hz(1:Nx-1,:,2:Nz))*Cx;
  Ez(2:Nx,2:Ny,:) = KE0Z(2:Nx,2:Ny,:).*Ez(2:Nx,2:Ny,:) + ...
      KE1Z(2:Nx,2:Ny,:).*(Hy(2:Nx,2:Ny,:)-Hy(1:Nx-1,2:Ny,:))*Cx ...
     - KE1Z(2:Nx,2:Ny,:).*(Hx(2:Nx,2:Ny,:)-Hx(2:Nx,1:Ny-1,:))*Cy;

  % --------------------------------------------------------------------
  % Enregistrement du champ électrique à la position de la sonde
  % --------------------------------------------------------------------
  Ets(n,:) = [Ex(xo,yo,zo) Ey(xo,yo,zo) Ez(xo,yo,zo)];
end
toc

% ======================================================================
% Avantages de l'utilisation d'un code temporel (FDTD) :
% ======================================================================
% 1. Large bande de fréquences : Une seule simulation avec une source
%    impulsionnelle (comme la gaussienne utilisée ici) permet d'obtenir
%    la réponse du système sur une large gamme de fréquences.
% 2. Simplicité : L'algorithme FDTD est conceptuellement simple et
%    relativement facile à mettre en œuvre.
% 3. Non-linéarité : Il peut facilement gérer des matériaux non linéaires,
%    ce qui est plus complexe avec les méthodes fréquentielles.
% 4. Visualisation : Il fournit une visualisation directe de la propagation
%    des ondes dans le temps, ce qui aide à la compréhension physique des
%    phénomènes.
% ======================================================================
