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
    int IntNumber;
    if (!getValidBingoNumber(Number, IntNumber))
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
        const auto Num = uniqueRandBetween(m_MaxColNumberCount * (ColumnId - 1) + 1,
                                           m_MaxColNumberCount * ColumnId);
        const auto Type = i == 12 ? CScoreCardNumberField::FREE_SPACE :
                                    CScoreCardNumberField::NORMAL_SPACE;
        ScoreCard.append(CScoreCardNumberField(Num, Type));
    }

    return ScoreCard;
}

//============================================================================
bool CScoreCardModel::getValidBingoNumber(const QString& StringNumber, int& IntNumber)
{
    bool ok;
    IntNumber = StringNumber.mid(1).toInt(&ok);

    if (ok)
    {
        const auto ColumnId = bingoLetterToColumnId(StringNumber.front());
        const auto LowerBound = 1 + m_MaxColNumberCount * ColumnId;
        const auto UpperBound = LowerBound + m_MaxColNumberCount;
        return (IntNumber >= LowerBound && IntNumber < UpperBound);
    }
    return false;
}

//============================================================================
CScoreCardModel::eBingoLetter CScoreCardModel::bingoLetterToColumnId(const QChar& Letter)
{
    switch (Letter.toLatin1())
    {
    case 'B':
        return LETTER_B;
    case 'I':
        return LETTER_I;
    case 'N':
        return LETTER_N;
    case 'G':
        return LETTER_G;
    case 'O':
        return LETTER_O;
    default:
        // should not get here
        qWarning("The given bingo letter '%c' is not valid!", Letter.toLatin1());
        return LETTER_INVALID;
    }
}