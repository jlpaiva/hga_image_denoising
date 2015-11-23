function pop = arrangePop(pop, desc)

pop = nestedSortStruct(pop, 'fitness');

if(nargin > 1)
    if(desc)
        pop = fliplr(pop);
    end
end

end