close all;

[I1, map] = imread('DataTPsterero/rdimage.000.ppm');
I1 = rgb2gray(I1);
I2 = imread('DataTPsterero/rdimage.001.ppm');
I2 = rgb2gray(I2);

%%copier-coller de la doc https://fr.mathworks.com/help/matlab/ref/rgb2gray.html
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend("matched points 1","matched points 2");
%%fin copier-coller de la doc https://fr.mathworks.com/help/matlab/ref/rgb2gray.html

% Les correspondances ne sont pas toutes correctes. ex sol vs coupole
% (grand droite en diagonale). POURQUOI, par contre ? Je ne saurais pas
% expliquer.

%% 2 Reconstruction d'un nuage de points par triangulation

%q1
calibration = load('DataTPsterero/calib.mat');
%disp(calibration);

%q2 %utilisation de la contrainte épipolaire pour éliminer certaines
%correspondances erronées.

%epipolarLine: ligne épipolaire associée à un point.
%pointLineDistance (dans l'archive): mesure la distance d'un pt à une
%droite.

%pour chaque point:
index = []; %va contenir les index ne respectant pas distance <=2
epiLines = epipolarLine(calibration.F, matchedPoints1.Location); %Compute the epipolar lines in the first image. cf. doc. % Il faut que ce soit les points de l'iamge 1 pour avoir la ligne épipolaire dans l'image 2 !!
n = length(matchedPoints2.Location); %nb de points mis en correspondance
for i=1:n
    match = pointLineDistance(epiLines(i,:), matchedPoints2(i).Location); %point = y
    if match > 2 %si distance >2, c'est ciao
        index = [index i]; %ajout de i à l'index
        % on ne peut pas reti
    end
end
matchedPoints1(index) = [];
matchedPoints2(index) = [];


figure('Name', 'Mise en correspondance AVEC CONTRAINTE épipolaire.'); showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend("matched points 1","matched points 2");

%il en reste un qui est mauvais, mais qui par hasard est sur une ligne
%épipolaire!...

%q3
%fonction triangulate

worldPoints = triangulate(matchedPoints1,matchedPoints2, calibration.stereoParams);
figure('Name', 'Reconstruction de la cathédrale à partir des Matched Points.'); 
plot3(worldPoints(:,1), worldPoints(:,2), worldPoints(:,3), '*');
%il faut mettre '*' ou '+' ou autre pour ne pas que les points soient
%reliés!!


% Le résultat est assez satisfaisant mais on aimerait un peu plus de
% points.
% La cathédrale est mieux reconstruite que la statue...


%% Exercice 3 -  Reconstruction dense.

calibrationRed = load('DataTPsterero/calibRed.mat');


%[I1_valid,I2_valid, reprojectionMatrix] = rectifyStereoImages(imresize(I1,.25),imresize(I2,.25),calibrationRed.stereoParams,OutputView='valid');
[I1Red,I2Red, reprojectionMatrix] = rectifyStereoImages(imresize(I1,.25),imresize(I2,.25),calibrationRed.stereoParams,OutputView='valid'); % ATTENTION à bien resize ICI et pas après coup !! (voir pourquoi il faut faire ça...
%I1Red = imresize(I1_valid,.25);
%I2Red = imresize(I2_valid,.25);

%q1
%on utilise disparitySGM pour la disparité - correspond à celle présentée dans le cours.
% (plusieurs fonctions disparity* existent)
%il faut que ce soit parallèle => images rectifiées pour calculer disparité!

DisparityRange= [0, 64];
disparityMap = disparitySGM(I1Red,I2Red, "DisparityRange",DisparityRange);
%imtool(disparityMap); pour afficher les valeurs NaN.

figure('Name', 'Disparity map pour la cathédrale');
imshow(disparityMap, DisplayRange=DisparityRange)
hold on
title("Disparity Map")
colormap jet
colorbar
hold off

%il y a encore du rouge à des endroits un peu inattendus, mais ça va

%%%%%%% q3
%imtool(disparityMap); %la documentation recommande plutôt imageViewer(disparityMap) que imtool, mais ici imtool marche mieux.

%q4 reconstruction de la scène avec pcshow

xyzPoints = reconstructScene(disparityMap,calibrationRed.stereoParams);
figure('Name', 'Reconstruction dense de la cathédrale');
%plot3(xyzPoints(:,:,1), xyzPoints(:,:,2), xyzPoints(:,:,3), '*');
%imshow(xyzPoints);
xlimits= [0, 10];
ylimits=[0, 10];
zlimits= [0, 10];

%player = pcplayer(xlimits,ylimits,zlimits);
I1_couleur = imread('DataTPsterero/rdimage.000.ppm');
I1_couleur = imresize(I1_couleur,[445 686]);  %[445 686]
%view(player, xyzPoints)%, I1_couleur);
%scatter3(xyzPoints(:,:,1), xyzPoints(:,:,2), xyzPoints(:,:,3));

pcshow(xyzPoints, I1_couleur)




%%%%% q4 - en se basant sur la documentation pour reconstructScene
I1_couleur=imresize(imread('DataTPsterero/rdimage.000.ppm'),.25);
I2_couleur=imresize(imread('DataTPsterero/rdimage.001.ppm'),.25);
[J1, J2, reprojectionMatrix] = rectifyStereoImages(I1_couleur,I2_couleur,calibrationRed.stereoParams,OutputView='valid'); % ATTENTION à bien resize ICI et pas après coup !! (voir pourquoi il faut faire ça...
xyzPoints = reconstructScene(disparityMap,calibrationRed.stereoParams);

figure('Name', "Reconstruction avec l'aide de la documentation Matlab")
Z = xyzPoints(:,:,3);
mask = repmat(Z > 2 & Z < 25,[1,1,3]);
J1(~mask) = 0;
imshow(J1,'InitialMagnification',50);

%la c'est affiché avec la couleur de la disparité; il faut attribuer la
%couleur des points d'origine !