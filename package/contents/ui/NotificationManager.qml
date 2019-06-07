import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore
import QtMultimedia 5.4

QtObject {
    id: notificationManager

    property var dataSource: PlasmaCore.DataSource {
        id: dataSource
        engine: "notifications"
        connectedSources: "org.freedesktop.Notifications"
    }


    function start(args) {
        switch(args) {
            case 1:
            case 3:
            case 5:
            case 7:
                createNotification({
                    appName: "fokus",
                    appIcon: "pomodoro-start-light",
                    summary: "Focus",
                    body: "Focus on your work!",
                })
                break;
            case 2:
            case 4:
            case 6:
                createNotification({
                    appName: "fokus",
                    appIcon: "pomodoro-start-light",
                    summary: "Short Break",
                    body: "Go for a walk.",
                })
                break;
            case 8:
                createNotification({
                    appName: "fokus",
                    appIcon: "pomodoro-start-light",
                    summary: "Long Break",
                    body: "Take a long break!",
                })
                break;
        }
    }

    function end(args) {
        createNotification({
            appName: "fokus",
            appIcon: "pomodoro-start-light",
            summary: "Focus",
            body: "End of time.",
            soundFile: "/usr/share/sounds/freedesktop/stereo/complete.oga"
        })
    }

    function stop(args) {
        createNotification({
            appName: "fokus",
            appIcon: "pomodoro-stop-light",
            summary: "Focus",
            body: "Session stopped.",
        })
    }

    function createNotification(args) {
        // https://github.com/KDE/plasma-workspace/blob/master/dataengines/notifications/notifications.operations
        var service = dataSource.serviceForSource("notification")
        var operation = service.operationDescription("createNotification")

        operation.appName = args.appName || "plasmashell"
        operation.appIcon = args.appIcon || ""
        operation.summary = args.summary || ""
        operation.body = args.body || ""
        if (typeof args.expireTimeout !== "undefined") {
            operation.expireTimeout = args.expireTimeout
        }

        service.startOperationCall(operation)
        if (args.soundFile) {
            sfx.source = args.soundFile
            sfx.play()
        }
    }

    property Audio sfx: Audio {}
}
