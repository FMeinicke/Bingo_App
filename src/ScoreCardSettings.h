//============================================================================
/// \file   ScoreCardSettings.h
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   12.10.2019
/// \brief  Declaration of the CScoreCardSettings class.
//============================================================================
#ifndef SCORECARDSETTINGS_H
#define SCORECARDSETTINGS_H

//============================================================================
//                                   INCLUDES
//============================================================================
#include <QObject>


/**
 * @brief The CScoreCardSettings class is a singleton encapsulating all shared
 * settings between all of the scorecards used in the app (e.g. global game settings)
 */
class CScoreCardSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool detectDiagonal READ detectDiagonal WRITE setDetectDiagonal NOTIFY detectDiagonalChanged)
    Q_PROPERTY(uint numScoreCards READ numScoreCards WRITE setNumScoreCards NOTIFY numScoreCardsChanged)

public:
    /**
     * @brief Get the CScoreCardSettings instance
     */
    static CScoreCardSettings* instance();

    /**
     * @brief Get whether the @b CScoreCardModel::checkForBingo() method should
     * also check for diagonal bingos.
     */
    bool detectDiagonal() const;

    /**
     * @brief Set whether the @b CScoreCardModel::checkForBingo() method should
     * also check for diagonal bingos.
     */
    void setDetectDiagonal(bool detectDiagonal);

    /**
     * @brief Get the number of scorecards for a game with random scorecards.
     */
    uint numScoreCards() const;

    /**
     * @brief Set the number of scorecards to use for a game with random cards.
     */
    void setNumScoreCards(const uint& value);

signals:
    /**
     * @brief This signal is emitted whenever the property @a detectDiagonal is changed.
     */
    void detectDiagonalChanged();

    /**
     * @brief This signal is emitted whenever the number of scorecards for a game
     * with random cards changes.
     */
    void numScoreCardsChanged();


private:
    /**
     * @brief C'tor
     */
    CScoreCardSettings(QObject* parent = nullptr);

    static CScoreCardSettings* m_Instance;

    bool m_DetectDiagonal{true}; ///< whether to also check for diagonal bingos
    uint m_NumScoreCards{5}; ///< how many scorecards to use or a random game
};

#endif // SCORECARDSETTINGS_H
