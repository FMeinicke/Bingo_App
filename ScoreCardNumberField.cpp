//============================================================================
/// \file   ScoreCardNumber.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Implementation of the CScoreCardNumber class.
//============================================================================

//============================================================================
//                                   INCLUDES
//============================================================================
#include "ScoreCardNumberField.h"

//============================================================================
CScoreCardNumberField::CScoreCardNumberField(int number, QObject* parent) :
    QObject(parent),
    m_Number{number},
    m_Marked{false}
{
}

////============================================================================
//CScoreCardNumberField::CScoreCardNumberField(const CScoreCardNumberField& rhs) :
//    QObject(nullptr),
//    m_Number{rhs.m_Number},
//    m_Marked{rhs.m_Marked}
//{
//}

////============================================================================
//CScoreCardNumberField::CScoreCardNumberField(CScoreCardNumberField&& rhs) :
//    m_Number{rhs.m_Number},
//    m_Marked{rhs.m_Marked}
//{
//}

////============================================================================
//CScoreCardNumberField& CScoreCardNumberField::operator=(const CScoreCardNumberField& rhs)
//{
//    m_Number = rhs.m_Number;
//    m_Marked = rhs.m_Marked;
//    return *this;
//}

////============================================================================
//CScoreCardNumberField& CScoreCardNumberField::operator=(CScoreCardNumberField&& rhs)
//{
//    m_Number = rhs.m_Number;
//    m_Marked = rhs.m_Marked;
//    return *this;
//}

//============================================================================
bool CScoreCardNumberField::isMarked() const
{
    return m_Marked;
}

//============================================================================
void CScoreCardNumberField::mark(bool marked)
{
    m_Marked = marked;
}

//============================================================================
int CScoreCardNumberField::number() const
{
    return m_Number;
}

//============================================================================
void CScoreCardNumberField::setNumber(int number)
{
    m_Number = number;
}
