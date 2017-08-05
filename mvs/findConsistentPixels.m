
% Find the corresponding pixels in another view.
%
% - srcProj and dstProj are projection matrices
% - srcDepth and dstDepth are depth maps
% - srcPoints are the coordinates of source pixels
%       Each column is [col*depth row*depth depth 1]'
% - maxDepthError is the maximum relative difference between measured
%   and projected depth (default: 0.01)
%
% - dstPoints are corresponding pixels in another view
%       Each column is [col row depth 1]'
% - isConsistent labels the consistency of pixel pairs

function [dstPoints, isConsistent] = findConsistentPixels(srcProj, dstProj, srcDepth, dstDepth, srcPoints, maxDepthError)
    
    if ~exist('maxDepthError', 'var') || isempty(maxDepthError)
        maxDepthError = 0.01;
    end
    
    [h, w] = size(srcDepth);
    z = srcDepth(sub2ind([h, w], srcPoints(2, :), srcPoints(1, :)));
    srcPoints = [srcPoints(1, :) .* z; srcPoints(2, :) .* z; z; ones(1, length(z))];
    
    % Reproject reference points to 3D space
    points3D = srcProj \ srcPoints; % points3D = inv(srcProj) * srcPoints;
    
    % Project 3D points back to another view
    dstPoints = dstProj * points3D;
    dstPoints(1:2, :) = round(dstPoints(1:2, :) ./ dstPoints(3, :));
    
    validIdx = find(dstPoints(2, :) >= 1 & dstPoints(2, :) <= h & ...
                    dstPoints(1, :) >= 1 & dstPoints(1, :) <= w);
    depth = zeros(1, length(z));
    depth(validIdx) = dstDepth(sub2ind([h, w], dstPoints(2, validIdx), dstPoints(1, validIdx)));
    isConsistent = abs((dstPoints(3, :) - depth) ./ depth) < maxDepthError;

end