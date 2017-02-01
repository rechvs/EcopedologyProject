# This file contains van Genuchten parameter settings for different soil textures (and functions to translate between different units).
# Switching between settings is done by setting the variable "parset" to the corresponding value (integer or character).
# Note: Every setting should contain a short comment and cite its source!
""; # This line is necessary to prevent Octave from considering the file to be a function file (and prompting for the correct function or file name at every save attempt).
function K_s = K_s_to_cm_s(input)
  K_s = input * 1.1574 * 10^(-5);
endfunction
if (or((parset == 1),(parset == "Ss")))
### Source: Renger et al. (2009)
# Comment:
# - soil type: Ss
# - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
# - in the source "lambda" is called "x"
# - in the source "K_s" is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0;
  theta_s = 0.3879;
  alpha = 0.26437;
  n = 1.35154;
  lambda = -0.594;
  K_s = K_s_to_cm_s(512.094);
elseif (or((parset == 2),(parset == "Lt2")))
### Source: Renger et al. (2009)
# Comment:
# - soil type: Lt2
# - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
# - in the source "lambda" is called "x"
# - in the source "K_s" is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0.1406;
  theta_s = 0.4148;
  alpha = 0.06835;
  n = 1.20501;
  lambda = -3.226;
  K_s = K_s_to_cm_s(98.2);
elseif (or((parset == 3),(parset == "Uu")))
### Source: Renger et al. (2009)
# Comment:
# - soil type: Uu
# - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
# - in the source "lambda" is called "x"
# - in the source "K_s" is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0;
  theta_s = 0.4030;
  alpha = 0.01420;
  n = 1.21344;
  lambda = -0.561;
  K_s = K_s_to_cm_s(33.787);
elseif (or((parset == 4),(parset == "Celia")))
### Source: Celia et al. (1990)
# Comment:
# - New Mexico field site
# - the source does not state the value of "lambda", so the standard value of 0.5 is used (cp. van Genuchten (1980), eq. [8])
  alpha = 0.0335;
  theta_s = 0.368;
  theta_r = 0.102;
  n = 2;
  K_s = 0.00922;
  lambda = 0.5;
## else # template below
### Source:
# Comment:
  ## theta_r = ;
  ## theta_s = ;
  ## alpha = ;
  ## n = ;
  ## lambda = ;
  ## K_s = ;
endif
