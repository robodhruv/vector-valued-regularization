f = im2double(imread('canyon.png'));
figure, imshow(f);
h = imfreehand();
binaryMask = h.createMask();
extractMask = 1 - binaryMask;
for i = 1:3
A(:,:,i) = f(:,:,i).*extractMask;
end
X = regularization(A, binaryMask, 200);

