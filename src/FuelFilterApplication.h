#ifndef FUELFILTERAPPLICATION_H
#define FUELFILTERAPPLICATION_H

#include "models/TestModel.h"

#include "Viewfinder/QMLAdapter.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

class FuelFilterApplication : public QGuiApplication
{
    Q_OBJECT

public:
    explicit FuelFilterApplication(int &argc, char **argv);

    bool initialize();

	void makeConnections();

private:
	Q_DISABLE_COPY(FuelFilterApplication)

    QScopedPointer<TestModel> m_testsModel;
    QQmlApplicationEngine m_engine;
    QScopedPointer<QMLAdapter> m_vfAdapter;
};

#endif // FUELFILTERAPPLICATION_H
