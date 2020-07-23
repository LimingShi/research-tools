% Written by Liming Shi to solve Tx=y, where T is Toeplitz matrix
function [x,var_output,forward_vector]=Levinson_Durbin_ls(Toepmatrix,y_vector)
forward_vector=1/Toepmatrix(1,1);
backward_vector=forward_vector;
x(1)=backward_vector*y_vector(1);
for kk=1:length(y_vector)-1
%  step 1: finding the forward and backward vectors
   Error_forward=Toepmatrix(kk+1,1:kk)*forward_vector;
   Erro_backward=Toepmatrix(1,2:kk+1)*backward_vector;
   alpha_f=1/(1-Error_forward*Erro_backward);
   beta_f=-alpha_f*Error_forward;
   forward_temp=[forward_vector;0];
   backward_temp=[0;backward_vector];
   forward_vector=alpha_f*forward_temp+beta_f*backward_temp;
   alpha_b=-alpha_f*Erro_backward;
   beta_b=alpha_f;
   backward_vector=alpha_b*forward_temp+beta_b*backward_temp;
%  step 2: using the backward vector to construct the solution
   x=[x;0]+(y_vector(kk+1)-Toepmatrix(kk+1,1:kk)*x)*backward_vector;
   
end
var_output=Toepmatrix(1,1)-x'*y_vector;
x=[1;-x];
end