function [Ets]=FDTD_crbm_chargee()

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
Lx = 6.7; Ly = 8.4; Lz = 3.5; 
% Pas spatial (en mètres)
delta = 0.1;
% Nombre de cellules dans chaque direction
Nx =  round(Lx/delta); Ny =  round(Ly/delta); Nz =  round(Lz/delta); 

% Pas de temps (selon le critère de Courant)
Dt = delta / (c0 * sqrt(3)); 

% Dimensions inverses des cellules (utilisées dans les équations de mise à jour)
Cx = 1 / delta;                 
Cy = 1 / delta;
Cz = 1 / delta;
% Nombre d'itérations temporelles
Nt = 400;                     

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
% Initialisation des propriétés du matériau
% ----------------------------------------------------------------------
EPS_X = eps0*ones(Nx  , Ny+1, Nz+1);
SIGMA_X = zeros(Nx  , Ny+1, Nz+1);
EPS_Y = eps0*ones(Nx+1, Ny  , Nz+1);
SIGMA_Y = zeros(Nx+1, Ny  , Nz+1);
EPS_Z = eps0*ones(Nx+1, Ny+1, Nz  );
SIGMA_Z = zeros(Nx+1, Ny+1, Nz  );

% Insertion du diélectrique
epsr = 3;
xmin = 1; xmax = 4;
ymin = 1; ymax = 6;
zmin = 1; zmax = 3;

xmin_idx = round(xmin/delta);
xmax_idx = round(xmax/delta);
ymin_idx = round(ymin/delta);
ymax_idx = round(ymax/delta);
zmin_idx = round(zmin/delta);
zmax_idx = round(zmax/delta);

EPS_X(xmin_idx:xmax_idx, ymin_idx:ymax_idx, zmin_idx:zmax_idx) = epsr*eps0;
EPS_Y(xmin_idx:xmax_idx, ymin_idx:ymax_idx, zmin_idx:zmax_idx) = epsr*eps0;
EPS_Z(xmin_idx:xmax_idx, ymin_idx:ymax_idx, zmin_idx:zmax_idx) = epsr*eps0;

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
Ets = zeros(Nt,3);

% ----------------------------------------------------------------------
% Paramètres de la source (gaussienne)
% ----------------------------------------------------------------------
% Position de la source
xi=round(Nx/2);
yi=round(Ny/2);
zi=round(Nz/2);
% Paramètres temporels de la source
t0=8.761e-009;
sigma=2e-009;
nfin=round(t0*2/Dt);
% Position de la sonde
xo=round(Nx/4);
yo=round(Ny/4);
zo=round(Nz/4);


% ======================================================================
% PARTIE 2 : Boucle temporelle FDTD
% ======================================================================
toc
for n = 1:Nt
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
    Ex(xi,yi,zi) = Ex(xi,yi,zi) + source_ponctuelle;
  end
  
  % --------------------------------------------------------------------
  % Mise à jour du champ électrique E (avec conditions aux limites PEC)
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
% PARTIE 3 : Sauvegarde des résultats
% ======================================================================
dlmwrite('result_chargee.txt', Ets, 'delimiter', '\t');
fprintf('Résultats sauvegardés dans le fichier result_chargee.txt\n');
