# geolite2-import
This is a little script I created to import and normalize cities data from Maxmind's Geolite 2 data dump into a MySQL database

## Instructions
- Pull the *GeoLite2 City* data dump from here: https://dev.maxmind.com/geoip/geoip2/geolite2/
- MySQL may have issues trying to read the data dump in Linux, so after extracting the files, copy GeoLite2-City-Locations-en.csv over into your "/tmp" directory--this will allow Workbench or MySQL client to access the file.
- Run the SQL instructions in the *import-geolite2-cities.sql* file

That should be it. Modify as you like and have fun!
