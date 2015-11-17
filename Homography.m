%% Project 3: Homographies
% Part 1: Homography

%% Clean up
clear all
close all

%% Load previously saved pair points
load('shanahan_saved_variables')

%% Take in the images and grab the grey of them
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Homographies/shanahan/';
input_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

for grey_image = 1:length(files)
    current_name = files(grey_image).name;
    current_image = im2double(imread([input_dir current_name]));
    current_image = imresize(current_image,0.1);
    images{grey_image} = rgb2gray(current_image);
end

% for peripheral_image = 2:length(files)
%     cpselect(images{peripheral_image},images{1}) % ..., 'Wait', true)
% end

%% Compute homographies
num_of_images = length(images);
H = cell(1,2);
H{1} = eye(3);
movingPoints = cpcorr(movingPoints,fixedPoints,images{2},images{1});
x1 = fixedPoints(:,1);
y1 = fixedPoints(:,2);
x2 = movingPoints(:,1);
y2 = movingPoints(:,2);
H{2} = computeHomography(x1,y1,x2,y2);
movingPoints2 = cpcorr(movingPoints2,fixedPoints2,images{3},images{1});
x1_2 = fixedPoints2(:,1);
y1_2 = fixedPoints2(:,2);
x2_2 = movingPoints2(:,1);
y2_2 = movingPoints2(:,2);
H{3} = computeHomography(x1_2,y1_2,x2_2,y2_2);


%% Find the max and min coordinates of the mosaic
x_values = [];
y_values = [];
for current_image = 1:num_of_images
    [h, w] = size(images{current_image});
    x_limits = [1;w;1;w];
    y_limits = [h;h;1;1];
    [new_x, new_y] = applyHomography(inv(H{current_image}),x_limits,y_limits);
    x_values = [x_values, new_x];
    y_values = [y_values, new_y];
end

min_X = min(x_values);
min_Y = min(y_values);
max_X = max(x_values);
max_Y = max(y_values);

[X, Y] = meshgrid(min_X(2):400, 0:max_Y(2));
% [X, Y] = meshgrid(-50:400, -200:310);

%% Apply homography to all images
mosaic = cell(num_of_images);
for j = 1:num_of_images
    image_j = images{j};
    [meshX, meshY] = applyHomography(H{j},X,Y);
    mosaic_pieces{j} = interp2(image_j, meshX, meshY);
%     figure
%     imshow(mosaic_pieces{j})
%     title(['mosaic piece ', j])
end

% % Get mosaic without any blending normal_mosaic =
% normal_mosaic = zeros(size(mosaic_pieces{1})); 
% for mosaic_piece = 1:num_of_images
%     valid_pieces = ~isnan(mosaic_pieces{mosaic_piece});
%     normal_mosaic(valid_pieces) = mosaic_pieces{mosaic_piece}(valid_pieces);
% end
% figure 
% imshow(normal_mosaic) 
% title('normal mosaic')


%% Creating alpha masks for each image
for this_image = 1:num_of_images
    alpha_masks{this_image} = ~isnan(mosaic_pieces{this_image});
    
%     figure
%     imshow(alpha_masks{this_image})
%     title(['alpha_masks pixels ', this_image])
end

