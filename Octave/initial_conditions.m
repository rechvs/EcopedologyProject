## This file contains different initial conditions settings.
## Switching between settings is done by setting the variable "init_con" to the corresponding value (integer).
## Note: Every setting should contain a short description.
if (init_con == 1)
### Description: linear change using boundary conditions
  init_con_string = "linspace(H_bot,H_top,length(z))'";
  H_0 = eval(init_con_string);
elseif (init_con == 2)
### Description: linear change from -60 cm at bottom to -30 cm at top
  init_con_string = "linspace(-60,-30,length(z))'";
  H_0 = eval(init_con_string);
else ## fallback 
  error("%s\n","unknown value of \"init_con\".")
endif
