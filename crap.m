function [f,Hnew,Dnew] = update_density(f,H,D,x)
%------------------------------------------------------------------------%
%     Updates the current density with data in x. The number of dyads is
%     kept constant, so that the oldest data points are removed.
% 
%     Parameters
%     ----------
%     f : Estimated density of D
%     H : Old data samples used
%     D : Old dissimilarity matrix
%     x : New data
%
%     Returns
%     -------
%     fnew : Updated density
%     Hnew : New set of data points used (updated window)
%     Dnew : New set of dyads                                             
%------------------------------------------------------------------------%
Hnew = [H(2:end,:);x];           %Remove first data point and add newest
Dx = test_dissimilarity(H,x);    %Compute dyads with respect to x
Dx = Dx(2:end,:); %Remove dyad with respect to oldest point
Dnew = update_dyads(D,Dx);
n = size(D,1);                  %Number of dyads
N = size(f,1);                  %Grid size
h = 1/(N-1);                    %Spatial resolution
numpts = size(H,1);
for i = 1 : numpts-1
    %Remove effect of first (n-1) dyads from density, which correspond to
    %the oldest point.
    d_old = norm_pt(D(i,:),D);  %normalize old dyad wrt old list
    indOld = floor(d_old/h + 1);    %find index of normalized dyad
    p = indOld(1);
    q = indOld(2);
    f(p,q) = f(p,q) - 1/(n*h^2);
    
    %update with new data point
    d_new = norm_pt(Dx(i,:),Dnew);  %normalize new dyad wrt new list
    indNew = floor(d_new/h + 1);
    p = indNew(1);
    q = indNew(2);
    f(p,q) = f(p,q) + 1/(n*h^2); 
end
end

function newdyads = update_dyads(D,Dnew)
%Updates D with entries in Dnew. Assumes the form 
T = size(Dnew,1);
lieu = D(T+1:end,:); %dyad matrix with dyads for the oldest point removed
ind1 = 0;
ind2 = 0;
datanew = zeros(size(D));
for i = 1 : T
    d_new = Dnew(i,:);
    
    %Updates the matrix of dyads (preserving ordering)
    if i <= T-2
        datanew(ind1+1:ind1+T-i,:) = lieu(ind2+1:ind2+T-i,:);
        datanew(ind1+T-i+1,:) = d_new;
        ind1 = ind1 + T-i+1;
        ind2 = ind2 + T-i;
    else
        datanew(end,:) = d_new;
    end
end
newdyads = datanew; %updates the old dyads with the new dyads
end
% function Dnew = update_dyads(dyads,D)
% Dnew = zeros(size(D));
% Dnew(1:end-1,1:end-1,:) = D(2:end,2:end,:);
% 
% Dnew(1:end-1,end,1) = dyads(:,1);
% Dnew(1:end-1,end,2) = dyads(:,2);
% end