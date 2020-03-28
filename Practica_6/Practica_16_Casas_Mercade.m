clear all
close all
clc

addpath('../Practica_5')

%% Section A)

determinants = [];
alphas = 0:0.01:3;

alphaZeros = [];

for alpha=alphas
    
    f=@(phi)([tan(phi(1))-alpha*(2*sin(phi(1)) +sin(phi(2))) ; tan(phi(2)) - 2*alpha*(sin(phi(1)) + sin(phi(2)))]);
    
    phi=[0,0];

    j = jaco(f,phi);
    
    determinants = [determinants, det(j)];
    
    if abs(det(j)) < 0.01
    alphaZeros = [alphaZeros, alpha];
    end
    
end

plot(alphas, determinants)

% The implicit function theorem (imft) states that as long as the jacobian
% is non-singular (det non zero) the system will define phi(1) and phi(2)
% as a unique functions of aplha, so we'll have a unique map between
% the solutions and alphas
%When the determinant is zero the uniqueness will be lost locally nearby
%the aplha points which make the determinant 0 and new branches of
%solution may emerge. This points are
alphaZeros
%


%% Section B)
%addpath('..Practica_5')
randomSeed = [pi/4, 0];
alphas = 0:0.1:2;
% Dominis dels angles
dom1 = [0, pi/2];
dom2 = [-pi/2, pi/2];

solucions = [];
for alpha = alphas
    f=@(phi)([(tan(phi(1))-alpha*(2*sin(phi(1)) +sin(phi(2)))) , (tan(phi(2)) - 2*alpha*(sin(phi(1)) + sin(phi(2))))]);
    [XK, resd, it] = newtonn(randomSeed', 1e-8, 100, f);
    
    if XK(1, end) > dom1(1) && XK(1,end) < dom1(2) && XK(2,end) > dom2(1) && XK(2, end) < dom2(2)
        plot(alpha,XK(:,end),'-*')
        hold on
        solucions = [solucions, XK(:,end)];
    else 
        solucions = [solucions, [0;0]];
        plot(alpha,XK(:,end),'-o')
        hold on
    end

end

plot(alphas, solucions);
