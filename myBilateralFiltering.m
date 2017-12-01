function [im_new] = myBilateralFiltering(img, std)
% This function implements the Bilinear filter on "img" with the 3D gaussian
% passed with the argument "std".

img = max (0,img);
imgs = img/max(max(img)) * 100;
img_trunc = ceil(imgs);

img_trunc = img_trunc + (img_trunc==0);
space = zeros([size(img, 1), size(img, 2), max(max(img_trunc))]);
void_space = zeros(size(space));
m = max(max(img_trunc));


for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        space(i, j, img_trunc(i, j)) = img(i, j);
        void_space(i, j, img_trunc(i, j)) = 1;
    end
end

% Simplest way, for now
B = imgaussfilt3(space, std);
B1 = imgaussfilt3(void_space, std);
B = B ./ B1;
im_new = zeros(size(img));
% disp(size(B));
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        im_new(i, j) = B(i, j, img_trunc(i, j));
    end
end