function row = get_rows_with_matching_col(struct, match,col)
    cell = struct2cell(struct);
    row = find(contains(cell(col,:), convertCharsToStrings(match)));
end

