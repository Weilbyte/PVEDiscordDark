const swapLogo = async function() {
	const imgElements = document.getElementsByTagName('img');
	var found = false;
	for (var i = 0; i< imgElements.length; i++) {
		var node = imgElements[i]
		if (node.src.includes('proxmox_logo.png')) {
			found = true;
			var width = (node.parentElement.clientWidth == undefined || node.parentElement.clientWidth == 0) ? 172 : node.parentElement.clientWidth;
			var height = (node.parentElement.clientHeight == undefined || node.parentElement.clientHeight == 0) ? 30 : node.parentElement.clientHeight;
			node.parentElement.parentElement.style.background = '#23272A';
			node.setAttribute('height', `${height}px`);
			node.setAttribute('width', `${width}px`);
			node.setAttribute('src', '/images/dd_logo.png');
		}
	}
	if (!found) {
		await new Promise(resolve => setTimeout(resolve, 60));
		await swapLogo();
	};
};

const patchCharts = function() {
	Ext.chart.theme.Base.prototype.config.chart.defaults.background = '#23272a';
	Ext.chart.theme.Base.prototype.config.axis.defaults.label.color = 'white';
	Ext.chart.theme.Base.prototype.config.axis.defaults.title.color = 'white';
	Ext.chart.theme.Base.prototype.config.axis.defaults.style.strokeStyle = '#7289DA';
	Ext.chart.theme.Base.prototype.config.axis.defaults.grid.strokeStyle = 'rgba(44, 47, 51, 1)';
	Ext.chart.theme.Base.prototype.config.sprites.text.color = 'white';
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
	const target = PVE.DiskSmartWindow || Proxmox.window.DiskSmart;
	target.prototype.items[1].style['background-color'] = '#23272a';
}

function patchTFAEdit() {
	PVE.window.TFAEdit.prototype.items[0].items[0].items[1].style["background-color"] = 'transparent';
}

function patchCreateWidget() {
	_createWidget = Ext.createWidget
	Ext.createWidget = function(c, p) {
		if (typeof p === 'object' && typeof p.style === 'object') {
			if (c === 'component' && typeof p.style['background-color'] === 'string' && p.style['background-color'] === 'white') p.style['background-color'] = '#2C2F33'
		}
		return _createWidget(c, p)
	}
}

swapLogo();
patchCharts();
patchGaugeWidget();
patchBackupConfig();
patchDiskSmartWindow();
patchTFAEdit();
patchCreateWidget();
console.log('PVEDiscordDark :: Patched');
