'use strict';

var child_process = require('child_process');
var fs = require('fs');
var path = require('path');

var psTree = require('ps-tree');

var last = Date.now();
var buildAndRun = null;

function doBuildAndRun() {
	console.log('do sass build');
	if (buildAndRun !== null && buildAndRun.kill) {
		console.log('kill');
		psTree(buildAndRun.pid, function(err, children) {
			var pids = [ buildAndRun.pid ];

			if (err) {
				console.error(err);
			} else {
				children.map(function(proc) {
					return proc.PID;
				}).forEach(function(pid) {
					pids.push(pid);
				});
			}

			pids.forEach(function(pid) {
				console.log('kill pid: ', pid);
				try {
					process.kill(pid, 'SIGKILL');
				} catch(e) {
					console.error(e);
				}
			});

			buildAndRun = child_process.spawn('npm', ['run', 'build-sass'], {
				detatched: true,
				cwd: path.dirname(__dirname),
				stdio: 'inherit',
			});
		});
	} else {
		buildAndRun = child_process.spawn('npm', ['run', 'build-sass'], {
			cwd: path.dirname(__dirname),
			stdio: 'inherit',
		});
	}
}

function hasBeenSomeTime() {
	return Math.abs(last - Date.now()) > 500;
}

function watchTheRightStuff() {
	var pathsToWatch = [
		path.join(path.dirname(__dirname), 'client/stylesheets')
	];

	pathsToWatch.forEach(function(pathToWatch) {
		watch(pathToWatch);
	});
}

function watch(pathToWatch) {
	fs.watch(pathToWatch, {recursive: true}, function() {
		if (hasBeenSomeTime()) {
			doBuildAndRun();
		}
		last = Date.now();
	});
}

module.exports = () => {
	doBuildAndRun();
	watchTheRightStuff();
};
