%% 球铰动力学及动画显示
% 功能描述：ZXY顺规欧拉角表示三维旋转，牛顿欧拉方程建立球铰动力学方程，拉格朗日乘子法求解，动画显示
% 作者：-DandD-
% 创建日期：2025-04-02
% 版本：1.0

close all;
clear;
clc;

%% Parameters
global pole MB

pole.m = 1;
pole.l = 1;
pole.d = 0.1;
pole.Ixx = 1/12*pole.m*( 3*( pole.d/2 )^2+pole.l^2 );
pole.Iyy = pole.Ixx;
pole.Izz = 1/2*pole.m*( pole.d/2 )^2;
pole.J   = diag([pole.Ixx pole.Iyy pole.Izz]);

MB.M     = diag([pole.m  pole.m pole.m pole.Ixx pole.Iyy pole.Izz]);

pole.ro  = [0;
            0;
            pole.l/2];
pole.v   = [0 0;
            0 0;
            -pole.l/2 pole.l/2];

pole.C = 0.1;
%% Initialization
t_all = 10;
T     = 0.01;
N     = t_all/T;
gain  = 1/20/T;

State = zeros(12,N);
Ctrl  = zeros(6,N);

Euler0 = [0;
          0;
          80/180*pi];
pos0   = [-(pole.l/2)*sin(80/180*pi);
                        0;
          -(pole.l/2)*cos(80/180*pi)];

v0 = [0;
      0;
      0];
w0 = [0;
      0;
      0];
State(:,1) = [pos0;
              Euler0;
              v0;
              w0];

Ctrl(:,1:10)  = [pole.m*8;
                 pole.m*8;
                 0;
                 0;
                 0;
                 0]*ones(1,10);
%% main
for i = 1:N
    tic
    State(:,i+1) = runge_kutta4(@Pendulum,State(:,i),Ctrl(:,i),T);
    toc
end
Animation(State,gain);
%%
function dState = Pendulum(State,Ctrl)

    global pole MB

    pos   = State(1:3);
    Euler = State(4:6);
    v     = State(7:9);
    w     = State(10:12);

    psi   = Euler(1);
    phi   = Euler(2);
    theta = Euler(3);

    % | dpsi |                |wx|
    % |dtheta| = omega2dEuler |wy|
    % | dphi |                |wz|
    omega2dEuler = [          -sin(theta)/(cos(phi)*cos(theta)^2 + cos(phi)*sin(theta)^2), 0,             cos(theta)/(cos(phi)*cos(theta)^2 + cos(phi)*sin(theta)^2);
                                                 cos(theta)/(cos(theta)^2 + sin(theta)^2), 0,                               sin(theta)/(cos(theta)^2 + sin(theta)^2);
                    (sin(phi)*sin(theta))/(cos(phi)*cos(theta)^2 + cos(phi)*sin(theta)^2), 1, -(cos(theta)*sin(phi))/(cos(phi)*cos(theta)^2 + cos(phi)*sin(theta)^2)];
    dEuler = omega2dEuler*w;

    % |Xgnd|     |x|
    % |Ygnd| = A |y|
    % |Zgnd|     |z|
    A = [cos(psi)*cos(theta) - sin(phi)*sin(psi)*sin(theta), -cos(phi)*sin(psi), cos(psi)*sin(theta) + cos(theta)*sin(phi)*sin(psi);
         cos(theta)*sin(psi) + cos(psi)*sin(phi)*sin(theta),  cos(phi)*cos(psi), sin(psi)*sin(theta) - cos(psi)*cos(theta)*sin(phi);
                                       -cos(phi)*sin(theta),           sin(phi),                                cos(phi)*cos(theta)];

    C   = [eye(3)    -A*AntiSym(pole.ro)];
    Qd  = -A*AntiSym(w)*AntiSym(w)*pole.ro;

    Qv  = [zeros(3,1);-AntiSym(w)*pole.J*w];
    Qe  = [0;
           0;
           -9.8*pole.m;
           0;
           0;
           0]...
           +Ctrl...
           +[0;
             0;
             0;
             -pole.C*w];

    M_L = [MB.M C';
           C    zeros(3)];
    M_R = [Qe+Qv;
           Qd];
    V   = M_L^(-1)*M_R;
    dv  = V(1:3);
    dw  = V(4:6);

    dState(1:3,1)   = v;
    dState(4:6,1)   = dEuler;
    dState(7:9,1)   = dv;
    dState(10:12,1) = dw;

end
%%
function y = AntiSym(u)
    y = [    0 -u(3)  u(2);
          u(3)     0 -u(1);
         -u(2)  u(1)    0];
end
%%
function y = runge_kutta4(ufunc,Xin,u,h)
    k1 = ufunc(Xin,u);
    k2 = ufunc(Xin+h/2*k1,u);
    k3 = ufunc(Xin+h/2*k2,u);
    k4 = ufunc(Xin+h*k3,u);
    y  = Xin+h/6*(k1+2*k2+2*k3+k4);
end
%%
function Animation(State,gain)
    global pole
    x      = State(1,:);
    y      = State(2,:);
    z      = State(3,:);
    psi_   = State(4,:);
    phi_   = State(5,:);
    theta_ = State(6,:);
    N = floor(length(State)/gain);
    Tx = zeros(1,N);
    Ty = zeros(1,N);
    Tz = zeros(1,N);

    fig1 = figure('NumberTitle','off','Name','MultiPend','Color','w');
    hold on;
    grid on;
    box  on;
    axis equal;
    xlabel('X' );
    ylabel('Y' );
    zlabel('Z' );
    set(gca, 'gridlinestyle',':', 'gridalpha',0.5,'FontSize',10,'TickLabelInterpreter', 'latex');
    set(get(gca,'XLabel'),'FontSize',10);
    set(get(gca,'YLabel'),'FontSize',10);
    set(get(gca,'ZLabel'),'FontSize',10);
    view(15,15);
    axis([-1 1 -1 1 -1.2 0.2]);
    patch([1 -1 -1 1],[1 1 -1 -1],[0 0 0 0],'g','FaceAlpha',.7);

    for index = 1:N
        i = gain*index;
        title({['Spherical Hinge'],['t=',sprintf('%f',i*0.01),'s']});
        psi   = psi_(i);
        theta = theta_(i);
        phi   = phi_(i);
        A = [cos(psi)*cos(theta) - sin(phi)*sin(psi)*sin(theta), -cos(phi)*sin(psi), cos(psi)*sin(theta) + cos(theta)*sin(phi)*sin(psi);
             cos(theta)*sin(psi) + cos(psi)*sin(phi)*sin(theta),  cos(phi)*cos(psi), sin(psi)*sin(theta) - cos(psi)*cos(theta)*sin(phi);
                                           -cos(phi)*sin(theta),           sin(phi),                                cos(phi)*cos(theta)];
        T = [x(i);y(i);z(i)]*ones(1,2);
        v = A*pole.v+T;
        L = plot3(v(1,:),v(2,:),v(3,:),'r','LineWidth',2);
        O = plot3(v(1,2),v(2,2),v(3,2),'ko','LineWidth',2);
        Tx(index) = v(1,1);
        Ty(index) = v(2,1);
        Tz(index) = v(3,1);
        if index>50
            T = plot3(Tx(index-50:index),Ty(index-50:index),Tz(index-50:index),'b','LineWidth',1);
        else
            T = plot3(Tx(1:index),Ty(1:index),Tz(1:index),'b','LineWidth',1);
        end
        pause(.01);
        if index ~= N
            delete(L);
            delete(O);
            delete(T);
        end
    end
end