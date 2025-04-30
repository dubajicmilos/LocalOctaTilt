function [SQ_QS, SQ_full, H, K, Energy, array3D] = loadMD_Data(filePath)
    % loadPerovskiteData - Loads specified datasets from a HDF5 file.
    %
    % Syntax: [SQ_QS, SQ_full, H, K, Energy, array3D] = loadPerovskiteData(filePath)
    %
    % Inputs:
    %   filePath - String, path to the HDF5 file.
    %
    % Outputs:
    %   SQ_QS, SQ_full, H, K, Energy, array3D - Loaded datasets.
    
    % Check if the file exists
    if ~isfile(filePath)
        error('File does not exist: %s', filePath);
    end

    % Define dataset names
    dataset1 = '/SQ_QS';
    dataset2 = '/SQ_full';
    dataset3 = '/H';
    dataset4 = '/K';
    dataset5 = '/E';
    dataset6 = '/SQ_E';

    % Load the datasets
    try
        SQ_QS = h5read(filePath, dataset1);
        SQ_full = h5read(filePath, dataset2);
        H = h5read(filePath, dataset3);
        K = h5read(filePath, dataset4);
        Energy = h5read(filePath, dataset5);
        array3D = h5read(filePath, dataset6);
    catch ME
        rethrow(ME);
    end
end
