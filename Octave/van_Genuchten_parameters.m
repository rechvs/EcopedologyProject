## This file contains van Genuchten parameter settings for different soil textures (and functions to translate between different units).
## Switching between settings is done by setting the variable "par_set" to the corresponding value (character).
## Note: Every setting should contain a short comment and cite its source!
""; # This line is necessary to prevent Octave from considering the file to be a function file (and prompting for the correct function or file name at every save attempt).
function K_s = K_s_to_cm_s(input)
  K_s = input * 1.1574 * 10^(-5);
endfunction
if (strcmp(par_set,"Celia"))
### Source: Celia et al. (1990)
## Comment:
## - New Mexico field site
## - the source does not state the value of "lambda", so the standard value of 0.5 is used (cp. van Genuchten (1980), eq. [8])
  alpha = 0.0335;
  theta_s = 0.368;
  theta_r = 0.102;
  n = 2;
  K_s = 0.00922;
  lambda = 0.5;
elseif (strcmp(par_set,"Lt2"))
### Source: Renger et al. (2009)
## Comment:
## - soil type: Lt2
## - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
## - in the source "lambda" is called "x"
## - in the source "K_s" is called "K_0" and is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0.1492;
  theta_s = 0.4380;
  alpha = 0.07013;
  n = 1.24572;
  lambda = -3.180;
  K_s = K_s_to_cm_s(62.531);
elseif (strcmp(par_set,"Ss"))
### Source: Renger et al. (2009)
## Comment:
## - soil type: Ss
## - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
## - in the source "lambda" is called "x"
## - in the source "K_s" is called "K_0" and is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0;
  theta_s = 0.3879;
  alpha = 0.26437;
  n = 1.35154;
  lambda = -0.594;
  K_s = K_s_to_cm_s(512.094);
elseif (strcmp(par_set,"Tt"))
### Source: Renger et al. (2009)
## Comment:
## - soil type: Tt
## - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
## - in the source "lambda" is called "x"
## - in the source "K_s" is called "K_0" and is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0;
  theta_s = 0.5238;
  alpha = 0.06612;
  n = 1.05215;
  lambda = 0;
  K_s = K_s_to_cm_s(154.737);
elseif (strcmp(par_set,"Uu"))
### Source: Renger et al. (2009)
## Comment:
## - soil type: Uu
## - in the source "alpha" is given in hPa^-1, which is equal to cm^-1 (if we assume density of water = 1 g*cm^-3 and gravitational acceleration = 10 m*s^-2)
## - in the source "lambda" is called "x"
## - in the source "K_s" is called "K_0" and is given in cm*d^-1, which is equal to 1.1574*10^-5 cm*s^-1
  theta_r = 0;
  theta_s = 0.4030;
  alpha = 0.01420;
  n = 1.21344;
  lambda = -0.561;
  K_s = K_s_to_cm_s(33.787);
  ## TEMPLATE:
  ## Source:
  ## Comment:
  ## theta_r = ;
  ## theta_s = ;
  ## alpha = ;
  ## n = ;
  ## lambda = ;
  ## K_s = ;
else ## fallback 
  error("%s\n","unknown value of \"par_set\".")
endif
