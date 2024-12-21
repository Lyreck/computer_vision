clear all
close all

%% Section 1 (fonctions définies dans fichiers annexes)

%%1.2
I=imread("varan.jpg"); %attention au directory
A=makeRigidTransform(15,(size(I,1:2)-1)/2, [0 0]);
%print(A);
J=imwarp(I,A);
%imshow(I);
%figure, imshow(J);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2 - Recalage rigide basé points

% Récupération des données
I = imread('varan.jpg');
J = imread('varan_t.jpg');
P = load('varan.pts');
Q = load('varan_t.pts');

% Code de l'énoncé
figure('Name', 'Varan avant transformation + points')
imshow(I);
hold on
plot(P(:,1),P(:,2),'+y');
hold off
figure('Name', 'Varan APRES transformation + points')
imshow(J);
hold on
plot(Q(:,1),Q(:,2),'+y');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% q2: voir fonction find_trans_Procuste dans fichier annexe

A=find_trans_Procuste(P, Q); %entrée = deux vecteurs de points 2xN

%% Comparaison entre la transformation trouvée et l'image que l'on souhaite recaler
figure('Name', 'Varan recalé avec Procuste + points recalés')
varan = imread("varan.jpg"); %image originale, qu'on veut faire tourner
[J,RJ]=transformImage(varan,A,-1);
Qfound=transformPointsForward(A,P);
imshow(J);
hold on
plot(Qfound(:,1),Qfound(:,2),'+y');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% q3 voir fonction erreur_trans dans fichier annexe

E=erreur_trans(P',Q',A);
disp('Erreur E, X, Y et Z:');
disp(E);

