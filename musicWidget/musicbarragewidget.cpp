#include "musicbarragewidget.h"
#include "musictime.h"

MusicBarrageAnimation::MusicBarrageAnimation(QObject *parent)
    : QPropertyAnimation(parent)
{
    init();
}

MusicBarrageAnimation::MusicBarrageAnimation(QObject *target,
                                             const QByteArray &propertyName,
                                             QObject *parent)
    : QPropertyAnimation(target, propertyName, parent)
{
    init();
}

void MusicBarrageAnimation::animationFinished()
{
    setDuration(qrand()%10000 + 1000);
    setSize(m_parentSize);
    start();
}

void MusicBarrageAnimation::setSize(const QSize &size)
{
    m_parentSize = size;
    int randHeight = qrand()%size.height();
    setStartValue(QPoint(0, randHeight));
    setEndValue(QPoint(size.width(), randHeight));
}

void MusicBarrageAnimation::init()
{
    MusicTime::timeSRand();
    setDuration(qrand()%10000 + 1000);
    setEasingCurve(QEasingCurve::Linear);

    connect(this, SIGNAL(finished()), SLOT(animationFinished()));
}



MusicBarrageWidget::MusicBarrageWidget(QObject *parent)
    : QObject(parent)
{
    m_parentClass = static_cast<QWidget*>(parent);
    m_barrageState = false;
}

MusicBarrageWidget::~MusicBarrageWidget()
{
    deleteItems();
}

void MusicBarrageWidget::start()
{
    if(m_barrageState)
    {
        for(int i=0; i<m_labels.count(); i++)
        {
            m_labels[i]->show();
            m_animations[i]->start();
        }
    }
}

void MusicBarrageWidget::pause()
{
    if(m_barrageState)
    {
        for(int i=0; i<m_labels.count(); i++)
        {
            m_labels[i]->hide();
            m_animations[i]->pause();
        }
    }
}

void MusicBarrageWidget::stop()
{
    for(int i=0; i<m_labels.count(); i++)
    {
        m_labels[i]->hide();
        m_animations[i]->stop();
    }
}

void MusicBarrageWidget::barrageStateChanged(bool on)
{
    m_barrageState = on;
    if(m_barrageState)
    {
        deleteItems();
        createLabel();
        createAnimation();
        start();
    }
    else
    {
        stop();
    }
}

void MusicBarrageWidget::setSize(const QSize &size)
{
    m_parentSize = size;
    for(int i=0; i<m_labels.count(); i++)
    {
        m_animations[i]->setSize(size);
    }
}

void MusicBarrageWidget::setLabelBackground(const QColor &color)
{
    for(int i=0; i<m_labels.count(); i++)
    {
        QLabel *label = m_labels[i];
        label->setAutoFillBackground(true);
        QPalette Pal(label->palette());
        Pal.setColor(QPalette::Background, color);
        label->setPalette(Pal);
    }
}

void MusicBarrageWidget::setLabelTextSize(int size)
{
    for(int i=0; i<m_labels.count(); i++)
    {
        QLabel *label = m_labels[i];
        QFont f = label->font();
        f.setPointSize(size);
        label->setFont(f);
    }
}

void MusicBarrageWidget::deleteItems()
{
    while(!m_labels.isEmpty())
    {
        delete m_labels.takeLast();
        delete m_animations.takeLast();
    }
}

void MusicBarrageWidget::createLabel()
{
    MusicTime::timeSRand();
    for(int i=0; i<NUMBER; i++)
    {
        QLabel *label = new QLabel(m_parentClass);
        QString color = QString("QLabel{color:rgb(%1,%2,%3);}")
                .arg(qrand()%255).arg(qrand()%255).arg(qrand()%255);
        label->setStyleSheet(color);
        label->setText("test");
        label->hide();
        m_labels << label;
    }
}

void MusicBarrageWidget::createAnimation()
{
    for(int i=0; i<m_labels.count(); i++)
    {
        MusicBarrageAnimation *anim = new MusicBarrageAnimation(m_labels[i], "pos");
        anim->setSize(m_parentSize);
        m_animations << anim;
    }
}