%{
%% -------------------------- Blended Assumbly Portion ------------------------------
%% Create alpha masks and blur them
gaussian_filter = fspecial('gaussian', [3 3], 5);
for this_image = 1:num_of_images
    
    %Blur the masks
    blurred_masks{this_image} = imfilter(im2double(alpha_masks{this_image}), gaussian_filter, 'symmetric');
%     
%     figure
%     imshow(blurred_masks{this_image})
%     title(['blurred pixels ', this_image])     
end

%% Cut off newly introduced pixels
for this_image = 1:num_of_images
    blurred_masks{this_image} = alpha_masks{this_image} .* blurred_masks{this_image};
    
%     figure
%     imshow(blurred_masks{this_image})
%     title(['cleaned pixels ', this_image])
end

%% Normalize blurred masks
total_of_all_masks = blurred_masks{1} + blurred_masks{2} + blurred_masks{3};
for this_image = 1:num_of_images
    
    % Normalize all the blurred masks, this introduces NaNs
    blurred_masks{this_image} = blurred_masks{this_image} ./ total_of_all_masks;
    
%     figure
%     imshow(blurred_masks{this_image})
%     title(['normalized pixels ', this_image])
end

%% Blur mosaic pieces
for this_image = 1:num_of_images
    % Multiply with the images
    mosaic_pieces{this_image} = mosaic_pieces{this_image} .* blurred_masks{this_image};
    
    figure
    imshow(mosaic_pieces{this_image})
    title(['mosaic pieces ' this_image])
end

%% Compile the mosaic
blended_mosaic = zeros(size(mosaic_pieces{1}));
for this_piece = 1:num_of_images
    valid_pieces = ~isnan(mosaic_pieces{this_piece});
    blended_mosaic(valid_pieces) = mosaic_pieces{this_piece}(valid_pieces);
end
figure
imshow(blended_mosaic)
title('blended mosaic')
%}


%% -------------------------- Two-Band Blending Portion ------------------------------
%% Create low frequency images
gaussian_filter = fspecial('gaussian', [10 10], 10);
for this_image = 1:num_of_images
    
    low_freq_images{this_image} = imfilter(im2double(mosaic_pieces{this_image}), gaussian_filter, 'symmetric');

    figure
    imshow(low_freq_images{this_image})
    title(['low_freq_images ', this_image])    
end

%% Create high frequency images
for this_image = 1:num_of_images
    high_freq_images{this_image} = mosaic_pieces{this_image} - low_freq_images{this_image};
    
    figure
    imshow(high_freq_images{this_image})
    title(['high_freq_images ' this_image]) 
end

%% Blur alpha masks 
gaussian_filter = fspecial('gaussian', [3 3], 5);
for this_image = 1:num_of_images
    
    %Blur the masks
    blurred_masks{this_image} = imfilter(im2double(alpha_masks{this_image}), gaussian_filter, 'symmetric');

%     figure
%     imshow(blurred_masks{this_image})
%     title(['blurred pixels ', this_image])     
end

%% Cut off newly introduced pixels
for this_image = 1:num_of_images
    blurred_masks{this_image} = alpha_masks{this_image} .* blurred_masks{this_image};
    
%     figure
%     imshow(blurred_masks{this_image})
%     title(['cleaned pixels ', this_image])
end

%% Apply masks to low frequency mosaic pieces
for this_image = 1:num_of_images
    % Multiply with the images
    low_freq_images{this_image} = low_freq_images{this_image} .* blurred_masks{this_image};
    
%     figure
%     imshow(low_freq_images{this_image})
%     title(['low_freq_images pieces ' this_image])
end

%% Apply binary alpha masks to high frequency mosaic pieces
for this_image = 1:num_of_images
    high_freq_images{this_image} = high_freq_images{this_image} .* alpha_masks{this_image};
    
%     figure
%     imshow(high_freq_images{this_image})
%     title(['high_freq_images pieces ' this_image])
end

%% Compile the low frequency mosaic
low_freq_mosaic = zeros(size(mosaic_pieces{1}));
for this_piece = 1:num_of_images
    valid_pieces = ~isnan(mosaic_pieces{this_piece});
    low_freq_mosaic(valid_pieces) = low_freq_images{this_piece}(valid_pieces);
end
figure
imshow(low_freq_mosaic)
title('low_freq_mosaic image')

%% Compile the high frequency mosaic
high_freq_mosaic = zeros(size(mosaic_pieces{1}));
for this_piece = 1:num_of_images
    valid_pieces = ~isnan(mosaic_pieces{this_piece});
    high_freq_mosaic(valid_pieces) = high_freq_images{this_piece}(valid_pieces);
end
figure
imshow(high_freq_mosaic)
title('high_freq_mosaic image')

%% Compile the low and high frequency mosaic
total_freq_mosaic = low_freq_mosaic + high_freq_mosaic;
figure
imshow(total_freq_mosaic)
title('total_freq_mosaic image')
%} 
