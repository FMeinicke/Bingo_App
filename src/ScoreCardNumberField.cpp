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
CScoreCardNumberField::CScoreCardNumberField(int number, eFieldType type, QObject* parent) :
    QObject(parent),
    m_Number{number},
    m_FieldType{type},
    m_Marked{false}
{
}

CScoreCardNumberField::CScoreCardNumberField(QObject* parent) :
    QObject(parent)
{
}

//============================================================================
bool CScoreCardNumberField::isMarked() const
{
    return m_Marked;
}

//============================================================================
void CScoreCardNumberField::mark(bool marked)
{
    m_Marked = marked;
    emit markedChanged();
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
    emit numberChanged();
}

CScoreCardNumberField::eFieldType CScoreCardNumberField::fieldType() const
{
    return m_FieldType;
}

void CScoreCardNumberField::setFieldType(const eFieldType& fieldType)
{
    m_FieldType = fieldType;
    emit fieldTypeChanged();
}
