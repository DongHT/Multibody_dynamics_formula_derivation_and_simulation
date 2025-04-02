%--------------------------------------------------------------------------
% 文件名: Commutative law of rotation matrix.m
% 作者: -DandD-
% 日期: 2025-04-02
% 描述: 说明旋转矩阵通常不具备交换律
% 版本: 1.0
% 依赖项: 无
% 注意事项: 无
%--------------------------------------------------------------------------

close all;
clear;
clc;
%%
psi   = .1/180*pi; % Z yaw
theta = .2/180*pi; % Y pitch
phi   = .3/180*pi; % X roll
Rz = [cos(psi) -sin(psi) 0;
      sin(psi)  cos(psi) 0;
         0          0    1];
Ry = [ cos(theta) 0 sin(theta);
            0     1     0;
      -sin(theta) 0 cos(theta)];
Rx = [1    0         0;
      0 cos(phi) -sin(phi);
      0 sin(phi)  cos(phi)];
%%
Rzyx = Rz*Ry*Rx;
Rzxy = Rz*Rx*Ry;
Ryxz = Ry*Rx*Rz;
Ryzx = Ry*Rz*Rx;
Rxyz = Rx*Ry*Rz;
Rxzy = Rx*Rz*Ry;

fig = figure(1);
set(fig,'NumberTitle','off',...
        'Name','law of commutation',...
        'color','w',...
        'Units','Inches',...
        'Position',[1 1 1+8 1+5]);
for i = 1:9
    subplot(3,3,i);
    hold on;
    grid on;
    box  on;
    set(gca, 'gridlinestyle',':', 'gridalpha',0.5,'FontSize',10,'TickLabelInterpreter', 'latex');
    set(get(gca,'XLabel'),'FontSize',10);
    set(get(gca,'YLabel'),'FontSize',10);
    set(get(gca,'ZLabel'),'FontSize',10);
    xlim([1 6]);
    col = mod(i-1,3)+1;
    row = (i-col)/3+1;
    plot([Rzyx(row,col) Rzxy(row,col) Ryxz(row,col) Ryzx(row,col) Rxyz(row,col) Rxzy(row,col)],'r-o');
    title(['$$\rm{row:}\,$$',num2str(row),'$$\,\,\rm{column:}$$',num2str(col)], 'Interpreter','latex');
end

syms psi theta phi;
Rz = [cos(psi) -sin(psi) 0;
      sin(psi)  cos(psi) 0;
         0          0    1];
Ry = [ cos(theta) 0 sin(theta);
            0     1     0;
      -sin(theta) 0 cos(theta)];
Rx = [1    0         0;
      0 cos(phi) -sin(phi);
      0 sin(phi)  cos(phi)];
Rzyx = Rz*Ry*Rx;
Rzxy = Rz*Rx*Ry;
Ryxz = Ry*Rx*Rz;
Ryzx = Ry*Rz*Rx;
Rxyz = Rx*Ry*Rz;
Rxzy = Rx*Rz*Ry;

latex_Rzyx = latex(Rzyx);
latex_Rzxy = latex(Rzxy);
latex_Ryxz = latex(Ryxz);
latex_Ryzx = latex(Ryzx);
latex_Rxyz = latex(Rxyz);
latex_Rxzy = latex(Rxzy);
