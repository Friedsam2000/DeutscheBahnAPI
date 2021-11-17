function found_trains = get_arrivals_in_y_from_x(departStation,arrivalStation,arrivalDate,arrivalTime)
%NEXTTRAIN Outputs the arrival and departure time of the next train between two certain stations
%   departStation:      string, Name of depearture station
%   arriveStation:      string, Name of arrival station
%   arrivalDate:        string ('yyyy-mm-dd')
%   arrivalTime:        string ('hh:mm')


%% Select Output Format

format = weboptions('ContentType','json');
format.Timeout = 10;


%% Get Station-ID of the Arrival Station
arrivalStation_id = get_station_id(arrivalStation);

%% Call Arrival Board

    url_arrival             = convertCharsToStrings(['https://api.deutschebahn.com/freeplan/v1/arrivalBoard/', num2str(arrivalStation_id), '?date=', arrivalDate, 'T', arrivalTime]);
    arrivals                = webread(url_arrival, format);             % Returns struct containing the origin and train-id of the next 20 arriving trains


%     url_departures             = convertCharsToStrings(['https://api.deutschebahn.com/freeplan/v1/departureBoard/', num2str(departStation_id), '?date=', departureDate, 'T', departureTime]);
%     departures                = webread(url_departures, format);             % Returns struct containing the origin and train-id of the next 20 departuring trains


        % Make sure that the arrival board returns a struct (API-Bug)
        if iscell(arrivals) == true
            arrivals = arrivals{1};
        end

        % Compare the origin of each train until it matches the departStation
        rows = get_rows_with_matching_col(arrivals,departStation,7);
        if isempty(rows)||sum(isnan(rows))
            disp('no train found');
            trains_found = 0;
        else
            trains_found = length(rows);
        end


        % Store necessary output information: train name, arrival station and arrival time
        arrivals_cell = struct2cell(arrivals);

        for i = 1:trains_found
           found_trains(i).name = arrivals_cell(1,rows(i));
           found_trains(i).stopName = arrivals_cell(5,rows(i));
           found_trains(i).arrivalTime = arrivals_cell(6,rows(i));
           found_trains_size = size(found_trains);
        end
        


end

