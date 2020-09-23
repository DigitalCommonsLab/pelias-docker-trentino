
const fs = require('fs');
const path = require('path');
const _ = require('lodash');

const csv = require('csv-parse');
const through = require('through2');
const polyline = require('@mapbox/polyline');
const wkx = require('wkx');
//	https://github.com/pelias/csv-importer/blob/0f1ffa85730bfe644690db39501f3ec0a0e404d6/lib/streams/recordStream.js

const columnGeom = 'WKT';
const columnName = 'street';

function processRecord(row) {

    //let geom = row[ columnGeom ].match(/LINESTRING \((.*)\)/);
    let wkt = row[ columnGeom ];
    
    if(!_.isString(wkt)){
      console.warn("EMPTY GEOMETRY...", row)
      return null;
    }

    let geom = wkx.Geometry.parse(wkt);
    let geoj = geom.toGeoJSON();
    let coords = geoj.coordinates;
    
    let enc = polyline.encode(coords),
    	name = row[ columnName ];

    return enc+"\0"+name+"\n";
}

function createRecordStream( filePath ) {

  var csvParser = csv({
    trim: true,
    skip_empty_lines: true,
    relax_column_count: true,
    relax: true,
    columns: true
  });

  let uid = 0;
  var docStream = through.obj(
    function write( record, enc, next ) {

      const recDoc = processRecord(record);
      uid++;

      if (recDoc) {
        this.push( recDoc );
      }
      else


      next();
    }
  );

  return fs.createReadStream( filePath )
    .pipe( csvParser )
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