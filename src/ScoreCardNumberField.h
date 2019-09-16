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
 * scorcard. The number can be marked or unmarked.
 */
class CScoreCardNumberField : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(bool marked READ isMarked WRITE mark NOTIFY markedChanged)
    Q_PROPERTY(eFieldType fieldType READ fieldType WRITE setFieldType NOTIFY fieldTypeChanged)

public:
    /**
     * @brief The FieldType enum specifies the two different types of fields on
     * a scorecard.
     */
    enum eFieldType
    {
        FREE_SPACE, ///< the free space in the denter of the scorecard
        NORMAL_SPACE, ///< ay other field on the scorecard
    };
    Q_ENUM(eFieldType);

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

    /**
     * @brief Returns the type of this number field
     */
    eFieldType fieldType() const;

    /**
     * @brief Set the type of this number field to @a fieldType
     */
    void setFieldType(const eFieldType& fieldType);

signals:
    /**
     * @brief This field is emitted every time the number of the field changed.
     */
    void numberChanged();

    /**
     * @brief This signal is mitted every time the field is marked or cleared.
     */
    void markedChanged();

    /**
     * @brief This signal is mitted every time the field is marked or cleared.
     */
    void fieldTypeChanged();

public slots:

private:
    int m_Number{};
    eFieldType m_FieldType{};
    bool m_Marked{};
};

#endif // CSCORECARDNUMBER_H
