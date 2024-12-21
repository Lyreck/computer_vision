%% Quelques affichages
close all
% I = imread('DataMatch/castle.018Red.jpg');
% tabx = [ 100 200 330 150 200 ];
% taby = [200 350 400 500 100];
% imshow(I);
% hold on
% %plot(tabx,taby, 'linestyle', 'none' ,'Marker', '+')
% plot(taby,tabx, LineWidth=4)%, 'LineWidth',1, 'Marker', '*') %attention à l'ordre - et on se rappelle que le 0,0 est en haut à gauche pour une image !
% hold off
% 
% figure('Name','test');
% plot(tabx,taby, 'LineWidth',1, 'Marker', '*');



%% Exercice 2 - Mise en correspondance par corrélation

%m1 = [108, 233]; %point considéré pour cet exercices (coordonnées exprimées dans la représentation matricielle de l'image)
m1 = [108, 245]; %test avec un autre point pour regarder si l'on a toujours des points dans le ciel pour w grand.

I1 = imread('DataMatch/castle.018Red.jpg');
I2 = imread('DataMatch/castle.010Red.jpg');

% figure('Name', 'Point à mettre en correspondance dans I1'); %affichage pour le compte-rendu
% imshow(I1);
% hold on 
% plot(m1(2),m1(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
% hold off

%q1
w=10; %fenêtre de demie-taille w.
template = I1(m1(1)-w:m1(1)+w, m1(2)-w:m1(2)+w);

c = normxcorr2(template,I2);
%surf(c);
%shading flat

[ypeak,xpeak] = find(c==max(c(:)));
xpeak=xpeak-w;
ypeak=ypeak-w; %heureusement que c'était précisé dans l'énoncé...

fenetre_trouvee =I2(xpeak-w:xpeak+w, ypeak-w:ypeak+w);

tabx=[xpeak-w, xpeak-w, xpeak+w, xpeak+w, xpeak-w];
taby=[ypeak+w, ypeak-w, ypeak-w, ypeak+w, ypeak+w];

figure('Name','Mise en correspondance dans I2');
imshow(I2);
%drawrectangle(gca,'Position',[xpeak,ypeak,w,w], ...
%    'FaceAlpha',0);
hold on
plot(tabx,taby, 'LineWidth',5 , 'Marker', 'square', MarkerEdgeColor='cyan', MarkerFaceColor='none', Color='white'); %attention à l'ordre - et on se rappelle que le 0,0 est en haut à gauche pour une image !
plot(xpeak,ypeak, 'o', Color='red'); %je ne comprends pas: je pensais que x et y étaient inversés !!peut être que le fait que c soit une matrice corrige le tir.
hold off


%q2
%N=1;
%w=10; %cette boucle ne amrche pas et affiche les carrés sur des figures
%bizarrement... dommage. J'ai fait bouger w "à la main", faute de mieux.
%for w=[3 5 15 25]
%    [points] = find_N_highest_corr(N, w, m1, I1, I2);
%    display_N_points(I2, points, w, N);
%end
m1 = [108, 240];
N=25;
w=25;
[points] = find_N_highest_corr(N, w, m1, I1, I2);
display_N_points(I2, points, w, N);