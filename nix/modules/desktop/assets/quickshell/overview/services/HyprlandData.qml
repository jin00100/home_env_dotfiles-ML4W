pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../common"

/**
 * Provides access to some Hyprland data not available in Quickshell.Hyprland.
 */
Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var workspaces: []
    property var allWorkspaces: []
    property var workspaceIds: []
    property var workspaceById: ({})
    property var activeWorkspace: null
    property var activeWindow: null
    property string activeWindowAddress: ""
    property var monitors: []
    property var layers: ({})
    property bool pendingWindowsUpdate: false
    property bool pendingMonitorsUpdate: false
    property bool pendingLayersUpdate: false
    property bool pendingWorkspacesUpdate: false
    property bool pendingActiveWorkspaceUpdate: false
    property bool pendingActiveWindowUpdate: false

    function updateWindowList() {
        getClients.running = true;
    }

    function updateLayers() {
        getLayers.running = true;
    }

    function updateMonitors() {
        getMonitors.running = true;
    }

    function updateWorkspaces() {
        getWorkspaces.running = true;
        getActiveWorkspace.running = true;
    }

    function updateActiveWindow() {
        getActiveWindow.running = true;
    }

    function updateAll() {
        scheduleUpdates(true, true, true, true, true, true);
    }

    function scheduleUpdates(windows, monitors, layers, workspaces, activeWorkspace, activeWindow) {
        pendingWindowsUpdate = pendingWindowsUpdate || !!windows;
        pendingMonitorsUpdate = pendingMonitorsUpdate || !!monitors;
        pendingLayersUpdate = pendingLayersUpdate || !!layers;
        pendingWorkspacesUpdate = pendingWorkspacesUpdate || !!workspaces;
        pendingActiveWorkspaceUpdate = pendingActiveWorkspaceUpdate || !!activeWorkspace;
        pendingActiveWindowUpdate = pendingActiveWindowUpdate || !!activeWindow;

        const debounceMs = Math.max(0, Config.options.hacks.hyprlandEventDebounceMs);
        if (debounceMs === 0) {
            flushPendingUpdates();
        } else {
            eventDebounceTimer.interval = debounceMs;
            eventDebounceTimer.restart();
        }
    }

    function flushPendingUpdates() {
        if (pendingWindowsUpdate) {
            pendingWindowsUpdate = false;
            updateWindowList();
        }
        if (pendingMonitorsUpdate) {
            pendingMonitorsUpdate = false;
            updateMonitors();
        }
        if (pendingLayersUpdate) {
            pendingLayersUpdate = false;
            updateLayers();
        }
        if (pendingWorkspacesUpdate) {
            pendingWorkspacesUpdate = false;
            getWorkspaces.running = true;
        }
        if (pendingActiveWorkspaceUpdate) {
            pendingActiveWorkspaceUpdate = false;
            getActiveWorkspace.running = true;
        }
        if (pendingActiveWindowUpdate) {
            pendingActiveWindowUpdate = false;
            updateActiveWindow();
        }
    }

    function biggestWindowForWorkspace(workspaceId) {
        const windowsInThisWorkspace = HyprlandData.windowList.filter(w => w.workspace.id == workspaceId);
        return windowsInThisWorkspace.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }

    Component.onCompleted: {
        scheduleUpdates(true, true, true, true, true, true);
        flushPendingUpdates();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            const eventName = `${event?.name ?? event?.event ?? event?.type ?? ""}`;
            if (["openlayer", "closelayer", "screencast"].includes(eventName))
                return;

            if (eventName === "openwindow" || eventName === "closewindow" || eventName === "movewindow" || eventName === "movewindowv2" || eventName === "windowtitle") {
                scheduleUpdates(true, false, false, true, false, true);
                return;
            }

            if (eventName === "activewindow" || eventName === "activewindowv2") {
                scheduleUpdates(true, false, false, false, false, true);
                return;
            }

            if (eventName === "workspace" || eventName === "workspacev2" || eventName === "focusedmon" || eventName === "focusedmonv2") {
                scheduleUpdates(false, false, false, true, true, true);
                return;
            }

            if (eventName.startsWith("monitor") || eventName === "configreloaded") {
                scheduleUpdates(true, true, false, true, true, true);
                return;
            }

            scheduleUpdates(true, true, true, true, true, true);
        }
    }

    Timer {
        id: eventDebounceTimer
        interval: Math.max(0, Config.options.hacks.hyprlandEventDebounceMs)
        repeat: false
        onTriggered: root.flushPendingUpdates()
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                root.windowList = JSON.parse(clientsCollector.text);
                let tempWinByAddress = {};
                for (var i = 0; i < root.windowList.length; ++i) {
                    var win = root.windowList[i];
                    tempWinByAddress[win.address] = win;
                }
                root.windowByAddress = tempWinByAddress;
                root.addresses = root.windowList.map(win => win.address);
            }
        }
    }

    Process {
        id: getMonitors
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            id: monitorsCollector
            onStreamFinished: {
                root.monitors = JSON.parse(monitorsCollector.text);
            }
        }
    }

    Process {
        id: getLayers
        command: ["hyprctl", "layers", "-j"]
        stdout: StdioCollector {
            id: layersCollector
            onStreamFinished: {
                root.layers = JSON.parse(layersCollector.text);
            }
        }
    }

    Process {
        id: getWorkspaces
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            id: workspacesCollector
            onStreamFinished: {
                const rawWorkspaces = JSON.parse(workspacesCollector.text);
                root.allWorkspaces = rawWorkspaces;
                root.workspaces = rawWorkspaces.filter(ws => ws.id >= 1 && ws.id <= 100);
                let tempWorkspaceById = {};
                for (var i = 0; i < root.workspaces.length; ++i) {
                    var ws = root.workspaces[i];
                    tempWorkspaceById[ws.id] = ws;
                }
                root.workspaceById = tempWorkspaceById;
                root.workspaceIds = root.workspaces.map(ws => ws.id);
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            id: activeWorkspaceCollector
            onStreamFinished: {
                try {
                    root.activeWorkspace = JSON.parse(activeWorkspaceCollector.text);
                } catch (e) {
                    root.activeWorkspace = null;
                }
            }
        }
    }

    Process {
        id: getActiveWindow
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            id: activeWindowCollector
            onStreamFinished: {
                try {
                    const text = activeWindowCollector.text.trim();
                    if (text.length > 0 && text !== "{}") {
                        const parsed = JSON.parse(text);
                        if (parsed && parsed.address) {
                            root.activeWindow = parsed;
                            root.activeWindowAddress = `${parsed.address}`.toLowerCase();
                        } else {
                            root.activeWindow = null;
                            root.activeWindowAddress = "";
                        }
                    } else {
                        root.activeWindow = null;
                        root.activeWindowAddress = "";
                    }
                } catch (e) {
                    root.activeWindow = null;
                    root.activeWindowAddress = "";
                }
            }
        }
    }
}
