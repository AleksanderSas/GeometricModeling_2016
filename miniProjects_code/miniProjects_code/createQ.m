function Q = createQ(vertices, faces)
    Q = zeros(size(vertices,1), 4, 4);
    for i = 1:size(faces, 2)
        face_params = get_surface_params(vertices(faces(1,i),:), vertices(faces(2,i),:), vertices(faces(3,i),:));
        face_params = reshape(face_params' * face_params, 1, 4, 4);
        Q(faces(1,i),:,:) = Q(faces(1,i),:,:) + face_params;
        Q(faces(2,i),:,:) = Q(faces(2,i),:,:) + face_params;
        Q(faces(3,i),:,:) = Q(faces(3,i),:,:) + face_params;
    end