## This file contains different boundary conditions settings.
## Switching between settings is done by setting the variable "bound_con" to the corresponding value (integer).
## Note: Every setting should contain a short description.
if (bound_con == 1)
### Description: equilibrium
  H_bot = 0;
  H_top = -z_final;
elseif (bound_con == 2)
### Description: dry bottom, very dry top
  H_bot = -200;
  H_top = -30000
elseif (bound_con == 3)
### Description: free water at bottom, free water at top
  H_bot = 0;
  H_top = 0
elseif (bound_con == 4)
### Description: ca. PWP at bottom, free water at top
  H_bot = -16000;
  H_top = 0;
else ## fallback 
  error("%s\n","unknown value of \"bound_con\".")
endif
