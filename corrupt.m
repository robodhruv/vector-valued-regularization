function [corrupted] = corrupt(im, mask)

mask = (255 - mask) / 255;
corrupted = im;

for i = 1:3
    corrupted(:, :, i) = im(:, :, i).*mask;
end