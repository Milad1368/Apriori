clc
clear

T = readtable('Bestbuy.xlsx'); % Reading the data file 
Ta = table2cell(T);  % converting from table to cell
Ta(:,1) = [];  

Tr = string(Ta);  % Converting to string array
Tr = Tr';

B = convertStringsToChars(Tr);
Tr_new = [];

% Removing "," from the items 
for i = 1:length(Tr)
    s = B{i};
    s(regexp(s,'[,]')) = [];
    ss = convertCharsToStrings(s);
    Tr_new = [Tr_new ss];
end

Tr = [];
Tr = Tr_new;

%B = convertCharsToStrings(A)

prompt1 = 'Please input your minimum support: ';
prompt2 = 'Please input your minimum confidence: ';
supp_min = input(prompt1);
conf_min = input(prompt2);


%%
cc = {}; % An empty cell for saving the frequent items 
jo = join(Tr);
sp = split(jo);
un_1 = unique(sp); %unique items 

un_1_count = zeros(1,length(un_1)); 
a = [];

% one-item sets
for i = 1:length(un_1)
    for j = 1:length(Tr)
      a(j) = contains(Tr(j),un_1(i));
    end
    un_1_count(i) = sum(a);
    a = [];
end

supp_1 = 100*un_1_count/length(Tr);
i = find(supp_1<supp_min);
un_1_new = un_1;
un_1_new(i) = [];
un_1_count(i) = [];

disp('Frequent Items: ')
items_1 = [un_1_new 100*un_1_count'/length(Tr)] % 1-item sets after deleting non-frequent items

cc{1} = items_1; 

k = 2; % This is for k-item sets 

while 1
   
    cmb = nchoosek(1:length(un_1_new),k); % Finding all the k-item combinations in an n item set
    un_k = un_1_new(cmb);
    
    un_k_c = zeros(1,length(un_k));
    
    for i = 1:length(un_k)
        for j = 1:length(Tr)
            c = contains(split(Tr(j)),un_k(i,:));
            if sum(c)==k
                un_k_c(i) = un_k_c(i) + 1;
            end
        end
    end
    
    supp = 100*un_k_c/length(Tr);
    i = find(supp<supp_min); % checking the min-support requirement 
    un_k_new = un_k;
    un_k_new(i,:) = [];
    un_k_c(i) = [];

    items_k = [un_k_new 100*un_k_c'/length(Tr)]
    
    if isempty(items_k)
        break
    end
    
    cc{k} = items_k;
    k = k + 1;
end

disp('Done!');

% Association rules 

%% Association rules for 2-item sets
rule_1 = [cc{2}(:,1) cc{2}(:,2) cc{2}(:,3)];
rule_2 = [cc{2}(:,2) cc{2}(:,1) cc{2}(:,3)];

k = 2;
c1 = [];
c2 = [];

for i = 1:length(cc{k})
    c1(i) = 100*str2num(cc{k}(i,k+1))/str2num(cc{k-1}(find(cc{k-1}==cc{k}(i)),k));
    c2(i) = 100*str2num(cc{k}(i,k+1))/str2num(cc{k-1}(find(cc{k-1}==cc{k}(i,k)),k));
end

c11 = find(c1>=conf_min);
c22 = find(c2>=conf_min);

disp('Association rules for 2-item sets with corresponding confidences. The rules are from right to left')
r1 = [rule_1(c11',:) c1(c11)'];
for i = 1:length(r1)
    formatSpec = '%s --> %s   Support:%4.2f   Confidence:%4.2f \n';
    fprintf(formatSpec,r1(i,1),r1(i,2),r1(i,3),r1(i,4));  
end

disp('==================================================================')
disp('==================================================================')
disp('==================================================================')

r2 = [rule_2(c22',:) c2(c22)'];
for i = 1:length(r2)
    formatSpec = '%s --> %s   Support:%4.2f   Confidence:%4.2f \n';
    fprintf(formatSpec,r2(i,1),r2(i,2),r2(i,3),r2(i,4));  
end

%% Association rules for 3-item sets
% rule_1 = [cc{3}(:,1) cc{3}(:,2) cc{3}(:,3) cc{3}(:,4)];
% rule_2 = [cc{3}(:,1) cc{3}(:,3) cc{3}(:,2) cc{3}(:,4)];
% rule_3 = [cc{3}(:,2) cc{3}(:,3) cc{3}(:,1) cc{3}(:,4)];
% 
% k = 3;
% c1 = [];
% c2 = [];
% c3 = [];
% c = [];
% for j = 1:length(cc{k-1})
%     for i = 1:length(cc{k})
%         a12 = strcmp(cc{k-1}(j,1:2),cc{k}(i,1:2));
%         if sum(a12) == 2
%            c(i) = 100*str2double(cc{k}(i,k+1))/str2double(cc{k-1}(j,3)); 
%         end
%         
%         
%         a13 = strcmp(cc{k-1}(j,1:2),[cc{k}(i,1) cc{k}(i,3)]);
%         a23 = strcmp(cc{k-1}(j,1:2),cc{k}(i,2:3));
%     end
% end
%     
% 
% for i = 1:length(cc{k})
%     a = strcmp(cc{k-1}(i,1:2),cc{k}(i,1:2));
%     
%     c1(i) = 100*str2double(cc{k}(i,k+1))/str2double(cc{k-1}(find(cc{k-1}==cc{k}(i)),k));
%     
%     c2(i) = 100*str2double(cc{k}(i,k+1))/str2double(cc{k-1}(find(cc{k-1}==cc{k}(i,k)),k));
%     c3(i) = 100*str2double(cc{k}(i,k+1))/str2double(cc{k-1}(find(cc{k-1}==cc{k}(i,k)),k));
% end














