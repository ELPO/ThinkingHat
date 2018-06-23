#include "Problem.h"

Problem::Problem(const QString &name, const QString &statment, const QStringList &uList,
                 const QStringList &sList, const QStringList &cList, int solution)
    : m_name(name)
    , m_statment(statment)
    , m_unknownList(uList)
    , m_startingList(sList)
    , m_changerList(cList)
    , m_solution(solution)
{

}

QSharedPointer<Problem> Problem::createProblem(const QString &name, const QString &statment, const QStringList &uList,
                                               const QStringList &sList, const QStringList &cList, int solution)
{
    if (name.isEmpty()) {
        return QSharedPointer<Problem>(nullptr);
    }

    if (statment.isEmpty()) {
        return QSharedPointer<Problem>(nullptr);
    }

    if (uList.isEmpty()) {
        return QSharedPointer<Problem>(nullptr);
    }

    if (sList.isEmpty()) {
        return QSharedPointer<Problem>(nullptr);
    }

    if (cList.isEmpty()) {
        return QSharedPointer<Problem>(nullptr);
    }

    for (auto u : uList) {
        if (statment.indexOf(u) == -1) {
            return QSharedPointer<Problem>(nullptr);
        }
    }

    for (auto c : cList) {
        if (statment.indexOf(c) == -1) {
            return QSharedPointer<Problem>(nullptr);
        }
    }

    for (auto s : sList) {
        if (statment.indexOf(s) == -1) {
            return QSharedPointer<Problem>(nullptr);
        }
    }

    return QSharedPointer<Problem>(new Problem(name, statment, uList, sList, cList, solution));
}

QString Problem::getName() const
{
    return m_name;
}

QString Problem::getStatment() const
{
    return m_statment;
}

QStringList Problem::getUnknownList() const
{
    return m_unknownList;
}

QStringList Problem::getStartingList() const
{
    return m_startingList;
}

QStringList Problem::getChangerList() const
{
    return m_changerList;
}

int Problem::getSolution() const
{
    return m_solution;
}
