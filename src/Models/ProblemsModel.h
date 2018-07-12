#ifndef PROBLEMSMODEL_H
#define PROBLEMSMODEL_H

#include <QAbstractListModel>

#include "../Data/Problem.h"

class ProblemsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum AnimalRoles {
        NameRole = Qt::UserRole + 1
    };

    explicit ProblemsModel(QObject *parent = nullptr);

    bool initialize(const QString &dataPath);

    int rowCount(const QModelIndex & parent) const override;

    QVariant data(const QModelIndex & index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QString getName(int index) const;
    Q_INVOKABLE QString getStatment(int index) const;
    Q_INVOKABLE QStringList getUnknown(int index) const;
    Q_INVOKABLE QStringList getStarting(int index) const;
    Q_INVOKABLE QStringList getChanger(int index) const;
    Q_INVOKABLE int getSolution(int index) const;

    int version() const;

signals:

public slots:

private:
    QList<QSharedPointer<Problem>> m_problems;

    int m_version;
};

#endif // PROBLEMSMODEL_H
