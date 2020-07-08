const swapLogo = async function() {
	const imgElements = document.getElementsByTagName('img');
	var found = false;
	for (var i = 0; i< imgElements.length; i++) {
		var node = imgElements[i]
		if (node.src.includes('proxmox_logo.png')) {
			found = true;
			var width = (node.parentElement.clientWidth == undefined || node.parentElement.clientWidth == 0) ? 177 : node.parentElement.clientWidth;
			var height = (node.parentElement.clientHeight == undefined || node.parentElement.clientHeight == 0) ? 34 : node.parentElement.clientHeight;
			node.parentElement.parentElement.style.background = '#23272A';
			node.setAttribute('height', `${height}px`);
			node.setAttribute('width', `${width}px`);
			node.setAttribute('src', '/pve2/images/dd_logo.png');
		}
	}
	if (!found) {
		await new Promise(resolve => setTimeout(resolve, 60));
		await swapLogo();
	};
};

function patchGaugeWidget() {
	Proxmox.panel.GaugeWidget.prototype.backgroundColor = '#2C2F33';
	Proxmox.panel.GaugeWidget.prototype.criticalColor = '#f04747';
	Proxmox.panel.GaugeWidget.prototype.warningColor = '#faa61a';
	Proxmox.panel.GaugeWidget.prototype.defaultColor = '#7289DA';
	Proxmox.panel.GaugeWidget.prototype.items[1].series[0].colors[0] = '#2C2F33';
};

function patchBackupConfig() {
	PVE.window.BackupConfig.prototype.items.style['background-color'] = '#23272a';
};

function patchDiskSmartWindow() {
	PVE.DiskSmartWindow.prototype.items[1].style['background-color'] = '#23272a';
}

function patchTFAEdit() {
	PVE.window.TFAEdit.prototype.items[0].items[0].items[1].style["background-color"] = 'transparent';
}

function patchSummary() {
	// Nothing malicious is done here. The component responsible for the color is residing inside a function, and we cannot just change a functions private variable, so we are overwriting the function with a copy of itself (with changed component color).
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
}

function patchSubscription() {
	// Nothing malicious is done here. The component responsible for the color is residing inside a function, and we cannot just change a functions private variable, so we are overwriting the function with a copy of itself (with changed component color).
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
}

swapLogo();
patchGaugeWidget();
patchBackupConfig();
patchDiskSmartWindow();
patchTFAEdit();
patchSummary();
patchSubscription();
console.log('PVEDiscordDark :: Patched');