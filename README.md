# Initial sample usage:

Make sure your database is set up and the app is running

    rake db:migrate
    rails s

Create Precint 101

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101"}' 'http://localhost:3000/api/v1/precincts/create' -H Content-Type:application/json

Create Precinct 102
  
    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:102", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 102"}' 'http://localhost:3000/api/v1/precincts/create' -H Content-Type:application/json

Rename Precinct 102

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:102", "name": "Precinct One Oh Two"}' 'http://localhost:3000/api/v1/precincts/update' -H Content-Type:application/json

Show details for Precinct 102

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:102"}' 'http://localhost:3000/api/v1/precincts/read' -H Content-Type:application/json


Show all Precincts (2)

    curl 'http://localhost:3000/api/v1/precincts'

Create Split Precincts: (101-A and 101-B)

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-A", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101-A"}' 'http://localhost:3000/api/v1/precincts/create' -H Content-Type:application/json

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-B", "spatialextent": {"filename": "myfile.kml"}, "name": "Precinct 101-B"}' 'http://localhost:3000/api/v1/precincts/create' -H Content-Type:application/json


Attach 101-A to Precinct 101

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "composing_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-A"}' 'http://localhost:3000/api/v1/precincts/attach_precinct' -H Content-Type:application/json


Show all splits within 101 (just 101-A)

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101"}' 'http://localhost:3000/api/v1/precincts/list_composing_precincts' -H Content-Type:application/json

Attach 101-B to Precinct 101

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101", "composing_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101-B"}' 'http://localhost:3000/api/v1/precincts/attach_precinct' -H Content-Type:application/json

Show all splits within 101 (2 of them now)

    curl -d '{"ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101"}' 'http://localhost:3000/api/v1/precincts/list_composing_precincts' -H Content-Type:application/json


Show all precincts (4)

    curl 'http://localhost:3000/api/v1/precincts'
  