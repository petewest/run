var $jq = jQuery.noConflict();
//Have to use $jq alias to save me from decoupling Garmin API from prototype


/**
 * Copyright © 2007 Garmin Ltd. or its subsidiaries.
 *
 * Licensed under the Apache License, Version 2.0 (the 'License')
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @fileoverview GarminDeviceControlDemo Demonstrates Garmin.DeviceControl.
 *
 * @author Michael Bina michael.bina.at.garmin.com
 * @version 1.0
 */
var GarminDeviceControlDemo = Class.create();
GarminDeviceControlDemo.prototype = {

	initialize: function(statusDiv, mapId, keysArray) {
		this.status = $(statusDiv);
		this.factory = null;
		this.keys = keysArray;
		
		this.$activity_table = $jq("#activityListing");
		this.checkbox_prefix = "activity_check_";
		this.progress_prefix = "activity_progress_";
		this.upload_prefix = "activity_upload_";
		this.upload_icon_unknown = "glyphicon glyphicon-question-sign";
		this.upload_icon_pending = "glyphicon glyphicon-transfer";
		this.upload_icon_success = "glyphicon glyphicon-ok-sign";
		this.upload_icon_error = "glyphicon glyphicon-warning-sign";
		this.upload_icon_no = "glyphicon glyphicon-record";
		
		this.queryUploadStatusQueue = null;

		this.findDevicesButton = $("findDevicesButton");
		this.cancelFindDevicesButton = $("cancelFindDevicesButton");
		this.deviceSelect = $("deviceSelect");

		this.fileTypeSelect = $("fileTypeSelect");
		this.readDataButton = $("readDataButton");
		this.cancelReadDataButton = $("cancelReadDataButton");
		this.readTracksText = $("readTracksText");
		this.readRoutesSelect = $("readRoutesSelect");
		this.readTracksSelect = $("readTracksSelect");
		this.readWaypointsSelect = $("readWaypointsSelect");
		this.dataString = $("dataString");
		this.compressedDataString = $("compressedDataString");

		this.progressBar = $("progressBar");
		this.progressBarDisplay = $("progressBarDisplay");

		this.activityListing = $("activityListing");
		this.readSelectedButton = $("readSelectedButton");

		this.checkAllBox = $("checkAllBox"); // Checkbox used to check/select all directory checkboxes.
		this.garminController = null;
		this.intializeController();

		this.activityDirectory = null; // Array of activity ID strings in the directory
		this.activitySelection = null; // Array of selected activity objects in the directory
		this.activityQueue = null; // Queue of activity IDs to sync events
		this.fileTypeRead = this.fileTypeSelect.value;

		if (this.garminController && this.garminController.isPluginInitialized()) {
			this.garminController.findDevices();
		}
	},

	intializeController: function() {
		try {
			this.garminController = new Garmin.DeviceControl();
			this.garminController.register(this);

			if (this.garminController.unlock(this.keys)) {
				this.setStatus("Plug-in initialized.  Find some devices to get started.");
			} else {
				this.setStatus("The plug-in was not unlocked successfully.");
				this.garminController = null;
			}
		} catch (e) {
			this.handleException(e);
		}
	},

	showProgressBar: function() {
		Element.show(this.progressBar);
	},

	hideProgressBar: function() {
		Element.hide(this.progressBar);
	},

	updateProgressBar: function(value) {
		if (value) {
			var percent = (value <= 100) ? value : 100;
			this.progressBarDisplay.style.width = percent + "%";
		}
	},

	onStartFindDevices: function(json) {
		this.setStatus("Looking for connected Garmin devices");
		this.findDevicesButton.disabled = true;
	},

	onFinishFindDevices: function(json) {
		try {
			this.findDevicesButton.disabled = false;
			this.cancelFindDevicesButton.disabled = true;

			if (json.controller.numDevices > 0) {
				var devices = json.controller.getDevices();
				this.setStatus("Found " + devices.length + " devices.");

				this.listDevices(devices);

				this.cancelReadDataButton.onclick = function() {
					this.fileTypeSelect.disabled = false;
					this.readDataButton.disabled = false;
					this.cancelReadDataButton.disabled = true;
					this.hideProgressBar();
					this.garminController.cancelReadFromDevice();
				}.bind(this)

				this.fileTypeSelect.disabled = false;
				this.readDataButton.disabled = false;
				this.readDataButton.onclick = function() {
					this.activities = null;
					this.readTracksSelect.length = 0;
					this.readWaypointsSelect.length = 0;
					this.readRoutesSelect.length = 0;
					this.fileTypeSelect.disabled = true;
					this.readDataButton.disabled = true;
					this.cancelReadDataButton.disabled = false;
					this.showProgressBar();
					this.readSelectedButton.disabled = true;
					this.checkAllBox.disabled = true;
					this._clearActivityListing();

					try {
						// Leave as specific type calls in order to test both generic and specific
						switch (this.fileTypeRead) {
						case Garmin.DeviceControl.FILE_TYPES.gpx:
							this.garminController.readFromDevice();
							break;
						case Garmin.DeviceControl.FILE_TYPES.tcx:
							this.garminController.readHistoryFromFitnessDevice();
							break;
						case Garmin.DeviceControl.FILE_TYPES.crs:
							this.garminController.readCoursesFromFitnessDevice();
							break;
						case Garmin.DeviceControl.FILE_TYPES.tcxDir:
						case Garmin.DeviceControl.FILE_TYPES.crsDir:
							this.garminController.readDataFromDevice(this.fileTypeRead);
							break;
						case Garmin.DeviceControl.FILE_TYPES.wkt:
							this.garminController.readWorkoutsFromFitnessDevice();
							break;
						case Garmin.DeviceControl.FILE_TYPES.tcxProfile:
							this.garminController.readUserProfileFromFitnessDevice();
							break;
						case Garmin.DeviceControl.FILE_TYPES.goals:
							this.garminController.readGoalsFromFitnessDevice();
							break;
						}
					} catch (e) {
						this.handleException(e);
					}

					this.checkAllBox.disabled = false;

				}.bind(this)

				this.readSelectedButton.disabled = true;
				this.readSelectedButton.onclick = function() {

					if (this._directoryHasSelected() == false) {
						alert("At least one activity must be selected before attempting to read.");
					} else {
						this.activities = null;
						this.readTracksSelect.length = 0;
						this.readWaypointsSelect.length = 0;
						this.readRoutesSelect.length = 0;
						this.fileTypeSelect.disabled = true;
						this.readSelectedButton.disabled = true;
						this.cancelReadDataButton.disabled = false;

						this.showProgressBar();

						if (this.fileTypeRead == Garmin.DeviceControl.FILE_TYPES.tcxDir) {
							this.fileTypeRead = Garmin.DeviceControl.FILE_TYPES.tcxDetail;
						} else if (this.fileTypeRead == Garmin.DeviceControl.FILE_TYPES.crsDir) {
							this.fileTypeRead = Garmin.DeviceControl.FILE_TYPES.crsDetail;
						}

						this._populateActivityQueue();

						this._readSelectedActivities();

						this.checkAllBox.disabled = false;
					}
				}.bind(this);

				this.checkAllBox.disabled = true;
				this.checkAllBox.onclick = function() {
					this._checkAllDirectory();
				}.bind(this);

				this.fileTypeSelect.onchange = function() {
					this.fileTypeRead = this.fileTypeSelect.value;
				}.bind(this);

			} else {
				this.setStatus("No devices found.");
				this.deviceInfo.innerHTML = "";
				this._clearHtmlSelect(this.deviceSelect);
				this.deviceSelect.disabled = true;
			}
		} catch (e) {
			this.handleException(e);
		}
	},

	onCancelFindDevices: function(json) {
		this.setStatus("Find cancelled");
	},

	listDevices: function(devices) {
		this._clearHtmlSelect(this.deviceSelect);
		var $device_list = $jq("#list_of_devices");
		for (var i = 0; i < devices.length; i++) {
			var $new_link = $jq('<a>').attr({
				class: 'garmin_device btn btn-default btn-block',
				href: '#'
			}).append(devices[i].getDisplayName());
			$new_link.data("device", devices[i]);
			$new_link.click({
				controller: this
			}, function(event) {
				event.preventDefault();
				//check if we're the currently active device
				if (!$jq(this).hasClass("active")) {
					event.data.controller.select_device($jq(this));
				}
			});
			$device_list.append($jq('<li>').append($new_link));
		}
	},

	select_device: function($dev) {
		var device = $dev.data("device");
		$jq("#activities_header").html("Reading activities from " + device.getDisplayName());
		//remove active styling from all items
		$jq(".garmin_device").removeClass("active");
		//and then add it back to this specific one
		$dev.addClass("active");
		//clear any existing activities
		this.$activity_table.html('<tr><td>Reading activities from device.</td></tr>');
		//Tell the device ID which unit we're looking at:
		this.garminController.setDeviceNumber(device.getNumber());
		//Trigger a directory read of the device
		this.fileTypeRead=Garmin.DeviceControl.FILE_TYPES.tcxDir
		this.garminController.readDataFromDevice(Garmin.DeviceControl.FILE_TYPES.tcxDir);
	},

	onProgressReadFromDevice: function(json) {
		this.updateProgressBar(json.progress.getPercentage());
		this.setStatus(json.progress);
	},

	onCancelReadFromDevice: function(json) {
		this.setStatus("Read cancelled");
	},

	onFinishReadFromDevice: function(json) {
		try {
			this.setStatus("Processing retrieved data...");
			this.fileTypeSelect.disabled = false;
			this.readDataButton.disabled = false;
			this.cancelReadDataButton.disabled = true;
			this.hideProgressBar();
			this.dataString.value = json.controller.gpsDataString;
			this.compressedDataString.value = json.controller.gpsDataStringCompressed;

			// Factory setting for parsing the data into activities if applicable.
			switch (this.fileTypeRead) {
			case Garmin.DeviceControl.FILE_TYPES.gpx:
				this.factory = Garmin.GpxActivityFactory;
				break;
			case Garmin.DeviceControl.FILE_TYPES.tcx:
			case Garmin.DeviceControl.FILE_TYPES.crs:
			case Garmin.DeviceControl.FILE_TYPES.tcxDir:
			case Garmin.DeviceControl.FILE_TYPES.crsDir:
			case Garmin.DeviceControl.FILE_TYPES.tcxDetail:
			case Garmin.DeviceControl.FILE_TYPES.crsDetail:
				this.factory = Garmin.TcxActivityFactory;
				break;
			default:
				// No factory for unsupported type.
				this.factory = null;
				break;
			}

			// parse the data into activities if possible
			if (this.factory != null) {

				// Convert the data obtained from the device into activities.
				// If we're starting a new read session, start a new activities array
				if (this.activities == null) {
					this.activities = new Array();
				}

				// Populate this.activities
				switch (this.fileTypeRead) {
				case Garmin.DeviceControl.FILE_TYPES.crsDir:
				case Garmin.DeviceControl.FILE_TYPES.tcxDir:
					this.activities = this.factory.parseDocument(json.controller.gpsData);

					if (this.activities != null) {
						// If we read a directory, save the directory for the session
						//this._createActivityDirectory();
						this.display_activity_list();
					}
					break;
				case Garmin.DeviceControl.FILE_TYPES.tcxDetail:
				case Garmin.DeviceControl.FILE_TYPES.crsDetail:

					// Store this read activity
					this.activities = this.activities.concat(this.factory.parseDocument(json.controller.gpsData));

					// Not finished with the activity queue
					if (this.activityQueue.length > 0) {
						this._readSelectedActivities();

						// Cleanest way to deal with the js single-thread issue for now.
						// Cutting out to immediately move on to the next activity in the queue before listing.
						return;
					}

					break;
				default:
					this.activities = this.factory.parseDocument(json.controller.gpsData);
					break;
				}
			}

			// Finished reading activities in queue, if any
			if (this.activityQueue == null || this.activityQueue.length == 0) {

				if (this.fileTypeRead != Garmin.DeviceControl.FILE_TYPES.tcxDir && this.fileTypeRead != Garmin.DeviceControl.FILE_TYPES.crsDir) {
					// List the activities (and display on Google Map)
					if (this.activities != null) {
						this.setStatus("Listing activities...");
						var summary = this._listActivities(this.activities);
						this.setStatus(new Template("Results: #{routes} routes, #{tracks} tracks and  #{waypoints} waypoints found").evaluate(summary));
					} else {
						this.setStatus("Finished retrieving data.");
					}
				} else {
					// List the activity directory
					if (this.activities != null) {
						this.setStatus("Listing activity directory...");
						//var summary = this._listDirectory(this.activities);
						//this.setStatus( new Template("Results: #{routes} routes, #{tracks} tracks and  #{waypoints} waypoints found").evaluate(summary) );
					} else {
						this.setStatus("Finished retrieving data.");
					}
				}

				// Disable appropriate buttons after read is finished
				switch (this.fileTypeRead) {
				case Garmin.DeviceControl.FILE_TYPES.gpx:
					break;
				case Garmin.DeviceControl.FILE_TYPES.tcx:
				case Garmin.DeviceControl.FILE_TYPES.crs:
					// Display the track selected by default, if there is one.
					if (this.readTracksSelect.onchange) {
						this.readTracksSelect.onchange();
					}
					break;
				case Garmin.DeviceControl.FILE_TYPES.tcxDir:
				case Garmin.DeviceControl.FILE_TYPES.crsDir:
					this.readSelectedButton.disabled = false;
					this.checkAllBox.disabled = false;
					break;
				case Garmin.DeviceControl.FILE_TYPES.tcxDetail:
				case Garmin.DeviceControl.FILE_TYPES.crsDetail:
					this.readSelectedButton.disabled = false;
					this.checkAllBox.disabled = false;
					break;
				}
			}

		} catch (e) {
			this.handleException(e);
		}
	},

	/** Reads the user-selected activities from the device by using the activity queue. 
	 */
	_readSelectedActivities: function() {
		// Pop the selected activity off the queue.  (The queue only holds selected activities)
		var currentActivity = this.activityQueue.last();
		this.garminController.readDetailFromDevice(this.fileTypeRead, $(currentActivity).value);
		this.activityQueue.pop();
	},

	_clearActivityListing: function() {
		//clear previous data, if any (keep the header).  IE deletes header too...
		while (this.activityListing.rows.length > 0) {
			this.activityListing.deleteRow(0);
		}
	},

	/** Creates the activity directory of all activities on the device
	 * of the user-selected type.  Most recent entries are first.
	 */
	_createActivityDirectory: function() {
		this.activityDirectory = new Array();
		this.activityQueue = new Array(); // Initialized here so that we can detect activity selection read status
		for (var jj = 0; jj < this.activities.length; jj++) {

			this.activityDirectory[jj] = this.activities[jj].getAttribute("activityName");
		}
	},
	display_activity_list: function() {
		var new_activities = '';
		//initialise our query queues
		if (this.queryUploadStatusQueue==null) {
			this.queryUploadStatusQueue=new Array();
		}
		if (this.activityQueue==null) {
			this.activityQueue = new Array();	
		}
		for (var i = 0; i < this.activities.length; i++) {
			var activity = this.activities[i];
			var name = activity.getAttribute("activityName");
			var description = activity.getSummaryValue(Garmin.Activity.SUMMARY_KEYS.startTime).getValue().getDateString() + " (Duration: " + activity.getStartTime().getDurationTo(activity.getEndTime()) + ")";
			//construct the HTML to output for this activity
			new_activities += '<tr>\n<td><input type="checkbox" class="activity_check" disabled=true id="'+ this.checkbox_prefix + i + '" value="' + name + '"/></td>\n';
			new_activities += '<td id="'+this.progress_prefix+i+'">' + description + '</td>\n';
			new_activities += '<td><span id="'+this.upload_prefix+i+'" class="'+this.upload_icon_unknown+'"></span></td>\n</tr>';
			//add it to the query status queue, so we can find out if we've already uploaded this one
			var activity_info={internal_id: i, start_time: name};
			this.queryUploadStatusQueue.push(activity_info);
		}
		this.$activity_table.html(new_activities);
		this._findUploadStatus();
		var controller=this; //set this here so we can use it in the callback function
		//Add event handlers to these items
		$jq("input.activity_check").click(function(event) {
			//var controller = event.data.controller;
			//check to see if we've already processed (or are processing) this item
			if (!this.disabled) {
				this.disabled=true;
				controller.activityQueue.push(this.id);
				alert("process data " + this.value + " for uploading");
			}
		});
	},
	
	// fires off requests to the DB to find out which items have been uploaded
	_findUploadStatus: function() {
		for (var i=0; i<this.queryUploadStatusQueue.length; i++) {
			//fire off a JSON request for each item in the queue
			var controller=this;
			$jq.getJSON("/activity_check",this.queryUploadStatusQueue[i]).done(function(json) {
				var $upload_icon=$jq('#'+controller.upload_prefix+json.internal_id);
				var $checkbox=$jq('#'+controller.checkbox_prefix+json.internal_id);
				$upload_icon.removeClass(controller.upload_icon_unknown);
				//if we get an id value of -1 it means we haven't uploaded this item yet
				if (json.id!=-1){
					$upload_icon.addClass(controller.upload_icon_success);
					//tell the checkbox we've got it
					$checkbox[0].checked=true;
					//and disable it so we don't try again
					//([0] makes it operate direct on the DOM object)
					$checkbox[0].disabled=true;
				} else {
					$upload_icon.addClass(controller.upload_icon_no);
					$checkbox[0].disabled=false;
					$checkbox[0].checked=false;
				}
			});
		}
	},

	/** Creates the activity queue of selected activities.  This should be called
	 * only after the user has finished selecting activities.  The queue
	 * is an Array that is constructed and then reversed to simulate a queue.
	 */
	_populateActivityQueue: function() {

		for (var jj = 0; jj < this.activityDirectory.length; jj++) {

			if ($("activityItemCheckbox" + jj).checked == true) {
				this.activityQueue.push("activityItemCheckbox" + jj);
			}
		}

		// Reverse the array to turn it into a queue
		this.activityQueue.reverse();
	},

	/** Selects all checkboxes in the activity directory, which selects all activities to be read from the device.
	 */
	_checkAllDirectory: function() {
		for (var boxIndex = 0; boxIndex < this.activityDirectory.length; boxIndex++) {
			$("activityItemCheckbox" + boxIndex).checked = this.checkAllBox.checked;
		}
	},

	/** Checks if any activities in directory listing are selected.  Returns true if so, false otherwise.
	 */
	_directoryHasSelected: function() {
		for (var boxIndex = 0; boxIndex < this.activityDirectory.length; boxIndex++) {
			if ($("activityItemCheckbox" + boxIndex).checked == true) {
				return true;
			}
		}

		return false;
	},

	/** Lists the directory and returns summary data (# of tracks). 
	 */
	_listDirectory: function(activities) {
		var numOfRoutes = 0;
		var numOfTracks = 0;
		var numOfWaypoints = 0;

		// clear existing entries
		this._clearHtmlSelect(this.readRoutesSelect);
		this._clearHtmlSelect(this.readTracksSelect);
		this._clearHtmlSelect(this.readWaypointsSelect);

		// loop through each activity
		for (var i = 0; i < activities.length; i++) {
			var activity = activities[i];

			// Directory entry
			if (this.fileTypeRead == Garmin.DeviceControl.FILE_TYPES.tcxDir || this.fileTypeRead == Garmin.DeviceControl.FILE_TYPES.crsDir) {
				this._addToActivityListing(i, activity);
			}

			numOfTracks++;
		}

		return {
			routes: numOfRoutes,
			tracks: numOfTracks,
			waypoints: numOfWaypoints
		};
	},

	/** List activities and display on Google Map when appropriate.
	 */
	_listActivities: function(activities) {
		var numOfRoutes = 0;
		var numOfTracks = 0;
		var numOfWaypoints = 0;

		// clear existing entries
		this._clearHtmlSelect(this.readRoutesSelect);
		this._clearHtmlSelect(this.readTracksSelect);
		this._clearHtmlSelect(this.readWaypointsSelect);

		// loop through each activity
		for (var i = 0; i < activities.length; i++) {
			var activity = activities[i];
			var series = activity.getSeries();

			// loop through each series in the activity
			for (var j = 0; j < series.length; j++) {
				var curSeries = series[j];

				switch (curSeries.getSeriesType()) {
				case Garmin.Series.TYPES.history:
					// activity contains a series of type history, list the track
					this._listTrack(activity, curSeries, i, j);
					numOfTracks++;
					break;
				case Garmin.Series.TYPES.route:
					// activity contains a series of type route, list the route
					this._listRoute(activity, curSeries, i, j);
					numOfRoutes++;
					break;
				case Garmin.Series.TYPES.waypoint:
					// activity contains a series of type waypoint, list the waypoint
					this._listWaypoint(activity, curSeries, i, j);
					numOfWaypoints++;
					break;
				case Garmin.Series.TYPES.course:
					// activity contains a series of type course, list the coursetrack
					this._listCourseTrack(activity, curSeries, i, j);
					numOfTracks++;
					break;
				}
			}
		}

		if (numOfRoutes > 0) {
			this.readRoutesSelect.disabled = false;
			this.displayTrack(this.readRoutesSelect.options[this.readRoutesSelect.selectedIndex].value);
			this.readRoutesSelect.onchange = function() {
				this.displayTrack(this.readRoutesSelect.options[this.readRoutesSelect.selectedIndex].value);
			}.bind(this);
		} else {
			this.readRoutesSelect.disabled = true;
		}

		if (numOfTracks > 0) {
			this.readTracksSelect.disabled = false;
			this.displayTrack(this.readTracksSelect.options[this.readTracksSelect.selectedIndex].value);
			this.readTracksSelect.onchange = function() {
				this.displayTrack(this.readTracksSelect.options[this.readTracksSelect.selectedIndex].value);
			}.bind(this);
		} else {
			this.readTracksSelect.disabled = true;
		}

		if (numOfWaypoints > 0) {
			this.readWaypointsSelect.disabled = false;
			this.displayWaypoint(this.readWaypointsSelect.options[this.readWaypointsSelect.selectedIndex].value);
			this.readWaypointsSelect.onchange = function() {
				this.displayWaypoint(this.readWaypointsSelect.options[this.readWaypointsSelect.selectedIndex].value);
			}.bind(this);
		} else {
			this.readWaypointsSelect.disabled = true;
		}

		return {
			routes: numOfRoutes,
			tracks: numOfTracks,
			waypoints: numOfWaypoints
		};
	},

	/** Load route names into select UI component.
	 * @private
	 */
	_listRoute: function(activity, series, activityIndex, seriesIndex) {
		var routeName = activity.getAttribute(Garmin.Activity.ATTRIBUTE_KEYS.activityName);
		this.readRoutesSelect.options[this.readRoutesSelect.length] = new Option(routeName, activityIndex + "," + seriesIndex);
	},

	/** Load track name into select UI component.
	 * @private
	 */
	_listTrack: function(activity, series, activityIndex, seriesIndex) {
		var startDate = activity.getSummaryValue(Garmin.Activity.SUMMARY_KEYS.startTime).getValue();
		var endDate = activity.getSummaryValue(Garmin.Activity.SUMMARY_KEYS.endTime).getValue();
		var trackName = startDate.getDateString() + " (Duration: " + startDate.getDurationTo(endDate) + ")";
		this.readTracksSelect.options[this.readTracksSelect.length] = new Option(trackName, activityIndex + "," + seriesIndex);
	},

	/** Load track name into select UI component.
	 * @private
	 */
	_listCourseTrack: function(activity, series, activityIndex, seriesIndex) {
		var trackName = activity.getAttribute(Garmin.Activity.ATTRIBUTE_KEYS.activityName);
		this.readTracksSelect.options[this.readTracksSelect.length] = new Option(trackName, activityIndex + "," + seriesIndex);
	},


	/** Load waypoint name into select UI component.
	 * @private
	 */
	_listWaypoint: function(activity, series, activityIndex, seriesIndex) {
		var wptName = activity.getAttribute(Garmin.Activity.ATTRIBUTE_KEYS.activityName);
		this.readWaypointsSelect.options[this.readWaypointsSelect.length] = new Option(wptName, activityIndex + "," + seriesIndex);
	},

	/** Draws a simple line on the map using the Garmin.MapController.
	 * @param {Select} index - value of select widget.
	 */
	displayTrack: function(index) {
		index = index.split(",", 2);
		var activity = this.activities[parseInt(index[0])];
		var series = activity.getSeries()[parseInt(index[1])];

		//this.mc.map.clearOverlays();
		if (series.findNearestValidLocationSample(0, 1) != null) {
			//this.mc.drawTrack(series);
		}
	},

	/** Draws a point (usualy as a thumb tack) on the map using the Garmin.MapController.
	 * @param {Select} index - value of select widget.
	 */
	displayWaypoint: function(index) {
		index = index.split(",", 2);
		var activity = this.activities[parseInt(index[0])];
		var series = activity.getSeries()[parseInt(index[1])];

		this.mc.map.clearOverlays();
		this.mc.drawWaypoint(series);
	},

	/**Sets the size of the select options to zero which essentially clears it from 
	 * any values.
	 * @private
	 */
	_clearHtmlSelect: function(select) {
		if (select) {
			//select.size = 0;
			select.options.size = 0;
		}
	},

	onException: function(json) {
		this.handleException(json.msg);
	},

	handleException: function(error) {
		var msg = error.name + ": " + error.message;
		if (Garmin.PluginUtils.isDeviceErrorXml(error)) {
			msg = Garmin.PluginUtils.getDeviceErrorMessage(error);
		}
		this.setStatus(msg);
		alert(msg);
	},

	setStatus: function(statusText) {
		this.status.innerHTML = statusText;
	}
};
var display;

function find_garmin_devices() {
	display = new GarminDeviceControlDemo("statusText", "readMap",
	["http://run.petewest.org","a640806a0d1262ae4d2b43733773f3f0"]
	);
}
