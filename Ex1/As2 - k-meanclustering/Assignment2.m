path = 'E:\TU_Andi/Computervision/mm.jpg';
K = 5; % number of clusters
D = 5; % 3 or 5
r = []; %mapping of the points to the clusters
J_old = inf; %initial value of J_old, have been bigger then the start value of J
J = 10;
epsilon = 2; %

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
            my_k(i,1) = img(my_kx(i),my_ky(i),1);
            my_k(i,2) = img(my_kx(i),my_ky(i),2);
            my_k(i,3) = img(my_kx(i),my_ky(i),3);
            my_k(i,4) = my_kx(i)/dim(1); %normalize the position [0,1]
            my_k(i,5) = my_ky(i)/dim(2); % same here
    end
end

%wird ein cluster 0 nimmt man aus einem Cluster den Punkt, der am
%weitesten vom Centroid entfernt ist als neuen Clustercentroid

while abs(J_old - J) > epsilon 

    J_old = J;

    data = []; %stores the currend data information
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
            
            mindist = inf; % initial minimal distance is infinity
            index = 0; %initial index of the centroid with minimal distance is 0 to detect problems
            for k = 1:1:K
                %dist(pos) = (pdist([data(pos,:);my_k(k,:)],'euclidean'))^2;
                %dist(pos,k) = (pdist([data;my_k(k,:)],'euclidean'))^2;
                dist(pos,k) = sum((data - my_k(k,:)).^2);
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
    if abs(J_old - J) <= epsilon %breaking condition of the main loop
        break
    end
    
    for k = 1:1:K
        if norm(k) == 0 %cluster has no elements
            [dex,e] = max(dist(:));
            in_k = fix(e/(dim(1)*dim(2)))+1; %in what cluster is the maximum
            exaktpos = mod(e,dim(1)*dim(2)); %position in the cluster
            new_y = fix(exaktpos/dim(1))+1; %y-coordinate in the imige
            new_x = mod(exaktpos ,dim(1)); %x-coordinate in the image
            
            %set the new parameters of my_k (k)
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

image(img);
hold on;
%drawing loop
for i = 1:1:dim(1)
        for j = 1:1:dim(2)
            pos = (i-1)*dim(2)+j;
            if i == 1 || i == dim(1) || j == 1|| j == dim(2)
                %plot(j,i,'b.');
                [val,dex] = max(r(pos,:)); 
                plot(j,i,'*','Color',[1-my_k(dex,1) 1-my_k(dex,2) 1-my_k(dex,3)]);
            else
                if any(r(pos,:) == r(pos+1,:) == 0) || any(r(pos-1,:) == r(pos,:) == 0) || any(r(pos,:) == r(pos-dim(2),:) == 0) || any(r(pos,:) == r(pos+dim(2),:) == 0);
                    %plot(j,i,'b.');
                    [val,dex] = max(r(pos,:)); 
                    plot(j,i,'*','Color',[1-my_k(dex,1) 1-my_k(dex,2) 1-my_k(dex,3)]);
                end
            end
        end
end
if D == 5
    for i = 1:1:K
        plot(my_k(i,5)*dim(2),my_k(i,4)*dim(1),'o','Color',[1-my_k(i,1) 1-my_k(i,2) 1-my_k(i,3)]);
    end
end
hold off;