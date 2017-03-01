function [L,num,sz] = swtlabel(I,n)

sizI = size(I);
id = reshape(1:prod(sizI),sizI);
sz = ones(sizI);

% Indexes of the adjacent pixels
vec = @(x) x(:);
if n==4 % 4-connected neighborhood
    idx1 = [vec(id(:,1:end-1)); vec(id(1:end-1,:))];
    idx2 = [vec(id(:,2:end)); vec(id(2:end,:))];
elseif n==8 % 8-connected neighborhood
    idx1 = [vec(id(:,1:end-1)); vec(id(1:end-1,:))];
    idx2 = [vec(id(:,2:end)); vec(id(2:end,:))];
    idx1 = [idx1; vec(id(1:end-1,1:end-1)); vec(id(2:end,1:end-1))];
    idx2 = [idx2; vec(id(2:end,2:end)); vec(id(1:end-1,2:end))];
else
    error('The second input argument must be either 4 or 8.')
end

% Create the groups and merge them (Union/Find Algorithm)
for k = 1:length(idx1)
    root1 = idx1(k);
    root2 = idx2(k);
    
    while root1~=id(root1)
        id(root1) = id(id(root1));
        root1 = id(root1);
    end
    while root2~=id(root2)
        id(root2) = id(id(root2));
        root2 = id(root2);
    end
    
    if root1==root2, 
        continue, 
    end
      
    N1 = sz(root1); % size of the group belonging to root1
    N2 = sz(root2); % size of the group belonging to root2
    
    if max(I(root1),I(root2))/min(I(root1),I(root2)) <= 3
        % then merge the two groups
        if N1 < N2
            id(root1) = root2;
            sz(root2) = N1+N2;
        else
            id(root2) = root1;
            sz(root1) = N1+N2;
        end
    end
end

while 1
    id0 = id;
    id = id(id);
    if isequal(id0,id), break, end
end
sz = sz(id);

% Label matrix
isNaNI = isinf(I);
id(isNaNI) = NaN;
[id,m,n] = unique(id);
I = 1:length(id);
L = reshape(I(n),sizI);
L(isNaNI) = 0;

if nargout>1, num = nnz(~isnan(id)); 
  end