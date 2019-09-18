//============================================================================
/// \file   ScoreCardNumberField.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Implementation of the CScoreCardNumberField class.
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
    m_Marked{type == FREE_SPACE}, ///< free space (i.e. center field) is marked by default
    m_PartOfBingo{false}
{
}

//============================================================================
CScoreCardNumberField::CScoreCardNumberField(QObject* parent) :
    QObject(parent)
{
}

//============================================================================
CScoreCardNumberField::CScoreCardNumberField(const CScoreCardNumberField& rhs) :
    QObject(rhs.parent()),
    m_Number{rhs.m_Number},
    m_FieldType{rhs.m_FieldType},
    m_Marked{rhs.m_Marked},
    m_PartOfBingo{rhs.m_PartOfBingo}
{
}

//============================================================================
CScoreCardNumberField::CScoreCardNumberField(CScoreCardNumberField&& rhs) noexcept :
    QObject(rhs.parent()),
    m_Number{rhs.m_Number},
    m_FieldType{rhs.m_FieldType},
    m_Marked{rhs.m_Marked},
    m_PartOfBingo{rhs.m_PartOfBingo}
{
}

//============================================================================
CScoreCardNumberField& CScoreCardNumberField::operator=(const CScoreCardNumberField& rhs)
{
    m_Number = rhs.m_Number;
    m_FieldType = rhs.m_FieldType;
    m_Marked = rhs.m_Marked;
    m_PartOfBingo = rhs.m_PartOfBingo;
    return *this;
}

//============================================================================
CScoreCardNumberField& CScoreCardNumberField::operator=(CScoreCardNumberField&& rhs) noexcept
{
    m_Number = rhs.m_Number;
    m_FieldType = rhs.m_FieldType;
    m_Marked = rhs.m_Marked;
    m_PartOfBingo = rhs.m_PartOfBingo;
    return *this;
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

//============================================================================
CScoreCardNumberField::eFieldType CScoreCardNumberField::fieldType() const
{
    return m_FieldType;
}

//============================================================================
void CScoreCardNumberField::setFieldType(const eFieldType& fieldType)
{
    m_FieldType = fieldType;
}

//============================================================================
bool CScoreCardNumberField::isPartOfBingo() const
{
    return m_PartOfBingo;
}

//============================================================================
void CScoreCardNumberField::setPartOfBingo(bool Bingo)
{
    m_PartOfBingo = Bingo;
}


//============================================================================
bool CScoreCardNumberField::operator==(const CScoreCardNumberField& rhs) const
{
    return m_Number == rhs.m_Number
           && m_FieldType == rhs.m_FieldType
           && m_Marked == rhs.m_Marked;
}
