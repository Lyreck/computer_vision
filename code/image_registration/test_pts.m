% On charge les données
I = imread('varan.jpg');
J = imread('varan_t.jpg');
P = load('varan.pts');
Q = load('varan_t.pts');

% Code copié de l'énoncé
figure(1)
imshow(I);
hold on
plot(P(:,1),P(:,2),'+y');
hold off
figure(2)
imshow(J);
hold on
plot(Q(:,1),Q(:,2),'+y');
hold off