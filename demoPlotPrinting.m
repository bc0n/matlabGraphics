%% Ben Conrad - Compare Tunings - Step Responses - 20151113
clc; close all; clear all; format compact;
    left = [1928           9         944         988];
    rght = [2889           9         944         988];
    rght2 = [968     9   944   988];
    maximized = [1921 1 1920 1004];
    % set(0,'DefaultFigurePosition',rght);
    % set(0,'DefaultAxesColor', .7*[1,1,1]);
    % set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on','DefaultAxesZGrid','on');

%% Generate data
x = linspace(0,1,1000);
a = 1*sin(x)+1*sin(2*x)+sin(10*x);
b = 1*sin(x)+1*sin(2.2*x)+.9*sin(10*x);
c = 1*sin(x)+1.2*sin(2*x)+sin(10*x)+rand(1,1000)/100;

%% Plot It
fs = 16; %fontsize in points
lwd = 2; %linewidth in ?

fig = figure('Name','Demo');
hold on;
ha = plot(x,a,'m-', 'linewidth',lwd);
hb = plot(x,b,'c:', 'linewidth',lwd);
hc = plot(x,c,'y--', 'linewidth',lwd);

ha.DisplayName = 'lineA';
hb.DisplayName = 'lineB';
hc.DisplayName = 'lineC';

set(fig, 'Position', [2043 600 400 400]); % get(gcf,'position')
set(gca,'FontSize',fs); %get(gca) to list all peoperties
set(gca,'Color',.7*[1,1,1]);

title('Low \alpha, Measured','FontSize',fs+1);
ylabel('\alpha [\circ]','FontSize',fs+1);
xlabel('Time [s]','FontSize',fs+1);
grid on; set(gca,'GridLineStyle','-.');

%% save 'em
%getFrame()
rect = get(fig,'Position');
ec = 0; %[px] crop from the left and right edges by
rect = [ec 1 rect(3)-ec rect(4)];
f = getframe(fig,rect); imwrite(f.cdata,'highAlpha_getFrame.png','png');

%print()
f = fig;
figpos=getpixelposition(fig);
resolution=get(0,'ScreenPixelsPerInch');
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]);
print(f,'highAlpha_print.png','-dpng','-r800','-opengl'); %-r800 specifies 800 dpi
print(f,'highAlpha_print.svg','-dsvg','-r800','-opengl'); 
saveas(f,'highAlpha_print.fig');



