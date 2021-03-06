## This file contains different boundary conditions settings.
## Switching between settings is done by setting the variable "bound_con" to the corresponding value (integer).
## Note: Every setting should contain a short description.
if (bound_con == 1)
### Description: equilibrium
  H_bot = 0;
  H_top = -z_final;
elseif (bound_con == 2)
### Description: free water at bottom, wet top
  H_bot = 0;
  H_top = -10;
elseif (bound_con == 3)
### Description: free water at bottom, dry top
  H_bot = 0;
  H_top = -300;
elseif (bound_con == 4)
### Description: free water at bottom, moderately dry top
  H_bot = 0;
  H_top = -35;
elseif (bound_con == 5)
### Description: free water at bottom, ca. FC at top
  H_bot = 0;
  H_top = -60;
else ## fallback 
  error("%s\n","unknown value of \"bound_con\".")
endif
