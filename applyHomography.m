function [ x2, y2 ] = applyHomography( H, x1, y1 )    
%     p = [x1'; y1'];
    p(1,:) = x1(:);
    p(2,:) = y1(:);
    p(3,:) = 1; %ones(1,length(x1));

    q = H*p;
    x2 = q(1,:) ./ q(3,:);
    y2 = q(2,:) ./ q(3,:);
    
    x2 = reshape(x2, size(x1));
    y2 = reshape(y2, size(y1));
end

