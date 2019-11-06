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
#include "ScoreCardSettings.h"

#include <QDebug>

#include <cmath>
#include <random>
#include <set>
#include <vector>

using namespace std;

//============================================================================
CScoreCardModel::CScoreCardModel(QObject* parent) :
    QAbstractListModel(parent),
    m_ScoreCard(makeRandomScoreCard()),
    m_LastError("No error"),
    m_SettingsInstance(CScoreCardSettings::instance())
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
    case PartOfBingoRole:
        return m_ScoreCard[index.row()].isPartOfBingo();
    default:
        qWarning() << "Unknown role" << role << "for CScoreCardModel::data";
        return QVariant();
    }
}

//============================================================================
bool CScoreCardModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (role != NumberRole)
    {
        qWarning() << "Tried to set data \"" << value
                   << "\" which does not have the required role "
                      "eScoreCardNumberFieldRoles::NumberRole!";
        return false;
    }

    qDebug() << "Set data at" << index << "with role" << role << "to value" << value;
    m_ScoreCard[index.row()].setNumber(value.toInt());
    emit dataChanged(index, index, {NumberRole});
    emit isValidChanged();
    return true;
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
    Roles[PartOfBingoRole] = "partOfBingo";
    return Roles;
}

//============================================================================
bool CScoreCardModel::hasBingo() const
{
    return m_HasBingo;
}

//============================================================================
bool CScoreCardModel::isValid() const
{
    const auto valid = all_of(begin(m_ScoreCard), end(m_ScoreCard),
                              [](const CScoreCardNumberField& field) -> bool {
                                  return field.isFreeField() ? true : field.number() > 0;
                              });
    return valid;
}

//============================================================================
QString CScoreCardModel::readLastError() const
{
    return m_LastError;
}

//============================================================================
bool CScoreCardModel::markValidNumber(const QString& Number)
{
    if (Number.isEmpty())
    {
        // don't do anything with an empty input -> don't even show an error
        return true;
    }

    bool ok;
    const int IntNumber = Number.toInt(&ok);
    if (!ok && IntNumber > 0 && IntNumber <= m_NumFields * m_MaxColNumberCount)
    {
        qWarning() << "The given number" << Number << "is not a valid Bingo number!";
        m_LastError = "Invalid Bingo number!";
        return false;
    }

    const auto FieldIndex = m_ScoreCard.indexOf(CScoreCardNumberField(IntNumber));
    if (FieldIndex > -1)
    {
        m_ScoreCard[FieldIndex].mark();
        const auto FieldModelIndex = createIndex(FieldIndex, 0);
        emit dataChanged(FieldModelIndex, FieldModelIndex, {MarkedRole});
    }
    m_LastError = "";
    return true;
}

//============================================================================
void CScoreCardModel::checkForBingo()
{
    unordered_map<int, bool> PossibleBingoColumns;
    unordered_map<int, bool> PossibleBingoRows;
    unordered_map<int, bool> PossibleBingoDiagonals;
    for (int i = 0; i < m_NumColumns; ++i)
    {
        // every column has the chance of containing a bingo
        PossibleBingoColumns[i] = true;
        // every row has the chance of containing a bingo
        PossibleBingoRows[i] = true;
    }
    // every diagonal has the chance of containing a bingo, but only if the user
    // wants to play with diagonal bingos
    PossibleBingoDiagonals[DIAGONAL_0] = m_SettingsInstance->detectDiagonal();
    PossibleBingoDiagonals[DIAGONAL_4] = m_SettingsInstance->detectDiagonal();

    for (int i = 0; i < m_NumFields; ++i)
    {
        const auto FieldIsMarked = m_ScoreCard[i].isMarked();

        // check horizontally
        const auto CurrentRowId = (i - (i % m_NumColumns)) / m_NumColumns;
        PossibleBingoRows[CurrentRowId] &= FieldIsMarked;

        // check vertically
        const auto CurrentColumnId = i % m_NumColumns;
        PossibleBingoColumns[CurrentColumnId] &= FieldIsMarked;

        // check diagonally
        if (CurrentRowId == CurrentColumnId)
        {
            PossibleBingoDiagonals[DIAGONAL_0] &= FieldIsMarked;
        }
        if (CurrentRowId + CurrentColumnId == m_NumColumns - 1)
        {
            PossibleBingoDiagonals[DIAGONAL_4] &= FieldIsMarked;
        }
    }

    setHasBingo(setPartOfBingo(PossibleBingoRows, HORIZONTAL) ||
                setPartOfBingo(PossibleBingoColumns, VERTICAL) ||
                setPartOfBingo(PossibleBingoDiagonals, DIAGONAL_0) ||
                setPartOfBingo(PossibleBingoDiagonals, DIAGONAL_4));
}

