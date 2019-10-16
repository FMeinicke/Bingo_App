//============================================================================
/// \file   ScoreCardSettings.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   12.10.2019
/// \brief  Implementation of the CScoreCardSettings class.
//============================================================================

//============================================================================
//                                   INCLUDES
//============================================================================
#include "ScoreCardSettings.h"

#include <QDebug>


using namespace std;

CScoreCardSettings* CScoreCardSettings::m_Instance {nullptr};

//============================================================================
CScoreCardSettings* CScoreCardSettings::instance()
{
    if (!m_Instance)
    {
        m_Instance = new CScoreCardSettings();
    }

    return m_Instance;
}

//============================================================================
bool CScoreCardSettings::detectDiagonal() const
{
    return m_DetectDiagonal;
}

//============================================================================
void CScoreCardSettings::setDetectDiagonal(bool detectDiagonal)
{
    m_DetectDiagonal = detectDiagonal;
    emit detectDiagonalChanged();
}

//============================================================================
CScoreCardSettings::CScoreCardSettings(QObject* parent) :
    QObject(parent)
{
}

//============================================================================
uint CScoreCardSettings::numScoreCards() const
{
    return m_NumScoreCards;
}


//============================================================================
void CScoreCardSettings::setNumScoreCards(const uint& value)
{
    m_NumScoreCards = value;
    emit numScoreCardsChanged();
}
