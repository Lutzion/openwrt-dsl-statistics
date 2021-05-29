/* 
  Copyright Lutz Hillebrand

  feel free to use for personal use

  use exec.js instead of exec.lua
  
  /www/luci-static/resources/statistics/rrdtool/definitions/exec.js
  instead of
  /usr/lib/lua/luci/statistics/rrdtool/definitions/exec.lua 

  https://github.com/openwrt/luci/issues/3719
  https://forum.openwrt.org/t/luci-statistics-discrete-values-using-putval/79533/2
*/

'use strict';

return L.Class.extend({
    title: _('Exec'),

    rrdargs: function(graph, host, plugin, plugin_instance, dtype) {
	if (plugin_instance == 'dsluptime') {
	    return {
		title: "%H: DSL-Uptime",
		vlabel: " dsluptime",
		number_format: "%8.0lf",
		autoscale_max: true,
		data: {
		    types: [ "gauge", "counter" ]
		}
	    };
	}
	
	if (plugin_instance == 'dsldr') {
	    return {
		title: "%H: DSL-Datarate",
		vlabel: " dsldr",
		number_format: "%8.0lf",
		autoscale_max: true,
		data: {
		    types: [ "gauge" ],
		    options: {
			gauge_downdr: { color: "00ff00", title: "Down DataRate", overlay: true, noarea: false, total: false, flip :true },
			gauge_updr: { color: "0000ff", title: "Up DataRate", overlay: true, noarea: false, total: false, flip : false },
			gauge_downadr: { color: "B0FF00", title: "Down ATTNDR", overlay: true, noarea: true, total: false, flip :true },
			gauge_upadr: { color: "FF00FF", title: "Up ATTNDR", overlay: true, noarea: true, total: false }
		    }
		}
	    };
	}
	
	if (plugin_instance == 'dslsnr') {
	    return {
		title: "%H: DSL-SNR",
		vlabel: " dslsnr",
		number_format: "%8.0lf",
		autoscale_max: true,
		data: {
		    types: [ "gauge" ],
		    options: {
			gauge_down: { color: "00ff00", title: "Down SNR", overlay: true, noarea: false, total: false, flip :true },
			gauge_up: { color: "0000ff", title: "Up SNR", overlay: true, noarea: false, total: false  }
		    }
		}
	    };
	}

	if (plugin_instance == 'dslerr') {
	    return {
		title: "%H: DSL-Errors",
		vlabel: " dslerr",
		number_format: "%8.0lf",
		autoscale_max: true,
		data: {
		    types: [ "gauge" ],
		    options: {
			gauge_loss: { color: "00FF00", title: "LOSS", overlay: true, noarea: true, total: false },
			gauge_uas: { color: "0000FF", title: "UAS", overlay: true, noarea: true, total: false  },
			gauge_f_loss: { color: "FF8000", title: "Far LOSS", overlay: true, noarea: true, total: false, flip :true },
			gauge_f_uas: { color: "FF00FF", title: "Far UAS", overlay: true, noarea: true, total: false, flip :true }
		    }
		}
	    };
	}

	if (plugin_instance == 'dslcrc') {
	    return {
		title: "%H: DSL-CRC-Errors",
		vlabel: " dslcrc",
		number_format: "%8.0lf",
		autoscale_max: true,
		data: {
		    types: [ "gauge" ],
		    options: {
			gauge_crc: { color: "00FF00", title: "LOSS", overlay: true, noarea: true, total: false },
			gauge_crcp: { color: "0000FF", title: "UAS", overlay: true, noarea: true, total: false  },
			gauge_f_crc: { color: "FF8000", title: "Far LOSS", overlay: true, noarea: true, total: false, flip :true },
			gauge_f_crcp: { color: "FF00FF", title: "Far UAS", overlay: true, noarea: true, total: false, flip :true }
		    }
		}
	    };
	}

    }
});