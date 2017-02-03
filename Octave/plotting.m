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
## Set directory in which to save plots:
plot_dir=[root_dir,"Grafiken/"];
## Set names of files from which to read data:
par_set = "Celia";
par_set = "Lt2";
par_set = "Ss";
par_set = "Uu";
bound_con = 1;    
## init_con = 4; ## equilibrium
## bound_con = 2; ## dry bottom, very dry top
## bound_con = 3; ## free water at bottom, free water at top
## bound_con = 4; ## ca. PWP at bottom, free water at top
init_con = 1; ## linear change in pressure head using boundary conditions 
## init_con = 2; ## linear change from free water at bottom to ca. PWP at top
## init_con = 3; ## linear change from free water at bottom to ca. FC at top 
par_struc_file = [data_dir,par_set,"_",num2str(bound_con),"_",num2str(init_con),"_","par_struc.csv"];
## Read data:
load(par_struc_file);
load(par_struc.H_mat_file);
load(par_struc.theta_mat_file);
filename_prefix = par_struc.filename_prefix;
##################
## Plot H in 2D ##
##################
############################################################
## Plot H for a single spatial level over all time levels ##
############################################################
## Set directory in which to store plots created by this block:
current_dir = [plot_dir,"H_2D_plots/spatial_levels/"];
## Create "current_dir" if necessary:
system(["mkdir -vp ",current_dir]);
## Remove all .pdf file from current directory:
## system(["rm -v ",current_dir,"*.pdf"]);
## for row = 1:rows(H_mat)
for row = [1, round(median(1:rows(H_mat))), rows(H_mat)] ## plot only a selection of spatial levels
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
       3);
  xlabel("Time level");
  ylabel("Pressure head [cm]");
  title(["Spatial level: ",num2str(row)]);
  grid ("on");
  limits = axis();
  text(limits(1)+0.75*(limits(2)-limits(1)),
       limits(3)+0.25*(limits(4)-limits(3)),
       ["par\_set: ",par_set],
       "interpreter",
       "none");
  filename=([current_dir,filename_prefix,sprintf("%03d",row),".pdf"]);
  print(figurehandle,
        filename);
endfor
system(["pdftk ",current_dir,filename_prefix,"[0-9][0-9][0-9].pdf cat output ",current_dir,filename_prefix,"all.pdf"]);
############################################################
## Plot H for a single time level over all spatial levels ##
############################################################
## Set directory in which to store plots created by this block:
current_dir = [plot_dir,"H_2D_plots/time_levels/"];
## Create "current_dir" if necessary:
system(["mkdir -vp ",current_dir]);
## Remove all .pdf file from current directory:
## system(["rm -v ",current_dir,"*.pdf"]);
## for col = 1:columns(H_mat)
for col = [1, round(median(1:columns(H_mat))), columns(H_mat)] ## plot only a selection of time levels
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
       3);
  xlabel("Spatial level");
  ylabel("Pressure head [cm]");
  title(["Time level: ",num2str(col)]);
  grid ("on");
  limits = axis();
  text(limits(1)+0.75*(limits(2)-limits(1)),
       limits(3)+0.25*(limits(4)-limits(3)),
       ["par\_set: ",par_set],
       "interpreter",
       "none");
  filename=([current_dir,filename_prefix,sprintf("%03d",col),".pdf"]);
  print(figurehandle,
        filename);
endfor
system(["pdftk ",current_dir,filename_prefix,"[0-9][0-9][0-9].pdf cat output ",current_dir,filename_prefix,"all.pdf"]);

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
