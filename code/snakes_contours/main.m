close all

%% Exercice 2 - Ourobouros
%paramètres à tuner %par défaut ceux pour motifs.jpg
alpha=0.01; %influence de la dérivée première de C
beta=0.001; %influence de la dérivée 2nde
gamma=0.01; %influence des informations du reste de l'image ("gradient externe")
HSIZE = 5;
SIGMA=4;
lambda=1;

eps = 0.1; %condition d'arret lorsque l'on améliore que peu la solution
max_iter=1000; %nb max d'itérations

filename = 'images/motifs.jpg';

%% 1/ initialiser la courbe

% %%%%%%%cliquer les points%%%%%%%%%%
I = imread(filename);
% imshow(I);
% C = pickContour(); %pour cliquer
% save("saved_4_points_rectangle.mat","C");

% %%Pour rectangle motifs.jpg 
% %si on veut définir un cercle à la main...
% a=[0:0.01:2*pi];
% R= 80;
% Tx =100;
% Ty=120;
% C=[R.*cos(a) + Tx;R.*sin(a) + Ty];

%avant que je me souvienne de la commande save (points cliqués à la main puis retranscrits):
Cx=[43.1968, 43.1968, 43.1968, 43.9189, 43.1968, 43.5578, 43.5578, 43.1968, 42.8357, 42.8357, 42.8357, 42.8357, 42.4746, 42.8357, 42.1135,   42.1135,   42.1135,   42.4746,   43.1968,   42.8357,   42.1135,   42.8357,   43.1968,   42.8357,   43.1968,   43.1968,   43.5578,   43.1968, 44.2800,   43.9189,   43.5578,   45.0021,   50.4182,   56.1953,   60.1671,   63.7779,   65.9443,   70.6382,   74.9711,   80.3872,   85.4422,   90.8583, 97.3575,  103.1347,  107.8286,  115.0501,  122.2715,  129.1319,  135.9922,  142.8526,  144.2969,  143.9358, 143.9358,  143.9358,  144.2969,  144.6580, 144.6580,  144.6580,  144.6580,  145.3801,  144.2969,  143.9358,  143.9358,  143.9358  143.9358,  144.6580,  144.2969,  144.2969,  144.6580,  144.6580, 145.0190,  144.6580,  144.6580,  144.2969,  144.2969,  144.2969,  142.1305,  134.9090,  127.3265,  124.4379,  120.1051,  113.9669,  108.1897,  102.7736, 96.6354,   91.9415,   85.0811,   81.4704,   77.8597,   75.3322,   70.2772,   66.3054,   59.4450,   51.5014,   47.8907];
Cy=[47.1685,   52.5846,   56.5564,   61.6114,   66.3054,   71.3604,   76.0543,   81.4704,   86.5254,   91.5804,   95.5522,   99.1629,  103.4958,  107.4676, 111.0783,  114.3279,  118.2997,  121.9104,  128.0487,  132.3815,  137.4365,  145.0190,  148.9908,  154.7680,  158.3787,  163.7948, 169.2109,  176.7934, 181.1262,  185.8202,  190.5141,  193.7638,  194.4859,  194.8470,  194.8470,  194.4859,  194.4859,  194.8470, 194.8470,  194.8470,  194.4859,  195.2080, 194.8470,  194.8470,  194.8470,  194.8470,  197.0134,  195.5691,  195.2080,  194.8470,  188.7087,  181.8484,  177.5155,  171.7384,  167.7666,  161.2673, 154.7680,  148.9908,  142.4915,  136.7144,  130.2151,  124.7990,  119.0219,  112.5226,  107.4676,   99.5240,   93.3858,   87.9697,   81.1093,   76.4154, 70.6382,   65.2221,   59.8061,   56.9175,   50.7793,   44.6410,   44.2800,   45.0021,   45.0021,   45.7243,  46.4464,   46.4464,   44.6410,   45.3632, 46.8075,   45.7243,   46.8075,   46.4464,   46.0853,   46.0853,   47.5296,  46.0853,   47.5296,   48.6128,   47.5296];
C = [Cx; Cy];

%ou alors: définition d'un parallélogramme avec linspace (attention: trop
%de points pour "drawnow"->warning)
% Cx1 = linspace(43, 43, 1000);
% Cx2 = linspace(43,144,1000);
% Cx3 = linspace(144,144,1000);
% Cx4 = linspace(144,43,1000);
% 
% Cy1=linspace(44, 194, 1000);
% Cy2=linspace(194,194,1000);
% Cy3=linspace(194, 44,1000);
% Cy4=linspace(44,44,1000);
% 
% C= [Cx1,Cx2,Cx3,Cx4; Cy1,Cy2,Cy3,Cy4];

%%test seulement 4 points pour influence du nb de points.
%load("saved_4_points_rectangle.mat");

