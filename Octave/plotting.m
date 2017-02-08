##############
## Preamble ##
##############
## Set graphics toolkit:
graphics_toolkit("gnuplot");
## Clear workspace:
clear();
## Set working directory:
root_dir="~/laptop02_Projekt/";
cd(root_dir);
## Set directory from which to read data:
data_dir=[root_dir,"Daten/"];
## Set and create main directory in which to save plots:
plot_dir=[root_dir,"Grafiken/"];
system(["mkdir -vp ",plot_dir]);
## Set and create directory in which to temporarily save plots:
tmp_dir=[plot_dir,"tmp/"];
system(["mkdir -vp ",tmp_dir]);
for par_set = {"Celia","Lt2","Ss","Tt","Uu"}
## for par_set = {"Celia"} ## TESTING
  par_set = par_set{1}; # necessary for “for” loop
  ## for bound_con = [1,2,3,4]
  for bound_con = [1,2,3] ## TESTING (since bound_con = 4 does not converge for some par_sets)
  ## for bound_con = 4
    for init_con = [1]
      ## Set names of files from which to read data:
      ## par_set = "Celia";
      ## par_set = "Lt2";
      ## par_set = "Ss";
      ## par_set = "Uu";
      ## bound_con=1; ## equilibrium
      ## bound_con=2; ## free water at bottom, ca. FC at top
      ## bound_con=3; ## free water at bottom, dry top
      ## init_con=1; ## linear change using boundary conditions
      results_struct_file_name = [data_dir,par_set,"_",num2str(bound_con),"_",num2str(init_con),"_","results_struct.csv"];
      ## par_struc_file = [data_dir,par_set,"_",num2str(bound_con),"_",num2str(init_con),"_","par_struc.csv"];
      ## Read data:
      load(results_struct_file_name);
      ## load(par_struc_file);
      ## load(par_struc.H_mat_file);
      ## load(par_struc.theta_mat_file);
      H_mat = results_struct.H_mat;
      theta_mat = results_struct.theta_mat;
      par_struct = results_struct.par_struct;
      filename_prefix = par_struct.filename_prefix;
      H_top = par_struct.H_top;
      H_bot = par_struct.H_bot;
      length_t = par_struct.length_t;
      length_z = par_struct.length_z;
      init_con_string = par_struct.init_con_string;
      #textbox = ["par_set: ",par_set,sprintf("\n"),"H_top: ",num2str(H_top),sprintf("\n"),"H_bot: ",num2str(H_bot),sprintf("\n"),"init_con_string: ",init_con_string];
      textbox_spatial = [sprintf("%s%s","par_set: ",par_set),
		     sprintf("%s%s","length(z): ",num2str(length_z)),
		     sprintf("%s%s","H_top: ",num2str(H_top)),
		     sprintf("%s%s","H_bot: ",num2str(H_bot)),
		     sprintf("%s%s","init_con_string: ",init_con_string)];
      textbox_time = [sprintf("%s%s","par_set: ",par_set),
		  sprintf("%s%s","length(t): ",num2str(length_t)),
		  sprintf("%s%s","H_top: ",num2str(H_top)),
		  sprintf("%s%s","H_bot: ",num2str(H_bot)),
		  sprintf("%s%s","init_con_string: ",init_con_string)];
      ##################
      ## Plot H in 2D ##
      ##################
      ############################################################
      ## Plot H for a single spatial level over all time levels ##
      ############################################################
      ## Set directory in which to save plots created by this block:
      current_dir = [plot_dir,"H_2D_plots/spatial_levels/"];
      ## Create "current_dir" if necessary:
      system(["mkdir -vp ",current_dir]);
      ## Remove all .pdf files from "tmp_dir":
      system(["rm -vf ",tmp_dir,"*.pdf"]);
      ## for row = 1:rows(H_mat)
      for row = [1, round(median(1:rows(H_mat))), rows(H_mat)-1] ## plot only a selection of spatial levels
        ## row=2; ## TESTING
        ## close all;
        y=H_mat(row,:);
        x=1:length(y);
        figurehandle = figure("papertype",
			"a4",
			"paperorientation",
			"landscape",
			"paperunits",
			"centimeters",
			"paperposition",
			[2 2 17 25.6],
			"visible",
			"off");
        ## "on");
        line(x,y,
	   "linewidth",
	   3,
	   "color",
	   "red");
        xlabel("Time level");
        ylabel("Pressure head [cm]");
        title(["Spatial level: ",num2str(row)]);
        grid ("on");
        limits = axis();
        text(limits(1)+0.5*(limits(2)-limits(1)),
	   limits(3)+0.25*(limits(4)-limits(3)),
	   textbox_spatial,
	   "interpreter",
	   "none");
        filename=([tmp_dir,filename_prefix,sprintf("%09d",row),".pdf"]);
        print(figurehandle,
	    filename);
      endfor
      system(["pdftk ",tmp_dir,filename_prefix,"*.pdf cat output ",current_dir,filename_prefix,"all.pdf"]);
      ############################################################
      ## Plot H for a single time level over all spatial levels ##
      ############################################################
      ## Set directory in which to save plots created by this block:
      current_dir = [plot_dir,"H_2D_plots/time_levels/"];
      ## Create "current_dir" if necessary:
      system(["mkdir -vp ",current_dir]);
      ## Remove all .pdf files from current directory:
      system(["rm -v ",tmp_dir,"*.pdf"]);
      ## for col = 1:columns(H_mat)
      for col = [1, round(median(1:columns(H_mat))), columns(H_mat)-1] ## plot only a selection of time levels
        ## col = 1; ## TESTING
        ## close all;
        y=H_mat(:,col);
        x=1:length(y);
        figurehandle = figure("papertype",
			"a4",
			"paperorientation",
			"landscape",
			"paperunits",
			"centimeters",
			"paperposition",
			[2 2 17 25.6],
			"visible",
			"off");
        ## "on");
        line(x,y,
	   "linewidth",
	   3,
	   "color",
	   "red");
        xlabel("Spatial level");
        ylabel("Pressure head [cm]");
        title(["Time level: ",num2str(col)]);
        grid ("on");
        limits = axis();
        text(limits(1)+0.5*(limits(2)-limits(1)),
	   limits(3)+0.25*(limits(4)-limits(3)),
	   textbox_time,
	   "interpreter",
	   "none");
        filename=([tmp_dir,filename_prefix,sprintf("%09d",col),".pdf"]);
        print(figurehandle,
	    filename);
      endfor
      system(["pdftk ",tmp_dir,filename_prefix,"*.pdf cat output ",current_dir,filename_prefix,"all.pdf"]);
    endfor
  endfor
