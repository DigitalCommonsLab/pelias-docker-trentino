var fs = require('fs');
var path = require('path');
var _ = require('lodash');
var csvParse = require('csv-parse');
var csvGenerate = require('csv-generate')

var through = require('through2');
var wkx = require('wkx');
var geoUtils = require('geojson-utils');
//	https://github.com/pelias/csv-importer/blob/0f1ffa85730bfe644690db39501f3ec0a0e404d6/lib/streams/recordStream.js

const columnGeom = 'WKT';

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
    
    console.log(geoj);

    let point = centroid(geoj);

    console.log(point);

	delete row[ columnGeom ];

	row['lat'] = point.lat;
	row['lon'] = point.lon;

    //console.log('ROW COORDS',coords)

    return _.values(row).join(',')+"\n";
}

function createRecordStream( filePath ) {

	var csvPar = csvGenerate({
		trim: true,
		skip_empty_lines: true,
		relax_column_count: true,
		relax: true,
		columns: true
	});

	var csvGen = csvGenerate({
		columns: ['lat', 'lon'],
		length: 2
	})
	.pipe(process.stdout)

  let uid = 0;
  var docStream = through.obj(
    function write( record, enc, next ){
      const recDoc = processRecord(record);
      uid++;

      if (recDoc) {
        this.push( recDoc );
      }

      next();
    }
  );

  return fs.createReadStream( filePath )
    .pipe( csvPar )
    .pipe( docStream );
}

const fileIn = process.argv[2];		//csv file input

if( fs.existsSync(fileIn) ) {
  createRecordStream(fileIn).pipe(process.stdout);
}
/*stream.on('data', function(d) {
  process.stdout.write(d);
})
.on('end', function(e) {
	console.log('end',e)
});*/