function [Ets] = tp04()
% ======================================================================
% tp04.m
% 
% Description :
% Ce script simule la cavité vide et sauvegarde les résultats.
% ======================================================================

% --- Constantes physiques ---
eps0 = 8.8541878e-12;
mu0  = 4e-7 * pi;
c0   = 299792458;

% --- Paramètres de la simulation ---
Lx = 6.7; Ly = 8.4; Lz = 3.5; 
delta = 0.1;
Nx = round(Lx/delta); Ny = round(Ly/delta); Nz = round(Lz/delta); 
Dt = delta / (c0 * sqrt(3)); 
Cx = 1 / delta; Cy = 1 / delta; Cz = 1 / delta;
Nt = 400;                     

% --- Allocation mémoire ---
Ex = zeros(Nx, Ny+1, Nz+1);
Ey = zeros(Nx+1, Ny, Nz+1);
Ez = zeros(Nx+1, Ny+1, Nz);
Hx = zeros(Nx+1, Ny, Nz);
Hy = zeros(Nx, Ny+1, Nz);
Hz = zeros(Nx, Ny, Nz+1);
Ets = zeros(Nt,3);

% --- Propriétés du matériau (vide) ---
KE1X = Dt/eps0;
KE1Y = Dt/eps0;
KE1Z = Dt/eps0;

% --- Paramètres de la source et de la sonde ---
xi=round(Nx/2); yi=round(Ny/2); zi=round(Nz/2);
t0=20*Dt;
sigma=t0/3;
nfin=round(t0*3/Dt);
xo=round(Nx/4); yo=round(Ny/4); zo=round(Nz/4);

% ======================================================================
% Boucle temporelle FDTD
% ======================================================================
toc
for n = 1:Nt
  % --- Mise à jour du champ magnétique H ---
  Hx = Hx + (Dt/mu0)*((Ey(:,:,2:Nz+1)-Ey(:,:,1:Nz))*Cz ...
                    - (Ez(:,2:Ny+1,:)-Ez(:,1:Ny,:))*Cy);
  Hy = Hy + (Dt/mu0)*((Ez(2:Nx+1,:,:)-Ez(1:Nx,:,:))*Cx ...
                    - (Ex(:,:,2:Nz+1)-Ex(:,:,1:Nz))*Cz);
  Hz = Hz + (Dt/mu0)*((Ex(:,2:Ny+1,:)-Ex(:,1:Ny,:))*Cy ...
                    - (Ey(2:Nx+1,:,:)-Ey(1:Nx,:,:))*Cx);

  % --- Insertion de la source (soft source) ---
  if (n<=nfin)
    source_ponctuelle = exp(-(n*Dt-t0)^2/sigma^2);
    Ex(xi,yi,zi) = Ex(xi,yi,zi) + source_ponctuelle;
  end
  
  % --- Mise à jour du champ électrique E (avec conditions PEC implicites) ---
  Ex(:,2:Ny,2:Nz) = Ex(:,2:Ny,2:Nz) + ...
      KE1X.*(Hz(:,2:Ny,2:Nz)-Hz(:,1:Ny-1,2:Nz))*Cy ...
     - KE1X.*(Hy(:,2:Ny,2:Nz)-Hy(:,2:Ny,1:Nz-1))*Cz;
  Ey(2:Nx,:,2:Nz) = Ey(2:Nx,:,2:Nz) + ...
      KE1Y.*(Hx(2:Nx,:,2:Nz)-Hx(2:Nx,:,1:Nz-1))*Cz ...
     - KE1Y.*(Hz(2:Nx,:,2:Nz)-Hz(1:Nx-1,:,2:Nz))*Cx;
  Ez(2:Nx,2:Ny,:) = Ez(2:Nx,2:Ny,:) + ...
      KE1Z.*(Hy(2:Nx,2:Ny,:)-Hy(1:Nx-1,2:Ny,:))*Cx ...
     - KE1Z.*(Hx(2:Nx,2:Ny,:)-Hx(2:Nx,1:Ny-1,:))*Cy;

  % --- Enregistrement du champ à la sonde ---
  Ets(n,:) = [Ex(xo,yo,zo) Ey(xo,yo,zo) Ez(xo,yo,zo)];
end
toc

% --- Sauvegarde des résultats ---
dlmwrite('result_vide.txt', Ets, 'delimiter', '\t');
fprintf('Résultats de la cavité vide sauvegardés dans result_vide.txt\n');

end