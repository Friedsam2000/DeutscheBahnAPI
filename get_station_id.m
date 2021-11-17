function station_id = get_station_id(city)
    options = weboptions('ContentType','json');
    url_stations = ['https://api.deutschebahn.com/freeplan/v1/location/' city];
    station_data_struct = webread(url_stations,options);
    station_data_cell = struct2cell(station_data_struct);
    index_correct_station = find(contains(station_data_cell(1,:),city));
    station_id = station_data_struct(index_correct_station).id;
end