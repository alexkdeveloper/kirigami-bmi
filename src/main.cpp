/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>

#include "about.h"
#include "app.h"
#include "version-bmicalc.h"
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "bmicalcconfig.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));
    QCoreApplication::setApplicationName(QStringLiteral("bmicalc"));

    KAboutData aboutData(
                         // The program name used internally.
                         QStringLiteral("bmicalc"),
                         // A displayable program name string.
                         i18nc("@title", "BMI Calculator"),
                         // The program version string.
                         QStringLiteral("1.0.0"),
                         // Short description of what the app does.
                         i18n("Body mass index calculator"),
                         // The license this code is released under.
                         KAboutLicense::GPL,
                         // Copyright Statement.
                         i18n("(c) 2023"));
    aboutData.addAuthor(i18nc("@info:credit", "Alex K"),
                        i18nc("@info:credit", "Developer"),
                        QStringLiteral("unknown"),
                        QStringLiteral("https://github.com/alexkdeveloper"));
    KAboutData::setApplicationData(aboutData);

    QQmlApplicationEngine engine;

    auto config = bmicalcConfig::self();

    qmlRegisterSingletonInstance("org.kde.bmicalc", 1, 0, "Config", config);

    AboutType about;
    qmlRegisterSingletonInstance("org.kde.bmicalc", 1, 0, "AboutType", &about);

    App application;
    qmlRegisterSingletonInstance("org.kde.bmicalc", 1, 0, "App", &application);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
