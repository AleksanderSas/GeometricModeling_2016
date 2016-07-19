iterations = 1700;
indexes2remov = zeros(1, iterations);
removed_faces = 0;

[v,f]=loadmesh('D:\\studia\\Geometric_modelig\\GeometricModeling_2016\\miniProjects_code\\miniProjects_code\\samplemeshes\\pig.off');
%[v,f]=loadmesh('D:\\studia\\Geometric_modelig\\GeometricModeling_2016\\miniProjects_code\\miniProjects_code\\data\\pig.off');
%[v, f] = test();

v=v'; %flip to colums for convenience in matrix multiplication
Q = createQ(v,f);
%connectivity matrix
C = sparse(f([1 2 3],:),f([2 3 1],:),1,size(v, 1),size(v,1));
nt = size(f,2);
f = f';
VT=sparse(reshape(f, 1,numel(f)),[1:nt, 1:nt, 1:nt], ones(1,3*nt),size(v, 1),nt);
C = C + C';
[valid_pairs, pair_table] = get_valid_pairs(C, size(v, 1));
pq = pq_create(size(valid_pairs, 1));

%fill queue
for i = 1:size(valid_pairs, 1) 
  idx1 = valid_pairs(i,1);
  idx2 = valid_pairs(i,2);
  cost = comput_cost(reshape(Q(idx1,:,:), 4,4), reshape(Q(idx2,:,:), 4,4));
  pq_push(pq, i, cost);
end

for i = 1:iterations
   [pair_id, cost] = pq_pop(pq); 
   v1 = valid_pairs(pair_id, 1);
   v2 = valid_pairs(pair_id, 2);
   fan=find(VT(v2,:));
   % if numel(fan) < 3
       % continue;
   % end
   indexes2remov(i) = v2;
   
   %remove processed pair
   pair_table(v1, pair_id) = 0;
   pair_table(v2, pair_id) = 0;
   C(v1, v2) = 0;
   C(v2, v1) = 0;
   
   %get indices of pair containing v1 or v2
   v1_p= find(pair_table(v1,:));
   v2_p= find(pair_table(v2,:));
   
   %update cost and position on v1
   [cost, v_new] = comput_cost(reshape(Q(v1,:,:), 4,4), reshape(Q(v2,:,:), 4,4));
   v(v1, :) = reshape(v_new(1:3), 1, 3);
   Q(v1,:,:) = Q(v1,:,:) + Q(v2,:,:);
   
   %update faces
   for k = 1:numel(fan)
      [face, remove] = update_face( f(fan(k),:), v2, v1);
      if ~remove
        VT(v2, fan(k)) = 0;
        VT(v1, fan(k)) = 1;
      else
        VT( f(fan(k)), fan(k)) = 0;
      end
      f(fan(k),:) = face;
      removed_faces = removed_faces + remove;
   end
   
   %update v1 neighbours
   for k = 1:numel(v1_p)
       idx1 = valid_pairs(v1_p(k), 1);
       idx2 = valid_pairs(v1_p(k), 2);
       [cost, v_new] = comput_cost(reshape(Q(idx1,:,:), 4,4), reshape(Q(idx2,:,:), 4,4));
       %to update, one needs first to remove the element
       pq_push(pq, v1_p(k), realmax);
       pq_pop(pq);
       pq_push(pq, v1_p(k), cost);
   end
   
   %remove triangles containing v1 and v2
   v1_n = find(C(v1,:));
   v2_n = find(C(v2,:));
   toRemowe = v2_n(ismember(v2_n, v1_n));
       
   for n = 1:size(toRemowe, 2)
       pid = v2_p(ismember(v2_p, find(pair_table(toRemowe(n),:))));
       pq_push(pq, pid(1), realmax);
       [s,d] = pq_pop(pq);
       pair_table(valid_pairs(pid(1),1) ,pid(1)) = 0;
       pair_table(valid_pairs(pid(1),2) ,pid(1)) = 0;
       C(valid_pairs(pid(1),1), valid_pairs(pid(1),2)) = 0;
       C(valid_pairs(pid(1),2), valid_pairs(pid(1),1)) = 0;
   end
       
   %update v2 neighbours
   toUpdate = v2_n(~ismember(v2_n, v1_n));  %lista vierzcholkow
   for k = 1:size(toUpdate, 2)
       pid = v2_p(ismember(v2_p, find(pair_table(toUpdate(k),:))));
       %the second vertex of the pair
       idx2 = toUpdate(k);
       cost = comput_cost(reshape(Q(v1,:,:), 4,4), reshape(Q(idx2,:,:), 4,4));
       %to update, one needs first to remove the element
       pq_push(pq, pid(1), realmax);
       pq_pop(pq);
       pq_push(pq, pid(1), cost);
       %reconnect pair, we remove v2
       pair_table(v1, pid(1)) = 1;
       pair_table(v2, pid(1)) = 0;
       C(v1, idx2) = 1;
       C(idx2, v1) = 1;
       C(idx2, v2) = 0;
       C(v2, idx2) = 0;
       valid_pairs(pid(1), 1) = idx2;
       valid_pairs(pid(1), 2) = v1;
   end
end
[v, f] = reconstruct(v, f, size(f, 1) - removed_faces, size(v, 1));

figure, plotmesh(v,f);
rzview('on')
pq_delete(pq);