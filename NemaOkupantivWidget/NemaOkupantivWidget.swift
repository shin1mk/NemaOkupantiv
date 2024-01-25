//
//  NemaOkupantivWidget.swift
//  NemaOkupantivWidget
//
//  Created by SHIN MIKHAIL on 25.01.2024.
//

import WidgetKit
import SwiftUI
import AppIntents

struct NemaOkupantivWidget: Widget {
    let kind: String = "NemaOkupantivWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NemaOkupantivWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NemaOkupantiv Widget")
        .description("Widget to display current alarm.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
// MARK: - Widget Preview
struct NemaOkupantivWidget_Previews: PreviewProvider {
    static var previews: some View {
        NemaOkupantivWidgetEntryView(entry: NemaOkupantivWidgetEntry(date: Date(), configuration: ConfigurationAppIntent(), activeAlerts: [], lastUpdate: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        //            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


struct NemaOkupantivWidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let activeAlerts: [Alert] // Добавляем это свойство
    let lastUpdate: Date // Добавлено новое свойство
    
}

struct NemaOkupantivWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            // Отображаем результат запроса в виджете
            Text("Днiпро")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 0)
                .widgetBackground(backgroundView: Color(.sRGB, red: 28/255, green: 28/255, blue: 30/255).opacity(0.9))
            // Проверяем наличие активных тревог
            if entry.activeAlerts.isEmpty {
                Text("Немає тривоги")
                    .foregroundColor(.green)
                    .padding(.bottom, 15)
            } else {
                Text("Є тривога")
                    .foregroundColor(.red)
                    .padding(.bottom, 15)
            }
            // Добавляем отображение lastUpdate
            Text("Оновлено: \(formattedDate(from: entry.lastUpdate))")
                .font(.system(size: 8, weight: .light))
                .foregroundColor(.gray)
                .padding(.bottom, 0)

            if #available(iOS 17.0, macOS 14.0, *) {
                Button(intent: MyWidgetActionIntent()) {
                    
                    Image(systemName: "arrow.clockwise.circle") // Иконка "refresh"
                        .foregroundColor(.white)
                        .imageScale(.large)

                    Text("Оновити")
                        .foregroundColor(.white)

                }

            }
        }
    }
}


func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .medium
    return dateFormatter.string(from: date)
}

// вызов апи
@available(iOS 17.0, macOS 14.0, *)
struct MyWidgetActionIntent: AppIntent {
    static var title: LocalizedStringResource = "My Widget Action"
    static var description = IntentDescription("Perform an action from the widget.")
    
    private static var lastExecutionDate: Date?
    
    func perform() async throws -> some IntentResult {
        // Ваш код действия, который будет выполнен при нажатии на кнопку в виджете
        
        // Проверяем, прошло ли более 1 минуты с последнего нажатия
        if let lastExecutionDate = MyWidgetActionIntent.lastExecutionDate,
           Date().timeIntervalSince(lastExecutionDate) < 5 {
            print("Button press is restricted to once per minute.")
            return .result()
        }
        
        print("Button pressed in widget!")
        
        // Вызываем ваш асинхронный код
        performDniproAirAlertRequest()
        
        // Запоминаем текущее время как время последнего нажатия
        MyWidgetActionIntent.lastExecutionDate = Date()
        
        return .result()
    }
}



struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> NemaOkupantivWidgetEntry {
        NemaOkupantivWidgetEntry(date: Date(), configuration: ConfigurationAppIntent(), activeAlerts: [], lastUpdate: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> NemaOkupantivWidgetEntry {
        NemaOkupantivWidgetEntry(date: Date(), configuration: configuration, activeAlerts: [], lastUpdate: Date())
    }

    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<NemaOkupantivWidgetEntry> {
        var entries: [NemaOkupantivWidgetEntry] = []
        
        // Генерируем таймлайн, состоящий из пяти записей с интервалом в один час, начиная с текущей даты.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let lastUpdate = Date() // Замените это на реальную дату последнего обновления
            let entry = NemaOkupantivWidgetEntry(date: entryDate, configuration: configuration, activeAlerts: [], lastUpdate: lastUpdate)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
