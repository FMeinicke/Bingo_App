//============================================================================
/// \file   ScoreCard.h
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Declaration of the CScoreCard class.
//============================================================================
#ifndef CSCORECARD_H
#define CSCORECARD_H

//============================================================================
//                                   INCLUDES
//============================================================================
#include <QList>

//============================================================================
//                            FORWARD DECLARATIONS
//============================================================================
class CScoreCardNumberField;

/**
 * @brief The CScoreCard class represents a single bingo scorecard
 * consisting of CScoreCardNumberFields.
 */
class CScoreCard : public QList<CScoreCardNumberField*>
{
public:
    /**
     * @brief Construct a new CScoreCard
     */
    CScoreCard();

    /**
     * @brief Creates a scorecard with randomly filled number fields.
     * @note To easily integrate the scorecard into QML we explicitly use a
     * QList<QObject*> here. It's not supported to use custom types
     * (like CScoreCardNumberField*) as the elements of a QList and make them
     * available to QML. We must use QObject* instead.
     * (see: https://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html)
     */
    static QList<QObject*> makeRandomScoreCard();

private:

    static constexpr int m_NumFields{25};
    static constexpr int m_NumColumns{5};
};

#endif // CSCORECARDMODEL_H
