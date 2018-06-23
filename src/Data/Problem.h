#ifndef PROBLEM_H
#define PROBLEM_H

#include <QSharedPointer>

class Problem
{

public:
    static QSharedPointer<Problem> createProblem(const QString &name, const QString &statment, const QStringList &uList,
                                                 const QStringList &sList, const QStringList &cList, int solution);

    QString getName() const;

    QString getStatment() const;

    QStringList getUnknownList() const;

    QStringList getStartingList() const;

    QStringList getChangerList() const;

    int getSolution() const;

signals:

public slots:

private:
    QString m_name;
    QString m_statment;
    QStringList m_unknownList;
    QStringList m_startingList;
    QStringList m_changerList;

    int m_solution;

    Problem(const QString &name, const QString &statment, const QStringList &uList,
            const QStringList &sList, const QStringList &cList, int solution);
};

#endif // PROBLEM_H
