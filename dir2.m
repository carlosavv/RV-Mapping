function [files] = dir2(loc)

f_temp = dir(loc);

len = length(f_temp);
ind = ones(1, len);

for i = 1:len
    if f_temp(i).name == "." || f_temp(i).name == ".." || f_temp(i).name == ".DS_Store" || f_temp(i).name == ".mat files"
        ind(i) = 0;
    end
end

files = f_temp(boolean(ind));
end