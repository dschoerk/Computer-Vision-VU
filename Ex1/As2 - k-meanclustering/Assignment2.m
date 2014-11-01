path = 'E:\TU_Andi/Computervision/simple.PNG';
K = 3; % number of clusters
D = 3; % 3 or 5
r = []; %mapping of the points to the clusters
J_old = inf; %initial value of J_old, have been bigger then the start value of J
J = 10;
epsilon = 1; %

% reading the input file
img = imread(path);
img = im2double(img);
dim = size(img);


%random Clusterstartingpoints
my_kx = randperm(dim(1),K);
my_ky = randperm(dim(2),K);
my_k = zeros(K,D);

if D == 3
    for i=1:1:K
            my_k(i,:) = img(my_kx(i),my_ky(i),:);  %only the Colours in 3D
    end
else
    for i=1:1:K %Colours and positions
            my_k(i,1) = my_kx(i)/dim(1); %normalize the position [0,1]
            my_k(i,2) = my_ky(i)/dim(2); % same here
            my_k(i,3) = img(my_kx(i),my_ky(i),1);
            my_k(i,4) = img(my_kx(i),my_ky(i),2);
            my_k(i,5) = img(my_kx(i),my_ky(i),3);
    end
end

%wird ein cluster 0 nimmt man aus einem Cluster den Punkt, der am
%weitesten vom Centroid entfernt ist als neuen Clustercentroid

while abs(J_old - J) > epsilon 

            test = J_old - J
    J_old = J;

    data = [];
    %initialize the matrices
    r = zeros(dim(1)*dim(2),K); %mapping matrix
    sum_k = zeros(K,D); %matrix for the summ of the distances for each cluster
    norm = zeros(1,K);  %vektor for the normalization of the computation for the new my_k  
    dist = zeros(dim(1)*dim(2),K);
    
    pos = 0;
    for i = 1:1:dim(1)
        for j = 1:1:dim(2)
            pos = (i-1)*dim(2)+j;
            %data(pos,:) = img (i,j,:);
            
            %current datapoint
            data(1) = img (i,j,1);
            data(2) = img (i,j,2);
            data(3) = img (i,j,3);
            if D == 5
                data(4) = i/dim(1);
                data(5) = j/dim(2);
            end
            
            mindist = inf;
            index = 0;
            for k = 1:1:K
                %dist(pos) = (pdist([data(pos,:);my_k(k,:)],'euclidean'))^2;
                dist(pos,k) = (pdist([data;my_k(k,:)],'euclidean'))^2;
                if(dist(pos,k) < mindist) %searches for the minimum distance of the datapoint to the clusters
                    mindist = dist(pos,k);
                    index = k;
                end
            end
            r(pos,index) = 1; %r berechnen

            %sum_k(index,:) = sum_k(index,:) + data(pos,:); %for den new my_k
            sum_k(index,:) = sum_k(index,:) + data; %for den new my_k
            norm(index) = norm(index) + 1; %for the normalization
        end
    end
    
    J = sum(sum(dist));
    if abs(J_old - J) <= epsilon
        break
    end
    
    for k = 1:1:K
        if norm(k) == 0 %cluster has no elements
            [dex,e] = max(dist(:));
            in_k = fix(e/(dim(1)*dim(2)))+1; %in what cluster is the maximum
            exaktpos = mod(e,dim(1)*dim(2)); %position in the cluster
            new_y = fix(exaktpos/dim(1))+1; %y-coordinate in the imige
            new_x = mod(exaktpos ,dim(1)); %x-coordinate in the image
            
            my_k(k,1) = img (new_x,new_y,1);
            my_k(k,2) = img (new_x,new_y,2);
            my_k(k,3) = img (new_x,new_y,3);
            if D == 5
                my_k(k,4) = new_y/dim(1);
                my_k(k,5) = new_x/dim(2);
            end
        else
            my_k(k,:) = sum_k(k,:)/norm(k); % compute the new my_k's
        end
    end
    %J = sum(sum(dist));
end