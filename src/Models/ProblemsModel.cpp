#include "ProblemsModel.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QFile>

ProblemsModel::ProblemsModel(QObject *parent)
    : QAbstractListModel(parent) ,
      m_version(0)
{
}

bool ProblemsModel::initialize(const QString &dataPath)
{
    m_problems.clear();

    QFile f(dataPath);

    if(!f.open(QFile::ReadOnly | QFile::Text)){
        qDebug() << "could not open file for read";
        return false;
    }

    QJsonDocument sd = QJsonDocument::fromJson(f.readAll());
    QJsonObject problemData = sd.object();
    QString versionStr = problemData.value("problem list version").toString();
    bool error = false;
    int version = versionStr.toInt(&error);
    if (error) {
        m_version = 0;
    } else {
        m_version = version;
    }

    QJsonArray problemArray = problemData.value("problems").toArray();

    for (auto problem : problemArray) {
        QString name = problem.toObject()["name"].toString();
        if (name.isEmpty()) {
            qDebug() << "Json parsing failed. Name is empty.";
            return false;
        }

        QString statment = problem.toObject()["statment"].toString();
        if (statment.isEmpty()) {
            qDebug() << "Json parsing failed. Statment in " << name << " is empty.";
            return false;
        }

        QJsonArray unknownList = problem.toObject()["unknown"].toArray();
        if (unknownList.isEmpty()) {
            qDebug() << "Json parsing failed. Unknown in " << name << " is empty.";
            return false;
        }

        QStringList uList;
        for (auto unknown : unknownList) {
            uList.append(unknown.toString());
        }

        if (uList.isEmpty()) {
            qDebug() << "Json parsing failed. Unknown list in " << name << " is empty.";
            return false;
        }

        QJsonArray startingList = problem.toObject()["starting"].toArray();
        if (startingList.isEmpty()) {
            qDebug() << "Json parsing failed. Starting in " << name << " is empty.";
            return false;
        }

        QStringList sList;
        for (auto starting : startingList) {
            sList.append(starting.toString());
        }

        if (sList.isEmpty()) {
            qDebug() << "Json parsing failed. Starting list in " << name << " is empty.";
            return false;
        }

        QJsonArray changerList = problem.toObject()["changer"].toArray();
        if (changerList.isEmpty()) {
            qDebug() << "Json parsing failed. Changer in " << name << " is empty.";
            return false;
        }

        QStringList cList;
        for (auto changer : changerList) {
            cList.append(changer.toString());
        }

        if (cList.isEmpty()) {
            qDebug() << "Json parsing failed. Changer list in " << name << " is empty.";
            return false;
        }

        int solution = problem.toObject()["solution"].toInt(-1000);
        if (solution == -1000) {
            qDebug() << "Json parsing failed. Changer in " << name << " is empty.";
            return false;
        }

        QSharedPointer<Problem> p = Problem::createProblem(name, statment, uList, sList, cList, solution);
        if (p.isNull())
        {
            qDebug() << "Problem creation failed.";
            return false;
        }

        m_problems.append(p);
    }

    if (m_problems.empty())
    {
        qDebug() << "Error: Problem list is Empty";
        return false;
    }

    return true;
}

int ProblemsModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_problems.count();
}

QVariant ProblemsModel::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() >= m_problems.count())
        return QVariant();

    QSharedPointer<Problem> p = m_problems[index.row()];
    if (role == NameRole)
        return p->getName();
    return QVariant();
}

QHash<int, QByteArray> ProblemsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}

QString ProblemsModel::getName(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return "";

    QSharedPointer<Problem> p = m_problems[index];
    return p->getName();
}

QString ProblemsModel::getStatment(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return "";

    QSharedPointer<Problem> p = m_problems[index];
    return p->getStatment();
}

QStringList ProblemsModel::getUnknown(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return QStringList();

    QSharedPointer<Problem> p = m_problems[index];
    return p->getUnknownList();
}

QStringList ProblemsModel::getStarting(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return QStringList();

    QSharedPointer<Problem> p = m_problems[index];
    return p->getStartingList();
}

QStringList ProblemsModel::getChanger(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return QStringList();

    QSharedPointer<Problem> p = m_problems[index];
    return p->getChangerList();
}

int ProblemsModel::getSolution(int index) const
{
    if (index < 0 || index >= m_problems.count())
        return -1;

    QSharedPointer<Problem> p = m_problems[index];
    return p->getSolution();
}

int ProblemsModel::version() const
{
    return m_version;
}
