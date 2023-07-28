const {app, BrowserWindow, ipcMain, globalShortcut} = require("electron");
const {exec} = require("child_process");
const Server = require("./Server");
const CFG = require("./config.json");
const Shell = require('node-powershell');
const find = require('find-process');

let win = null;
let isServerOnline
let overlayWindow = null;
let isOverlayOpened = false;

const createWindow = async () => {
    win = new BrowserWindow({
        width: 1200,
        height: 700,
        resizable: false,
        frame: false,
        icon: 'icon.ico',
        webPreferences:{
            nodeIntegration: true,
            contextIsolation: false,
            devTools:false,
        }
    });

    win.loadFile('index.html'); 
}

app.whenReady().then(() => {
    createWindow();
    win.webContents.on('did-finish-load', function() {
        serverStatus(JSON.stringify(CFG.servers[0].ip));
    });
});

ipcMain.on('appClose', (event, data) => {
    win.close();
})

ipcMain.on('minimizeApp', (event, data) => {
    win.minimize();
})

ipcMain.on('openfm', (event, data) => {
    const ps = new Shell();
    ps.addCommand("start " + JSON.stringify(CFG.fivem));
    ps.invoke();
});

ipcMain.on('openlt', (event, data) => {
    const ps = new Shell();
    ps.addCommand("start " + JSON.stringify(CFG.linktr));
    ps.invoke();
});

ipcMain.on('opentk', (event, data) => {
    const ps = new Shell();
    ps.addCommand("start " + JSON.stringify(CFG.ticket));
    ps.invoke();
});

ipcMain.on('counter', (event, data) => {
    const incrementedNumber = parseInt(data) + 1;
    win.webContents.send('updateNumber', incrementedNumber);
});

ipcMain.on('counterMinus', (event, data) => {
    if(parseInt(data) < 1) return;
        const decrementedNumber = parseInt(data) - 1;
    win.webContents.send('updateNumber', decrementedNumber);
});

ipcMain.on('fivemOpened', (event, data) => {
    win.webContents.send('fivemCheck', data);
});

ipcMain.on('serverStatus', (event, data) => {
    const API = new Server(data);
    API.getServerStatus().then((val) => {
        isServerOnline = val.online;
        win.webContents.send("StatusChecker",isServerOnline);
    });
});

const serverStatus = async (ip) =>{
    const API = new Server(ip);
    API.getServerStatus().then((val) => {
        isServerOnline = val.online;
        win.webContents.send("updateStatus",isServerOnline);
    });
}

ipcMain.on('getConnectedPlayers', (event, data) => {
    const API = new Server(data);
    API.getPlayersList().then((val) => {
        win.webContents.send("listPlayers",val);
    });
});


