if ((exist("outside_call") == 0))
   ## Clear workspace:
  clear;
  ## Set general model parameters:
  delta_t = 10;
  delta_z = 0.3;
  t_final = 43200;
  z_final = 30;
  threshold_delta = 0.001;
  t = [(0 + delta_t):delta_t:t_final]';
  z = [0:delta_z:z_final]';
  ## Set van Genuchten parameters and model conditions:
  alpha = 0.0335;
  theta_s = 0.368;
  theta_r = 0.102;
  n = 2;
  K_s = 0.00922;
  lambda = 0.5;
  ## H_bot = 0;
  ## H_top = -z_final;
  H_bot = 0;
  H_top = -100;
  H_0 = linspace(H_bot,H_top,length(z))';
  H_top=-28;
  H_0(end)=H_top;
  ## Set working directory:
  root_dir="~/laptop02_Projekt/";
  octave_dir=[root_dir,"Octave/"];
  cd(octave_dir);
  ## Set threshold for maximum number of iterations:
  threshold_iteration_cntr = 100; ## DEBUGGING
endif
## Run the model:
[K_0, theta_0, C_0] = van_Genuchten_variables(alpha, lambda, n, theta_r, theta_s, K_s, H_0);
H_mat = zeros(length(z),length(t));
H_mat(:,1) = H_0;
theta_mat = zeros(length(z),length(t));
theta_mat(:,1) = theta_0;
for timestep = 2:length(t)
  H_n_plus_1_m = H_mat(:,timestep-1);
  theta_n = theta_mat(:,timestep-1);
  iteration_cntr = 0; ## DEBUGGING
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
    ## bottom node % constant pressure
    node=1;
    Alpha(node) = 0;
    Beta(node) = 1;
    Gamma(node) = 0;
    f(node) = 0;
    ## bottom node % no flux
    ## node=1;
    ## Alpha(node) = 0;
    ## Beta(node) = C_n_plus_1_m(node)/delta_t + (K_plus(node)./delta_z.^2 + 0);
    ## Gamma(node) = -K_plus(node)./delta_z.^2;
    ## f(node) = (1./delta_z.^2) .* (K_plus(node).*(H_n_plus_1_m(node+1)-H_n_plus_1_m(node)) - 0) +(K_plus(node)- 0)/delta_z- (theta_n_plus_1_m(node) - theta_n(node))/delta_t;

    ## top node % constant pressure
    node=size(H_n_plus_1_m,1);
    Alpha(node) = 0;
    Beta(node) = 1;
    Gamma(node) = 0;
    f(node) = 0;

    ## create A
    A=sparse(diag(Beta))+sparse(diag(Gamma(1:end-1),1))+sparse(diag(Alpha(2:end),-1));
    delta = full(A\sparse(f'));

    ## check whether we need another iteration step
    if (max(abs(delta)) <= abs(threshold_delta))
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
    ++iteration_cntr; ## DEBUGGING
    iteration_cntr  ## DEBUGGING
    if (iteration_cntr > threshold_iteration_cntr) ## DEBUGGING
      error("%s","too many iterations required.") ## DEBUGGING
    endif ## DEBUGGING
  endwhile
  H_mat(:,timestep) = H_n;
  theta_mat(:,timestep) = theta_n;
  timestep ## DEBUGGING
endfor

if ((exist("outside_call") == 0))
  plot(H_mat(1,:))
endif
