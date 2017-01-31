% Preamble %
% Clear workspace:
clear;
% Model %
% Set model parameters:
delta_t = 10; % distance between time levels in s
delta_z = 0.3; % vertical distance between spatial levels in cm
t_final = 5000; % total distance between first and last time level in s (should be 100 s)
z_final = 30; % total distance between first and last spatial level in cm (should be 30 cm)
threshold_value = 0.001; % set threshold value for delta
t = [(0 + delta_t):delta_t:t_final]'; % vector of time levels in s
z = [0:delta_z:z_final]'; % vector of spatial levels in cm
H_top = -30000; % boundary condition at the top node in cm (equilibrium: -30)
H_bot = -200; % boundary condition at bottom node in cm (equilibrium: 0)
H_0 = linspace(H_bot,H_top,length(z))'; % initial conditions
% Set parameters for "van_Genuchten_variables" (values taken from Celia et al. (1990), p. 1487 below eq. (13b)):
theta_r = 0.102;
theta_s =0.368;
alpha = 0.0335;
n = 2;
K_s = 0.00922;
[K_0, theta_0, C_0] = van_Genuchten_variables(alpha,n, theta_r, theta_s,    K_s,H_0);
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
    [K_n_plus_1_m, theta_n_plus_1_m, C_n_plus_1_m] = van_Genuchten_variables(alpha,n,theta_r, theta_s, K_s,  H_n_plus_1_m);
    Kmean=2./(1./K_n_plus_1_m(2:end)+1./K_n_plus_1_m(1:end-1));
    K_plus=[Kmean; Kmean(end)];
    K_minus=[Kmean(1); Kmean]; 
    % intermediate nodes
    node=2:size(H_n_plus_1_m,1)-1; 
    Alpha(node) = -K_minus(node)./delta_z.^2;
    Beta(node) = C_n_plus_1_m(node)/delta_t + (K_plus(node)./delta_z.^2 + K_minus(node)./delta_z.^2);
    Gamma(node) = -K_plus(node)./delta_z.^2;
    f(node) = (1./delta_z.^2) .* (K_plus(node).*(H_n_plus_1_m(node+1)-H_n_plus_1_m(node)) - K_minus(node).*(H_n_plus_1_m(node)-H_n_plus_1_m(node-1))) +(K_plus(node)- K_minus(node))/delta_z - (theta_n_plus_1_m(node) - theta_n(node))/delta_t;
    % bottom node
    node=1;
    Alpha(node) = 0;
    Beta(node) = C_n_plus_1_m(node)/delta_t + (K_plus(node)./delta_z.^2 + 0);
    Gamma(node) = -K_plus(node)./delta_z.^2;
    f(node) = (1./delta_z.^2) .* (K_plus(node).*(H_n_plus_1_m(node+1)-H_n_plus_1_m(node)) - 0) +(K_plus(node)- 0)/delta_z- (theta_n_plus_1_m(node) - theta_n(node))/delta_t;
    % top node
    node=size(H_n_plus_1_m,1);
    Alpha(node) = 0;
    Beta(node) = 1;
    Gamma(node) = 0;
    f(node) = 0;
    % create A
    A=sparse(diag(Beta))+sparse(diag(Gamma(1:end-1),1))+sparse(diag(Alpha(2:end),-1));
    delta = full(A\sparse(f'));
    if (max(abs(delta)) <= abs(threshold_value))
      H_n = delta + H_n_plus_1_m;
      H_n(end) = H_top;
      flag = 1;
      [K_n, theta_n, C_n] = van_Genuchten_variables(alpha, n, theta_r, theta_s,  K_s, H_n);
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

plot(H_mat(1,:))
% Set working directory:
% cd("/home/renke/laptop02_Projekt/Octave");
% % Set graphics toolkit:
% graphics_toolkit("gnuplot");
% % Set destination directory for saving data:
% data_dir = "../Daten/Probelaeufe/";
% % Set names of files in which to save and from which to read data:
% H_mat_file = cat(2, data_dir, "H_mat.csv");
% theta_mat_file = cat(2, data_dir, "theta_mat.csv");
% % Set default file type for saving data:
% save_default_options("-text");
% 
% % Save data %
% save (H_mat_file, "H_mat");
% save (theta_mat_file, "theta_mat");
% 
% % Read data %
% H_mat = dlmread(H_mat_file," ",5,0);
% theta_mat = dlmread(theta_mat_file," ",5,0);
% 
% % Plot H:
% close all;
% figurehandle = figure("papertype",
% 		  "a4",
% 		  "paperorientation",
% 		  "landscape",
% 		  "paperunits",
% 		  "centimeters",
% 		  "paperposition",
% 		  [2 2 17 25.6],
% 		  "visible",
% 		  % "off");
% 		  "on");
% xlabel("Timestep");
% ylabel("Node");
% zlabel("Pressure head [cm]");
% axis([0;
%       length(t) + 1;
%       0;
%       length(z) + 1;
%       min(min(H_mat)) - 1 * (10 ^ -9);
%       max(max(H_mat)) + 1 * (10 ^ -7)],
%      "tic",
%      "label");
% grid ("on");
% view(45,
%      35);
% color = ["k"];
% linestyle = "-";
% linewidth = 2;
% % Create plots using for-loop:
% % for row = [1, median(1:rows(H_mat)), rows(H_mat)] % print only a selection of nodes
%   for row = 1:rows(H_mat)
%   line(1:length(t),
%        (1:length(z))(row),
%        % H_mat(row,:).', % transposing seems to result in plotting the same line mutlitple times
%        H_mat(row,:),
%        "linewidth",
%        linewidth,
%        "linestyle",
%        linestyle,
%        "color",
%        color)
% endfor
% system("rm -vf ../Grafiken/H_mat_3D_plot.pdf");
% print(figurehandle,
%       "../Grafiken/H_mat_3D_plot.pdf");
% 
% system("mupdf -r 66 ../Grafiken/H_mat_3D_plot.pdf &");
% 
% % Plot theta:
% close all;
% figurehandle = figure("papertype",
% 		  "a4",
% 		  "paperorientation",
% 		  "landscape",
% 		  "paperunits",
% 		  "centimeters",
% 		  "paperposition",
% 		  [2 2 17 25.6],
% 		  "visible",
% 		  % "off");
% 		  "on");
% xlabel("Timestep");
% ylabel("Node");
% zlabel("Pressure head [cm]");
% axis([0;
%       length(t) + 1;
%       0;
%       length(z) + 1;
%       min(min(theta_mat)) - 1 * (10 ^ -9);
%       max(max(theta_mat)) + 1 * (10 ^ -7)],
%      "tic",
%      "label");
% grid ("on");
% view(45,
%      35);
% color = ["k"];
% linestyle = "-";
% linewidth = 2;
% % Create plots using for-loop:
% for row = [1, median(1:rows(theta_mat)), rows(theta_mat)] % print only a selection of nodes
%   % for row = 1:rows(theta_mat)
%   line(1:length(t),
%        (1:length(z))(row),
%        % theta_mat(row,:).', % transposing seems to result in plotting the same line mutlitple times
%        theta_mat(row,:),
%        "linewidth",
%        linewidth,
%        "linestyle",
%        linestyle,
%        "color",
%        color)
% endfor
% system("rm -vf ../Grafiken/theta_mat_3D_plot.pdf");
% print(figurehandle,
%       "../Grafiken/theta_mat_3D_plot.pdf");
% system("mupdf -r 66 ../Grafiken/theta_mat_3D_plot.pdf &");
