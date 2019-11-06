/**
 ** This file is part of the "Mobile Bingo" project.
 ** Copyright (c) 2019 Florian Meinicke <florian.meinicke@t-online.de>.
 **
 ** Permission is hereby granted, free of charge, to any person obtaining a copy
 ** of this software and associated documentation files (the "Software"), to deal
 ** in the Software without restriction, including without limitation the rights
 ** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 ** copies of the Software, and to permit persons to whom the Software is
 ** furnished to do so, subject to the following conditions:
 **
 ** The above copyright notice and this permission notice shall be included in all
 ** copies or substantial portions of the Software.
 **
 ** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 ** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 ** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 ** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 ** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 ** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 ** SOFTWARE.
 **/

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
