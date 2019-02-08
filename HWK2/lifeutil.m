function [w] = lifeutil(m,t,c,h,kappa, nu, beta)

 util = log(c) - kappa * (h.^(1+1/nu))/(1+1/nu);
 
  %Lifetime utility
 
 beta_m = zeros(m,1);
 beta_t = zeros(t,1);
 
  for j = 1: m
    beta_m(j) = beta^(j-1);
 end
 for k = 1:t
     beta_t(k) = beta^(12*k);
 end
 
w_month = squeeze(sum(util.* beta_m', 2));

w = beta_t' * w_month;

end