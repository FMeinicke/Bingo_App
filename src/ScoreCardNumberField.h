//============================================================================
/// \file   ScoreCardNumberField.h
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Declaration of the CScoreCardNumberField class.
//============================================================================
#ifndef CSCORECARDNUMBERFIELD_H
#define CSCORECARDNUMBERFIELD_H

//============================================================================
//                                   INCLUDES
//============================================================================
#include <QObject>

/**
 * @brief The CScoreCardNumber class represents one number in a field on a bingo
 * scorcard. The number can be marked or unmarked.
 */
class CScoreCardNumberField : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief The FieldType enum specifies the two different types of fields on
     * a scorecard.
     */
    enum eFieldType
    {
        FREE_SPACE, ///< the free space in the center of the scorecard
        NORMAL_SPACE, ///< any other field on the scorecard
    };
    Q_ENUM(eFieldType); ///< make Qt aware of this enum to use it in QML as well

    /**
     * @brief Construct a new CScoreCardNumber initialized with @a number,
     * @a type and @a parent as the parent object.
     */
    CScoreCardNumberField(int number, eFieldType type = NORMAL_SPACE, QObject* parent = nullptr);

    /**
     * @brief Default c'tor
     */
    CScoreCardNumberField(QObject* parent = nullptr);

    /**
     * @brief Copy c'tor
     */
    CScoreCardNumberField(const CScoreCardNumberField& rhs);

    /**
     * @brief Move c'tor
     */
    CScoreCardNumberField(CScoreCardNumberField&& rhs) noexcept;

    /**
     * @brief Copy assignment operator
     */
    CScoreCardNumberField& operator=(const CScoreCardNumberField& rhs);

    /**
     * @brief Move assignment operator
     */
    CScoreCardNumberField& operator=(CScoreCardNumberField&& rhs) noexcept;

    /**
     * @brief D'tor
     */
    ~CScoreCardNumberField() override = default;


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
     * @brief Returns the internal number of this number field
     * @return
     */
    int number() const;

    /**
     * @brief Set the internal number of this number field to @a number
     */
    void setNumber(int number);

    /**
     * @brief Returns the type of this number field
     */
    eFieldType fieldType() const;

    /**
     * @brief Set the type of this number field to @a fieldType
     */
    void setFieldType(const eFieldType& fieldType);

    /**
     * @brief Conveniwnce function to check if the type of this field is @b FREE_FIELD.
     */
    bool isFreeField() const;

    /**
     * @brief Returns whether this number field is part of a bingo row/column/diagonal
     */
    bool isPartOfBingo() const;

    /**
     * @brief Set whether this number field is part of a bingo row/column/diagonal
     */
    void setPartOfBingo(bool partOfBingo = true);

    /**
     * @brief Returns if the field @a rhs is equal to this number field
     */
    bool operator==(const CScoreCardNumberField& rhs) const;

signals:

public slots:

private:
    int m_Number{}; ///< the field's number (from 1 to 75)
    eFieldType m_FieldType{}; ///< the field type (either FREE_SPACE or NORMAL_SPACE)
    bool m_Marked{}; ///< a called-out number gets marked
    bool m_PartOfBingo{}; ///< true if the field is part of a bingo row/column/diagonal
};

#endif // CSCORECARDNUMBERFIELD_H
