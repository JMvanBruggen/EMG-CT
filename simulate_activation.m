function [TEST] = simulate_activation(X_j,Y_j,activation,muscles)
% Input:        Muscles: a vector of muscles that you want activated
%               expressed in numbers corresponding to muscles: 
%               Brachioradialis = {1};
%               Extensor carpi ulnaris = {2};
%               Extensor digitorum DX = {3};
%               Abductor pollices longus = {4};
%               flexor pollices longus = {5};
%               flexor carpi radialis = {6};
%               Flexor difigotorum superificiales = {7};
%               Extensor digiti quinti proprius = {8};
%               flexor digitorum profundus = {9};
%               Extensor pollices longus = {10};
%               Extensor carpi ulnaris = {11};
%               Palmaris longus = {12};
%               Flexor carpi ulnaris = {13};
%               Activation: a vector with the activation levels
%               corresponding to the muscles in the muscle vector.
%               X_j and Y_j the size of the simulated area as created in
%               get_Vi_model.m
% Output:       TEST: test Activation mapping


im = imread('cross_section.png');
im = im(10:350,70:410,:);           % This should be better is the cross section is warped to a cirkel. But for now it makes it fit in the grid.

a = find(im(:,:,1) == 255);         % Find the index if pixels with muscles based on color of muscles in picture
b = find(im(:,:,2) == 204); 
c = find(im(:,:,3) == 153);
a = a(ismember(a,b));
a = a(ismember(a,b));

im = rgb2gray(im);
%%
imtemplate = zeros(size(im));
imtemplate(a) = 255;
imtemplate = imdilate(imtemplate,strel('diamond',1));
imtemplate = imerode(imtemplate,strel('diamond',1));

cc = bwconncomp(imtemplate);                                                % detect all 'components' i.e. muscles



%%
TEST = zeros(size(im));                                                     % Create test data
for i =1:length(muscles)
    TEST(cc.PixelIdxList{muscles(i)}) = activation(i);
end

TEST = imresize(TEST,size(X_j));
figure(1), surf(X_j,Y_j,TEST)
colorbar
view(2)