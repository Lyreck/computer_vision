function [R,T] = homog2pose(H,K)

    h = K\H; %h contient les h(i), qui sont des vecteurs colonne de taille 3.
    %disp(h);


    %%premier cas: tout avec un +
    r=[0, 0; 0, 0; 0, 0]; %contient les r_i mais pas r_3
    for i=1:2
        r(:,i) = h(:,i) / norm(h(:,i));
    end

    t=h(:,3)/norm(h(:,1));

    if t(3) < 0
        %on refait tout car ça n'est pas bon; sinon, tout va bien.
        for i=1:2
            r(:,i) = - h(:,i) / norm(h(:,i));
        end
    end

    t=-h(:,3)/norm(h(:,1));

    r3 = cross(r(:,1), r(:,2)); %produit vectoriel des deux premiers pour donner le 3e, car la matrice de rotation R est orthogonale. !!(pb repère direct?)!!
    R = [r(:,1), r(:,2), r3];
    T=t;
end
