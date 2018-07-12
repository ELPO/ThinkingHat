#include "ThinkingHatApplication.h"
#include "InstanceGuard.h"

#include <QDebug>

namespace
{
const QString APPLICATION_NAME = "ThinkingHat";
const QString THINKINGHAT_VERSION = "0.9.3";
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("ThinkingHat");
    QCoreApplication::setOrganizationDomain("thinkinghat.com");
    QCoreApplication::setApplicationName(APPLICATION_NAME);
    QCoreApplication::setApplicationVersion(THINKINGHAT_VERSION);

    InstanceGuard guard(APPLICATION_NAME);

    if (!guard.tryRun())
    {
        qDebug() << APPLICATION_NAME + " is already running.";
    }
    else
    {
        ThinkingHatApplication app(argc, argv);

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
