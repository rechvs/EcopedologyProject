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
for par_set = {"Celia","Lt2","Ss","Tt","Uu"}
## for par_set = {"Celia"} ## DEBUGGING
  par_set = par_set{1}; # necessary for accessing the string from the cell array
  for bound_con = [1,2,3,4]
  ## for bound_con = [4] ## DEBUGGING
    for init_con = [1,2]
    ## for init_con = [1] ## DEBUGGING
      ## Begin “try” block:
      try
        ## Set general model parameters:
        delta_t = 10;
        delta_z = 0.3;
        t_final = 43200;
        z_final = 30;
        threshold_delta = 0.001;
        t = [(0 + delta_t):delta_t:t_final]';
        z = [0:delta_z:z_final]';
        ## Set threshold for maximum number of iterations:
        threshold_iteration_cntr = 100; ## DEBUGGING
        ## Retrieve van Genuchten parameters and model conditions from input files:
        source("van_Genuchten_parameters.m");
        source("boundary_conditions.m");
        source("initial_conditions.m");
        ## Set file name prefix:
        filename_prefix = [par_set,"_",num2str(bound_con),"_",num2str(init_con),"_"];
        ## Set name of file in which to save data:
        results_struct_file_name = [data_dir,filename_prefix,"results_struct.csv"];
        ## Delete results from previous run:
        system(["rm -vf ",results_struct_file_name]);
        ## Let the model know whether it was called from outside:
        outside_call = 1;
        ## RUN MODEL ##
        source("Richards.m")
        ## SAVE DATA ##
        ## Create "data_dir" if necessary:
        system(["mkdir -vp ",data_dir]);
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
        par_struct.threshold_delta = threshold_delta;
        par_struct.bound_con = bound_con;
        par_struct.init_con = init_con;
        par_struct.init_con_string = init_con_string;
        par_struct.H_top = H_top;
        par_struct.H_bot = H_bot;
        par_struct.threshold_iteration_cntr = threshold_iteration_cntr;
        par_struct.filename_prefix = filename_prefix;
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
        ## Begin “catch” block:
      catch
        [msg,msgid] = lasterr();
        ## sprintf("last error: %s",msg)
        ## Create dummy file to mark modelling attempt for the given parameter setting and conditions:
        textbox = [sprintf("%s%s","par_set: ",par_set),
	         sprintf("%s%s","H_top: ",num2str(H_top)),
	         sprintf("%s%s","H_bot: ",num2str(H_bot)),
	         sprintf("%s%s","init_con_string: ",init_con_string),
	         sprintf("%s%s","threshold_iteration_cntr: ",num2str(threshold_iteration_cntr))];
        attempt_message=[sprintf("%s\n",
			   "This file exists to document that the attempt to model the combination of ",
			   textbox,
			   "was not successful. Last error message was: ",
			   msg)];
        attempt_file = [data_dir,filename_prefix,"attempted.txt"];
        save("-text",attempt_file,"attempt_message");
      end_try_catch
    endfor
  endfor
endfor
