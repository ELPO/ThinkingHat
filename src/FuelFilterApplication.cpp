#include "FuelFilterApplication.h"

#include <QQuickStyle>
#include <QQmlContext>
#include <QDebug>
#include <QDir>

namespace
{
    constexpr auto LOGGING_PATH = "C:/Temp/FuelFilter/scanner_log.txt";
    constexpr auto SAVE_PATH = "C:/Temp/FuelFilter/";
}

FuelFilterApplication::FuelFilterApplication(int &argc, char **argv)
    : QGuiApplication (argc, argv)
    , m_testsModel(new TestModel())
{

}

bool FuelFilterApplication::initialize()
{
	QQuickStyle::setStyle("Material");

    m_vfAdapter.reset(new QMLAdapter(LOGGING_PATH, SAVE_PATH));

    if (!m_vfAdapter->initialize())
    {
        qDebug() << "Viewfinder Adapter Initialization failed.";
        return false;
    }

    m_engine.addImageProvider(QLatin1String("vfimage"), m_vfAdapter->getImageProvider());
    m_engine.rootContext()->setContextProperty("adapter", m_vfAdapter.data());
    m_engine.rootContext()->setContextProperty("testsModel", m_testsModel.data());
    m_engine.load(QUrl(QStringLiteral("qrc:/src/QML/main.qml")));

    if (m_engine.rootObjects().isEmpty())
    {
        qDebug() << "Failed to initialize Viewfinder UI";
        return false;
    }

	//hardcoded for now
	if (!QDir(SAVE_PATH).exists()) {
		QDir().mkdir(SAVE_PATH);
	}

	makeConnections();

    return true;
}

void FuelFilterApplication::makeConnections()
{
	connect(m_vfAdapter.data(), &QMLAdapter::testResult, m_testsModel.data(), &TestModel::onTestResult);
}
