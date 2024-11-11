
#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Анкета
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Анкета";
	КомандаПечати.Представление = НСтр("ru = 'Анкета покупателя'");
	КомандаПечати.Порядок = 5;
	
	// Товарная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ТоварнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Товарная накладная'");
	КомандаПечати.Порядок = 10; 
	
	// Комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Анкета,ТоварнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	КомандаПечати.Порядок = 75;

		
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Анкета");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАнкеты(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Анкета'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РСВ_Доставка.ПФ_MXL_Анкета";
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ТоварнаяНакладная");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьТоварнойНакладной(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'ТоварнаяНакладная'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РСВ_Доставка.ПФ_MXL_ТоварнаяНакладная";
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РСВ_Доставка.Ссылка КАК Ссылка,
	               |	РСВ_Доставка.ВерсияДанных КАК ВерсияДанных,
	               |	РСВ_Доставка.ПометкаУдаления КАК ПометкаУдаления,
	               |	РСВ_Доставка.Номер КАК Номер,
	               |	РСВ_Доставка.Дата КАК Дата,
	               |	РСВ_Доставка.Проведен КАК Проведен,
	               |	РСВ_Доставка.Организация КАК Организация,
	               |	РСВ_Доставка.Контрагент КАК Контрагент,
	               |	РСВ_Доставка.Договор КАК Договор,
	               |	РСВ_Доставка.АдресДоставки КАК АдресДоставки,
	               |	РСВ_Доставка.Основание КАК Основание,
	               |	РСВ_Доставка.Ответственный КАК Ответственный,
	               |	РСВ_Доставка.Комментарий КАК Комментарий,
	               |	РСВ_Доставка.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество
	               |	) КАК Товары
	               |ИЗ
	               |	Документ.РСВ_Доставка КАК РСВ_Доставка
	               |ГДЕ
	               |	РСВ_Доставка.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Результат = Запрос.Выполнить().Выбрать(); 
	
	Возврат Результат;
	
КонецФункции

Функция ПечатьАнкеты(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Анкета";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РСВ_Доставка.ПФ_MXL_Анкета");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиШапкаАнкета(ДанныеДокументов, ТабличныйДокумент, Макет); 
		
		ВывестиТабличнаяЧастьАнкета(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиШапкаАнкета(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Анкета о доставке №%1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьШапка.Параметры.Заполнить(ДанныеПечати);
	
	//QR
	Ссылка = ДанныеДокументов.Ссылка;
	ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(Ссылка, 1, 120);
	Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		|Технические подробности см. в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Иначе
		КартинкаКода = Новый Картинка(ДанныеQRКода);
		ОбластьШапка.Рисунки.МашиночитаемыйКод.Картинка = КартинкаКода;
	КонецЕсли;
	//QR
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
КонецПроцедуры

Процедура ВывестиТабличнаяЧастьАнкета(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьТабличнаяЧасть = Макет.ПолучитьОбласть("ТабличнаяЧасть");
	ТабличныйДокумент.Вывести(ОбластьТабличнаяЧасть);
	
КонецПроцедуры

Функция ПечатьТоварнойНакладной(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ТоварнаяНакладная";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РСВ_Доставка.ПФ_MXL_ТоварнаяНакладная");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиШапкаТоварнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет); 
		ВывестиШапкаТабличнойЧасти(ДанныеДокументов, ТабличныйДокумент, Макет);
		ВывестиСтрокаТабличнойЧасти(ДанныеДокументов, ТабличныйДокумент, Макет);
		ВывестиПодвалТоварнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиШапкаТоварнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТоварнаяНакладная");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Транспортная накладная №%1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Контрагент);
	ОбластьШапка.Параметры.Заполнить(ДанныеПечати);
	
	//QR
	Ссылка = ДанныеДокументов.Ссылка;
	ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(Ссылка, 1, 120);
	Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		|Технические подробности см. в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Иначе
		КартинкаКода = Новый Картинка(ДанныеQRКода);
		ОбластьШапка.Рисунки.МашиночитаемыйКод.Картинка = КартинкаКода;
	КонецЕсли;
	//QR

	ТабличныйДокумент.Вывести(ОбластьШапка);
	
КонецПроцедуры

Процедура ВывестиШапкаТабличнойЧасти(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ШапкаТабличнойЧасти = Макет.ПолучитьОбласть("ШапкаТабличнойЧасти");
	ТабличныйДокумент.Вывести(ШапкаТабличнойЧасти);
	
КонецПроцедуры

Процедура ВывестиСтрокаТабличнойЧасти(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	СтрокаТабличнойЧасти = Макет.ПолучитьОбласть("СтрокаТабличнойЧасти");
	Номер = 1;
	ВыборкаДоставка = ДанныеДокументов.Товары.Выбрать();
	Пока ВыборкаДоставка.Следующий() Цикл
		 СтрокаТабличнойЧасти.Параметры.Номер = Номер;
		 СтрокаТабличнойЧасти.Параметры.Заполнить(ВыборкаДоставка);
		 Номер = Номер + 1;
		 ТабличныйДокумент.Вывести(СтрокаТабличнойЧасти);
	КонецЦикла;
		
	
	
КонецПроцедуры 

Процедура ВывестиПодвалТоварнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ПодвалТоварнаяНакладная = Макет.ПолучитьОбласть("ПодвалТоварнаяНакладная");
	ТабличныйДокумент.Вывести(ПодвалТоварнаяНакладная);
	
КонецПроцедуры 