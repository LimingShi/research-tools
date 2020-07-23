function [path] = hmmViterbi_LS(logpi, logA, loglik)
% Written by Liming  on 7TH Sep 2017 in Aalborg University
% This is an implementation of the max sum algorithm 
%%
K=length(logpi);
N=size(loglik,2);
message_passing=zeros(K,N);
path_set=zeros(K,N-1);
path=zeros(N,1);
message_passing(:,1)=logpi+loglik(:,1);
for n=2:N
    [temp,pos_temp]=max(repmat(message_passing(:,n-1),1,K)+logA);
    path_set(:,n-1)=pos_temp(:);
    message_passing(:,n)=loglik(:,n)+temp(:);
end
%% backtrack the path 
[~,path(N)]=max(message_passing(:,end));
for n=N-1:-1:1
    path(n)=path_set(path(n+1),n);
end
end