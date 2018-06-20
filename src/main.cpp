#include "FuelFilterApplication.h"
#include "InstanceGuard.h"

#include <QGuiApplication>
#include <QDebug>

namespace
{
    const QString APPLICATION_NAME = "FuelFilter";
    const QString FUELFILTER_VERSION = "1.0.0";
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Fuel3D");
    QCoreApplication::setOrganizationDomain("fuel-3d.com");
    QCoreApplication::setApplicationName(APPLICATION_NAME);
    QCoreApplication::setApplicationVersion(FUELFILTER_VERSION);

    // Enable loggging of quick scene graph renderer information
    //qputenv("QSG_INFO", "1");

    //console window
    //#ifdef CONSOLE_MODE
    //    qputenv("QT_LOGGING_TO_CONSOLE", QByteArray("1"));
    //#else
    //    qputenv("QT_LOGGING_TO_CONSOLE", QByteArray("0"));
    //#endif

    //qInstallMessageHandler(RodentMessageHandler);
    InstanceGuard guard(APPLICATION_NAME);

    if (!guard.tryRun())
    {
        qDebug() << APPLICATION_NAME + " is already running.";
    }
    else
    {
        FuelFilterApplication app(argc, argv);

        if(!app.initialize())
        {
            qDebug() << "Cannot initialize application.";
        }
        else
        {
            app.exec();
        }
    }

    return 0;
}
