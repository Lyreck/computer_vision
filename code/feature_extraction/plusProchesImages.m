function [N_similar_images, similarite_list]=plusProchesImages(name_image, N, net, couche, descriptor_size)
disp(name_image)
%prend en entrée un image de nom name_image, et renvoie les noms des N
%images les plus semblables.
%net = alexnet 
%couche = fc7, ou fc8 ou autre en fonction de où l'on choisit d'extraire le descripteur dans le réseau de neurones.
%descriptor_size = pour définir le reshape du descripteur. 4096 pour la couche 'fc7', 1000 pour 'fc8'.

%% informations pour l'image originale
original_image = imread(strcat('DataMatch/UsineReduit/', name_image));
activ_origin = activations(net, original_image,couche);
activ_origin = reshape(activ_origin,[1,descriptor_size]); %reshape en un tableau de bonne dimension
activ_origin = activ_origin / norm(activ_origin); %normalisation

%% Récupérations des autres données
list_all_images = dir('DataMatch/UsineReduit/*JPG');
p = length(list_all_images);
assert(N<=p, 'Cannot extract more images than the dataset has.')

%% Traitement, récupération des descripteurs et calcul des produits scalaires
similarite = zeros(p,1); %vecteur contenant les produits scalaires des images avec l'image originale
for i=1:p
    image = list_all_images(i); %contient les infos de l'image
    img = imread(strcat(image.folder, '/', image.name)); %contient le tableau des pixels de l'image

    %if not(strcmp(image.name, name_image)) %on ne traite pas si c'est l'image d'origine
    activ = reshape(activations(net, img, couche), [1,descriptor_size]); %on récupère le descripteur et on le reshape à la bonne dimension
    activ = activ / norm(activ); %on normalise

    similarite(i) = activ_origin*activ'; %produit scalaire et nom de l'image
    %end
end

[similarite, index] = sort(similarite, 'descend'); %cheatcode: index!!

%index_similar_images = index(2:N+1); % le premier sera forcément l'image originale... et on en veut pas.
%index_similar_images = index(1:N); %en vrai si c'est bien de voir l'originale !!
N_similar_images = strings(N,1);
for i=1:N
    image = list_all_images(index(i)); %récupération de l'image de base dans la liste originale récupérée par dir().
    N_similar_images(i) = image.name;
end

%%retrouver usine38.JPG pour voir son score (elle aurait dû être affichée pour usine40).
%list_all_images(index(length(index)-32)).name
%similarite(index(length(index)-32))


similarite_list = similarite(1:N);

end