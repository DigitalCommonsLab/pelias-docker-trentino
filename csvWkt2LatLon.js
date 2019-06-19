const fs = require('fs');
const path = require('path');
const _ = require('lodash');

const csvParse = require('csv-parse');
const csvWrite = require('csv-write-stream');

const through = require('through2');
const wkx = require('wkx');
const geoUtils = require('geojson-utils');
//	https://github.com/pelias/csv-importer/blob/0f1ffa85730bfe644690db39501f3ec0a0e404d6/lib/streams/recordStream.js

const columnGeom = 'WKT';
const columnLat = 'LAT';
const columnLon = 'LON';

function centroid(geom) {
	
	var ll, cen;

	if(geom.type==="Point") {
		ll = geom.coordinates;
	}
	else if(geom.type==="MultiPoint") {
		ll = geom.coordinates[0];
		//TODO intersect multiple centers of polygons
	}
	else 
	{
		if(geom.type==="Polygon") {
			cc = geom.coordinates;
		}
		else if(geom.type==="MultiPolygon") {
			cc = geom.coordinates[0];
			//TODO intersect multiple centers of polygons
		}
		else if(geom.type==="LineString") {
			cc = [geom.coordinates];
			//TODO point in polyline
		}
		else if(geom.type==="MultiLineString") {
			cc = [geom.coordinates[0]];
			//TODO point in polyline
		}
		else {
			console.warn('Core: L.Util.geo.centroid() geometry not supported',geom.type)
			return null;
		}

		cen = geoUtils.centroid({coordinates: cc});

		ll = cen.coordinates;
	}

	return {lat: ll[1], lon: ll[0] };
}

function processRecord(row) {

    let wkt = row[ columnGeom ];

    let geom =  wkx.Geometry.parse(wkt);

    let geoj = geom.toGeoJSON();
    
    //console.log(geoj);

    let point = centroid(geoj);

    //console.log(point);

	delete row[ columnGeom ];

	row[ columnLat ] = point.lat;
	row[ columnLon ] = point.lon;

    return row;
}

function createRecordStream(fileIn) {

	var csvP = csvParse({
		trim: true,
		skip_empty_lines: true,
		relax_column_count: true,
		relax: true,
		columns: true
	});

	var csvW = csvWrite({
		separator: ',',
		newline: "\n",
		headers: undefined,
		sendHeaders: true
	});

	csvW.pipe(process.stdout);

	let obj,head,row,uid=0;

	var docStream = through.obj(function(record, enc, next ) {

		obj = processRecord(record);

/*		if(uid===0) {
			head = _.keys(obj).join(',')+"\n";
			this.push(head);
		}
		
		row = _.values(obj).join(',')+"\n";

		this.push(row);*/
		
		csvW.write(obj);

		uid++;

		next();
	});

	fs.createReadStream(fileIn)
		.pipe(csvP)
		.pipe(docStream);
	
	//csvW.write({hello: "world", foo: "bar", baz: "taco"})
	//csvW.end()

}

/*
const transf = transform(function(record, callback){
	setTimeout(function() {
console.log(record)
		callback(null, );

	}, 500)
}, {
  parallel: 5
})*/

const fileIn = process.argv[2];		//csv file input

if(fs.existsSync(fileIn))
	createRecordStream(fileIn);

/*stream.on('data', function(d) {
  process.stdout.write(d);
})
.on('end', function(e) {
	console.log('end',e)
});*/