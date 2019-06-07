import QtQuick 2.5
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

ColumnLayout {
    id: appearancePage

    property alias cfg_focusTime: focus_time.value
    property alias cfg_shortBreakTime: short_break_time.value
    property alias cfg_longBreakTime: long_break_time.value

    RowLayout {
        Label {
            text: i18n("Focus time: ")
        }

        SpinBox {
            id: focus_time
            suffix: i18ncp("Time in minutes", " min", " min", value)
        }
    }

    RowLayout {
        Label {
            text: i18n("Short break time: ")
        }

        SpinBox {
            id: short_break_time
            suffix: i18ncp("Time in minutes", " min", " min", value)
        }
    }

    RowLayout {
        Label {
            text: i18n("Long break time: ")
        }

        SpinBox {
            id: long_break_time
            suffix: i18ncp("Time in minutes", " min", " min", value)
        }
    }

    Item {
        // tighten layout
        Layout.fillHeight: true
    }
}
