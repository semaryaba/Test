///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключает внешнюю обработку (отчет).
// Подробнее см. ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - подключаемая обработка.
//
// Возвращаемое значение: 
//   Строка       - имя подключенного отчета или обработки.
//   Неопределено - если передана некорректная ссылка.
//
Функция ПодключитьВнешнююОбработку(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку(Ссылка);
	
КонецФункции

// Создает и возвращает экземпляр внешней обработки (отчета).
// Подробнее см. ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - подключаемый отчет или обработка.
//
// Возвращаемое значение:
//   ВнешняяОбработка 
//   ВнешнийОтчет     
//   Неопределено     - если передана некорректная ссылка.
//
Функция ОбъектВнешнейОбработки(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(Ссылка);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет команду обработки и помещает результат во временное хранилище.
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ВыполнитьКоманду.
//
Функция ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата = Неопределено) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата);
	
КонецФункции

// Помещает двоичные данные дополнительного отчета или обработки во временное хранилище.
Функция ПоместитьВХранилище(Ссылка, ИдентификаторФормы) Экспорт
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ ДополнительныеОтчетыИОбработки.ВозможнаВыгрузкаОбработкиВФайл(Ссылка) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выгрузки файлов дополнительных отчетов и обработок'");
	КонецЕсли;
	
	ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
	
	Возврат ПоместитьВоВременноеХранилище(ХранилищеОбработки.Получить(), ИдентификаторФормы);
КонецФункции

// Запускает длительную операцию.
Функция ЗапуститьДлительнуюОперацию(Знач УникальныйИдентификатор, Знач ПараметрыКоманды) Экспорт
	ИмяМетода = "ДополнительныеОтчетыИОбработки.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	НастройкиЗапуска.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнение дополнительного отчета или обработки ""%1"", имя команды ""%2""'"),
		Строка(ПараметрыКоманды.ДополнительнаяОбработкаСсылка),
		ПараметрыКоманды.ИдентификаторКоманды);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыКоманды, НастройкиЗапуска);
КонецФункции

#КонецОбласти
