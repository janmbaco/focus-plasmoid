import QtQuick 2.5
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1

ColumnLayout {
    id: appearancePage

    property alias cfg_focusTime: focus_time.value
    property alias cfg_shortBreakTime: short_break_time.value
    property alias cfg_longBreakTime: long_break_time.value
    property string cfg_clock_fontfamily: ""

    onCfg_clock_fontfamilyChanged: {
        if (cfg_clock_fontfamily) {
            for (var i = 0, j = clock_fontfamilyComboBox.model.length; i < j; ++i) {
                if (clock_fontfamilyComboBox.model[i].value == cfg_clock_fontfamily) {
                    clock_fontfamilyComboBox.currentIndex = i
                    break
                }
            }
        }
    }

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

    RowLayout {
        Label {
            text: i18n("Timer font:")
        }

        ComboBox {
            id: clock_fontfamilyComboBox
            textRole: "text"

            Component.onCompleted: {
                var arr = []
                arr.push({text: i18n("Default"), value: ""})

                var fonts = Qt.fontFamilies()
                var foundIndex = 0
                for (var i = 0, j = fonts.length; i < j; ++i) {
                    arr.push({text: fonts[i], value: fonts[i]})
                }

                model = arr
            }

            onCurrentIndexChanged: {
                var current = model[currentIndex]
                if (current) {
                    cfg_clock_fontfamily = current.value
                }
            }
        }
    }

    Item {
        // tighten layout
        Layout.fillHeight: true
    }
}
