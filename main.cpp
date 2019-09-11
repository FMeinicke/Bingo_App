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
#include <QTime>

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

int main(int argc, char* argv[])
{
    // just for nicer debug output
    qInstallMessageHandler(myMessageOutput);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication App(argc, argv);

    QQmlApplicationEngine Engine;
    const QUrl Url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&Engine, &QQmlApplicationEngine::objectCreated,
                     &App, [Url](QObject* Obj, const QUrl& ObjUrl) {
        if (!Obj && Url == ObjUrl)
        {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    Engine.load(Url);

    return App.exec();
}
