function [new_image, iter] = regularization(img, mask_m, max_iter)
%% Regularization routine, based on the PDE-based methods proposed by Tschumperle et al.

pad_img = padarray(img, [2 2], 0, 'both');
pad_mask = padarray(mask_m, [2 2], 0, 'both');
G = fspecial('gaussian',2, 1);
new_image = pad_img;
[x y] = meshgrid(-2:2, -2:2);
[m n ~] = size(pad_img);
mask = zeros(3,3);
Gx = zeros(m,n,3);
Gy = zeros(m,n,3);
 for iter = 1:max_iter
    for i = 1:size(img,3)
         [Gx(:,:,i),Gy(:,:,i)] = imgradientxy(new_image(:,:,i),'sobel'); 
    end
    XX = sum(Gx.^2, 3);
    YY = sum(Gy.^2, 3);
    XY = sum(Gx.*Gy, 3);

    disp(iter);
%     if (mod(iter, 20) == 0)
%         imshow(new_image)
%     end
    for i = 3:size(pad_img,1) - 2    
        for j = 3:size(pad_img,2) - 2
            if (pad_mask(i, j) < 1)
                continue
            end   
            struct_tensor = [XX(i,j) XY(i,j);XY(i,j) YY(i,j)] ;
            struct_tensor = imfilter(struct_tensor, G);
            [W,D] = eig(struct_tensor);
            [Eigenvalues, permutation] = sort(diag(D), 'descend');
            W = W(:, permutation);

             T =  W(:,1)*W(:,1)'/(1 + Eigenvalues(1) + Eigenvalues(2)) ...
                  + W(:,2)*W(:,2)'/sqrt(1+ Eigenvalues(1) + Eigenvalues(2)) ;
       
            T_inv = inv(T);
            t = 0.5;
            mask = exp(-((x.^2*T_inv(1,1) + y.^2*T_inv(2,2) + x.*y*(T_inv(1,2) + T_inv(2,1))))/(4*t));
            mask_cut = mask(max(1,4+2-i):min(end,m+1-i),max(1,4+2-j):min(end,n+1-j));
            mask = mask/sum(sum(mask_cut));
            for k = 1:size(img,3)
                temp_conv = conv2(new_image(i-2:i+2,j-2:j+2,k),mask,'same');
                new_image(i,j,k) = temp_conv(3,3);
            end
            new_image([1,2,size(new_image,1),size(pad_img,1)-1],:) = 0;
            new_image(:,[1,2,size(new_image,2),size(pad_img,2)-1]) = 0;
            
        end
    end
 end
 new_image = new_image(3:end-2, 3:end-2, :);
