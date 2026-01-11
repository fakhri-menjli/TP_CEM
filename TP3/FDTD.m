function [Ets]=FDTD()

% Physical constants
eps0 = 8.8541878e-12;         % Permittivity of vacuum
mu0  = 4e-7 * pi;             % Permeability of vacuum
c0   = 299792458;             % Speed of light in vacuum

% Parameter initiation
Lx = 3.; Ly = 3.; Lz = 3.; % Cavity dimensions in meters
Nx =  30; Ny =  30; Nz =  30; % Number of cells in each direction

Cx = Nx / Lx;                 % Inverse cell dimensions
Cy = Ny / Ly;
Cz = Nz / Lz;
Nt = 40;                     % Number of time steps
%Dt = 1/(c0*norm([Cx Cy Cz])); % Time step
Dt=1e-10;

% Allocate field matrices
Ex = zeros(Nx  , Ny+1, Nz+1);
Ey = zeros(Nx+1, Ny  , Nz+1);
Ez = zeros(Nx+1, Ny+1, Nz  );
Hx = zeros(Nx+1, Ny  , Nz  );
Hy = zeros(Nx  , Ny+1, Nz  );
Hz = zeros(Nx  , Ny  , Nz+1);
EPS_X = eps0*ones(Nx  , Ny+1, Nz+1);
SIGMA_X = zeros(Nx  , Ny+1, Nz+1);
EPS_Y = eps0*ones(Nx+1, Ny  , Nz+1);
SIGMA_Y = zeros(Nx+1, Ny  , Nz+1);
EPS_Z = eps0*ones(Nx+1, Ny+1, Nz  );
SIGMA_Z = zeros(Nx+1, Ny+1, Nz  );

% Initial value : epsr
epsrx=1.0;
epsry=1.0;
epsrz=1.0;
EPS_X(20:25,20:21,20)=epsrx*eps0;
EPS_Y(20:25,20:21,20)=epsry*eps0;
EPS_Z(20:25,20:21,20)=epsrz*eps0;

% Insertion of espilon/sigma
KE0X=(2*EPS_X-SIGMA_X*Dt)./(2*EPS_X+SIGMA_X*Dt);
KE1X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt));
%KE2X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt));
KE0Y=(2*EPS_Y-SIGMA_Y*Dt)./(2*EPS_Y+SIGMA_Y*Dt);
KE1Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt));
%KE2Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt));
KE0Z=(2*EPS_Z-SIGMA_Z*Dt)./(2*EPS_Z+SIGMA_Z*Dt);
KE1Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt));
%KE2Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt));

% Allocate time signals
Et = zeros(Nt,3);

% Initial value : input/output
xi=6;
yi=6;
zi=6;
%t0=6.486e-9;
%sigma=1.61e-9;
%nfin=71;
t0=8.761e-009;
sigma=2e-009;
nfin=93;
% xo=15;
% yo=15;
% zo=15;
xo=6;
yo=11;
zo=6;


tic
% Time stepping
for n = 1:Nt;
  n
  % Update H everywhere
  Hx = Hx + (Dt/mu0)*((Ey(:,:,2:Nz+1)-Ey(:,:,1:Nz))*Cz ...
                    - (Ez(:,2:Ny+1,:)-Ez(:,1:Ny,:))*Cy);
  Hy = Hy + (Dt/mu0)*((Ez(2:Nx+1,:,:)-Ez(1:Nx,:,:))*Cx ...
                    - (Ex(:,:,2:Nz+1)-Ex(:,:,1:Nz))*Cz);
  Hz = Hz + (Dt/mu0)*((Ex(:,2:Ny+1,:)-Ex(:,1:Ny,:))*Cy ...
                    - (Ey(2:Nx+1,:,:)-Ey(1:Nx,:,:))*Cx);

  % Initiate fields (near but not on the boundary)
  if (n<=nfin)
    source_ponctuelle = exp(-(n*Dt-t0)*(n*Dt-t0)/sigma/sigma);
    Ex(xi,yi,zi) = source_ponctuelle;
    Ey(xi,yi,zi) = source_ponctuelle;
    Ez(xi,yi,zi) = source_ponctuelle;
  end
  
  % Update E everywhere except on boundary
  Ex(:,2:Ny,2:Nz) = KE0X(:,2:Ny,2:Nz).*Ex(:,2:Ny,2:Nz) + ... %(Dt /eps0) * ...
      KE1X(:,2:Ny,2:Nz).*(Hz(:,2:Ny,2:Nz)-Hz(:,1:Ny-1,2:Nz))*Cy ...
     - KE1X(:,2:Ny,2:Nz).*(Hy(:,2:Ny,2:Nz)-Hy(:,2:Ny,1:Nz-1))*Cz;
  Ey(2:Nx,:,2:Nz) = KE0Y(2:Nx,:,2:Nz).*Ey(2:Nx,:,2:Nz) + ... %(Dt /eps0) * ...
      KE1Y(2:Nx,:,2:Nz).*(Hx(2:Nx,:,2:Nz)-Hx(2:Nx,:,1:Nz-1))*Cz ...
     - KE1Y(2:Nx,:,2:Nz).*(Hz(2:Nx,:,2:Nz)-Hz(1:Nx-1,:,2:Nz))*Cx;
  Ez(2:Nx,2:Ny,:) = KE0Z(2:Nx,2:Ny,:).*Ez(2:Nx,2:Ny,:) + ... %(Dt /eps0) * ...
      KE1Z(2:Nx,2:Ny,:).*(Hy(2:Nx,2:Ny,:)-Hy(1:Nx-1,2:Ny,:))*Cx ...
     - KE1Z(2:Nx,2:Ny,:).*(Hx(2:Nx,2:Ny,:)-Hx(2:Nx,1:Ny-1,:))*Cy;

  % Sample the electric field at chosen points
  Ets(n,:) = [Ex(xo,yo,zo) Ey(xo,yo,zo) Ez(xo,yo,zo)];
end

toc
