## This file contains different initial conditions settings.
## Switching between settings is done by setting the variable "init_con" to the corresponding value (integer).
## Note: Every setting should contain a short description.
if (init_con == 1)
### Description: linear change in pressure head using boundary conditions
  H_0 = linspace(H_bot,H_top,length(z))';
elseif (init_con == 2)
### Description: linear change from free water at bottom to ca. PWP at top
  H_0 = linspace(0,-16000,length(z))';
elseif (init_con == 3)
### Description: linear change from free water at bottom to ca. FC at top
  H_0 = linspace(0,-60,length(z))';
else ## fallback 
  error("%s\n","unknown value of \"init_con\".")
endif
