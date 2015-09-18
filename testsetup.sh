# Script to run to just fill up the DB with objects
# Testing script will be separate


curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101", "spatial_format": "kml"}' 'http://localhost:3000/api/v1/precincts/create_combined' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:102", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 102", "spatial_format": "kml"}' 'http://localhost:3000/api/v1/precincts/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-A", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101-A", "spatial_format": "kml"}' 'http://localhost:3000/api/v1/precincts/create_split' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-B", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101-B", "spatial_format": "kml"}' 'http://localhost:3000/api/v1/precincts/create_split' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "composing_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-A"}' 'http://localhost:3000/api/v1/precincts/attach_precinct' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "composing_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-B"}' 'http://localhost:3000/api/v1/precincts/attach_precinct' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35", "spatialextent": {"filename": "myfile.kml"}, "name": "District 35, Congressional", "spatial_format": "kml"}' 'http://localhost:3000/api/v1/districts/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35", "precinct_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101"}' 'http://localhost:3000/api/v1/districts/attach_precinct' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx", "name": "State of Texas", "unit_type": "state"}' 'http://localhost:3000/api/v1/jurisdictions/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx/county:travis", "name": "Travis County", "unit_type": "county"}' 'http://localhost:3000/api/v1/jurisdictions/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx", "child_ocdid": "ocd-division/country:us/state:tx/county:travis"}' 'http://localhost:3000/api/v1/jurisdictions/attach' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx/county:travis", "child_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101"}' 'http://localhost:3000/api/v1/jurisdictions/attach' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "ocd-division/country:us/state:tx/county:travis", "child_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:102"}' 'http://localhost:3000/api/v1/jurisdictions/attach' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "party:republican/ocd-division/country:us/state:tx", "name": "Republican", "color": "#FF3333", "abbreviation": "REP"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "party:democratic/ocd-division/country:us/state:tx", "name": "Democratic", "color": "#0000FF", "abbreviation": "DEM"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "party:libertarian/ocd-division/country:us/state:tx", "name": "Libertarian", "color": "#DCB732", "abbreviation": "LIB"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"ocdid": "party:green/ocd-division/country:us/state:tx", "name": "Green", "color": "#0BDA51", "abbreviation": "GRN"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "date_month": "11", "date_day": "6", "date_year": "2015", "name": "November Primary", "election_type": "primary"}' 'http://localhost:3000/api/v1/elections/create' -H Content-Type:application/json