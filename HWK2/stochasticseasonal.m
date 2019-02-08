function [W_middle, W_high, W_low] = stochasticseasonal(t,m,n,z,gm,eta,beta,sigma_epsilon,epsilon,v,sigma_v)

%Consumption at age t, season m for household i
 c_middle = zeros(t,m,n);
 c_high = zeros(t,m,n);
 c_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(gm(j,1))*epsilon(k,i)*exp(-sigma_v(j,1))*v(j,k,1);
            c_high(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(gm(j,2))*epsilon(k,i)*exp(-sigma_v(j,2))*v(j,k,2);
            c_low(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(gm(j,3))*epsilon(k,i)*exp(-sigma_v(j,3))*v(j,k,3);
         end
     end
 end
 
 %Utility
  
 util_middle = -(c_middle.^(1-eta)) / (1-eta);
 util_high = -(c_high.^(1-eta)) / (1-eta);
 util_low = -(c_low.^(1-eta)) / (1-eta);
 
 %Lifetime utility
 
 beta_m = zeros(m,1);
 beta_t = zeros(t,1);
 
  for j = 1: m
    beta_m(j) = beta^(j-1);
 end
 for k = 1:t
     beta_t(k) = beta^(12*k);
 end
 
Wm = squeeze(sum(util_middle.* beta_m', 2));
Wh = squeeze(sum(util_high.* beta_m', 2));
Wl = squeeze(sum(util_low.* beta_m', 2));
W_middle = beta_t' * Wm;
W_high = beta_t' * Wh;
W_low = beta_t' * Wl;

end