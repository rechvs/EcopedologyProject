##############
## Preamble ##
##############
## Clear workspace:
clear();
## Set working directory:
root_dir="~/laptop02_Projekt/";
cd(root_dir);
## Set directory from which to read data:
data_dir=[root_dir, "Daten/"];
## Set and create main directory in which to save plots:
plot_dir=[root_dir, "Grafiken/"];
system(["mkdir -vp ", plot_dir]);
## Set and create directory in which to temporarily save plots:
tmp_dir=[plot_dir, "tmp/"];
system(["mkdir -vp ", tmp_dir]);
## Select which plots to create:
## selection = ["H_2D_x_spatial_y_time", "H_2D_x_time_y_spatial", "H_3D"];
selection = ["H_3D"];
## for par_set = {"Celia", "Lt2", "Ss", "Tt", "Uu"}
for par_set = {"Ss"}
  par_set = par_set{1}; # necessary for accessing the string from the cell array
  for bound_con = [1, 2, 3, 4, 5]
  ## for bound_con = [1] ## equilibrium
  ## for bound_con = [5]
    ## for init_con = [1, 2]
    for init_con = [1] ## linear change using boundary conditions
      for scenario = {"cp" "nf"}
        scenario = scenario{1};
        try ## TESTING
	## Set name of file from which to read data:
	results_struct_file_name = [data_dir, par_set, "_", scenario, "_", num2str(bound_con), "_", num2str(init_con), "_", "results_struct.csv"];
	## Read data:
	load(results_struct_file_name);
	H_mat = results_struct.H_mat;
	theta_mat = results_struct.theta_mat;
	par_struct = results_struct.par_struct;
	filename_prefix = par_struct.filename_prefix;
	H_top = par_struct.H_top;
	H_bot = par_struct.H_bot;
	length_t = par_struct.length_t;
	length_z = par_struct.length_z;
	init_con_string = par_struct.init_con_string;
	textbox_spatial = [sprintf("%s%s", "par_set: ", par_set),
	      #sprintf("%s%s", "Spatial levels: ", num2str(length_z)),
		         sprintf("%s%s", "scenario: ", scenario),
		         sprintf("%s%s", "H_top: ", num2str(H_top)),
		         sprintf("%s%s", "H_bot: ", num2str(H_bot)),
		         sprintf("%s%s", "init_con_string: ", init_con_string)];
	textbox_time = [sprintf("%s%s", "par_set: ", par_set),
	         #sprintf("%s%s", "Time levels: ", num2str(length_t)),
		      sprintf("%s%s", "scenario: ", scenario),
		      sprintf("%s%s", "H_top: ", num2str(H_top)),
		      sprintf("%s%s", "H_bot: ", num2str(H_bot)),
		      sprintf("%s%s", "init_con_string: ", init_con_string)];
          ##################
	## Plot H in 2D ##
          ##################
	if (!isempty(regexp(selection, "H_2D_x_spatial_y_time")))
            ############################################################
	  ## Plot H for a single spatial level over all time levels ##
            ############################################################
	  ## Set directory in which to save plots created by this block:
	  current_dir = [plot_dir, "H_2D_plots/spatial_levels/"];
	  ## Create "current_dir" if necessary:
	  system(["mkdir -vp ", current_dir]);
	  ## Remove all .pdf files from "tmp_dir":
	  system(["rm -vf ", tmp_dir, "*.pdf"]);
	  ## for row = 1:rows(H_mat)
	  for row = [2, round(median(1:rows(H_mat))), rows(H_mat)-1] ## plot only a selection of spatial levels
	    ## row=2; ## TESTING
	    ## close all;
	    y=H_mat(row, :);
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
	    line(x, y,
	         "linewidth",
	         3,
	         "color",
	         "red");
	    xlabel("Time level");
	    ylabel("Pressure head [cm]");
	    title(["Spatial level: ", num2str(row), "/", num2str(length_z)]);
	    grid ("on");
	    limits = axis();
	    text(limits(1)+0.5*(limits(2)-limits(1)),
	         limits(3)+0.25*(limits(4)-limits(3)),
	         textbox_spatial,
	         "interpreter",
	         "none");
	    filename=([tmp_dir, filename_prefix, sprintf("%09d", row), ".pdf"]);
	    print(figurehandle,
		filename);
	  endfor
	  system(["pdftk ", tmp_dir, filename_prefix, "*.pdf cat output ", current_dir, filename_prefix, "all.pdf"]);
	endif
	if (!isempty(regexp(selection, "H_2D_x_time_y_spatial")))
          ############################################################
	## Plot H for a single time level over all spatial levels ##
          ############################################################
	## Set directory in which to save plots created by this block:
	current_dir = [plot_dir, "H_2D_plots/time_levels/"];
	## Create "current_dir" if necessary:
	system(["mkdir -vp ", current_dir]);
	## Remove all .pdf files from current directory:
	system(["rm -v ", tmp_dir, "*.pdf"]);
	## for col = 1:columns(H_mat)
	for col = [2, round(median(1:columns(H_mat))), columns(H_mat)] ## plot only a selection of time levels
	  ## col = 1; ## TESTING
	  ## close all;
	  y=H_mat(:, col);
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
	  line(x, y,
	       "linewidth",
	       3,
	       "color",
	       "red");
	  xlabel("Spatial level");
	  ylabel("Pressure head [cm]");
	  title(["Time level: ", num2str(col), "/", num2str(length_t)]);
	  grid ("on");
	  limits = axis();
	  text(limits(1)+0.5*(limits(2)-limits(1)),
	       limits(3)+0.25*(limits(4)-limits(3)),
	       textbox_time,
	       "interpreter",
	       "none");
	  filename=([tmp_dir, filename_prefix, sprintf("%09d", col), ".pdf"]);
	  print(figurehandle,
	        filename);
	endfor
	system(["pdftk ", tmp_dir, filename_prefix, "*.pdf cat output ", current_dir, filename_prefix, "all.pdf"]);
	endif
	if (!isempty(regexp(selection, "H_3D")))
          ##################
	## Plot H in 3D ##
          ##################
	## Set directory in which to save plots created by this block:
	current_dir = [plot_dir, "H_3D_plots/"];
	## Create "current_dir" if necessary:
	system(["mkdir -vp ", current_dir]);
	## Remove all .jpg files from "tmp_dir":
	system(["rm -vf ", tmp_dir, "*.jpg"]);
	close all;
	paperwidth = 25;
	paperheight = 15.625;
	figurehandle = figure("papertype",
			  ## "a4",
			  "<custom>",
			  ## "paperorientation",
			  ## "landscape",
			  "papersize",
			  [paperwidth paperheight],
			  "paperunits",
			  "centimeters",
			  "paperposition",
			  ## [2 2 17 25.6],
			  [0 0 paperwidth paperheight],
			  "visible",
			  "off");
	## "on");
	xlabel("Time level");
	ylabel("Spatial level");
	zlabel("Pressure head [cm]");
	title(["scenario: ", scenario, ", bcs: ", num2str(bound_con)]);
	axis([0;
	      length_t + 1;
	      0;
	      length_z + 1;
	      min(min(H_mat)) - 1 * (10 ^ -9);
	      max(max(H_mat)) + 1 * (10 ^ -7)],
	     "tic",
	     "label");
	grid ("on");
	view(65,
	     35);
	## view(60,
	     ## 30);
	color = ["k"];
	linestyle = "-";
	linewidth = 1;
	## Create plots using for-loop:
	## for row = [1, median(1:rows(H_mat)), rows(H_mat)] ## print only a selection of nodes
	for row = 1:rows(H_mat)
	  line(1:length_t,
	       (1:length_z)(row),
	       ## H_mat(row, :).', ## transposing seems to result in plotting the same line mutlitple times
	       H_mat(row, :),
	       "linewidth",
	       linewidth,
	       "linestyle",
	       linestyle,
	       "color",
	       color)
	endfor

	filename=([tmp_dir, filename_prefix, ".jpg"]);
	print(figurehandle,
	      filename);

	system(["rsync -uvh ", filename, " ", current_dir, "/"]);
	## system(["viewnior ", current_dir, filename, " &"]);
	endif

        catch
	[msg, msgid] = lasterr(); ## TESTING
	sprintf("last error: %s", msg) ## TESTING
        end_try_catch
      endfor
    endfor
  endfor
endfor

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
## for row = [1, median(1:rows(theta_mat)), rows(theta_mat)] ## print only a selection of nodes
##   ## for row = 1:rows(theta_mat)
##   line(1:length(t),
##        (1:length(z))(row),
##        ## theta_mat(row, :).', ## transposing seems to result in plotting the same line mutlitple times
##        theta_mat(row, :),
##        "linewidth",
##        linewidth,
##        "linestyle",
##        linestyle,
##        "color",
##        color)
## endfor
## system("rm -vf ../Grafiken/theta_mat_3D_plot.pdf");
## print(figurehandle,
##       "../Grafiken/theta_mat_3D_plot.pdf");
## system("mupdf -r 66 ../Grafiken/theta_mat_3D_plot.pdf &");
