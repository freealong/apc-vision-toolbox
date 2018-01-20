function [ bmasks, bboxes ] = getMasks( clouds, cMos, colorK, colorSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    assert(size(clouds, 2) == size(cMos, 2));
    
    % generate masks
    masks = cell(1, size(cMos, 2));
    dists = cell(1, size(cMos, 2));
    for i = 1:size(cMos, 2)
        [masks{i}, dists{i}] = generateMask(clouds{i}, cMos{i}, colorK, colorSize);
    end
    
    % combine masks
    mask = combineMasks(masks, dists);
    
    % crop mask, bbox from masks
    [bmasks, bboxes] = cropMask(mask, size(cMos, 2));
    
end

