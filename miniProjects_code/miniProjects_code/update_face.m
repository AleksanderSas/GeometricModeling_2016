function [face, remove] = update_face(face_ory, v_ory, v_new)
      mask = ismember(face_ory, [v_ory, v_new]);
      common_v = face_ory(mask);
      face = face_ory;
      if numel(common_v) > 1
        remove = true;
        face = face * 0;
      else
        face(mask) = v_new;
        remove = false;
      end