function found_trains = get_departures_in_x(departStation,departureDate,departureTime)
%NEXTTRAIN Outputs the arrival and departure time of the next train between two certain stations
%   departStation:      string, Name of depearture station
%   arriveStation:      string, Name of arrival station
%   arrivalDate:        string ('yyyy-mm-dd')
%   arrivalTime:        string ('hh:mm')


%% Select Output Format

format = weboptions('ContentType','json');
format.Timeout = 10;


%% Get Station-ID of the Arrival Station
departStation_id = get_station_id(departStation);


%% Call Arrival Board

    url_departures             = convertCharsToStrings(['https://api.deutschebahn.com/freeplan/v1/departureBoard/', num2str(departStation_id), '?date=', departureDate, 'T', departureTime]);
    departures                = webread(url_departures, format);             % Returns struct containing the origin and train-id of the next 20 departuring trains


        % Make sure that the arrival board returns a struct (API-Bug)
        if iscell(departures) == true
            departures = departures{1};
        end
        

                % Store necessary output information: train name, arrival station and arrival time
                
        departures_cell = struct2cell(departures);
        departures_size = size(departures);

        for i = 1:departures_size(1)
           found_trains(i).name = departures_cell(1,i);
           found_trains(i).stopName = departures_cell(5,i);
           found_trains(i).departureTime = departures_cell(6,i);
           found_trains_size = size(found_trains);
        end
        


        


end

