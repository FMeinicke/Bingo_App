//============================================================================
/// \file   ScoreCardModel.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Implementation of the CScoreCardModel class.
//============================================================================

//============================================================================
//                                   INCLUDES
//============================================================================
#include "ScoreCardModel.h"

#include <QDebug>

#include <unordered_map>

using namespace std;

//============================================================================
CScoreCardModel::CScoreCardModel(QObject* parent) :
    QAbstractListModel(parent),
    m_ScoreCard(makeRandomScoreCard())
{
}

//============================================================================
QVariant CScoreCardModel::data(const QModelIndex& index, int role) const
{
    switch (role)
    {
    case NumberRole:
        return m_ScoreCard[index.row()].number();
    case FieldTypeRole:
        return m_ScoreCard[index.row()].fieldType();
    case MarkedRole:
        return m_ScoreCard[index.row()].isMarked();
    default:
        qWarning() << "Unknown role" << role << "for CScoreCardModel::data";
        return QVariant();
    }
}

//============================================================================
int CScoreCardModel::rowCount(const QModelIndex& /*parent*/) const
{
    return m_NumFields;
}

//============================================================================
QHash<int, QByteArray> CScoreCardModel::roleNames() const
{
    QHash<int, QByteArray> Roles;
    Roles[NumberRole] = "number";
    Roles[FieldTypeRole] = "fieldType";
    Roles[MarkedRole] = "marked";
    return Roles;
}

//============================================================================
void CScoreCardModel::markNumber(const QString& Number)
{
    bool ok;
    const auto IntNumber = Number.toInt(&ok);
    if (!ok)
    {
        qWarning() << "The given number" << Number << "is not a valid Bingo number!";
        return;
    }

    const auto FieldIndex = m_ScoreCard.indexOf(CScoreCardNumberField(IntNumber));
    if (FieldIndex > -1)
    {
        m_ScoreCard[FieldIndex].mark();
        const auto FieldModelIndex = createIndex(FieldIndex, 0);
        emit dataChanged(FieldModelIndex, FieldModelIndex, {MarkedRole});
    }
}


//============================================================================
void CScoreCardModel::clearCard()
{
    for (auto& el : m_ScoreCard)
    {
        el.mark(false);
    }
    emit dataChanged(createIndex(0, 0), createIndex(m_NumFields, 0), {MarkedRole});
}

//============================================================================
void CScoreCardModel::newCard()
{
    m_ScoreCard.clear();
    m_ScoreCard = makeRandomScoreCard();
    emit dataChanged(createIndex(0, 0), createIndex(m_NumFields, 0));
}


//============================================================================
QList<CScoreCardNumberField> CScoreCardModel::makeRandomScoreCard()
{
    QList<CScoreCardNumberField> ScoreCard;

    // for each column there are 15 different number to pick from randomly
    constexpr auto MAX_COL_NUMBER_COUNT = 15;

    // initialise random seed
    srand(time(nullptr));

    unordered_map<int, int> TakenNumbers(m_NumFields);

    /**
     * @brief Calculates a unique random number between @arg lower and @arg upper.
     */
    auto uniqueRandBetween = [&TakenNumbers] (int lower, int upper) -> int
    {
        int RandomNumber{};
        do
        {
            RandomNumber = rand() % (upper + 1 - lower) + lower;
        }
        while (TakenNumbers[RandomNumber] == 1);
        TakenNumbers[RandomNumber]++;

        return RandomNumber;
    };

    for (int i = 0; i < m_NumFields; ++i)
    {
        const auto ColumnId = i % m_NumColumns + 1;
        const auto Num = uniqueRandBetween(MAX_COL_NUMBER_COUNT * (ColumnId - 1) + 1,
                                     MAX_COL_NUMBER_COUNT * ColumnId);
        const auto Type = i == 12 ? CScoreCardNumberField::FREE_SPACE :
                                    CScoreCardNumberField::NORMAL_SPACE;
        ScoreCard.append(CScoreCardNumberField(Num, Type));
    }

    return ScoreCard;
}
