var fs = require( 'fs' );
var path = require( 'path' );
var _ = require( 'lodash' );

var csv = require('csv-parse');
var through = require('through2');
var polyline = require('polyline');

//	https://github.com/pelias/csv-importer/blob/0f1ffa85730bfe644690db39501f3ec0a0e404d6/lib/streams/recordStream.js

function processRecord(row, next_uid, stats) {
 
 //	console.log('processRecord',row);
    
    let geom = row.geom.match(/LINESTRING \((.*)\)/);
    
    //console.log(geom[1]);

    let coords = geom[1].split(',').map(function(t) {
      return t.split(' ').map(parseFloat);
    });
    
    let enc = polyline.encode(coords);

    //console.log('ROW COORDS',coords)

    return enc+"\0"+row.name+"\n";
}

function createRecordStream( filePath, dirPath ) {

  var csvParser = csv({
    trim: true,
    skip_empty_lines: true,
    relax_column_count: true,
    relax: true,
    columns: true
  });

  let uid = 0;
  var docStream = through.obj(
    function write( record, enc, next ){
      const recDoc = processRecord(record, uid);
      uid++;

      if (recDoc) {
        this.push( recDoc );
      }

      next();
    }
  );

  return fs.createReadStream( filePath )
    .pipe( csvParser )
    .pipe( docStream );
}

if( fs.existsSync(process.argv[2]) ) {
  createRecordStream(process.argv[2]).pipe(process.stdout);
}
/*stream.on('data', function(d) {
  process.stdout.write(d);
})
.on('end', function(e) {
	console.log('end',e)
});*/