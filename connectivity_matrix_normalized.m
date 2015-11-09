function [matrix_normalize_sum] = connectivity_matrix_normalized(network_directory,overFlag)
%function connectivity_matrix_normalized(network_directory, overlapFlag )
% Script to plot the connectivity matrix with neonate Data

FigHandle = figure;
set(FigHandle, 'Position', [100, 100,2000, 2000]);

matrix=strcat(network_directory,'/fdt_network_matrix')
waytotal=strcat(network_directory,'/waytotal')
%Read matrix
fdt_network_matrix=importdata(matrix);
waytotal=importdata('/NIRAL/work/danaele/data/neo-0576-1-1-1year/Network_neo-0576-1-1-1year_2/waytotal');

%Get nb of region
N=size(waytotal);
disp('number of region : ')
nb_region=N(1,1)

%Normalize by the sum of each tracts
total_tracts=zeros(nb_region,1);
for k=1:nb_region
    total_tracts(k,1)=sum(fdt_network_matrix(k,:));
end
matrix_normalize_sum=zeros(nb_region,nb_region);
for i=1:nb_region
    matrix_normalize_sum(i,:)=fdt_network_matrix(i,:)/total_tracts(i,1);
end

%Normalize the connectivity matrix by the waytotal
% matrix_normalize_way=zeros(nb_region,nb_region);
% for i=1:nb_region
%     matrix_normalize_way(i,:)=fdt_network_matrix(i,:)/waytotal(i,1);
% end

%%Plot connectivity matrix normalized by waytotal%%
% FigHandle = figure(1);
% set(FigHandle, 'Position', [100, 100,2000, 2000]);
% %Axis
% ax=gca
% %Plot the connectivity matrix
% mat=imagesc(matrix_normalize_way); %# Create a colored plot of the matrix values
% colorbar;
% colormap(flipud(gray));                 %# Change the colormap to gray (so higher values are
%                                     %#   black and lower values are white)
% print_value=0;
% if  print_value==1
%     textStrings = num2str(matrix_normalize_way(:),'%0.4f');  %# Create strings from the matrix values
%     textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
%     [x,y] = meshgrid(1:nb_region);   %# Create x and y coordinates for the strings
%     hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
%                       'HorizontalAlignment','center');
%
%     midValue = mean(get(ax,'CLim'));  %# Get the middle value of the color range
%     textColors = repmat(matrix_normalize_way(:) > midValue,1,3);  %# Choose white or black for the
%                                                   %#   text color of the strings so
%                                                   %#   they can be easily seen over
%                                                   %#   the background color
%     set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% end
%
% title('\bf \fontsize{12} Connectivity matrix of neo-0508 data - with Loopcheck and with Overlapping /normalize by waytotal ')
% ylabel('\bf Seeds')
% xlabel('\bf Targets')
% set(ax,'TickLength',[0.00 0.00]);
% XTicks = get(gca,'XTickLabel')


%%Plot connectivity matrix normalized by sum of each tracts%%
FigHandle = figure(2);
set(FigHandle, 'Position', [100, 100,2000, 2000]);
%Axis
ax=gca
%Plot the connectivity matrix
mat=imagesc(matrix_normalize_sum); %# Create a colored plot of the matrix values
colorbar;
colormap(flipud(gray));                 %# Change the colormap to gray (so higher values are
%#   black and lower values are white)
print_value=0;
if  print_value==1
    textStrings = num2str(matrix_normalize_sum(:),'%0.4f');  %# Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
    [x,y] = meshgrid(1:nb_region);   %# Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
        'HorizontalAlignment','center');
    
    midValue = mean(get(ax,'CLim'));  %# Get the middle value of the color range
    textColors = repmat(matrix_normalize_sum(:) > midValue,1,3);  %# Choose white or black for the
    %#   text color of the strings so
    %#   they can be easily seen over
    %#   the background color
    set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
end

if length(overlapFlag)>1
    title('\bf \fontsize{12} Connectivity matrix of neo-0508 data - with Loopcheck and with Overlapping - normalize by sum ')
else 
    title('\bf \fontsize{12} Connectivity matrix of neo-0508 data - with Loopcheck and without Overlapping - normalize by sum ')
end

ylabel('\bf Seeds')
xlabel('\bf Targets')
set(ax,'TickLength',[0.00 0.00]);
XTicks = get(gca,'XTickLabel')

h=gcf;
set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
textfile_name =strcat(network_directory,'/Matrix_normalized_by_sum_row.txt');
pdf_name = strcat(network_directory , '/Matrix_normalized_by_sum_row_Visualization.pdf');
print(gcf, '-dpdf',pdf_name );
dlmwrite(textfile_name,matrix_normalize_sum,'-append','delimiter',' ','roffset',1)

% %%Total lines%%
% total_line=zeros(nb_region,1);
% for k=1:nb_region
%     for j=1:nb_region
%       total_line(k,1)=total_line(k,1)+matrix_normalize_way(k,j);
%     end
% end
% total_line

end

