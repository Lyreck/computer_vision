%exercice 2 - Filtre de Sobel
filtre_sobel = fspecial('sobel'); %affichage de la matrice pour la question 3

I_phone = imread('phone.jpg');
%imshow(I_phone,[0,255]);

sobel_phone = sobelNorm(I_phone);
%imshow(sobel_phone,[0,255]);

figure('Name', 'telephone') % command to show multiple images (cf https://fr.mathworks.com/help/images/display-multiple-images.html).
subplot(1,2,1), imshow(I_phone,[0,255])
subplot(1,2,2), imshow(sobel_phone,[0,255])

%recherche d'un exemple où le résultat est moins bon
I_marylin = imread('marylin.jpg');
%imshow(I_marylin,[0,255]);
sobel_marylin = sobelNorm(I_marylin);
%imshow(sobel_marylin,[0,255]);

figure('Name', 'marylin') % command to show multiple images
subplot(1,2,1), imshow(I_marylin,[0,255])
subplot(1,2,2), imshow(sobel_marylin,[0,255])


%% exercice 4 - Transformée de Fourier

%question 3
%bureau
I_bureau = imread('bureau.jpg');
s_bureau=FT(I_bureau); %class(s) = 'double'. C'est une matrice de complexes. C'est la transformée de fourier de l'image, "en s'assurant que les coefficients pour les fréquences nulles sont placés au centre de l'image résultat".
figure('Name', 'Fourier bureau') % command to show multiple images
subplot(1,2,1), imshow(I_bureau,[0,255])
subplot(1,2,2), imshow(abs(s_bureau),[0 100000])%,[0,255])

%barbara
I_barbara = imread('barbara.jpg');
s_barbara=FT(I_barbara);
figure('Name', 'Fourier Barbara') % command to show multiple images (cf https://fr.mathworks.com/help/images/display-multiple-images.html).
subplot(1,2,1), imshow(I_barbara)
subplot(1,2,2), imshow(abs(s_barbara),[0 100000]); % car dynamique de l'image va vers 0,255


%question 4
s_barbara(1:170,:) = 0;
s_barbara(:,1:170) = 0;
s_barbara(343:512,:) = 0;
s_barbara(:,343:512) = 0;

iI_barbara = iFT(s_barbara);

figure('Name', 'Fourier Inverse Barbara (à droite')
imshow(uint8(iI_barbara));

function [gradient_norm] = sobelNorm(I) %fonction pour la question 4 de l'exercice 2

I = double(I); %type doube pour pouvoir appliquer sqrt.

filtre_sobel_vertical=fspecial('sobel');
DyI = imfilter(I,filtre_sobel_vertical);

filtre_sobel_horizontal = filtre_sobel_vertical'; %transposée pour obtenir le gradient horizontal (selon x)
DxI = imfilter(I,filtre_sobel_horizontal);

gradient_norm = sqrt(DxI.^2 + DyI.^2);

end

function s=FT(I) %transformée de Fourier 
    s=fftshift(fft2(I));
end

function iI=iFT(s) %transformée de Fourier inverse
    iI=abs(ifft2(fftshift(s)));
end