X=transformPointsForward(A,[0 0]);
Y=transformPointsForward(A,[1 0]);
Z=transformPointsForward(A,[0 1]);
disp(X);
disp(Y);
disp(Z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 3 - Recalage rigide par ICP

%voir fichier recaleICP contenant la fonction du même nom

%test de la fonction avec le code proposé par l'énoncé:
a=[0:0.01:2*pi];
P=[cos(a);sin(a)];
Q=P+repmat([0.2;0],[1,size(P,2)]);

%situation initiale
figure('Name', 'Figures avant recalage ICP')
plot(P(1,:),P(2,:),"r-",Q(1,:),Q(2,:),"b-")
text(0.85,0,"P \rightarrow")
text(1.2,0,"\leftarrow Q")

%%exemple de l'énoncé: recalage de deux cercles.
%disp("Exemple de l'énoncé: recalage de deux cercles.")
A = recaleICP(P',Q',0.1, 'Recalage cercles'); %avec une erreur <0.1, les deux cerclces se superposent sur la fenêtre de plot().
Pf= transformPointsForward(A,P')'; %points P recalés sur Q de manière itérée - Attention il faut faire P' car Matlab prend les points comme des vecteurs "ligne"... (càd nx2)

%situation finale
figure('Name', 'Figures APRES recalage ICP (erreur 0.1)');
plot(Pf(1,:),Pf(2,:),"r-",Q(1,:),Q(2,:),"b-");
legend('P_{found}', 'Q');

E_cercles=erreur_trans(P,Q,A);
disp('Erreur pour les cercles (exemple du TD):');
disp(E_cercles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test d'une autre figure: "triangle aplati".

% figure('Name', 'Triangle "aplati sur un sommet" pour tester les limites de recaleICP')
% X_coordinates = [0 1 1.5 2.5 2.5];
% Y_coordinates = [0 1 1 0 0];
% P_triangle = zeros(5,2);
% P_triangle(:,1)=X_coordinates;
% P_triangle(:,2)=Y_coordinates;
% plot(X_coordinates,Y_coordinates)
% 
% 
% angle=90;
% rotation_triangle = rigidtform2d(angle, [1 -1]);
% Q_triangle=transformPointsForward(rotation_triangle,P_triangle);
%figure('Name', 'Triangle "aplati sur un sommet", rotation de 90 degrés')
%hold on
%plot(Q_triangle(:,1), Q_triangle(:,2))
%hold off

%recalage ave la méthode ICP
%A_triangle = recaleICP(P_triangle,Q_triangle,0.5); %je garde une erreur de 0.5 pour qu'on puisse encore distinguer les deux figures, mais on peut aller encore plus loin.
%Pf_triangle= transformPointsForward(A_triangle,P_triangle)'; %points P recalés sur Q de manière itérée - Attention il faut faire P' car Matlab prend les points comme des vecteurs "ligne"... (càd nx2)
%%erreur: "Invalid rotation matrix" !!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%autre figure: sablier (même idée que le triangle et fournit un
%disp("Figure sablier (rotation de 20 degrés, puis 180 degrés):")
%%contre-exemple à la méthode)

% Coordonnées des sommets du triangle équilatéral avec un segment plat
% La valeur 1 est la longueur du côté du triangle
% A, B et C sont les sommets du triangle

X1 = linspace(0,1,200);
Y1 = linspace(0,0,200);

X2 = linspace(1,0.25,200);
Y2 = linspace(0,sqrt(3)/4,200);

X3 = linspace(0.25,0.75,200);
Y3 = linspace(sqrt(3)/4,sqrt(3)/4,200);

X4 = linspace(0.75,0,200);
Y4 = linspace(sqrt(3)/4,0,200);

P_sablier=[[X1 X2 X3 X4]; [Y1 Y2 Y3 Y4]];
% Affichage de la figure "sablier"
figure('Name', 'Sablier: dans la même idée que triangle aplati');
plot(P_sablier(1,:), P_sablier(2,:), 'o-', 'LineWidth', 2);
axis equal;
grid on;
% ancienne verion (point par point)
% % Coordonnées du premier sommet (A)
% A = [0, 0];
% 
% % Coordonnées du deuxième sommet (B)
% B = [1, 0];
% 
% % Coordonnées du troisième sommet (C)
% C = [0.25, sqrt(3)/4; 0.75, sqrt(3)/4]; % Segment plat entre (0.25, sqrt(3)/4) et (0.75, sqrt(3)/4)
% 
% P_sablier = [A; B; C; A]';
% % Affichage des sommets
% figure('Name', 'Sablier: dans la même idée que triangle aplati');
% plot(P_sablier(1,:), P_sablier(2,:), 'o-', 'LineWidth', 2);
% axis equal;
% grid on;

%transformation (rotation) 1: "petit" angle, le recalageICP fonctionne bien
angle1=20;
rotation_sablier = rigidtform2d(angle1, [0 0]);
Q_sablier1=transformPointsForward(rotation_sablier,P_sablier');
figure('Name', 'Sablier "aplati sur un sommet", rotation de 20 degrés')
hold on
plot(Q_sablier1(:,1), Q_sablier1(:,2))
hold off

%relacage ICP
A_sablier1 = recaleICP(P_sablier',Q_sablier1,0.01, 'sablier 20 degrés'); %je garde une erreur de 0.01 pour qu'on puisse encore distinguer les deux figures, mais on peut aller encore plus loin. %PB D'OSCILLATION: RAJOUTER DES PONTS PAR LINSPACE ET TESTER AVEC DES PETITS ANGLES DE ROTAITON !
P_found_sablier1=transformPointsForward(A_sablier1,P_sablier')'; %points P recalés sur Q de manière itérée - Attention il faut faire P' car Matlab prend les points comme des vecteurs "ligne"... (càd nx2)
%%

%P_found doit correspondre au recalage de P sur Q.
figure('Name', "Recalage du sablier pour un angle de 20 degrés");
plot(P_found_sablier1(1,:), P_found_sablier1(2,:), 'r-', Q_sablier1(:,1), Q_sablier1(:,2), 'b-');
legend('P_{found}', 'Q');
xlabel('X');
ylabel('Y');
title('Courbes P_{found} et Q (sablier)');

E_sablier=erreur_trans(P_sablier,Q_sablier1',A_sablier1);
disp('Erreur pour les figures en sablier (rotation de 20 degrés):');
disp(E_sablier)

%%transformation 2: "grand" angle: on atteint maxiter=1000 recalages, et on
%atteint un minimum local qui ne correspond pas au recalage recherché
angle2=180;
rotation_sablier = rigidtform2d(angle2, [0 0]);
Q_sablier2=transformPointsForward(rotation_sablier,P_sablier');
figure('Name', 'Sablier "aplati sur un sommet", rotation de 180 degrés')
hold on
plot(Q_sablier2(:,1), Q_sablier2(:,2))
hold off

%relacage ICP
A_sablier = recaleICP(P_sablier',Q_sablier2,0.1,'sablier 180 degrés'); %je garde une erreur de 0.1 pour qu'on puisse encore distinguer les deux figures, mais on peut aller encore plus loin. %PB D'OSCILLATION: RAJOUTER DES PONTS PAR LINSPACE ET TESTER AVEC DES PETITS ANGLES DE ROTAITON !
P_found_sablier2=transformPointsForward(A_sablier,P_sablier')'; %points P recalés sur Q de manière itérée - Attention il faut faire P' car Matlab prend les points comme des vecteurs "ligne"... (càd nx2)
%%

%P_found doit correspondre au recalage de P sur Q.
figure('Name',"Recalage du sablier pour l'angle de 180 degrés.");
plot(P_found_sablier2(1,:), P_found_sablier2(2,:), 'r-', Q_sablier2(:,1), Q_sablier2(:,2), 'b-');
legend('P_{found}', 'Q');
xlabel('X');
ylabel('Y');
title('Courbes P_{found} et Q (sablier)');

E_sablier=erreur_trans(P_sablier,Q_sablier2',A_sablier);
disp('Erreur pour les figures en sablier (rotation de 180 degrés, erreur demandée 0.1):');
disp(E_sablier)

%% 
% % Essai avec un 8 (rotation et translation) %figure empruntée à un
% camarade -  le recalage fonction sans encombre. Décommenter les lignes
% 214 à 258 pour voir l'affichage.
% 
% % Paramétrisation
% t = linspace(0, 2*pi, 100); 
% x1 = cos(t); % Première partie de la courbe en 8
% y1 = sin(t);
% x2 = cos(t) + 2; % Deuxième partie de la courbe en 8
% y2 = sin(t);
% P_huit = [x1, x2; y1, y2]; % Formation du 8
% 
% % Rotation de 60 degrés
% theta = pi/3;
% R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
% 
% % Création de Q avec une translation de [-.5 .5] et la rotation ci-dessus
% Q_huit = R * P_huit + repmat([-.5; .5], 1, size(P_huit, 2));
% 
% % Tracé
% figure;
% plot(P_huit(1,:), P_huit(2,:), 'r-', Q_huit(1,:), Q_huit(2,:), 'b-');
% legend('P', 'Q');
% xlabel('X');
% ylabel('Y');
% title('Courbes P et Q');
% 
% % Résultats
% A_huit = recaleICP(P_huit',Q_huit',0.3);
% Rotation_huit = A_huit.Rotation;
% Translation_huit = A_huit.Translation;
% 
% 
% 
% P_found_huit=transformPointsForward(A_huit,P_huit')'; %P_found doit correspondre au recalage de P sur Q.
% figure;
% plot(P_found_huit(1,:), P_found_huit(2,:), 'r-', Q_huit(1,:), Q_huit(2,:), 'b-');
% legend('P_{found}', 'Q');
% xlabel('X');
% ylabel('Y');
% title('Courbes P_{found} et Q');
% 
% E_huit=erreur_trans(P_huit,Q_huit,A_huit);
% disp('Erreur pour les figures en huit:');
% disp(E_huit)
