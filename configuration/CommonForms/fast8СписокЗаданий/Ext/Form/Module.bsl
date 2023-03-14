﻿// MIT License
//
// Copyright (c) 2023 FAST8.RU
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПараметрыСеанса.fast8ТекущийПользователь = Справочники.fast8Пользователи.Сервер Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ЗадачиНаИсполнении.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	ЗадачиНаКонтроле.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	ЗадачиНаНазначении.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	ЗадачиНаПроверке.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	ЗадачиНаПросмотре.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	ЗадачиМоиНаПроверке.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	
	ВремяЗавершения		= Константы.fast8ВремяАвтовыключения.Получить();
	ИмяУстройства		= Константы.fast8ПользовательУстройства.Получить();
	СвязьУстановлена	= Ложь;
	Если ЗначениеЗаполнено(ИмяУстройства) Тогда
		Попытка
			ВебСервис = fast8ОбменКлиента.ПолучитьПодключение();
			Если fast8ОбменКлиента.ПроверитьСвязь(ВебСервис) = Истина Тогда
				СвязьУстановлена = Истина;
			КонецЕсли;
		Исключение
			СвязьУстановлена = Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Если СвязьУстановлена Тогда
		ВерсияСервера	= ВебСервис.ПолучитьВерсиюПриложения();
		ОшибкаВерсияОтличается = СтрШаблон("Версия приложения %1, версия сервера %2. Необходимо обновить программу.", Метаданные.Версия, ВерсияСервера);
		
		ВерсияСервераОтличается	= Не (Метаданные.Версия = ВерсияСервера);
		ВремяСервера			= Дата(fast8ОбменКлиента.ПолучитьВремяСервера(ВебСервис));
		ПараметрыСеанса.fast8ДельтаВремениССервером = Окр(ВремяСервера - ТекущаяДатаСеанса(), 0);
	КонецЕсли;
		
	УстановитьВидимость();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	fast8Задание.Процесс,
	|	fast8Задание.Процесс.Наименование КАК ИмяКоманды,
	|	СУММА(1) КАК Количество
	|ИЗ
	|	Документ.fast8Задание КАК fast8Задание
	|ГДЕ
	|	fast8Задание.Ответственный = &Ответственный
	|СГРУППИРОВАТЬ ПО
	|	fast8Задание.Процесс,
	|	fast8Задание.Процесс.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Количество УБЫВ";
	Запрос.УстановитьПараметр("Ответственный", ПараметрыСеанса.fast8ТекущийПользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Процесс1.Пустая() Тогда
			ДобавитьБыструюКоманду(Выборка.Процесс, 1, Выборка.ИмяКоманды);
		ИначеЕсли Процесс2.Пустая() Тогда
			ДобавитьБыструюКоманду(Выборка.Процесс, 2, Выборка.ИмяКоманды);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	глВерсияСервераОтличается = ВерсияСервераОтличается;
	глСвязьУстановлена = СвязьУстановлена; 
	
	Если ВерсияСервераОтличается Тогда
		Отказ = Истина;
		ВызватьИсключение ОшибкаВерсияОтличается;
	КонецЕсли;
	
	Если СвязьУстановлена Тогда
		ОписаниеОЗакрытии = Новый ОписаниеОповещения("ОбменДаннымиЗавершен", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.fast8ПрогрессОбмена",, ЭтотОбъект,,,, ОписаниеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		ВызватьИсключение "Связь с сервером не установлена. Проверьте настройки сети.";
	КонецЕсли;

КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "fast8ЗаписанаЗадача" Тогда
		ОповеститьОбИзмененияхСписков();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БыстроеЗадание1(Команда)
	
	БыстроеЗадание(1);

КонецПроцедуры // БыстроеЗадание1()

&НаКлиенте
Процедура БыстроеЗадание2(Команда)
	
	БыстроеЗадание(2);
	
КонецПроцедуры // БыстроеЗадание2()

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ПроверитьНаличиеНовыхДанных(Истина);
	
КонецПроцедуры // ОбновитьСписок()

&НаКлиенте
Процедура НовоеЗадание(Команда)
	
	ОткрытьФорму("ОбщаяФорма.fast8Задание");
	
КонецПроцедуры // НовоеЗадание()

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

//@skip-check module-structure-form-event-regions
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
		
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОткрытьФорму("ОбщаяФорма.fast8Задание", Новый Структура("Задание", ТекущиеДанные.Задание));
	КонецЕсли;

КонецПроцедуры // СписокВыбор()

&НаСервере
Процедура ДобавитьБыструюКоманду(Процесс, НомерКоманды, ИмяКоманды)
	
	ЭтотОбъект["Процесс" + НомерКоманды] = Процесс;
	Кнопка = Элементы["БыстроеЗадание" + НомерКоманды];
	Кнопка.Заголовок	= ИмяКоманды;
	Кнопка.Видимость	= Истина;
	
КонецПроцедуры // ДобавитьБыструюКоманду()

&НаКлиенте
Процедура БыстроеЗадание(НомерКоманды)

	ПоказатьВопрос(Новый ОписаниеОповещения("БыстроеЗаданиеЗавершение", ЭтотОбъект, Новый Структура("НомерКоманды", НомерКоманды)), "Запустить задание?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры // БыстроеЗадание()

&НаКлиенте
Процедура БыстроеЗаданиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	НомерКоманды = ДополнительныеПараметры.НомерКоманды;

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если БыстроеЗаданиеНаСервере(НомерКоманды) Тогда
			ОповеститьОбИзмененияхСписков();
		Иначе
			ПоказатьПредупреждение(, "Сначала необходимо закончить уже созданное задание");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // БыстроеЗаданиеЗавершение()

&НаСервере
Функция БыстроеЗаданиеНаСервере(НомерКоманды)
	
	Процесс = ЭтотОбъект["Процесс" + НомерКоманды];
	
	Если fast8УправлениеПроцессами.ЕстьНевыполненныеЗадания(Процесс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	fast8УправлениеПроцессами.НовоеЗадание(Процесс);
	fast8ОбменКлиента.ОтправитьДанные();
	ПроверитьНаличиеНовыхДанныхСервер();
	
	Возврат Истина;
	
КонецФункции // БыстроеЗаданиеНаСервере()
						
&НаКлиенте
Процедура ОбменДаннымиЗавершен(Параметр1, Параметр2) Экспорт

	ПодключитьОбработчикОжидания("ПроверитьНаличиеНовыхДанныхОбработчикОжидания", 60, Ложь);
	ОповеститьОбИзмененияхСписков();
	
КонецПроцедуры // ОбменДаннымиЗавершен()

&НаКлиенте
Процедура ПроверитьНаличиеНовыхДанныхОбработчикОжидания()
	
	Если глВыполняетсяОбмен = Истина Тогда
		Возврат;
	КонецЕсли;
	
	//@skip-check use-non-recommended-method
	Если НачалоМинуты(ВремяЗавершения) = НачалоМинуты(ТекущаяДата()) Тогда
		ЗавершитьРаботуСистемы();		
	КонецЕсли;
	
	ПроверитьНаличиеНовыхДанных();
	
КонецПроцедуры // ПроверитьНаличиеНовыхДанныхОбработчикОжидания()

&НаКлиенте
Процедура ПроверитьНаличиеНовыхДанных(Принудительно = Ложь)
	
	Если ПроверитьНаличиеНовыхДанныхСервер(Принудительно) Тогда
		ОповеститьОбИзмененияхСписков();
	КонецЕсли;
			
КонецПроцедуры // ПроверитьНаличиеНовыхДанных()

&НаКлиенте
Процедура ОповеститьОбИзмененияхСписков()
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ИсторияВыполненияЗаданий"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиМоиНаПроверке"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиНаИсполнении"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиНаКонтроле"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиНаНазначении"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиНаПроверке"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.fast8ЗадачиНаПросмотре"));
	Элементы.ЗадачиНаИсполнении.Обновить();
	Элементы.ЗадачиНаКонтроле.Обновить();
	Элементы.ЗадачиНаНазначении.Обновить();
	Элементы.ЗадачиНаПроверке.Обновить();
	Элементы.ЗадачиНаПросмотре.Обновить();
		
	УстановитьВидимость();
	
КонецПроцедуры // ОповеститьОбИзмененияхСписков()

&НаСервере
Функция ПроверитьНаличиеНовыхДанныхСервер(Принудительно = Ложь, ВебСервис = Неопределено)

	Если ВебСервис = Неопределено Тогда
		Попытка
			ВебСервис = fast8ОбменКлиента.ПолучитьПодключение();
		Исключение
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
			
	Если Принудительно Или fast8ОбменКлиента.ПроверитьНаличиеНовыхДанных(ВебСервис) Тогда
		fast8ОбменКлиента.ПолучитьНовыеДанные(ВебСервис);
		fast8ОбменКлиента.ОтправитьДанные(ВебСервис);
		УстановитьВидимость();
		
		ВебСервис = Неопределено;
		Возврат Истина;
	КонецЕсли;

	ВебСервис = Неопределено;
	Возврат Ложь;
	
КонецФункции // ПроверитьНаличиеНовыхДанныхСервер()

&НаСервере
Процедура УстановитьВидимость()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(КоличествоЗаписей.НаИсполнении) КАК НаИсполнении,
	|	СУММА(КоличествоЗаписей.НаКонтроле) КАК НаКонтроле,
	|	СУММА(КоличествоЗаписей.НаНазначении) КАК НаНазначении,
	|	СУММА(КоличествоЗаписей.НаПроверке) КАК НаПроверке,
	|	СУММА(КоличествоЗаписей.НаПросмотре) КАК НаПросмотре,
	|	СУММА(КоличествоЗаписей.МоиНаПроверке) КАК МоиНаПроверке
	|ИЗ
	|	(ВЫБРАТЬ
	|		1 КАК НаИсполнении,
	|		0 КАК НаКонтроле,
	|		0 КАК НаНазначении,
	|		0 КАК НаПроверке,
	|		0 КАК НаПросмотре,
	|		0 КАК МоиНаПроверке
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаИсполнении КАК fast8ЗадачиНаИсполнении
	|	ГДЕ
	|		fast8ЗадачиНаИсполнении.Пользователь = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		1,
	|		0,
	|		0,
	|		0,
	|		0
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаКонтроле КАК fast8ЗадачиНаКонтроле
	|	ГДЕ
	|		fast8ЗадачиНаКонтроле.Пользователь = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		0,
	|		1,
	|		0,
	|		0,
	|		0
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаНазначении КАК fast8ЗадачиНаНазначении
	|	ГДЕ
	|		fast8ЗадачиНаНазначении.Пользователь = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		0,
	|		0,
	|		1,
	|		0,
	|		0
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаПроверке КАК fast8ЗадачиНаПроверке
	|	ГДЕ
	|		fast8ЗадачиНаПроверке.Пользователь = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		0,
	|		0,
	|		0,
	|		1,
	|		0
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаПросмотре КАК fast8ЗадачиНаПросмотре
	|	ГДЕ
	|		fast8ЗадачиНаПросмотре.Пользователь = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		1
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиМоиНаПроверке КАК fast8ЗадачиМоиНаПроверке
	|	ГДЕ
	|		fast8ЗадачиМоиНаПроверке.Пользователь = &Пользователь) КАК КоличествоЗаписей";
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.fast8ТекущийПользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Элементы.СтраницаНаИсполнении.Видимость = ЗначениеЗаполнено(Выборка.НаИсполнении);
	Элементы.СтраницаНаКонтроле.Видимость = ЗначениеЗаполнено(Выборка.НаКонтроле);
	Элементы.СтраницаНаНазначении.Видимость = ЗначениеЗаполнено(Выборка.НаНазначении);
	Элементы.СтраницаНаПроверке.Видимость = ЗначениеЗаполнено(Выборка.НаПроверке);
	Элементы.СтраницаНаПросмотре.Видимость = ЗначениеЗаполнено(Выборка.НаПросмотре);
	Элементы.СтраницаМоиНаПроверке.Видимость = ЗначениеЗаполнено(Выборка.МоиНаПроверке);
	
	Элементы.СтраницаНаИсполнении.Заголовок = СтрШаблон("На исполнении %1", Выборка.НаИсполнении);
	Элементы.СтраницаНаКонтроле.Заголовок = СтрШаблон("На контроле %1", Выборка.НаКонтроле);
	Элементы.СтраницаНаНазначении.Заголовок = СтрШаблон("На назначении %1", Выборка.НаНазначении);
	Элементы.СтраницаНаПроверке.Заголовок = СтрШаблон("На проверке %1", Выборка.НаПроверке);
	Элементы.СтраницаНаПросмотре.Заголовок = СтрШаблон("На просмотре %1", Выборка.НаПросмотре);
	Элементы.СтраницаМоиНаПроверке.Заголовок = СтрШаблон("Мои на проверке %1", Выборка.МоиНаПроверке);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	fast8ПроцессыУчастники.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.fast8Процессы.Участники КАК fast8ПроцессыУчастники
	|ГДЕ
	|	fast8ПроцессыУчастники.Пользователь = &Пользователь
	|	И fast8ПроцессыУчастники.Создание";
	Запрос.УстановитьПараметр("Пользователь",	ПараметрыСеанса.fast8ТекущийПользователь);
	Результат = Запрос.Выполнить();
	Элементы.ФормаНовоеЗадание.Видимость = Не Результат.Пустой();
	
КонецПроцедуры // УстановитьВидимость()

#КонецОбласти // СлужебныеПроцедурыИФункции
