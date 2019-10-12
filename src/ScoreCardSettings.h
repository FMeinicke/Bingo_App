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

public:
    /**
     * @brief Get the CScoreCardSettings instance
     */
    static CScoreCardSettings* instance();

    /**
     * @brief Get whether the @b checkForBingo() method should also check for
     * diagonal bingos.
     */
    bool detectDiagonal() const;

    /**
     * @brief Set whether the @b checkForBingo() method should also check for
     * diagonal bingos.
     */
    void setDetectDiagonal(bool detectDiagonal);

signals:
    void detectDiagonalChanged();

private:
    /**
     * @brief C'tor
     */
    CScoreCardSettings(QObject* parent = nullptr);

    static CScoreCardSettings* m_Instance;

    bool m_DetectDiagonal{true}; ///< whether to also check for diagonal bingos
};

#endif // SCORECARDSETTINGS_H
