## Preamble #
## Clear workspace:
clear;
## Set working directory:
root_dir="~/laptop02_Projekt/";
octave_dir=[root_dir,"Octave/"];
cd(octave_dir);
## Model #
## Set van Genuchten parameters using file "van_Genuchten_parameters.m":
## par_set = "Ss";
## par_set = "Lt2";
## par_set = "Uu";
par_set = "Celia";
source("van_Genuchten_parameters.m");
## Set model parameters:
delta_t = 10; ## distance between time levels in s
delta_z = 0.3; ## vertical distance between spatial levels in cm
t_final = 5000; ## total distance between first and last time level in s (should be 100 s)
z_final = 30; ## total distance between first and last spatial level in cm (should be 30 cm)
threshold_value = 0.001; ## set threshold value for delta
t = [(0 + delta_t):delta_t:t_final]'; ## vector of time levels in s
z = [0:delta_z:z_final]'; ## vector of spatial levels in cm
## Set boundary conditions using file "boundary_conditions.m":
bound_con=1;
## bound_con=2;
## bound_con=3;
source("boundary_conditions.m");
## Set boundary conditions manually:
## H_top = -30000; ## boundary condition at the top node in cm (equilibrium: -30)
## H_bot = -200; ## boundary condition at bottom node in cm (equilibrium: 0)
## H_top = -30; ## boundary condition at the top node in cm (equilibrium: -30)
## H_bot = 0; ## boundary condition at bottom node in cm (equilibrium: 0)
## Set initial conditions using file "initial_conditions.m":
init_con=1;
## init_con=2;
## init_con=3;
source("initial_conditions.m");
## Set inital conditions manually:
## H_0 = linspace(H_bot,H_top,length(z))';
[K_0, theta_0, C_0] = van_Genuchten_variables(alpha, lambda, n, theta_r, theta_s, K_s, H_0);
H_mat = zeros(length(z),length(t));
H_mat(:,1) = H_0;
theta_mat = zeros(length(z),length(t));
theta_mat(:,1) = theta_0;
for timestep = 2:length(t)
  H_n_plus_1_m = H_mat(:,timestep-1);
  theta_n = theta_mat(:,timestep-1);
  iteration_cntr = 0;
  flag = 0;
  while ((flag == 0))
    [K_n_plus_1_m, theta_n_plus_1_m, C_n_plus_1_m] = van_Genuchten_variables(alpha, lambda, n,theta_r, theta_s, K_s, H_n_plus_1_m);
    Kmean=2./(1./K_n_plus_1_m(2:end)+1./K_n_plus_1_m(1:end-1));
    K_plus=[Kmean; Kmean(end)];
    K_minus=[Kmean(1); Kmean]; 
    ## intermediate nodes
    node=2:size(H_n_plus_1_m,1)-1; 
    Alpha(node) = -K_minus(node)./delta_z.^2;
    Beta(node) = C_n_plus_1_m(node)/delta_t + (K_plus(node)./delta_z.^2 + K_minus(node)./delta_z.^2);
    Gamma(node) = -K_plus(node)./delta_z.^2;
    f(node) = (1./delta_z.^2) .* (K_plus(node).*(H_n_plus_1_m(node+1)-H_n_plus_1_m(node)) - K_minus(node).*(H_n_plus_1_m(node)-H_n_plus_1_m(node-1))) +(K_plus(node)- K_minus(node))/delta_z - (theta_n_plus_1_m(node) - theta_n(node))/delta_t;
    ## bottom node
    node=1;
    Alpha(node) = 0;
    Beta(node) = C_n_plus_1_m(node)/delta_t + (K_plus(node)./delta_z.^2 + 0);
    Gamma(node) = -K_plus(node)./delta_z.^2;
    f(node) = (1./delta_z.^2) .* (K_plus(node).*(H_n_plus_1_m(node+1)-H_n_plus_1_m(node)) - 0) +(K_plus(node)- 0)/delta_z- (theta_n_plus_1_m(node) - theta_n(node))/delta_t;
    ## top node
    node=size(H_n_plus_1_m,1);
    Alpha(node) = 0;
    Beta(node) = 1;
    Gamma(node) = 0;
    f(node) = 0;
    ## create A
    A=sparse(diag(Beta))+sparse(diag(Gamma(1:end-1),1))+sparse(diag(Alpha(2:end),-1));
    delta = full(A\sparse(f'));
    if (max(abs(delta)) <= abs(threshold_value))
      H_n = delta + H_n_plus_1_m;
      H_n(end) = H_top;
      flag = 1;
      [K_n, theta_n, C_n] = van_Genuchten_variables(alpha, lambda, n, theta_r, theta_s, K_s, H_n);
    else
      flag = 0;
      H_n_plus_1_m = delta + H_n_plus_1_m;
      H_n_plus_1_m(end) = H_top;
      H_n = H_n_plus_1_m;
    endif
  endwhile
  H_mat(:,timestep) = H_n;
  theta_mat(:,timestep) = theta_n;
endfor
#################
## Saving data ##
#################
## Set destination directory for saving data:
data_dir = "~/laptop02_Projekt/Daten/";
## Create "data_dir" if necessary:
system(["mkdir -vp ",data_dir]);
## Remove all .csv files from "data_dir":
## system(["rm -v ",data_dir,"*.csv"]);
## Set names of files in which to save data:
H_mat_file = [data_dir,par_set,"_H_mat.csv"];
theta_mat_file = [data_dir,par_set,"_theta_mat.csv"];
par_struc_file = [data_dir,par_set,"_par_struc.csv"];
## Store relevant parameters in structure "par_struc":
par_struc.par_set = par_set;
par_struc.alpha = alpha;
par_struc.lambda = lambda;
par_struc.n = n;
par_struc.theta_r = theta_r;
par_struc.theta_s = theta_s;
par_struc.K_s = K_s;
par_struc.delta_t = delta_t;
par_struc.delta_z = delta_z;
par_struc.t_final = t_final;
par_struc.z_final = z_final;
par_struc.threshold_value = threshold_value;
par_struc.bound_con = bound_con;
par_struc.init_con = init_con;
par_struc.H_mat_file = H_mat_file;
par_struc.theta_mat_file = theta_mat_file;
## Set default file type for saving data:
save_default_options("-text");
## Save data:
save(H_mat_file, "H_mat");
save(theta_mat_file, "theta_mat");
save(par_struc_file, "par_struc");
       
