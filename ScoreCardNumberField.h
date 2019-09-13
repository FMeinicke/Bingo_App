//============================================================================
/// \file   ScoreCardNumber.h
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Declaration of the CScoreCardNumber class.
//============================================================================
#ifndef CSCORECARDNUMBER_H
#define CSCORECARDNUMBER_H

//============================================================================
//                                   INCLUDES
//============================================================================

#include <QObject>

/**
 * @brief The CScoreCardNumber class represents one number in a field on a bingo
 * score card. The number can be marked or unmarked.
 */
class CScoreCardNumberField : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int number READ number WRITE setNumber)
    Q_PROPERTY(bool marked READ isMarked WRITE mark)

public:
    /**
     * @brief Construct a new CScoreCardNumber initialized with @a number and
     * @a parent as the parent object.
     */
    CScoreCardNumberField(int number, QObject* parent = nullptr);

//    /**
//     * @brief Copy c'tor
//     */
//    CScoreCardNumberField(const CScoreCardNumberField& rhs);

//    /**
//     * @brief Move c'tor
//     */
//    CScoreCardNumberField(CScoreCardNumberField&& rhs);

//    /**
//     * @brief Copy assignment operator
//     */
//    CScoreCardNumberField& operator= (const CScoreCardNumberField& rhs);

//    /**
//     * @brief Move assignment operator
//     */
//    CScoreCardNumberField& operator= (CScoreCardNumberField&& rhs);


//    ~CScoreCardNumberField() override = default;

    /**
     * @brief Returns whether this number is marked or not
     * @returns true if marked, false otherwise
     */
    bool isMarked() const;

    /**
     * @brief Set whether the number is marked or not
     */
    void mark(bool marked = true);

    /**
     * @brief Returns the interal number of this number field
     * @return
     */
    int number() const;

    /**
     * @brief Set the internal number of this number field to @a number
     */
    void setNumber(int number);

signals:

public slots:

private:
    int m_Number{};
    bool m_Marked{};
};

#endif // CSCORECARDNUMBER_H
