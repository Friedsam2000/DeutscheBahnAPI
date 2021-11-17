function [time_string, date_string] = convert_date_to_string(date)

    Minutes = date.Minute;
    Hours = date.Hour;
    if Minutes < 10
       Minutes_string = ['0',num2str(Minutes)];
    else
       Minutes_string = num2str(Minutes);
    end

    if Hours < 10
       Hours_string = ['0',num2str(Hours)];
    else
      Hours_string = num2str(Hours);
    end


    time_string = [Hours_string,':',Minutes_string];
    date_string = [num2str(date.Year),'-',num2str(date.Month),'-',num2str(date.Day)];
    

end
