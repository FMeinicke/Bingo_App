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
/// \file   main.cpp
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A mobile app to play Bingo on your Android device.
//============================================================================

//============================================================================
//                                   INCLUDES
//============================================================================
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTime>

#include "ScoreCardModel.h"
#include "ScoreCardNumberField.h"
#include "ScoreCardSettings.h"

/**
 * @brief A custom message handler for formatting console output.
 */
void myMessageOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    QByteArray localTime = QTime::currentTime().toString().toLatin1();

    switch (type)
    {
    case QtDebugMsg:
        fprintf(stdout, "\e[1m%s: DEBUG:\e[0m %s (%s:%u, %s)\n", localTime.constData(), localMsg.constData(), context.file, context.line, context.function);
        break;

    case QtInfoMsg:
        fprintf(stdout, "\e[1m%s: INFO:\e[0m %s (%s:%u, %s)\n", localTime.constData(), localMsg.constData(), context.file, context.line, context.function);
        break;

    case QtWarningMsg:
        fprintf(stderr, "\e[1m%s: WARNING:\e[0m %s (%s:%u, %s)\n", localTime.constData(), localMsg.constData(), context.file, context.line, context.function);
        break;

    case QtCriticalMsg:
        fprintf(stderr, "\e[1m%s: CRITICAL:\e[0m %s (%s:%u, %s)\n", localTime.constData(), localMsg.constData(), context.file, context.line, context.function);
        break;

    case QtFatalMsg:
        fprintf(stderr, "\e[1m%s: FATAL:\e[0m %s (%s:%u, %s)\n", localTime.constData(), localMsg.constData(), context.file, context.line, context.function);
        fflush(stderr);
        abort();
        break;
    }

    fflush(stderr);
    fflush(stdout);
}

//============================================================================
int main(int argc, char* argv[])
{
#ifndef Q_OS_ANDROID
    // just for nicer debug output
    qInstallMessageHandler(myMessageOutput);
#endif
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication App(argc, argv);

    QGuiApplication::setApplicationName("Mobile Bingo App");
    QGuiApplication::setApplicationVersion("0.2.2");

    QQmlApplicationEngine Engine;

    // make C++ classes available to QML
    qmlRegisterType<CScoreCardNumberField>(
                "de.dhge.moco.fm.ScoreCardNumberField", 1, 0,
                "ScoreCardNumberFieldType");
    qmlRegisterType<CScoreCardModel>(
                "de.dhge.moco.fm.ScoreCardModel", 1, 0,
                "ScoreCardModel");
    qmlRegisterSingletonType<CScoreCardSettings>(
                "de.dhge.moco.fm.ScoreCardSettings", 1, 0,
                "ScoreCardSettings",
                [](QQmlEngine* /*unused*/, QJSEngine* /*unused*/) -> QObject* {
                    return CScoreCardSettings::instance();
                });

    // auto generated code
    const QUrl Url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&Engine, &QQmlApplicationEngine::objectCreated,
                     &App, [Url](QObject* Obj, const QUrl& ObjUrl) {
                        if (!Obj && Url == ObjUrl)
                        {
                            QCoreApplication::exit(-1);
                        }
                    },
                    Qt::QueuedConnection);
    Engine.load(Url);

    return App.exec();
}
