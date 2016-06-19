===============================================================================
Ruby version: 1.9.3

Steps to setup and execute bird service

1) git clone https://github.com/njain153/bird_service.git
2) cd bird_service
3) bundle install
4) bundler exec bin/bird_service start
This should start the bird service at http://localhost:3000
5) You can try following curl commands to test the service
6) to run unit tests, use command: bundler exec rspec spec
7) It would connect with mongodb at localhost, 27017. Separate dbs would get created for development and unit tests i.e bird_development
and bird_test respectively. Please make sure mongodb is up and running for running bird service and unit tests.
===============================================================================


#POST
1) Add bird which is visible
curl -X POST -H Content-Type:application/json --data-binary '{"name":"bird1","family":"pigeon","continents":["aisa","africa"],"added": "2015-19-05", "visible":true}' -v http://localhost:3000/birds/118

2) Add bird which is invisible
curl -X POST -H Content-Type:application/json --data-binary '{"name":"bird2","family":"pigeon","continents":["aisa","africa"],"added": "2015-10-07", "visible":false}' -v http://localhost:3000/birds/119

3) Add bird without date (should be retrieved with current date)
curl -X POST -H Content-Type:application/json --data-binary '{"name":"bird3","family":"pigeon","continents":["aisa","africa"]}' -v http://localhost:3000/birds/120


#GET
curl -X GET -v http://localhost:3000/birds/118


#LIST
curl -X GET -v http://localhost:3000/birds


#REMOVE
curl -X DELETE -v http://localhost:3000/birds/120


#Error validation scenarios
1) no 'name' field in the body
curl -X POST -H Content-Type:application/json --data-binary '{"family":"pigeon","continents":["aisa","africa"],"added": "2016-10-07", "visible":true}' -v http://localhost:3000/birds/150

2) date in wrong format
curl -X POST -H Content-Type:application/json --data-binary '{"name":"bird5", "family":"pigeon","continents":["aisa","africa"],"added": "10-07-2016", "visible":true}' -v http://localhost:3000/birds/150

3) Adding a bird which already exists (ex: id=118)
curl -X POST -H Content-Type:application/json --data-binary '{"name":"bird1","family":"pigeon","continents":["aisa","africa"],"added": "2015-19-05", "visible":true}' -v http://localhost:3000/birds/118

4) Remove non existing bird
curl -X DELETE -v http://localhost:3000/birds/700

5) GET non existing bird
curl -X GET -v http://localhost:3000/birds/700