endfor

##################
## Plot H in 3D ##
##################
## close all;
## figurehandle = figure("papertype",
## 		  "a4",
## 		  "paperorientation",
## 		  "landscape",
## 		  "paperunits",
## 		  "centimeters",
## 		  "paperposition",
## 		  [2 2 17 25.6],
## 		  "visible",
## 		  "off");
## 		  ## "on");
## xlabel("Timestep");
## ylabel("Node");
## zlabel("Pressure head [cm]");
## axis([0;
##       length(t) + 1;
##       0;
##       length(z) + 1;
##       min(min(H_mat)) - 1 * (10 ^ -9);
##       max(max(H_mat)) + 1 * (10 ^ -7)],
##      "tic",
##      "label");
## grid ("on");
## ## view(45,
## ## 35);
## view(60,
##      30);
## color = ["k"];
## linestyle = "-";
## linewidth = 2;
## ## Create plots using for-loop:
## ## for row = [1, median(1:rows(H_mat)), rows(H_mat)] ## print only a selection of nodes
##   for row = 1:rows(H_mat)
##   line(1:length(t),
##        (1:length(z))(row),
##        ## H_mat(row,:).', ## transposing seems to result in plotting the same line mutlitple times
##        H_mat(row,:),
##        "linewidth",
##        linewidth,
##        "linestyle",
##        linestyle,
##        "color",
##        color)
## endfor

## system("rm -vf ../Grafiken/H_mat_3D_plot.pdf");
## print(figurehandle,
##       "../Grafiken/H_mat_3D_plot.pdf");

## system("mupdf -r 66 ../Grafiken/H_mat_3D_plot.pdf &");

## ## Plot theta:
## close all;
## figurehandle = figure("papertype",
## 		  "a4",
## 		  "paperorientation",
## 		  "landscape",
## 		  "paperunits",
## 		  "centimeters",
## 		  "paperposition",
## 		  [2 2 17 25.6],
## 		  "visible",
## 		  ## "off");
## 		  "on");
## xlabel("Timestep");
## ylabel("Node");
## zlabel("Pressure head [cm]");
## axis([0;
##       length(t) + 1;
##       0;
##       length(z) + 1;
##       min(min(theta_mat)) - 1 * (10 ^ -9);
##       max(max(theta_mat)) + 1 * (10 ^ -7)],
##      "tic",
##      "label");
## grid ("on");
## view(45,
##      35);
## color = ["k"];
## linestyle = "-";
## linewidth = 2;
## ## Create plots using for-loop:
# for row = [1, median(1:rows(theta_mat)), rows(theta_mat)] ## print only a selection of nodes
#   ## for row = 1:rows(theta_mat)
#   line(1:length(t),
#        (1:length(z))(row),
#        ## theta_mat(row,:).', ## transposing seems to result in plotting the same line mutlitple times
#        theta_mat(row,:),
#        "linewidth",
#        linewidth,
#        "linestyle",
#        linestyle,
#        "color",
#        color)
# endfor
# system("rm -vf ../Grafiken/theta_mat_3D_plot.pdf");
# print(figurehandle,
#       "../Grafiken/theta_mat_3D_plot.pdf");
# system("mupdf -r 66 ../Grafiken/theta_mat_3D_plot.pdf &");
