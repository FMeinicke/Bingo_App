//============================================================================
/// \file   ScoreCard.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Implementation of the CScoreCard class.
//============================================================================

//============================================================================
//                                   INCLUDES
//============================================================================
#include "ScoreCard.h"

#include "ScoreCardNumberField.h"

#include <QDebug>

#include <unordered_map>

using namespace std;

//============================================================================
CScoreCard::CScoreCard()
{
}

//============================================================================
QList<QObject*> CScoreCard::makeRandomScoreCard()
{
    QList<QObject*> ScoreCard;

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
        ScoreCard.append(new CScoreCardNumberField(Num, Type));
    }

    return ScoreCard;
}
