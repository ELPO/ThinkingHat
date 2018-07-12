#include "ThinkingHatApplication.h"

#include <QDebug>
#include <QQmlContext>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

constexpr char defaultProblemData[] = ":/resources/problems/data.json";
constexpr int problemListVersion = 2;

ThinkingHatApplication::ThinkingHatApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
    , m_problemsModel(new ProblemsModel(this))
{
}

bool ThinkingHatApplication::initialize()
{
    // loading problem data
    QString problemData = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + "/problemData.json";

    QFile f(problemData);
    if (!f.exists()) {
        qDebug() << "No problem data found: creating one.";
        QFile innerData(defaultProblemData);
        innerData.open(QIODevice::ReadOnly);
        QFile test (problemData);
        if (test.open(QIODevice::ReadWrite))
        {
            QByteArray ba = innerData.readAll();
            test.write(ba);
            test.close();
        }

        innerData.close();
    }

    if (!f.exists()) {
        qDebug() << "Can't create a problem data file. Using inner file.";
        problemData = defaultProblemData;
    }

    if (!m_problemsModel->initialize(problemData))
    {
        qDebug() << "Failed to initialize problem list";
        return false;
    }

    if (m_problemsModel->version() < problemListVersion) {
        qDebug() << "Problem data file outdated. Using inner file.";

        if (!m_problemsModel->initialize(defaultProblemData))
        {
            qDebug() << "Failed to initialize problem list";
            return false;
        }
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
