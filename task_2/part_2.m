% y = theta
% f1: y'' + y = 0
% y1' = y2
% y2' = -y1
% | 0  1|   |y1|
% |-1  0| * |y2|
% f2: y'' + vy' + y = 0
% y1' = y2
% y2' = -y1 - vy2
% | 0   1|   |y1|
% |-1  -v| * |y2|

with_friction();


% Здесь решается первое уравнение при разных значениях y'(0).
function without_friction()
    f = @(t, y) [0 1; -1 0] * y;
    tspan = [0 10];
    y_0_start = [0; 0.1];
    y_0_end = [0; 1];
    
    hold on
    for i = 0:9
        y_0 = (9 - i) / 9 * y_0_start + i / 9 * y_0_end;
        [t, y] = forward_euler(f, tspan, y_0, 1000);
        plot(t, y(1, :), 'DisplayName', "y'(0) = " + num2str(y_0(2)));
    end
    legend
    hold off
end

% Здесь варьируется v - коэффициент трения.
function with_friction()
    tspan = [0 10];
    y_0 = [0; 1];
    v = linspace(0, 1, 10);
    
    
    hold on
    for i = 1:10
        v_curr = v(i);
        f = @(t, y) [0 1; -1 -v_curr] * y;
        [t, y] = forward_euler(f, tspan, y_0, 1000);
        plot(t, y(1, :), 'DisplayName', "v = " + num2str(v_curr));
    end
    legend
    hold off
end