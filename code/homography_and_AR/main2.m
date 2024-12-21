close all
%% Exercice 2
mire22 = imread('Data/mire22.pgm');
%% Calcul de pose et réalité augmentée à partir d'homographies.


%% 2.1 Calcul de la pose à partir d'un objet plan

K=[2307, 0, 444.8; 0, 2307, 289.9; 0, 0, 1]; %paramètres de la caméra

imshow(mire22);
%[x,y] = getpts;
x= [174.0596, 74.9771, 76.2982, 174.7202]';
y= [147.3073, 149.9495, 270.8303, 263.5642]';

%map_points = [0, 0; -112.5, 0; -112.5, -112.5; 0, -112.5]; %les points correspondants aux points x,y cliqués pour getpts, dans l'ordre. Le point (0,0) correspond au point en haut à droite de du plan de gauche (celui qui contient dans l'énoncé le carré vert; comme demandé par l'énoncé j'ai cliqué les points du carré vert)).
map_points= [112.5, 0; 0, 0; 0, -112.5; 112.5, -112.5]; %2e repere, le même que l'énoncé mais DIRECT (voir cahier-CR) - comme ça il y a moins de chances de se mélanger les pinceaux.

%construction de H à partir de [x,y] et de map_points:
x2 = [x, y, ones(4,1)]; %le ones(7,1) pour le passage en coordonnées homogènes.
x1 = [map_points, ones(4,1)]; %on échange x1 et x2 par rapport à l'exercice précédent car on veut H qui donne la transformation de "world view" à "viewed view", ce qui d'après la description de homography2d correspond à ce chgt.
H = homography2d(x1', x2');


%on applique maintenant homog2pose aux paramètres K et H:
[R,T] = homog2pose(H,K);

%on reprend les coordonnées du carré vert dans la plan monde (données par map_points), on calcule ses coordonnées dans le plan image et on
%affiche le carré vert sur l'image:
point1 = [30,0,0];
point2 = [0,0,0];
point3 = [0,-30,0];
point4 = [30,-30,0];
%points bis: les mêmes, mais avec z non nul
point1bis = [30,0,30];
point2bis = [0,0,30];
point3bis = [0,-30,30];
point4bis = [30,-30,30];
Xwc = [point1;point2;point3;point4;point1bis;point2bis;point3bis;point4bis];

