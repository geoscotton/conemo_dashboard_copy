var timezone = jstz.determine().name();

document.cookie = 'time_zone=' + timezone + ';';