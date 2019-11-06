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
bool CScoreCardNumberField::isFreeField() const
{
    return m_FieldType == FREE_SPACE;
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