%points_Xvc = zeros(3,4); %4 points 3D (coordonnées homogènes, ne pas oublier de "normaliser")
% for i=1:4
%     points_Xvc(:,i) = K * (R * Xwc(i,:)' + T);
%     points_Xvc(:,i) = points_Xvc(:,i) ./ points_Xvc(3,i);
% end
points_Xvc = K * (R * Xwc' + T); %c'est mieux sans boucle for... % il y a le K car on PROJETTE dans l'IMAGE !! cf échanges par mail
points_Xvc = points_Xvc ./ points_Xvc(3,:);

hold on
plot([points_Xvc(1,1:4), points_Xvc(1,1)], [points_Xvc(2,1:4), points_Xvc(2,1)], 'Color','red'); %on rajoute les points pour que ça boucle
plot([points_Xvc(1,5:8), points_Xvc(1,5)], [points_Xvc(2,5:8), points_Xvc(2,5)], 'Color','red'); %deuxième face
%tracé des aretes entre les deux faces
plot([points_Xvc(1,1), points_Xvc(1,5)], [points_Xvc(2,1), points_Xvc(2,5)], 'Color','red'); 
plot([points_Xvc(1,2), points_Xvc(1,6)], [points_Xvc(2,2), points_Xvc(2,6)], 'Color','red'); 
plot([points_Xvc(1,3), points_Xvc(1,7)], [points_Xvc(2,3), points_Xvc(2,7)], 'Color','red'); 
plot([points_Xvc(1,4), points_Xvc(1,8)], [points_Xvc(2,4), points_Xvc(2,8)], 'Color','red'); 
hold off
%je ne sais pas ce que signifie "dessiner en filaire", je suppose que ça
%correspond à ce que j'affiche (?).



%% 2.2 Calcul de l'angle entre deux surfaces à partir d'une image

%%côté vert
x_vert= [174.0596, 74.9771, 76.2982, 174.7202]';
y_vert= [147.3073, 149.9495, 270.8303, 263.5642]';
map_points_vert = [112.5, 0; 0, 0; 0, -112.5; 112.5, -112.5]; %on prend le même repère que l'énoncé (en faisant attention à ce qu'il soit direct), avec le (0,0) situé à l'endroit où le repère est tracé sur l'image de l'énoncé.

%construction de H à partir de [x,y] et de map_points:
x2_vert = [x_vert, y_vert, ones(4,1)]; %le ones(7,1) pour le passage en coordonnées homogènes.
x1_vert = [map_points_vert, ones(4,1)]; %on échange x1 et x2 par rapport à l'exercice précédent car on veut H qui donne la transformation de "world view" à "viewed view", ce qui d'après la description de homography2d correspond à ce chgt.
H_vert = homography2d(x1_vert', x2_vert');
%on applique maintenant homog2pose aux paramètres K et H:
[R_vert,T_vert] = homog2pose(H_vert,K);

%calcul des points de la normale verte dans le repère du carré vert
z_vert_world = [0,0,100]; %point de coordonnée en z non nulle
z_vert_viewed = K * (R_vert * z_vert_world' + T_vert);
z_vert_viewed = z_vert_viewed ./ z_vert_viewed(3);

O=[0,0,0];
O_vert_viewed = K * (R_vert * O' + T_vert);
O_vert_viewed = O_vert_viewed ./ O_vert_viewed(3);

normale_vert = [74.9771, z_vert_viewed(1); 149.9495, z_vert_viewed(2)];

%tracé de la normale verte
hold on
plot(normale_vert(1,:), normale_vert(2,:), Color='green', LineWidth=2);
hold off

%%côté rouge
x_rouge = [436.9587, 339.1972, 339.1972, 436.2982]';
y_rouge = [156.5550, 151.2706, 268.8486, 277.4358]';
map_points_rouge = [112.5, 0; 0, 0; 0, -112.5; 112.5, -112.5]; % encore une fois on prend le même repère que l'énoncé (en faisant attention à ce qu'il soit direct);

%construction de H à partir de [x,y] et de map_points:
x2_rouge = [x_rouge, y_rouge, ones(4,1)]; %le ones(7,1) pour le passage en coordonnées homogènes.
x1_rouge = [map_points_rouge, ones(4,1)]; %on échange x1 et x2 par rapport à l'exercice précédent car on veut H qui donne la transformation de "world view" à "viewed view", ce qui d'après la description de homography2d correspond à ce chgt.
H_rouge = homography2d(x1_rouge', x2_rouge');
%on applique maintenant homog2pose aux paramètres K et H:
[R_rouge,T_rouge] = homog2pose(H_rouge,K);

%calcul de la normale rouge
z_rouge_world = [0,0,-100]; %point de coordonnée en z non nulle
z_rouge_viewed = K * (R_rouge * z_rouge_world' + T_rouge); % il y a le K car on PROJETTE dans l'IMAGE !! cf échanges par mail
z_rouge_viewed = z_rouge_viewed ./ z_rouge_viewed(3);

O=[0,0,0];
O_rouge_viewed = K * (R_rouge * O' + T_rouge); %juste T_rouge en réalité
O_rouge_viewed = O_rouge_viewed ./ O_rouge_viewed(3);

normale_rouge = [339.1972, z_rouge_viewed(1); 151.2706, z_rouge_viewed(2)];

%tracé de la normale rouge
hold on
plot(normale_rouge(1,:), normale_rouge(2,:), Color='red', LineWidth=2); %339.8578, 151.9312
hold off




%%calcul de l'angle: produit scalaire

%calcul des points de la normale verte dans le repère du carré vert
z_vert_world = [0,0,100]; %point de coordonnée en z non nulle
z_vert_viewed = R_vert * z_vert_world';
z_vert_viewed = z_vert_viewed / norm(z_vert_viewed); %normalise

%calcul de la normale rouge
z_rouge_world = [0,0,100]; %point de coordonnée en z non nulle
z_rouge_viewed = R_rouge * z_rouge_world';
z_rouge_viewed = z_rouge_viewed / norm(z_rouge_viewed); %normalise

angle = acos(dot(z_vert_viewed(), z_rouge_viewed())) * (360/(2*pi)); %conversion en degrés
angle1 = acos(dot(z_vert_viewed(1:2), z_rouge_viewed(1:2))) * (360/(2*pi)); %conversion en degrés
angle2 = acos(dot(z_vert_viewed(2:3), z_rouge_viewed(2:3))) * (360/(2*pi)); %conversion en degrés
angle3 = acos(dot([z_vert_viewed(1), z_vert_viewed(2)], [z_rouge_viewed(1), z_rouge_viewed(2)])) * (360/(2*pi)); %conversion en degrés

disp("Valeur de l'angle calculée par produit scalaire:");
disp(180-angle); %on prend le complementaire car on veut le "grand" angle.
% disp(angle1);
% disp(angle2);
% disp(angle3);






%% vestiges de quelques heures de galère:

% %passage de la normale verte dans le système de coordonnées rouge:
% %disp(inv(H_vert) * [normale_vert; ones(1,2)])
% %disp([normale_vert', ones(2,1)]')
% normale_vert = H_rouge * inv(H_vert) * [normale_vert', ones(2,1)]'; %[0,0; 0,0; 0,1] ?
% normale_vert = normale_vert ./ normale_vert(3,:);
% 
% normale_vert = [normale_vert(1,1) - normale_vert(2,1); normale_vert(1,2) - normale_vert(2,2)]; %coordonnées du vecteur correspondant
% normale_vert = normale_vert ./ norm(normale_vert); %normalisation pour récupérer l'angle par produit scalaire ensuite
% %disp(normale_vert)
% normale_rouge = [normale_rouge(1,1) - normale_rouge(1,2); normale_rouge(2,1) - normale_rouge(2,2)]; %idem avec rouge
% normale_rouge = normale_rouge ./ norm(normale_rouge); %normalisation pour récupérer l'angle
% 
% %disp(normale_rouge)
% 
% angle = acos(normale_vert' * normale_rouge) * (360/(2*pi)); %conversion en degrés
% angle = acos(dot(normale_vert, normale_rouge)) * (360/(2*pi)); %conversion en degrés
% %angle = atan2(norm(cross(normale_vert,normale_rouge)), dot(normale_vert,normale_rouge));
% 
% disp("Valeur de l'angle calculée par produit scalaire:");
% disp(angle);

%test avec H - pas très fructueux. (ex-ligne 121)
% z_rouge_viewed = H_rouge * z_rouge_world';
% z_rouge_viewed = z_rouge_viewed ./ z_rouge_viewed(3);
% O_rouge_viewed = H_rouge*O';
% O_rouge_viewed = O_rouge_viewed %./ O_rouge_viewed(3);
% hold on
% plot([O_rouge_viewed(1), z_rouge_viewed(1)], [O_rouge_viewed(2), z_rouge_viewed(2)], Color='red', LineWidth=2);
% hold off

