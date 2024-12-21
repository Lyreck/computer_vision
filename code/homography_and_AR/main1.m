close all
%% Exercice 1

%% 1 - Mesurer des distances euclidiennes à partir d'une image: exemple des retransmissions sportives:

%attention, la fonction homographie prend des coordonnées homogènes (3
%coordonnées; u,v,1 dcp).

I1 = imread("Data/coup-franc.jpg");

imshow(I1);
%[x,y] = getpts;
x= [26.6493,   94.4701,  252.0821,  194.2910,  124.0821,  444.5597,  269.7537]';
y= [121.6343,  128.7985,   86.2910,   81.5149,  186.5896,   76.7388,   64.7985]';

map_points = [0, 0; 5.5, 0; 5.5, 18.3; 0, 18.3; 16.5, -11; 16.5, 29.3; 0, 29.3]; %les points correspondants aux points x,y cliqués pour getpts, dans l'ordre. Le point (0,0) correspond au point à l'extrémité droite des cages (point de vue du gardien)


%% q3
%construction de H à partir de [x,y] et de map_points:
x1 = [x, y, ones(7,1)]; %le ones(7,1) pour le passage en coordonnées homogènes.
x2 = [map_points, ones(7,1)];
H = homography2d(x1', x2');

%récupération des coordonnées du ballon
imshow(I1);
%[xballon,yballon]=getpts;
xballon = 520.0876;
yballon = 169.2835;

realBallon = H * [xballon; yballon; 1];
realBallon = realBallon./realBallon(3); %coordonnées dans mon repère (normalisé pour avoir la coordonnée homogène=1)

%récupération des coordonnées de la ligne de but (même process que pour le ballon):
imshow(I1);
%[xbut,ybut] = getpts;
xbut=108.3209;
ybut=101.0970;
realBut = H * [xbut; ybut; 1];
realBut = realBut./realBut(3);

%calcul de la distance entre la ligne de but et le ballon.
distance_ballon_but = abs(realBallon(1) - realBut(1));
disp('Distance du Ballon à la ligne de but (mètres):');
disp(distance_ballon_but); %donne 33.2, en réalité c'est plutôt 32 mais j'apaplique l'algo "bêtement" sans ajouter explicitement que la ligne de cage est à x = 0 (j'ai pointé à la main). Le fait de refaire la procédure pour la ligne de but introduit de l'erreur supplémentaire.

%tracé d'une ligne entre le ballon et la cage, affichage de la distance:
text_str = cell(1,1);
for ii = 1:1
   text_str{ii} = ['Distance du ballon à la ligne de but ' num2str(distance_ballon_but)];
end
position = [240, 30];%[314, 135]; 
box_color = {"red"};%,"green","yellow"};
I1_modified = insertText(I1,position,text_str,FontSize=18,TextBoxColor=box_color, ...
    BoxOpacity=0.4,TextColor="white");

figure('Name','Distance ballon-ligne de but');
imshow(I1_modified);
hold on
plot([xballon, xbut], [yballon, ybut], LineWidth=3, Color='magenta');
hold off

%% q4: 
% "Selon les règles du football, aucun joueur ne doit se trouver dans le
% cercle de rayon 9 m centré sur le ballon pour un coup franc. Dessiner cette zone sur l'image vidéo."

% valeurs dans le "plan cadastral"
R=9;%metres
nbPoints=1000;%nb de points pour tracer le cercle
theta = linspace(0,2*pi, nbPoints);
xCercle = R * cos(theta) + realBallon(1);
yCercle = R * sin(theta) + realBallon(2);


% figure('Name', 'test');
% plot(xCercle, yCercle);

%projection sur l'image:
Hinv = homography2d(x2', x1'); % transformation dans l'autre sens: passer du plan cadastral à l'image.
cercleImage = Hinv * [xCercle; yCercle; ones(1,nbPoints)];
cercleImage = cercleImage./cercleImage(3,:);

hold on
plot(cercleImage(1,:), cercleImage(2,:), LineWidth=2, Color='red');
hold off

%%aussi à faire: "embellir" l'affichage....? Un autre jour peut-être !