//============================================================================
void CScoreCardModel::removeAllMarkers()
{
    for_each(begin(m_ScoreCard), end(m_ScoreCard),
             [](CScoreCardNumberField& field) -> void {
                if (field.fieldType() == CScoreCardNumberField::NORMAL_SPACE)
                {
                    field.mark(false);
                    field.setPartOfBingo(false);
                }
             });
    emit dataChanged(createIndex(0, 0), createIndex(m_NumFields, 0),
                     {MarkedRole, PartOfBingoRole});

    setHasBingo(false);
}

//============================================================================
void CScoreCardModel::newCard()
{
    m_ScoreCard.clear();
    m_ScoreCard = makeRandomScoreCard();
    emit dataChanged(createIndex(0, 0), createIndex(m_NumFields, 0));

    setHasBingo(false);
}

//============================================================================
void CScoreCardModel::clearCard()
{
    for_each(begin(m_ScoreCard), end(m_ScoreCard),
             [](CScoreCardNumberField& field) -> void {
                 field.setNumber(0);
             });
    removeAllMarkers();
    emit dataChanged(createIndex(0, 0), createIndex(m_NumFields, 0));
    emit isValidChanged();

    setHasBingo(false);
}

//============================================================================
QList<CScoreCardNumberField> CScoreCardModel::makeRandomScoreCard()
{
    const auto RandomNumbers = generateRandomNumbers();

    const auto CenterFieldId = static_cast<int>(floor(m_NumFields / 2));
    QList<CScoreCardNumberField> ScoreCard;

    for (int i = 0; i < m_NumFields; ++i)
    {
        // center field is a free field
        const auto Type = i == CenterFieldId ? CScoreCardNumberField::FREE_SPACE :
                                               CScoreCardNumberField::NORMAL_SPACE;
        ScoreCard.append(CScoreCardNumberField(RandomNumbers[i], Type));
    }

    return ScoreCard;
}

//============================================================================
void CScoreCardModel::setHasBingo(bool hasBingo)
{
    m_HasBingo = hasBingo;
    emit hasBingoChanged();
}

//============================================================================
bool CScoreCardModel::setPartOfBingo(const unordered_map<int, bool>& PossibleBingos,
                                     eBingoType Type)
{
    int Step;
    switch (Type)
    {
        case HORIZONTAL:
            Step = 1;
            break;
        case VERTICAL:
            Step = m_NumColumns;
            break;
        case DIAGONAL_0:
            Step = m_NumColumns + 1;
            break;
        case DIAGONAL_4:
            Step = m_NumColumns - 1;
            break;
        default:
            // should not get here
            qCritical() << "Invalid eBingoType" << Type << "!";
            Step = -1;
            break;
    }

    for (const auto& [Idx, HasBingo] : PossibleBingos)
    {
        if (!HasBingo)
        {
            continue;
        }

        int FirstFieldId;
        int LastFieldId;
        switch (Type)
        {
            case HORIZONTAL:
                FirstFieldId = Idx * m_NumColumns;
                LastFieldId = (Idx + 1) * m_NumColumns;
                break;
            case VERTICAL:
                FirstFieldId = Idx;
                LastFieldId = m_NumFields;
                break;
            case DIAGONAL_0:
                FirstFieldId = 0;
                LastFieldId = m_NumFields;
                break;
            case DIAGONAL_4:
                FirstFieldId = m_NumColumns - 1;
                LastFieldId = Idx * m_NumColumns;
                break;
            default:
                // should not get here
                qCritical() << "Invalid eBingoType" << Type << "!";
                FirstFieldId = -1;
                LastFieldId = -1;
                break;
        }

        for (int i = FirstFieldId; i < LastFieldId; i += Step)
        {
            m_ScoreCard[i].setPartOfBingo();
        }
        emit dataChanged(createIndex(FirstFieldId, 0),
                         createIndex(LastFieldId, 0), {PartOfBingoRole});
        return true;
    }
    return false;
}

//============================================================================
std::vector<int> CScoreCardModel::generateRandomNumbers()
{
    vector<int> RandomNumbers;

    // seed the random number generator
    static mt19937 Generator(time(nullptr));

    for (size_t i = 0; i < m_NumColumns; ++i)
    {
        const auto MinNumber = m_MaxColNumberCount * i + 1;
        const auto MaxNumber = MinNumber + m_MaxColNumberCount - 1;
        uniform_int_distribution<> Distribution(MinNumber, MaxNumber);

        set<int> RandomNumberSet;
        while (size(RandomNumberSet) < m_NumColumns)
        {
            RandomNumberSet.insert(Distribution(Generator));
        }

        const auto NewElementIter =
            RandomNumbers.insert(end(RandomNumbers),
                                 begin(RandomNumberSet),
                                 end(RandomNumberSet));
        // because the numbers were sorted in the RandomNumberSet we need to
        // shuffle them to make a nice random scorecard
        shuffle(NewElementIter, end(RandomNumbers), Generator);
    }
    return RandomNumbers;
}
