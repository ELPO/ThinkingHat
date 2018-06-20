#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QJsonDocument>
#include <QDebug>
#include <QFile>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QFile f(":/resources/problems/data.json");
    qDebug() << f.exists();

    if(!f.open(QFile::ReadOnly | QFile::Text)){
        qDebug() << "could not open file for read";
        return -1;
    }

    QJsonDocument sd = QJsonDocument::fromJson(f.readAll());
    qDebug() << "hola" << sd.toJson(QJsonDocument::Compact).toStdString().c_str();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
