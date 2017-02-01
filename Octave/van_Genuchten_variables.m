function [K,theta, C] = van_Genuchten_variables(alpha, lambda, n, theta_R, theta_S, Ksat, h)

  m = 1-1./n;
### Compute the volumetric moisture content
  theta = (theta_S - theta_R)./(1 + (alpha.*abs(h)).^n).^m + theta_R;

### Compute the effective saturation (cp. van Genuchten (1980), eq. [2])
  Se = ((theta - theta_R)./(theta_S - theta_R));

### Compute the hydraulic conductivity (cp. van Genuchten (1980), eq. [8])
  K = Ksat.*Se.^(lambda).*(1 - (1 - Se.^(1./m)).^m).^2 ;
  
#### Compute the specific moisture storage
### C=(alpha.*m.*n.*sign(h).*(alpha.*abs(h)).^(n - 1).*(theta_R - theta_S))./((alpha.*abs(h)).^n + 1).^(m + 1);
  C = -alpha.*n.*sign(h).*(1./n - 1).*(alpha.*abs(h)).^(n - 1).*(theta_R - theta_S).*((alpha.*abs(h)).^n + 1).^(1./n - 2);
### C =(alpha.*m.*n.*sign(h).*(alpha.*abs(h)).^(n - 1).*(theta_R - theta_S))./((alpha.*abs(h)).^n + 1).^(m + 1);

###end
endfunction



