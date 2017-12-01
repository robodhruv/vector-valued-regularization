f = im2double(imread('canyon.png'));
f=J;
figure, imshow(J);
h = imfreehand();
binaryMask = h.createMask();
extractMask = 1 - binaryMask;
for i = 1:3
extracted_img(:,:,i) = f(:,:,i).*extractMask;
end
min_val_r = min(min(f(:,:,1)));
max_val_r = max(max(f(:,:,1)));
min_val_g = min(min(f(:,:,2)));
max_val_g = max(max(f(:,:,2)));
min_val_b = min(min(f(:,:,3)));
max_val_b = max(max(f(:,:,3)));
avg_val_r = (max_val_r - min_val_r)/2 + min_val_r;
avg_val_g = (max_val_g - min_val_g)/2 + min_val_g;
avg_val_b = (max_val_b - min_val_b)/2 + min_val_b;
redChannel = f(:,:,1);
greenChannel = f(:,:,2);
blueChannel = f(:,:,3);
desired_color = [avg_val_r, avg_val_g, avg_val_b];
redChannel(binaryMask) = desired_color(1);
greenChannel(binaryMask) = desired_color(2);
blueChannel(binaryMask) = desired_color(3);
f = cat(3, redChannel, greenChannel, blueChannel);
X = regularization(f, binaryMask, 100);