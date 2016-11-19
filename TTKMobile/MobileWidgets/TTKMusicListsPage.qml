/* =================================================
 * This file is part of the TTK Music Player project
 * Copyright (c) 2014 - 2016 Greedysky Studio
 * All rights reserved!
 * Redistribution and use of the source code or any derivative
 * works are strictly forbiden.
   =================================================*/

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "Core"

Item {
    id: ttkMusicListsPage
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        playlistModel.clear();
        var names = TTK_APP.mediaNames(ttkTheme.music_normal_list);
        var artists = TTK_APP.mediaArtists(ttkTheme.music_normal_list);
        for(var i=0; i<names.length; ++i) {
            var info = {
                title: names[i],
                artist: artists[i]
            }
            playlistModel.append(info);
        }
        itemListView.currentIndex = TTK_APP.getCurrentIndex();
    }

    onXChanged: {
        ttkMusicListsMorePage.visible = false;
        ttkMusicSongSettingPage.visible = false;
    }

    property int functionClickedIndex: -1

    function removeItemFromList() {
        playlistModel.remove(functionClickedIndex);
        TTK_APP.removeMusicSongs(functionClickedIndex);
    }

    Connections {
        target: TTK_APP
        onImportSongFinished: {
            if(index === ttkTheme.music_normal_list) {
                playlistModel.clear();
                var names = TTK_APP.mediaNames(ttkTheme.music_normal_list);
                var artists = TTK_APP.mediaArtists(ttkTheme.music_normal_list);
                for(var i=0; i<names.length; ++i) {
                    var info = {
                        title: names[i],
                        artist: artists[i]
                    };
                    playlistModel.append(info);
                }
            }
        }
        onCurrentIndexChanged: {
            itemListView.currentIndex = TTK_APP.getCurrentIndex();
        }
        onRemoveItemFromPlayerCenter: {
            playlistModel.remove(index);
        }
    }

    TTKMusicSongSettingPage {
        id: ttkMusicSongSettingPage
    }

    TTKMusicListsMorePage {
        id: ttkMusicListsMorePage
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        ///top bar
        Rectangle {
            id: mainMenubar
            Layout.fillWidth: true
            height: ttkGlobal.dpHeight(ttkTheme.topbar_height)
            color: ttkTheme.topbar_background

            RowLayout {
                spacing: 2
                anchors.fill: parent

                TTKImageButton {
                    source: "qrc:/image/title_bar_back"
                    Layout.preferredWidth: ttkGlobal.dpWidth(50)
                    Layout.preferredHeight: ttkGlobal.dpHeight(50)
                    anchors.left: parent.left
                    onPressed: {
                        ttkMainStackView.pop();
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: ttkTheme.color_white
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: mainMenubar.height/2
                    text: qsTr("本地歌曲")
                }

                TTKImageButton {
                    source: "qrc:/image/player_btn_more_normal"
                    Layout.preferredWidth: ttkGlobal.dpWidth(50)
                    Layout.preferredHeight: ttkGlobal.dpHeight(50)
                    anchors.right: parent.right
                    onPressed: {
                        ttkMusicListsMorePage.visible = true;
                    }
                }
            }
        }

        ///main body
        Rectangle {
            width: ttkMainWindow.width
            height: ttkMainStackView.height - mainMenubar.height
            color: ttkTheme.color_white

            ListView {
                id: itemListView
                anchors.fill: parent
                clip: true

                onFlickingVerticallyChanged: {
                    locationButton.visible = true;
                    timer.stop();
                    timer.start();
                }

                delegate: Component {
                    Rectangle {
                        id: wrapper
                        width: ttkMainWindow.width
                        height: ttkGlobal.dpHeight(70)
                        color: ttkTheme.color_white

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                itemListView.currentIndex = index;
                                TTK_APP.setCurrentIndex(ttkTheme.music_normal_list, index);
                            }
                        }

                        Rectangle {
                            width: ttkMainWindow.width
                            height: 1
                            color: ttkTheme.color_alpha_lv9
                        }

                        Rectangle {
                            width: ttkGlobal.dpWidth(5)
                            height: parent.height*2/3
                            anchors {
                                top: parent.top
                                topMargin: parent.height/3/2
                            }
                            color: parent.ListView.isCurrentItem ? ttkTheme.topbar_background : ttkTheme.color_white
                        }

                        Text {
                            id: titleArea
                            text: title
                            width: ttkMusicListsPage.width - iconArea.width - ttkGlobal.dpHeight(60)
                            anchors {
                                top: parent.top
                                topMargin: ttkGlobal.dpHeight(10)
                                left: parent.left
                                leftMargin: ttkGlobal.dpHeight(20)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height*3/10
                        }

                        Image {
                            id: iconArea
                            width: parent.height/3
                            height: parent.height/3
                            anchors {
                                top: titleArea.bottom
                                topMargin: ttkGlobal.dpHeight(5)
                                left: parent.left
                                leftMargin: ttkGlobal.dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_normal"
                        }

                        TTKImageButton {
                            id: moreFuncArea
                            width: parent.height/2
                            height: parent.height/2
                            anchors {
                                top: parent.top
                                right: parent.right
                                topMargin: ttkGlobal.dpHeight(20)
                                rightMargin: ttkGlobal.dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_more_normal"
                            onPressed: {
                                functionClickedIndex = index;
                                ttkMusicSongSettingPage.songName = title;
                                ttkMusicSongSettingPage.singerName = artist;
                                ttkMusicSongSettingPage.filePath = TTK_APP.mediaPath(ttkTheme.music_normal_list, index);
                                ttkMusicSongSettingPage.visible = true;
                            }
                        }

                        Text {
                            id: artistArea
                            text: artist
                            width: titleArea.width - iconArea.width
                            anchors {
                                top: titleArea.bottom
                                topMargin: ttkGlobal.dpHeight(10)
                                left: iconArea.right
                                leftMargin: ttkGlobal.dpHeight(10)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height/4
                            color: ttkTheme.color_gray
                        }
                    }
                }

                model: ListModel {
                    id: playlistModel
                }
            }
        }

        Timer {
            id: timer
            interval: 3000
            repeat: false

            onTriggered: {
                disappearAnimation.start();
            }
        }

        PropertyAnimation {
            id: disappearAnimation
            target: locationButton
            property: "opacity"
            duration: 1000
            from: 1
            to: 0
            onStopped: {
                locationButton.visible = false;
                locationButton.opacity = 1;
            }
        }

        TTKImageButton {
            id: locationButton
            visible: false
            source: "qrc:/image/anchor_in_cell_point"
            Layout.preferredWidth: ttkGlobal.dpWidth(50)
            Layout.preferredHeight: ttkGlobal.dpHeight(50)
            anchors {
                right: parent.right
                rightMargin: ttkGlobal.dpWidth(50)
                bottom: parent.bottom
                bottomMargin: ttkGlobal.dpHeight(10)
            }
            onPressed: {
                var delta = ttkGlobal.dpHeight(70)*itemListView.currentIndex;
                if(delta >= 0) {
                    itemListView.contentY = delta;
                }
            }
        }
    }
}
