#include "ThinkingHatApplication.h"

#include <QDebug>
#include <QQmlContext>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

ThinkingHatApplication::ThinkingHatApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
    , m_problemsModel(new ProblemsModel(this))
{
    //qDebug() << QStandardPaths::writableLocation(QStandardPaths::DataLocation);;

//    QDir d(locations[0]);
//    if (!d.exists()) {
//        d.mkdir(".");
//    }
}

bool ThinkingHatApplication::initialize()
{
    // loading problem data
    if (!m_problemsModel->initialize(":/resources/problems/data.json"))
    {
        qDebug() << "Failed to initialize problem list";
        return false;
    }

    m_engine.rootContext()->setContextProperty("problemsModel", m_problemsModel.data());
    m_engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (m_engine.rootObjects().isEmpty())
    {
        qDebug() << "Failed to initialize UI";
        return false;
    }

    makeConnections();

    return true;
}

void ThinkingHatApplication::makeConnections()
{

}