%%%Parapluie motifs.jpg
%%%initialisation des points un peu loin
% Cx = [189.4309,  184.7370,  179.6819,  176.7934,  173.5437,  169.2109,  165.6001,  165.9612,  166.6834,  168.1276, 171.0162,  174.2659,  178.9598,  183.2927,187.6255,  191.9584,  197.0134,  198.8188,  199.5409,  198.8188,  201.7073,  203.8738, 207.1234,  207.4845,  207.4845,  208.2066,  208.2066,  211.4563, 218.3166,  222.2884,  225.1770,  228.0656,  230.5931,  233.8427,  236.0092,  238.1756,  238.8977,  239.2588,  239.6199,  238.8977,  236.3702,  233.1206, 226.9824,  223.0106,  220.1220,  216.5113,  211.4563,  209.6509,  208.2066,  208.2066,  208.5677,  208.9288,  209.2898,  209.2898,  209.2898,  209.2898, 208.9288,  209.2898,  209.6509,  209.2898,  210.0120,  208.9288,  207.1234,  204.5959,  199.5409,  195.5691,  189.4309,  186.9034,  184.3759,  184.0148, 184.3759,  184.0148,  190.5141,  194.1248,  194.1248,  195.2080,  196.6523,  197.7355,  197.7355,  198.4577,  198.0966,  197.7355,  198.0966,  198.8188, 199.1798,  198.8188,  198.8188,  199.9020,  195.9302,  193.7638, 189.4309];
% Cy=[118.6608,  116.1333,  115.0501,  117.5776,  121.1883,  124.4379, 121.9104,  115.4111,  109.2729,  105.6622,   98.4408,   90.1361,   85.8032,   82.9147, 80.0261,   77.4986,   76.0543,   74.6100,   70.2772,   65.5832,   63.7779,   63.7779,  63.7779,   66.6664,   69.5550,   72.0825,   74.9711,   76.7764, 78.5818,   81.1093,   83.6368,   87.2475,   91.5804,   96.2743,  100.6072,  104.5790,  109.6340,  114.6890, 119.0219,  122.6326,  122.9937,  119.7440, 117.9386,  117.2165,  119.7440,  121.5494,  120.8272,  117.5776,  117.2165,  119.0219,  121.9104,  126.2433,  130.9372,  134.1869,  138.8808,  141.7694, 146.8244,  151.8794,  155.8512,  160.9062,  167.4055,  170.2941,  174.9880,  178.5987,  181.1262,  180.4041,  179.3209,  176.0712,  171.0162,  168.8498, 165.6001,  160.1841,  160.5451,  160.5451,  163.7948,  165.9612,  166.3223, 163.4337,  159.8230,  153.6848,  152.2405,  146.4633,  141.0472,  134.9090, 128.7708,  123.7158,  119.7440,  117.2165,  119.0219,  121.1883, 118.6608];
% C=[Cx;Cy];

%%initialisation des points bcp+proches
%load("saved_C_parapluie_proche.mat");


%%%%%pour montage.jpg
% I = imread('images/montage.jpg');
% imshow(I);
% %C = pickContour(); %pour cliquer
% %save("saved_C_montage", "C");
% load("saved_C_montage.mat");


imshow(I);
hold on
plot(C(1,:), C(2,:), 'g-',LineWidth=2); %why is it not CLOSED on the plotted image ??
hold off;


h = animatedline;


%% 2/ calculer le gradient de l'énergie en chaque point c_i
%% gradient externe
%1- image de la norme du gradient
[Gx, Gy] = DerivGauss(HSIZE,SIGMA);
Ix = imfilter(double(I),Gx,'conv');
Iy = imfilter(double(I),Gy,'conv');

%2- gradient de cette image
gradI = Ix.^2 + Iy.^2; %gradient de l'image au carré, cf. diapositive 39 par exemple.
Hx = imfilter(double(gradI),Gx,'conv');
Hy = imfilter(double(gradI),Gy,'conv');


nb_iter=0;
diff=eps+1; %pour entrer dans la boucle %condition sur l'évolution de C pour stopper la descente de gradient
while nb_iter<max_iter & diff > eps
    %% gradient interne
    eC=[C(:,end-1:end),C,C(:,1:2)];  %pour pouvoir calculer Csec et Cquarte =-)
    [Csec, Cquarte] = innerDerivative(eC); %dérivées

    gradient_interne = -alpha.*Csec + beta.*Cquarte;

    %gradient externe ça bouge pas: calculé avant la boucle.

    %interpolation et calcul
    Vx = interp2(Hx, C(1,:), C(2,:)); %on interpole quoi avec quoi là exactement ?
    Vy = interp2(Hy, C(1,:), C(2,:));

    gradient_externe = [Vx; Vy]; %pas compris / vois pas -> oui c'est la carte de gradients, cf image à droite diapo 41 + notes fin cahier

    grad_energie = gradient_interne - gamma.*gradient_externe;
    C = C - lambda .* (grad_energie); %mettre à jour chaque point c_i selon l'algorithme de descente du gradient
    C(:,end)=C(:,1); %obliger le snake a rester fermé car sinon, visiblement, ça ne le reste pas.


    addpoints(h,C(1,:),C(2,:));
    drawnow

    diff = norm(lambda.*grad_energie);
    %disp(diff); %si on veut voir l'évolution de l'erreur

    nb_iter=nb_iter+1;
end

hold on;
plot(C(1,:), C(2,:), LineWidth=2);
hold off


figure;
subplot(1,3,1), imshow(I);
subplot(1,3,2), imshow(Hx,[]);
subplot(1,3,3), imshow(Hy,[]);




%% Exécution et test
%paramètre à tuner: voir en début de code.