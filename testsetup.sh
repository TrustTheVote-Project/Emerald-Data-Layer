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
curl -d '{"name": "Republican", "color": "#FF3333", "abbreviation": "REP"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"name": "Democratic", "color": "#0000FF", "abbreviation": "DEM"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"name": "Libertarian", "color": "#DCB732", "abbreviation": "LIB"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"name": "Green", "color": "#0BDA51", "abbreviation": "GRN"}' 'http://localhost:3000/api/v1/parties/create' -H Content-Type:application/json
echo "\n"
curl -d '{"scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "date_month": "11", "date_day": "6", "date_year": "2015", "end_date_month": "11", "end_date_day": "6", "end_date_year": "2015", "name": "November Primary", "election_type": "primary"}' 'http://localhost:3000/api/v1/elections/create' -H Content-Type:application/json
echo "\n"
curl -d '{"election_scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "date_month": "11", "date_day": "6", "date_year": "2015", "name": "TestName", "jurisdiction_scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "abbreviation": "TestAbbreviation", "ballot_title": "TestBallotTitle", "ballot_subtitle": "TestBallotSubtitle", "ballot_measure_type": "ballotmeasure", "sequence_order": "0", "pro_statement": "TestPro", "con_statement": "TestCon", "passage_threshold": "60%", "full_text": "Test Full Text", "summary_text": "Test Summary Text", "effect_of_abstain": "Test Abstain Effect"}' 'http://localhost:3000/api/v1/ballot_measure_contests/create' -H Content-Type:application/json
echo "\n"
curl -d '{"contest_object_id": "contest:TestName-election:ocd-division/country:us/state:tx/cd:35-11/6/2015", "selection":"yes"}' 'http://localhost:3000/api/v1/ballot_measure_selections/create' -H Content-Type:application/json
echo "\n"
curl -d '{"contest_object_id": "contest:TestName-election:ocd-division/country:us/state:tx/cd:35-11/6/2015", "selection":"No"}' 'http://localhost:3000/api/v1/ballot_measure_selections/create' -H Content-Type:application/json
echo "\n"
curl -d '{"election_scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "date_month": "11", "date_day": "6", "date_year": "2015", "ballot_name": "Lloyd Doggett", "full_name": "Lloyd Doggett", "party_object_id": "party:Democratic", "first_name": "Lloyd", "middle_name": "Alton", "last_name": "Doggett", "prefix": "", "suffix": "II", "profession": "Attorney"}' 'http://localhost:3000/api/v1/candidates/create' -H Content-Type:application/json
echo "\n"
curl -d '{"full_name": "Susan Narvaiz", "first_name": "Susan", "middle_name": "Lea Clifford", "last_name": "Narvaiz", "prefix": "", "suffix": "", "profession": "CEO"}' 'http://localhost:3000/api/v1/people/create' -H Content-Type:application/json
echo "\n"
curl -d '{"election_scope_ocdid": "ocd-division/country:us/state:tx/cd:35", "date_month": "11", "date_day": "6", "date_year": "2015", "ballot_name": "Susan Narvaiz", "full_name": "Susan Narvaiz", "party_object_id": "party:Republican", "first_name": "Susan", "middle_name": "LeaClifford", "last_name": "Narvaiz", "prefix": "", "suffix": "", "profession": "CEO"}' 'http://localhost:3000/api/v1/candidates/create' -H Content-Type:application/json