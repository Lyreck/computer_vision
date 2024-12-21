net = alexnet;


%%% tests
img = imread('DataMatch/UsineReduit/usine53.JPG');

activ= activations(net, img,'fc7');

size(activ) %1 1 4096, réponse à la première question
%%% 

%%% test de plusProchesImages sur usine6.JPG, usine8.JPG et usine40.JPG:
%usine6
[N6, similarite6]=plusProchesImages('usine6.JPG', 9, net, 'fc7', 4096);
for i=1:9
    N6(i) = strcat('DataMatch/UsineReduit/', N6(i)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine6.JPG (fc7):');
disp(similarite6);

figure('Name', 'usine6.JPG (fc7)');
out=imtile(N6);
imshow(out);

%usine8
[N8, similarite8]=plusProchesImages('usine8.JPG', 9, net, 'fc7', 4096);
for i=1:9
    N8(i,1) = strcat('DataMatch/UsineReduit/', N8(i,1)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine8.JPG (fc7):');
disp(similarite8);

figure('Name', 'usine8.JPG (fc7)');
out=imtile(N8);
imshow(out);

%usine40
[N40, similarite40]=plusProchesImages('usine40.JPG', 9, net, 'fc7', 4096);
for i=1:9
    N40(i,1) = strcat('DataMatch/UsineReduit/', N40(i,1)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine40.JPG (fc7):');
disp(similarite40);


figure('Name', 'usine40.JPG (fc7)');
out=imtile(N40);
imshow(out);


%%Même question mais pour la couche fc8 (au lieu de fc7) ("%q4")

%%% test de plusProchesImages sur usine6.JPG, usine8.JPG et usine40.JPG:
%usine6
[N6, similarite6]=plusProchesImages('usine6.JPG', 9, net, 'fc8', 1000);
for i=1:9
    N6(i) = strcat('DataMatch/UsineReduit/', N6(i)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine6.JPG (fc8):');
disp(similarite6);

figure('Name', 'usine6.JPG (fc8)');
out=imtile(N6);
imshow(out);

%usine8
[N8, similarite8]=plusProchesImages('usine8.JPG', 9, net, 'fc8', 1000);
for i=1:9
    N8(i,1) = strcat('DataMatch/UsineReduit/', N8(i,1)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine8.JPG (fc8):');
disp(similarite8);

figure('Name', 'usine8.JPG (fc8)');
out=imtile(N8);
imshow(out);

%usine40
[N40, similarite40]=plusProchesImages('usine40.JPG', 9, net, 'fc8', 1000);
for i=1:9
    N40(i,1) = strcat('DataMatch/UsineReduit/', N40(i,1)); %on rajoute le directory pour pouvoir utiliser imtile ensuite
end
disp('9 premiers scores de similarité pour usine40.JPG (fc8):');
disp(similarite40);


figure('Name', 'usine40.JPG (fc8)');
out=imtile(N40);
imshow(out);

%% Deuxième exercice: Mise en correspondance par corrélation: voir fichier associé