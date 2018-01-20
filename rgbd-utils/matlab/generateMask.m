function [ mask, dist ] = generateMask( cloud, cMo, colorK, colorSize )
%UNTITLED Summary of this function goes here
%   generate mask from object point cloud
    mask = zeros(colorSize);
    dist = ones(colorSize) * 1000; % big enough
    for i = 1:cloud.Count
        p1 = cloud.Location(i, :);
        p1(end+1) = 1;
        p2 = cMo * p1';
        % project p2 to image plane
        x = p2(1) / p2(3);
        y = p2(2) / p2(3);
        u = round(x * colorK(1, 1) + colorK(1, 3));
        v = round(y * colorK(2, 2) + colorK(2, 3));
        d = p2(1)*p2(1) + p2(2)*p2(2) + p2(3)*p2(3);
        if u > 0 && u <= colorSize(2) && v > 0 && v <= colorSize(1) && dist(v, u) > d
            mask(v, u) = 1;
            dist(v, u) = d;
        end
    end
    mask = fillHoles(mask);
end

