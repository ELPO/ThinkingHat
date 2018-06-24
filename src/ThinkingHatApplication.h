#ifndef THINKINGHATAPPLICATION_H
#define THINKINGHATAPPLICATION_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Models/ProblemsModel.h"

class ThinkingHatApplication : public QGuiApplication
{
    Q_OBJECT

public:
    explicit ThinkingHatApplication(int &argc, char **argv);

    bool initialize();

    void makeConnections();

private:
    Q_DISABLE_COPY(ThinkingHatApplication)

    QQmlApplicationEngine m_engine;
    QScopedPointer<ProblemsModel> m_problemsModel;
};


#endif // THINKINGHATAPPLICATION_H
