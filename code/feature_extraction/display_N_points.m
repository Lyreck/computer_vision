function [] = display_N_points(I, points,w, N)
    % Affiche les N rectangles correspondants au N points trouvés sur
    %l'image I, avec une taille de fenêtre w.
    % J'ai préféré faire une fonction annexe pour éviter de surcharger le
    % code.


    %assert(N==length(points), 'wrong number of points in array "points"');

    figure('Name', strcat('Mise en correspondance dans I2 (', string(N), 'points extraits, w=', string(w), ')'))
    imshow(I)
    for i=2:N
        points(i,:)
        ypeak=points(i,1);
        xpeak=points(i,2);
        tabx=[xpeak-w, xpeak-w, xpeak+w, xpeak+w, xpeak-w];
        taby=[ypeak+w, ypeak-w, ypeak-w, ypeak+w, ypeak+w];
        
        hold on
        plot(taby,tabx, 'LineWidth',5 , 'Marker', 'square', MarkerEdgeColor='cyan', MarkerFaceColor='none', Color='white'); %attention à l'ordre - et on se rappelle que le 0,0 est en haut à gauche pour une image !
        plot(ypeak,xpeak, 'o', Color='red'); %je ne comprends pas: je pensais que x et y étaient inversés !!peut être que le fait que c soit une matrice corrige le tir.
        hold off
    end

    %pour le premier point on affiche en le point de corrélation maximale avec une couleur différente.
    %[ypeak,xpeak]=points(1,:);
    ypeak=points(1,1);
    xpeak=points(1,2);
    tabx=[xpeak-w, xpeak-w, xpeak+w, xpeak+w, xpeak-w];
    taby=[ypeak+w, ypeak-w, ypeak-w, ypeak+w, ypeak+w];
    
    hold on
    plot(taby,tabx, 'LineWidth',5 , 'Marker', 'square', MarkerEdgeColor='magenta', MarkerFaceColor='none', Color='blue') %attention à l'ordre - et on se rappelle que le 0,0 est en haut à gauche pour une image !
    plot(ypeak,xpeak, 'o', Color='red') %je ne comprends pas: je pensais que x et y étaient inversés !!peut être que le fait que c soit une matrice corrige le tir.
    hold off

end