clear

current_date = datetime('now');
min_travel_time = 5; %hours
first_possible_arrival_date = current_date + hours(min_travel_time);
first_possible_departure_date = current_date;

arrivals_in_hamburg_from_munich = struct();
arrivals_in_hamburg_from_munich.name = {};
arrivals_in_hamburg_from_munich.stopName = {};
arrivals_in_hamburg_from_munich.arrivalTime = {};
arrivals_in_hamburg_from_munich = arrivals_in_hamburg_from_munich([]);

departures_in_munich = struct();
departures_in_munich.name = {};
departures_in_munich.stopName = {};
departures_in_munich.departureTime = {};
departures_in_munich = departures_in_munich([]);


%Get all arrivals_in_hamburg_from_munich starting from
%first_possible_arrival_date until first_possible_arrival_date + 4h
for i = 1:20
    
    arrival_date = first_possible_arrival_date + minutes(20*i);
    
    [arrival_time_string, arrival_date_string] = convert_date_to_string(arrival_date);
    
    try
        arrivals_in_hamburg_from_munich = [arrivals_in_hamburg_from_munich, get_arrivals_in_y_from_x('München','Hamburg',arrival_date_string, arrival_time_string)];
    catch ME
        if (strcmp(ME.identifier,'MATLAB:unassignedOutputs'))
            disp('No arrivals in hamburg from munich found at time: ');
            disp(arrival_date);
        end
    end
            
    
end

% Get all departures in munich starting from now + 2h
for i = 1:10
    
    departure_date = current_date + minutes(20*i);
    
    [departure_time_string, departure_date_string] = convert_date_to_string(departure_date);
    
    departures_in_munich = [departures_in_munich, get_departures_in_x('München',departure_date_string, departure_time_string)];
    
end

%Duplicate rausfiltern
[~, idx] = unique([arrivals_in_hamburg_from_munich.name].',  'stable');  %stable optional if you don't care about the order.
 arrivals_in_hamburg_from_munich = arrivals_in_hamburg_from_munich(idx);
 
 [~, idx] = unique([departures_in_munich.name].',  'stable');  %stable optional if you don't care about the order.
 departures_in_munich = departures_in_munich(idx);

 clearvars -except departures_in_munich arrivals_in_hamburg_from_munich


 
 train_names_arrivals = vertcat(arrivals_in_hamburg_from_munich.name);
 train_names_departures = vertcat(departures_in_munich.name);
 rows_in_departures = [];
 rows_in_arrivals = [];
     
 for i = 1:length(train_names_arrivals)

     rows_in_departures = [rows_in_departures, find(strcmp(train_names_departures,train_names_arrivals(i)))];
     if ~isempty(find(strcmp(train_names_departures,train_names_arrivals(i))))
        rows_in_arrivals = [rows_in_arrivals, i];
     end
 end

 %Trains in the
 departures_in_munich_to_hamburg = struct2table(departures_in_munich(rows_in_departures));
 arrival_time_in_hamburg = cell2table(vertcat(arrivals_in_hamburg_from_munich(rows_in_arrivals).arrivalTime),'VariableNames',{'ArrivalTime'});
 departures_in_munich_to_hamburg = horzcat(departures_in_munich_to_hamburg,arrival_time_in_hamburg);
 
 departures_in_munich_to_hamburg = sortrows(departures_in_munich_to_hamburg, 'departureTime');

 clearvars -except departures_in_munich_to_hamburg

