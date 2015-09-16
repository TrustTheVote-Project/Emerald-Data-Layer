# Initial sample usage:

Make sure your database is set up and the app is running

    bundle install
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
  


Districts: 

Create Travis County TX Congressional District 35

    curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35", "spatialextent": {"filename": "myfile.kml"}, "name": "District 35, Congressional"}' 'http://localhost:3000/api/v1/districts/create' -H Content-Type:application/json

Edit Travis Congressional District 35

    curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35", "name": "Congressional District 35"}' 'http://localhost:3000/api/v1/districts/update' -H Content-Type:application/json

List all electoral districts

    curl 'http://localhost:3000/api/v1/districts'

Show details for Travis County TX Congressional District 35

    curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35"}' 'http://localhost:3000/api/v1/districts/read' -H Content-Type:application/json

Attach precinct 101 to Congressional District 35

    curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35", "precinct_ocdid": "ocd-division/country:us/state:ma/county:travis/precinct:101"}' 'http://localhost:3000/api/v1/districts/attach_precinct' -H Content-Type:application/json

List precincts attached to Travis County TX Congressional District 35

    curl -d '{"ocdid": "ocd-division/country:us/state:tx/cd:35"}' 'http://localhost:3000/api/v1/districts/list_precincts' -H Content-Type:application/json


Elections (WIP):

    curl -d '{"scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "name": "November Primary", "election_type": "4", "date_month": "11", "date_day": "16", "date_year": "1995"}' 'http://localhost:3000/api/v1/elections/create' -H Content-Type:application/json

Get all elections:

    curl 'http://localhost:3000/api/v1/elections'

Update election:
    curl -d '{"id": "1", "scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "name": "November Primary", "election_type": "4", "date_month": "11", "date_day": "16", "date_year": "1995"}' 'http://localhost:3000/api/v1/elections/update' -H Content-Type:application/json

Parties:

    Create test party with test OCDID: 

    curl -d '{"ocdid": "/partytest/", "name": "Test Party", "color": "0x00ff00", "abbreviation": "T"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json

    Update party: 

    curl -d '{"ocdid": "/partytest/", "name": "Test Party", "color": "0x00ff00", "abbreviation": "T"}' 'http://localhost:3000/api/v1/parties/update' -H Content-Type:application/json

    Detail party:

    curl -d '{"ocdid": "/partytest/"}' 'http://localhost:3000/api/v1/parties/read' -H Content-Type:application/json

    List all parties: 

    curl 'http://localhost:3000/api/v1/elections'