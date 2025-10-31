#include <QApplication>
#include <QGuiApplication>
#include <QIcon>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QRunnable>
#include <QThreadPool>
#include <iostream>

#include "SMU.h"
#include "config.h"
#include "utils/fileio.h"

int main(int argc, char* argv[]) {
  QLoggingCategory::setFilterRules("*.debug=false");

  // Prevent config being written to ~/.config/Unknown
  // Organization/pixelpulse2.conf
  QCoreApplication::setOrganizationName("ADI");
  QCoreApplication::setApplicationName("Pixelpulse2");

  QLocale::setDefault(QLocale(QLocale::English, QLocale::UnitedStates));

  registerTypes();

  SessionItem smu_session;
  FileIO fileIO;

  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("session", &smu_session);

  QVariantMap versions;
  versions.insert("build_date", BUILD_DATE);
  versions.insert("git_version", GIT_VERSION);
  engine.rootContext()->setContextProperty("versions", versions);
  engine.rootContext()->setContextProperty("fileio", &fileIO);
  engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

  app.setWindowIcon(QIcon("qrc:/icons/pp2.ico"));

  int r = app.exec();
  smu_session.closeAllDevices();

  return r;
}
