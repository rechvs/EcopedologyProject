## Set directory from which to read data:
data_dir = "../Daten/Probelaeufe/";
## Set names of files from which to read data:
H_mat_file = cat(2, data_dir, "H_mat.csv");
theta_mat_file = cat(2, data_dir, "theta_mat.csv");
## Read data:
H_mat = dlmread(H_mat_file," ",5,0);
theta_mat = dlmread(theta_mat_file," ",5,0);
## Set graphics toolkit:
graphics_toolkit("gnuplot");
## Create 2D plots:
close all;
plot(H_mat(1,:))
plot(H_mat(median(1:rows(H_mat)),:))

## Plot H in 3D:
close all;
figurehandle = figure("papertype",
		  "a4",
		  "paperorientation",
		  "landscape",
		  "paperunits",
		  "centimeters",
		  "paperposition",
		  [2 2 17 25.6],
		  "visible",
		  ## "off");
		  "on");
xlabel("Timestep");
ylabel("Node");
zlabel("Pressure head [cm]");
axis([0;
      length(t) + 1;
      0;
      length(z) + 1;
      min(min(H_mat)) - 1 * (10 ^ -9);
      max(max(H_mat)) + 1 * (10 ^ -7)],
     "tic",
     "label");
grid ("on");
## view(45,
## 35);
view(60,
     30);
color = ["k"];
linestyle = "-";
linewidth = 2;
## Create plots using for-loop:
for row = [1, median(1:rows(H_mat)), rows(H_mat)] ## print only a selection of nodes
  ## for row = 1:rows(H_mat)
  line(1:length(t),
       (1:length(z))(row),
       ## H_mat(row,:).', ## transposing seems to result in plotting the same line mutlitple times
       H_mat(row,:),
       "linewidth",
       linewidth,
       "linestyle",
       linestyle,
       "color",
       color)
endfor
system("rm -vf ../Grafiken/H_mat_3D_plot.pdf");
print(figurehandle,
      "../Grafiken/H_mat_3D_plot.pdf");

system("mupdf -r 66 ../Grafiken/H_mat_3D_plot.pdf &");

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
