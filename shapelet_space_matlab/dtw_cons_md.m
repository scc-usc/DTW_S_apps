function [Dist, w1, w2]=dtw_cons_md(t,r, win, dist_metric)
%Dynamic Time Warping Algorithm
%Dist is the DTW distance between t and r
%w is the optimal path
%t is the vector you are testing against
%r is the vector you are testing

N = size(t, 2); % If single source/dest
M = size(r, 2); % If single source/dest

if nargin < 3
    win = inf;
end
if nargin < 4
    dist_metric = 'eu';
end

if length(win) == 1
    win = [win(1) win(1)];
end

Dist = inf;
d = inf(N, M);
w1 = 0; w2 = 0; 
if startsWith(dist_metric, 'cos') && size(t, 1)>1
    t_norm = sqrt(sum(t.^2, 1)); r_norm = sqrt(sum(r.^2, 1));
    for n=1:N
        for m=1:M
            if (n-m) > -win(1) && (n-m) < win(2)
                d(n,m)=1 - dot(t(:, n), r(:, m))./(t_norm(n)*r_norm(m));
            end
        end
    end
else
    for n=1:N
        for m=1:M
            if (n-m) > -win(1) && (n-m) < win(2)
                d(n,m)=sum((t(:, n)-r(:, m)).^2, 'all');
            end
        end
    end
end

D=zeros(size(d));
D(1,1)=d(1,1);
for n=2:N
    D(n,1)=d(n,1)+D(n-1,1);
end
for m=2:M
    D(1,m)=d(1,m)+D(1,m-1);
end
for n=2:N
    for m=2:M
        D(n,m)=d(n,m)+min([D(n-1,m),D(n-1,m-1),D(n,m-1)]);
    end
end
Dist=D(N,M);
n=N;
m=M;
k=N+M;
w=zeros(N+M, 2);
w(N+M,:)=[N,M];
while ((n+m)~=2)
    if (n-1)==0
        m=m-1;
    elseif (m-1)==0
        n=n-1;
    else
        [~,number]=min([D(n-1,m),D(n,m-1),D(n-1,m-1)]);
        switch number
            case 1
                n=n-1;
            case 2
                m=m-1;
            case 3
                n=n-1;
                m=m-1;
        end
    end
    k=k-1;
    w(k, :)=[n, m];
end
w(1:k-1, :) = [];
w1 = w(:, 1); w2 = w(:, 2);