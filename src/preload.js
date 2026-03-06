const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  runInstaller: () => ipcRenderer.invoke('run-installer')
});
