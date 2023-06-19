// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.bmicalc 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("bmicalc")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: App.restoreWindowGeometry(root)

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }

    property int counter: 0

    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("bmicalc")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("About bmicalc")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page

   Kirigami.ScrollablePage {
    id: page
    Layout.fillWidth: true
    implicitWidth: applicationWindow().width
    title: "BMI Calculator"

    ColumnLayout {
        Kirigami.FormLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true

            width: page.width

            Controls.TextField {
                id: weight
                placeholderText: "Вес в килограммах"
                inputMethodHints: Qt.ImhDigitsOnly
                Kirigami.FormData.label: "Вес:"
            }
            Controls.TextField {
                id: height
                placeholderText: "Рост в сантиметрах"
                inputMethodHints: Qt.ImhDigitsOnly
                Kirigami.FormData.label: "Рост:"
            }
            Controls.TextField {
                id: circle
                placeholderText: "Окружность запястья в сантиметрах"
                inputMethodHints: Qt.ImhDigitsOnly
                Kirigami.FormData.label: "Окружность запястья:"
            }

            Controls.ComboBox {
                id: combo
                model: ["мужской","женский"]
                Kirigami.FormData.label: "Пол:"
            }

            Controls.Button {
                text: "Вычислить"
                onClicked: showResult()
            }

           Controls.Label {
               id: result1
           }
           Controls.Label {
               id: result2
           }
           Controls.Label {
               id: result3
           }
        }
     }

     Kirigami.PromptDialog {
        id: alert
        title: "Внимание!"
        subtitle: "Заполните все 3 поля!"
        standardButtons: Kirigami.Dialog.Ok
    }
  }



  function showResult(){
    var h=Number(height.text);
    var w=Number(weight.text);
    var c=Number(circle.text);
    if (isNullInField(height.text)||isNullInField(weight.text)||isNullInField(circle.text)){
        alert.visible = true
        return;
    }
    var gen,index,s;
    if (combo.currentIndex===0){
        gen=19;
    }else{
        gen=16;
    }
     h=h/100;
     index=w/(h*h);
     index=index*(gen/c);
     if(index<16)s="Deficiency of weight";
     else if(index>=16&&index<20)s="Insufficient weight";
     else if(index>=20&&index<25)s="Norm";
     else if(index>=25&&index<30)s="Pre-obese";
     else if(index>=30&&index<35)s="The first degree of obesity";
     else if(index>=35&&index<40)s="Second degree of obesity";
     else s="Morbid obesity";

    result1.text = somatoType(gen,c) + "\nBMI="+index.toFixed(2);
    result2.text = s
    if(s==="Norm"){
        result2.color = "green"
    }else{
        result2.color = "red"
    }
    result3.text = normalMassMin(c,h,gen) + "\n" + normalMassMax(c,h,gen);
}
  function isNullInField(p){
         return p.length === 0;
     }
  function  normalMassMin(x,y,z){
        var im=x*(y*y)/z;
        return "Lower limit of normal weight: "+20*im.toFixed(2)+" kg.";
    }
    function normalMassMax(x,y,z){
        var im=x*(y*y)/z;
        return "Upper limit of normal weight: "+25*im.toFixed(2)+" kg.";
    }
    function  somatoType(a,b){
        var s="";
        switch(a){
            case 19:
                if(b<18)s="Body type: asthenic.";
                else if(b>=18&&b<=20)s="Body type: normosthenic.";
                else s="Body type: hypersthenic.";
                break;
            case 16:
                if(b<15)s="Body type: asthenic.";
                else if(b>=15&&b<=17)s="Body type: normosthenic.";
                else s="Body type: hypersthenic.";
                break;
                default:
                break;
        }
        return s;
    }
}
