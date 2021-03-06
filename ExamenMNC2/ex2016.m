close all;
clear all;
clc

V= @(x,y)(x.^2 + y - 11).^2 + (x + y.^2 - 7).^2;

[X,Y] = meshgrid(-5:0.1:5,-5:0.1:5);
Z = V(X, Y);
figure
surf(X,Y,Z);xlabel('x');ylabel('y');zlabel('V(x,y)');title('V(x,y)');hold on;
colormap(hsv)
colorbar

[m, n] = size(X);
solutions = [];
solutions2 = [];
for ii = 1:1:m
    for jj = 1:1:n
        
        initial = [X(ii,jj); Y(ii,jj)];
        [XK, conv, it] = newtonnConv(initial, 1e-12, 30, @funNewton);
        %[XK2, conv2, it2] = test(initial, 1e-8, 20, @funNewton);
        if conv == 1
            solutions = [solutions XK(:, end)];
        end
        %         if conv2 == 1
        %             solutions2 = [solutions2 XK2(:, end)];
        %             disp('trobada2');
        %             XK2(:, end)
        %         end
    end
end

uniqueSolut = uniqueSol(solutions); 
% uniquetol(solutions',10^-6,'ByRows',true)';



for n=1:length(uniqueSolut(1,:))
    potential=V(uniqueSolut(1,n),uniqueSolut(2,n));
    plot3(uniqueSolut(1,n),uniqueSolut(2,n),potential,'.c','MarkerSize',30);
end

for iii = 1:1:length(uniqueSolut)
    uniqueSolut(:,iii)
    H = hessV(uniqueSolut(:,iii));
    det(H)
    H(1,1)
    H(2,2)
end
%%

% TRAMPA PER DIBUIXAR LES LINIES
figure
fimplicit(@(x,y) (x.^2 + y - 11).^2 + (x + y.^2 - 7).^2 - 100)
hold on

impliticitFun = @(x) ((x(1).^2 + x(2) - 11).^2 + (x(1) + x(2).^2 - 7).^2 - 100);
 % FUNCIO ON HE POSAT EL PARAMETRE MANUALMENT (li poso 0.1)
newtonY01 = @(y) ((-0.1.^2 + y - 11).^2 + (-0.1 + y.^2 - 7).^2 - 100);

initial0 = [1];
[y00, conv00, it] = newtonnConv(initial0, 1e-12, 30, newtonY01);
y0 = [-0.1; y00(end)];

newtonY02 = @(y) ((-0.12.^2 + y - 11).^2 + (-0.12 + y.^2 - 7).^2 - 100);% Canviem parametre!!
[y00, conv00, it] = newtonnConv(initial0, 1e-12, 30, newtonY02);
y1 = [-0.12; y00(end)];
%initial0 = [2.6,2.5]
%[y11, conv11, it] = newtonnConv(initial0, 1e-12, 30, impliticitFun);

s = 1;
maxIt = 1000;
iterations = 0;
Y = [];



while s > 0 && iterations <= maxIt
    [y, iconv] = continuationStep(impliticitFun, y0, y1, s, 1e-6, 100);

    if iconv == 1% No hem aconseguit solució i ajustem s
        s = s - 0.1; % Si la s arriba a 0 desistirem i no buscarem mes solucions
    else
        y0 = y1;
        y1 = y;
        Y = [Y, y]; %solucions
    end
    plot(y(end), max(y(1:end-1)), 'o');
    hold on;
    iterations = iterations + 1;
end

%%
figure
h = 0.01;
vn0 = [0;3 ; 0 ; 2.1 ;0];
finalTime = 5;
   %   Tfinal sera vn(0) + h*(desiredPoints-1)
desiredPoints = finalTime/h + 1;
V = RK4wTime(vn0, h, @rkFun, desiredPoints);
plot(V(1,:), V(2,:));

xt = V(2,1:end-1)';
N = length(xt);
%xt = sin(1:N);
fourierSpace = DFT(xt);
k = -N/2:(N/2-1);
wk = 2*pi/(N*h).*k; %spectrum of frequencies
semilogy(wk, abs(fourierSpace));
grid on;

function gradient = funNewton(coor)
x = coor(1);
y = coor(2);
dx = 4*(x.^2+y-11).*x + 2*(x+y^2 -7);
dy = 2*(x.^2+y-11) + 4*(x+y^2 -7).*y;
gradient = [dx; dy];
end

function [H]=hessV(X)
x=X(1,1);
y=X(2,1);

h1=[ 12*x^2 + 4*y - 42,         4*x + 4*y];
h2=[         4*x + 4*y, 12*y^2 + 4*x - 26];
H=[h1;h2];
end