close all;
clear all;

%
net = alexnet;
%net.Layers(1); %affichage des caractéristiques spécifiques à une couche
w=net.Layers(2).Weights; %stocker les poids de la 2e couche (i.e. de la premiere couche de convolution)

%
bulbul=imread('images/bulbul.jpg');
bulbul=imresize(bulbul,net.Layers(1).InputSize(1:2));
figure;
imshow(bulbul);
label_bulbul=classify(net,bulbul); %correctement reconnu

schipperke=imread('images/schipperke.jpg');
schipperke=imresize(schipperke,net.Layers(1).InputSize(1:2));
label_schipperke=classify(net,schipperke); %correctement reconnu

%
disp(size(w)); % 11 11 3 96

%
features_images = zeros(56,56,96);
R = bulbul(:,:,1);
G = bulbul(:,:,2);
B = bulbul(:,:,3);
for i=1:96
    convR = conv2(R, w(:,:,1,i), 'same');
    convG = conv2(G, w(:,:,2,i), 'same');
    convB = conv2(B, w(:,:,3,i), 'same');

    conv_no_stride = convR + convG + convB;
    conv_finale(:,:) = conv_no_stride(4:4:end, 4:4:end); %stride de 4- on démarre au 4e indice pour arriver au 224e, et ainsi avoir les convolutions "les plus centrées possibles (les plus proches d'un padding='same' que possible)
    features_images(:,:,i) = conv_finale;

    %implémentation du stride de 4 (pour obtenir une image plus petite).


    % %affichage de la feature (à commenter si l'on fait les 96 features)
    % figure;
    % imshow(conv_finale, [])

end

figure('Name', 'Features calculées avec conv2, padding = "same"');
imshow(imtile(features_images,"ThumbnailSize",[56 56]),[])

%à comparer avec:
a=activations(net,bulbul,net.Layers(2).Name); %activation: ReLu - les noirs (négatifs) sont mis à 0 !!
figure('Name', 'Features calculées grâce à la fonction "activations".');
imshow(imtile(a,"ThumbnailSize",[55 55]),[])

%pour aller plus loin: fonctions gradCam et deepDreamImage qui aident à
%l'analyse des features générées par le réseau.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% (à décommenter si besoin)
% %% Exercice 2: l'attrait des profondeurs. 
% 
% %récupération des données
% datadir=tempdir;
% downloadCIFARData(datadir);
% [XTrain,YTrain,XValidation,YValidation]=loadCIFARData(datadir);
% 
% %normalisation des images entre 0 et 1
% XTrain=single(XTrain)/255; %single = single precision (par opposition à "double"). Represents Floating-point numbers.
% XValidation=single(XValidation)/255;
% 
% %paramétrage de l'apprentissage
% miniBatchSize=64;
% learnRate=0.01;
% momentum=0.9; %?
% epochs=15;
% valFrequency=floor(size(XTrain,4)/miniBatchSize);
% %stockage de tous ces paramètres dans une variable de type
% %'trainingOptions':
% options=trainingOptions('sgdm', ... %sgdm pour stochastic gradient descent (je ne sais pas à quoi correspond le m?)
% 'InitialLearnRate',learnRate, ...
% 'Momentum',momentum,...
% 'MaxEpochs',epochs, ...
% 'MiniBatchSize',miniBatchSize, ...
% 'VerboseFrequency',valFrequency, ...
% 'Shuffle','every-epoch', ...
% 'Plots','training-progress', ... %permet de voir comment évolue la précision du réseau, et la fonction de coût
% 'Verbose',true, ...
% 'ValidationData',{XValidation,YValidation}, ...
% 'ValidationFrequency',valFrequency);size
% 
% %net = trainNetwork(XTrain, YTrain, layers, options); %on suppose le reseau
%de neurones "vierge" stocké dans la variable "layers". % Commande
%"template".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Design du réseau
%deepNetworkDesigner
%commande utile pour lancer le processus.

% net1 = trainNetwork(XTrain,YTrain,layers_1,options); %entraînement du premier réseau de neurones (layers_1) avec les options définies précédemment %26 minutes de training sur ma machine.
% save net1
% 
% net2 = trainNetwork(XTrain,YTrain,layers_2,options);
% save net2;
% 
% net3 = trainNetwork(XTrain,YTrain,layers_3,options);
% save net3;
% 
% %net4 = trainNetwork(XTrain,YTrain,layers_3,options); %learningRate de 0.1
