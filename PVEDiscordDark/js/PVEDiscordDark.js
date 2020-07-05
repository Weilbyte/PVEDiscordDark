Proxmox.panel.GaugeWidget.prototype.backgroundColor = '#2C2F33';
Proxmox.panel.GaugeWidget.prototype.criticalColor = '#f04747';
Proxmox.panel.GaugeWidget.prototype.warningColor = '#faa61a';
Proxmox.panel.GaugeWidget.prototype.defaultColor = '#7289DA';
Proxmox.panel.GaugeWidget.prototype.items[1].series[0].colors[0] = '#2C2F33';

PVE.window.BackupConfig.prototype.items.style['background-color'] = '#23272a';
PVE.DiskSmartWindow.prototype.items[1].style['background-color'] = '#23272a';
PVE.window.TFAEdit.prototype.items[0].items[0].items[1].style["background-color"] = '#23272a';


PVE.node.Summary.prototype.showVersions = function() {
	var me = this;
	var nodename = me.pveSelNode.data.node;

	var view = Ext.createWidget('component', {
	    autoScroll: true,
	    padding: 5,
	    style: {
		'background-color': '#23272a',
		'white-space': 'pre',
		'font-family': 'monospace'
	    }
	});

	var win = Ext.create('Ext.window.Window', {
	    title: gettext('Package versions'),
	    width: 600,
	    height: 400,
	    layout: 'fit',
	    modal: true,
	    items: [ view ]
	});

	Proxmox.Utils.API2Request({
	    waitMsgTarget: me,
	    url: "/nodes/" + nodename + "/apt/versions",
	    method: 'GET',
	    failure: function(response, opts) {
		win.close();
		Ext.Msg.alert(gettext('Error'), response.htmlStatus);
	    },
	    success: function(response, opts) {
		win.show();
		var text = '';
		Ext.Array.each(response.result.data, function(rec) {
		    var version = "not correctly installed";
		    var pkg = rec.Package;
		    if (rec.OldVersion && rec.CurrentState === 'Installed') {
			version = rec.OldVersion;
		    }
		    if (rec.RunningKernel) {
			text += pkg + ': ' + version + ' (running kernel: ' +
			    rec.RunningKernel + ')\n';
		    } else if (rec.ManagerVersion) {
			text += pkg + ': ' + version + ' (running version: ' +
			    rec.ManagerVersion + ')\n';
		    } else {
			text += pkg + ': ' + version + '\n';
		    }
		});

		view.update(Ext.htmlEncode(text));
	    }
	});
    }

PVE.node.Subscription.prototype.showReport = function() {
	var me = this;

	var getReportFileName = function() {
	    var now = Ext.Date.format(new Date(), 'D-d-F-Y-G-i');
	    return `${me.nodename}-pve-report-${now}.txt`;
	};

	var view = Ext.createWidget('component', {
	    itemId: 'system-report-view',
	    scrollable: true,
	    style: {
		'background-color': '#23272a',
		'white-space': 'pre',
		'font-family': 'monospace',
		padding: '5px',
	    },
	});

	var reportWindow = Ext.create('Ext.window.Window', {
	    title: gettext('System Report'),
	    width: 1024,
	    height: 600,
	    layout: 'fit',
	    modal: true,
	    buttons: [
		'->',
		{
		    text: gettext('Download'),
		    handler: function() {
			var fileContent = Ext.String.htmlDecode(reportWindow.getComponent('system-report-view').html);
			var fileName = getReportFileName();

			// Internet Explorer
			if (window.navigator.msSaveOrOpenBlob) {
			    navigator.msSaveOrOpenBlob(new Blob([fileContent]), fileName);
			} else {
			    var element = document.createElement('a');
			    element.setAttribute('href', 'data:text/plain;charset=utf-8,' +
			      encodeURIComponent(fileContent));
			    element.setAttribute('download', fileName);
			    element.style.display = 'none';
			    document.body.appendChild(element);
			    element.click();
			    document.body.removeChild(element);
			}
		    },
		},
	    ],
	    items: view,
	});

	Proxmox.Utils.API2Request({
	    url: '/api2/extjs/nodes/' + me.nodename + '/report',
	    method: 'GET',
	    waitMsgTarget: me,
	    failure: function(response) {
		Ext.Msg.alert(gettext('Error'), response.htmlStatus);
	    },
	    success: function(response) {
		var report = Ext.htmlEncode(response.result.data);
		reportWindow.show();
		view.update(report);
	    },
	});
    }

console.log('PVEDiscordDark :: Patched');