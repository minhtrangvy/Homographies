%% Project 3: Homographies
% Part 1: Homography

%% Clean up
clear all
close all

load('atrium_saved_variables')

% %% Take in the images and grab the grey of them
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Homographies/atrium/';
input_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

for grey_image = 1:length(files)
    current_name = files(grey_image).name;
    current_image = im2double(imread([input_dir current_name]));
    images{grey_image} = rgb2gray(current_image);
    figure
    imagesc(images{grey_image})
    title(grey_image)
end

for peripheral_image = 2:length(files)
    cpselect(images{peripheral_image},images{1}) % ..., 'Wait', true)
end