#ifndef MUSICDOWNLOADQUERYALBUMTHREAD_H
#define MUSICDOWNLOADQUERYALBUMTHREAD_H

/* =================================================
 * This file is part of the TTK Music Player project
 * Copyright (C) 2015 - 2018 Greedysky Studio

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License along
 * with this program; If not, see <http://www.gnu.org/licenses/>.
 ================================================= */

#include "musicdownloadquerythreadabstract.h"

/*! @brief The class to query album download data from net.
 * @author Greedysky <greedysky@163.com>
 */
class MUSIC_NETWORK_EXPORT MusicDownLoadQueryAlbumThread : public MusicDownLoadQueryThreadAbstract
{
    Q_OBJECT
    TTK_DECLARE_MODULE(MusicDownLoadQueryAlbumThread)
public:
    /*!
     * Object contsructor.
     */
    explicit MusicDownLoadQueryAlbumThread(QObject *parent = 0);

    /*!
     * Start to Search data from name and type.
     */
    virtual void startToSearch(QueryType type, const QString &album) override;
    /*!
     * Start to Search data from name and type.
     */
    virtual void startToSearch(const QString &album) = 0;

Q_SIGNALS:
    /*!
     * Create the current album info item.
     */
    void createAlbumInfoItem(const MusicResultsItem &item);

};

#endif // MUSICDOWNLOADQUERYALBUMTHREAD_H
