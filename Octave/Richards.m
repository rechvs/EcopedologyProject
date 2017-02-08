## Preamble #
## Clear workspace:
clear;
## Set working directory:
root_dir="~/laptop02_Projekt/";
octave_dir=[root_dir,"Octave/"];
cd(octave_dir);
## Set destination directory for saving data:
data_dir = "~/laptop02_Projekt/Daten/";
###########
## Model ##
###########
## Set model parameters:
delta_t = 10; ## distance between time levels in s
delta_z = 0.3; ## vertical distance between spatial levels in cm
t_final = 43200; ## total distance between first and last time level in s
z_final = 30; ## total distance between first and last spatial level in cm
threshold_value = 0.001; ## set threshold value for delta
t = [(0 + delta_t):delta_t:t_final]'; ## vector of time levels in s
z = [0:delta_z:z_final]'; ## vector of spatial levels in cm
for par_set = {"Celia","Lt2","Ss","Tt","Uu"}
## for par_set = {"Celia"}
  par_set = par_set{1}; # necessary for “for” loop
  ## for bound_con = [1,2,3,4] # par_set = "Lt2" and bound_con = 4 does not converge
  for bound_con = 4 ## TESTING
    ## for init_con = [1]
    for init_con = [2]
      ## Set van Genuchten parameters using file "van_Genuchten_parameters.m":
      ## par_set = "Celia";
      ## par_set = "Lt2";
      ## par_set = "Ss";
      ## par_set = "Uu";
      source("van_Genuchten_parameters.m");
      ## Set boundary conditions using file "boundary_conditions.m":
      ## bound_con=1; ## equilibrium
      ## bound_con=2; ## free water at bottom, ca. FC at top
      ## bound_con=3; ## free water at bottom, dry top
      source("boundary_conditions.m");
      ## Set initial conditions using file "initial_conditions.m":
      ## init_con=1; ## linear change using boundary conditions
      source("initial_conditions.m");
      ## Set file name prefix:
      filename_prefix = [par_set,"_",num2str(bound_con),"_",num2str(init_con),"_"];
      ## Create dummy file to mark modelling attempt for the given parameter combination:
      textbox = [sprintf("%s%s","par_set: ",par_set),
	       sprintf("%s%s","H_top: ",num2str(H_top)),
	       sprintf("%s%s","H_bot: ",num2str(H_bot)),
	       sprintf("%s%s","init_con_string: ",init_con_string)];
      ## attempt_message=["This file exists to document that the attempt to model the combination of ",sprintf("\n"),textbox,sprintf("\n"),"was not successful."];
      attempt_message=[sprintf("%s\n%s\n%s",
			 "This file exists to document that the attempt to model the combination of ",
			 textbox,
			 "was not successful.")];
      ## attempt_message=["This file exists to document that the attempt to model the combination of \"par_set = \"",par_set,"\"\",  \"bound_con = ",num2str(bound_con),"\", and \"init_con = ",num2str(init_con),"\" was not successful."];
      attempt_file = [data_dir,filename_prefix,"attempted.txt"];
      save("-text",attempt_file,"attempt_message");
      ## Run the model:
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
        timestep ## TESTING
      endfor
      #################
      ## Saving data ##
      #################
      ## Create "data_dir" if necessary:
      system(["mkdir -vp ",data_dir]);
      ## Remove all .csv files from "data_dir":
      ## system(["rm -v ",data_dir,"*.csv"]);
      ## Set names of files in which to save data:
      results_struct_file_name = [data_dir,filename_prefix,"results_struct.csv"];
      ## H_mat_file = [data_dir,filename_prefix,"H_mat.csv"];
      ## theta_mat_file = [data_dir,filename_prefix,"theta_mat.csv"];
      ## par_struct_file = [data_dir,filename_prefix,"par_struct.csv"];
      ## Store relevant parameters in structure "par_struct":
      par_struct.par_set = par_set;
      par_struct.alpha = alpha;
      par_struct.lambda = lambda;
      par_struct.n = n;
      par_struct.theta_r = theta_r;
      par_struct.theta_s = theta_s;
      par_struct.K_s = K_s;
      par_struct.delta_t = delta_t;
      par_struct.delta_z = delta_z;
      par_struct.t_final = t_final;
      par_struct.z_final = z_final;
      par_struct.length_t = length(t);
      par_struct.length_z = length(z);
      par_struct.threshold_value = threshold_value;
      par_struct.bound_con = bound_con;
      par_struct.init_con = init_con;
      par_struct.init_con_string = init_con_string;
      par_struct.H_top = H_top;
      par_struct.H_bot = H_bot;
      par_struct.filename_prefix = filename_prefix;
      ## par_struct.H_mat_file = H_mat_file;
      ## par_struct.theta_mat_file = theta_mat_file;
      ## Store "H_mat", "theta_mat", and "par_sctruct" in "results_struct":
      results_struct.H_mat = H_mat;
      results_struct.theta_mat = theta_mat;
      results_struct.par_struct = par_struct;
      ## Set default file type for saving data:
      save_default_options("-text");
      ## Save data:
      save(results_struct_file_name, "results_struct");
      ## save(H_mat_file, "H_mat");
      ## save(theta_mat_file, "theta_mat");
      ## save(par_struct_file, "par_struct");
      ## Remove dummy file after succesful modelling attempt:
      system(["rm -v ",attempt_file]);
    endfor
  endfor
endfor
