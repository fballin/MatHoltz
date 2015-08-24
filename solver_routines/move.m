function p = move(p,xm,ym)
% Move a node set p by [xm,ym]

n = size(p,1);
p = p + [xm*ones(n,1), ym*ones(n,1)];

end      % move()