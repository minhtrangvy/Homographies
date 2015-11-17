function [ H ] = computeHomography( x_fixed, y_fixed, x_moving, y_moving )
A = [
    x_fixed(1) y_fixed(1) 1 0 0 0 -x_moving(1)*x_fixed(1) -x_moving(1)*y_fixed(1) -x_moving(1);
    0 0 0 x_fixed(1) y_fixed(1) 1 -y_moving(1)*x_fixed(1) -y_moving(1)*y_fixed(1) -y_moving(1);
    
    x_fixed(2) y_fixed(2) 1 0 0 0 -x_moving(2)*x_fixed(2) -x_moving(2)*y_fixed(2) -x_moving(2);
    0 0 0 x_fixed(2) y_fixed(2) 1 -y_moving(2)*x_fixed(2) -y_moving(2)*y_fixed(2) -y_moving(2);
    
    x_fixed(3) y_fixed(3) 1 0 0 0 -x_moving(3)*x_fixed(3) -x_moving(3)*y_fixed(3) -x_moving(3);
    0 0 0 x_fixed(3) y_fixed(3) 1 -y_moving(3)*x_fixed(3) -y_moving(3)*y_fixed(3) -y_moving(3);
    
    x_fixed(4) y_fixed(4) 1 0 0 0 -x_moving(4)*x_fixed(4) -x_moving(4)*y_fixed(4) -x_moving(4);
    0 0 0 x_fixed(4) y_fixed(4) 1 -y_moving(4)*x_fixed(4) -y_moving(4)*y_fixed(4) -y_moving(4);
    
%     x_fixed(5) y_fixed(5) 1 0 0 0 -x_moving(5)*x_fixed(5) -x_moving(5)*y_fixed(5) -x_moving(5);
%     0 0 0 x_fixed(5) y_fixed(5) 1 -y_moving(5)*x_fixed(5) -y_moving(5)*y_fixed(5) -y_moving(5);
%     
%     x_fixed(6) y_fixed(6) 1 0 0 0 -x_moving(6)*x_fixed(6) -x_moving(6)*y_fixed(6) -x_moving(6);
%     0 0 0 x_fixed(6) y_fixed(6) 1 -y_moving(6)*x_fixed(6) -y_moving(6)*y_fixed(6) -y_moving(6);
%     
%     x_fixed(7) y_fixed(7) 1 0 0 0 -x_moving(7)*x_fixed(7) -x_moving(7)*y_fixed(7) -x_moving(7);
%     0 0 0 x_fixed(7) y_fixed(7) 1 -y_moving(7)*x_fixed(7) -y_moving(7)*y_fixed(7) -y_moving(7);
%     
%     x_fixed(8) y_fixed(8) 1 0 0 0 -x_moving(8)*x_fixed(8) -x_moving(8)*y_fixed(8) -x_moving(8);
%     0 0 0 x_fixed(8) y_fixed(8) 1 -y_moving(8)*x_fixed(8) -y_moving(8)*y_fixed(8) -y_moving(8);
    ];
[~, ~, V] = svd(A);
H = V(:,9);
H = reshape(H,3,3)';
