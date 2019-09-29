//============================================================================
/// \file   ScoreCardModel.h
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  Declaration of the CScoreCardModel class.
//============================================================================
#ifndef CSCORECARDMODEL_H
#define CSCORECARDMODEL_H

//============================================================================
//                                   INCLUDES
//============================================================================
#include <QAbstractListModel>

#include "ScoreCardNumberField.h"

/**
 * @brief The CScoreCard class represents a single bingo scorecard
 * consisting of CScoreCardNumberFields.
 */
class CScoreCardModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_PROPERTY(bool hasBingo READ hasBingo NOTIFY hasBingoChanged)

    /**
     * @brief The eScoreCardNumberFieldRoles enum defines the different roles
     * of this model. Each role represents an attribute of the underlying data
     * (i.e. attributes of the CScoreCardNubmerField class in this case) that
     * should be accessible from QML.
     */
    enum eScoreCardNumberFieldRoles
    {
        NumberRole = Qt::UserRole + 1,
        FieldTypeRole,
        MarkedRole,
        PartOfBingoRole,
    };

    /**
     * @brief Construct a new CScoreCardModel with @a parent as the parent object
     */
    CScoreCardModel(QObject* parent = nullptr);


    /**
     * @reimp
     * @brief Get the data (i.e. the CScoreCardnumberField object's
     * number/field type/marked status, depending on @a role) at the given @a index.
     */
    QVariant data(const QModelIndex& index, int role) const override;

    /**
     * @reimp
     * @brief Get the number of items (i.e. CScoreCardNumberField objects) of this model.
     */
    int rowCount(const QModelIndex& /*parent*/ = QModelIndex()) const override;

    /**
     * @reimp
     * @brief Returns the model's role names
     */
    QHash<int, QByteArray> roleNames() const override;

    /**
     * @brief Returns whether this scorecard has a bingo
     */
    bool hasBingo() const;

    /**
     * @brief Get the error message of the error that occurred latest.
     */
    Q_INVOKABLE QString readLastError() const;

    /**
     * @brief Mark the given @a Number on the scorecard if it is a valid bingo number.
     * @returns true, if the @a Number is valid
     * @returns false, if the @a Number is not valid. Get the exact error message
     * by calling @b readLastError()
     */
    Q_INVOKABLE bool markValidNumber(const QString& Number);

    /**
     * @brief Checks if there is a bingo on this scorecard.
     */
    Q_INVOKABLE void checkForBingo();

    /**
     * @brief Remove all markers from the scorecard.
     */
    Q_INVOKABLE void clearCard();

    /**
     * @brief Makes a new random scorecard.
     */
    Q_INVOKABLE void newCard();

signals:
    /**
     * @brief This signal is emitted whenever the scorecard has a bingo.
     */
    void hasBingoChanged();

protected:
    /**
     * @brief The eBingoLetter enum defines the column IDs of the letters
     * 'B', 'I', 'N', 'G' and 'O' on a bingo scorecard. That means the first column
     * on a scorecard has the letter 'B' and therefore ID `0' (or @a LETTER_B).
     */
    enum eBingoLetter
    {
        LETTER_B,
        LETTER_I,
        LETTER_N,
        LETTER_G,
        LETTER_O,
        LETTER_INVALID = -1,
    };

    /**
     * @brief The eBingoType enum defines the different directions of a bingo
     * (i.e. horizontal, vertical, diagonal, ...)
     */
    enum eBingoType
    {
        HORIZONTAL,
        VERTICAL,
        DIAGONAL
    };


    /**
     * @brief Creates a scorecard with randomly filled number fields.
     */
    static QList<CScoreCardNumberField> makeRandomScoreCard();

    /**
     * @brief Converts the given @a StringNumber from a string to an integer and
     * returns it in @a IntNumber. During conversion the first letter gets
     * stripped off and therefore @a IntNumber contains just the integer after
     * the letter (e.g. for the given string 'B13' @a IntNumber would contain `13').
     * @returns true, if the number is valid and the conversion was succesfull.
     * @a IntNumber contains the converted number.
     * @returns false, if the number is not valid and the conversion was not
     *  succesfull.@a IntNumber contains the value `0'.
     */
    static bool getValidBingoNumber(const QString& StringNumber, int& IntNumber);

    /**
     * @brief Converts the given @a Letter to an eBingoLetter that indicates the
     * column ID for the @a Letter (i.e. letter 'B' corresponds to ID 0,
     * 'I' to ID 1, and so on). If the letter is not one of 'B', 'I', 'N', 'G' or 'O'
     * @a LETTER_INVALID is returned.
     */
    static eBingoLetter bingoLetterToColumnId(const QChar& Letter);

private:
    /**
     * @brief Sets the @b HasBingo property to @a hasBingo.
     * Emits @b hasBingoChanged to notify observers.
     */
    void setHasBingo(bool hasBingo);


    static constexpr int m_NumFields{25};
    static constexpr int m_NumColumns{5};
    // for each column there are 15 different numbers to pick from randomly
    static constexpr int m_MaxColNumberCount{15};

    QList<CScoreCardNumberField> m_ScoreCard;
    QString m_LastError; ///< contains a description of the last occurred error
    bool m_HasBingo{false}; ///< indicates whether the scorecard has a bingo
};

#endif // CSCORECARDMODEL_H
