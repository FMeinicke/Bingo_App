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
