const COLOR_DARK = '#2C2F33'
const COLOR_DARKER = '#23272a'
const COLOR_BLURPLE = '#526DD1'
const COLOR_YELLOW = '#faa61a'
const COLOR_RED = '#ba2b2d'


const swapLogo = async function() {
	const imgElements = document.getElementsByTagName('img');
	var found = false;
	for (var i = 0; i< imgElements.length; i++) {
		var node = imgElements[i]
		if (node.src.includes('proxmox_logo.png')) {
			found = true;
			var width = (node.parentElement.clientWidth == undefined || node.parentElement.clientWidth == 0) ? 172 : node.parentElement.clientWidth;
			var height = (node.parentElement.clientHeight == undefined || node.parentElement.clientHeight == 0) ? 30 : node.parentElement.clientHeight;
			node.parentElement.parentElement.style.background = COLOR_DARKER;
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

const patchCharts = function() {
	Ext.chart.theme.Base.prototype.config.chart.defaults.background = COLOR_DARKER;
	Ext.chart.theme.Base.prototype.config.axis.defaults.label.color = 'white';
	Ext.chart.theme.Base.prototype.config.axis.defaults.title.color = 'white';
	Ext.chart.theme.Base.prototype.config.axis.defaults.style.strokeStyle = COLOR_BLURPLE;
	Ext.chart.theme.Base.prototype.config.axis.defaults.grid.strokeStyle = 'rgba(44, 47, 51, 1)'; // COLOR_DARK
	Ext.chart.theme.Base.prototype.config.sprites.text.color = 'white';
};

function patchGaugeWidget() {
	Proxmox.panel.GaugeWidget.prototype.backgroundColor = COLOR_DARK;
	Proxmox.panel.GaugeWidget.prototype.criticalColor = COLOR_RED;
	Proxmox.panel.GaugeWidget.prototype.warningColor = COLOR_YELLOW;
	Proxmox.panel.GaugeWidget.prototype.defaultColor = COLOR_BLURPLE;
	Proxmox.panel.GaugeWidget.prototype.items[1].series[0].colors[0] = COLOR_DARK;
};

function patchBackupConfig() {
	PVE.window.BackupConfig.prototype.items.style['background-color'] = COLOR_DARKER;
};

function patchDiskSmartWindow() {
	const target = PVE.DiskSmartWindow || Proxmox.window.DiskSmart;
	target.prototype.items[1].style['background-color'] = COLOR_DARKER;
}

function patchTFAEdit() {
	if (PVE.window.TFAEdit) PVE.window.TFAEdit.prototype.items[0].items[0].items[1].style["background-color"] = 'transparent';
}

function patchCreateWidget() {
	_createWidget = Ext.createWidget
	Ext.createWidget = function(c, p) {
		if (typeof p === 'object' && typeof p.style === 'object') {
			if (c === 'component' && typeof p.style['background-color'] === 'string' && p.style['background-color'] === 'white') p.style['background-color'] = COLOR_DARK
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
