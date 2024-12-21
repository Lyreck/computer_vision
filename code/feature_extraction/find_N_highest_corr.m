function [points] = find_N_highest_corr(N, w, m1, I1, I2)
    %étant donné une taille de fenêtre w, une image d'origine I1 (et un point à identifier m1 dans I1) et une image
    %cible I2, renvoie les N points de plus grande corrélation, calculés à
    %l'aide de normxcorr.

    template = I1(m1(1)-w:m1(1)+w, m1(2)-w:m1(2)+w);
    
    % figure('Name', 'Surface');
    c = normxcorr2(template,I2);
    % surf(c);
    % shading flat



    points = zeros(N,2);
    for i=1:N
        [ypeak,xpeak] = find(c==max(c(:)));
        points(i,:) = [xpeak-w, ypeak-w];
        c(ypeak,xpeak) = NaN; %on enlève l'élément que l'on vient de prendre dans c pour pouvoir chercher le deuxième plus grand avec max.
    end

end