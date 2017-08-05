
% Compose projection matrix from intrinsic matrix and extrinsic parameters.
% - K is the camera intrinsic matrix
% - R is the rotation matrix
% - t is the translation vector

function P = composeProjectionMatrix(K, R, t)
    P = [K * [R t]; 0 0 0 1];
end