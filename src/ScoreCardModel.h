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
#include <unordered_map>

#include "ScoreCardNumberField.h"

//============================================================================
//                            FORWARD DECLARATIONS
//============================================================================
class CScoreCardSettings;

/**
 * @brief The CScoreCard class represents a single bingo scorecard
 * consisting of CScoreCardNumberFields.
 */
class CScoreCardModel : public QAbstractListModel
{
    Q_OBJECT
public:
    Q_PROPERTY(bool hasBingo READ hasBingo NOTIFY hasBingoChanged)
    Q_PROPERTY(bool isValid READ isValid NOTIFY isValidChanged)

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
    explicit CScoreCardModel(QObject* parent = nullptr);

    /**
     * @reimp
     * @brief Get the data (i.e. the CScoreCardnumberField object's
     * number/field type/marked status, depending on @a role) at the given @a index.
     */
    QVariant data(const QModelIndex& index, int role) const override;

    /**
     * @reimp
     * @brief setData
     */
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole) override;

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
     * @brief Returns if this is a valid scorecard, i.e. if all fields contains
     * valid numbers. Used to validate a scorecard after entering the numbers
     * before starting a game.
     */
    bool isValid() const;

    /**
     * @brief Mark the given @a Number on the scorecard if it is a valid bingo number.
     * @returns true, if the @a Number appears on this scorecard and hence was marked
     * @returns false, if the @a Number does not appear on this scorecard
     */
    Q_INVOKABLE bool markValidNumber(const QString& Number);

    /**
     * @brief Checks if there is a bingo on this scorecard.
     */
    Q_INVOKABLE void checkForBingo();

    /**
     * @brief Remove all markers from the scorecard.
     */
    Q_INVOKABLE void removeAllMarkers();

    /**
     * @brief Makes a new random scorecard.
     */
    Q_INVOKABLE void newCard();

    /**
     * @brief Sets all number fields of this scorecard to 0. Useful for when the
     * user enters all of the numbers on the scorecard.
     */
    Q_INVOKABLE void clearCard();

signals:
    /**
     * @brief This signal is emitted whenever the scorecard has a bingo.
     */
    void hasBingoChanged();

    /**
     * @brief This signal is emitted whenever the scorecard is filled with only
     * valid numbers.
     */
    void isValidChanged();

protected:
    /**
     * @brief The eBingoType enum defines the different directions of a bingo
     * (i.e. horizontal, vertical, diagonal, ...)
     */
    enum eBingoType
    {
        HORIZONTAL,
        VERTICAL,
        DIAGONAL_0, ///< first diagonal (field IDs: 0, 6, 12, 18, 24) -> diag. ID: 0
        DIAGONAL_4, ///< second diagonal (field IDs: 4, 8, 12, 16, 20)  -> diag. ID: 4
    };


    /**
     * @brief Creates a scorecard with randomly filled number fields.
     */
    static QList<CScoreCardNumberField> makeRandomScoreCard();

private:
    /**
     * @brief Sets the @b HasBingo property to @a hasBingo.
     * Emits @b hasBingoChanged to notify observers.
     */
    void setHasBingo(bool hasBingo);

    /**
     * @brief Checks if there are elements in @a PossibleBingos that indicate a
     * bingo and sets the corresponding number fields as part of the bingo.
     * @a Type indicates the direction of the bingo (i.e. horizontal/vertical/...)
     * @returns true, if there is a bingo
     * @returns false otherwise
     */
    bool setPartOfBingo(const std::unordered_map<int, bool>& PossibleBingos,
                        eBingoType Type);

    /**
     * @brief Generates all of the random numbers for one scorecard and returns
     * them in a vector<int>.
     */
    static std::vector<int> generateRandomNumbers();

    static constexpr int m_NumFields{25};
    static constexpr int m_NumColumns{5};
    /// for each column there are 15 different numbers to pick from randomly
    static constexpr int m_MaxColNumberCount{15};

    QList<CScoreCardNumberField> m_ScoreCard;
    bool m_HasBingo{false}; ///< indicates whether the scorecard has a bingo
    CScoreCardSettings* m_SettingsInstance{nullptr};
};

#endif // CSCORECARDMODEL_H
