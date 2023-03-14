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

#Область ПрограммныйИнтерфейс

Функция НовоеЗадание(Процесс, Ответственный = Неопределено) Экспорт
	
	НовоеЗадание = Документы.fast8Задание.СоздатьДокумент();
	НовоеЗадание.Дата				= ТекущаяДатаСеанса() + ПараметрыСеанса.fast8ДельтаВремениССервером;
	НовоеЗадание.Ответственный		= ?(Ответственный = Неопределено, ПараметрыСеанса.fast8ТекущийПользователь, Ответственный);
	НовоеЗадание.Процесс			= Процесс;
	НовоеЗадание.Записать();
	
	Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(НовоеЗадание.Ссылка);
	
	Возврат НовоеЗадание;
	
КонецФункции // НовоеЗадание()

Функция НовоеНазначение(Процесс, Задание, Исполнитель, Дата = Неопределено) Экспорт
	
	НовоеНазначение = Документы.fast8НазначениеИсполнителя.СоздатьДокумент();
	НовоеНазначение.Дата				= ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()) + ПараметрыСеанса.fast8ДельтаВремениССервером;
	НовоеНазначение.Задание				= Задание;
	НовоеНазначение.Исполнитель			= Исполнитель;
	НовоеНазначение.Ответственный		= ПараметрыСеанса.fast8ТекущийПользователь;
	НовоеНазначение.Процесс				= Процесс;
	НовоеНазначение.Записать();

	Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(Задание);
	
	Возврат НовоеНазначение;
	
КонецФункции // НовоеНазначение()

Функция НовоеВыполнение(Процесс, Задание, Исполнитель, Выполнено, Отменено) Экспорт

	НовоеВыполнение = Документы.fast8ВыполнениеЗадания.СоздатьДокумент();
	НовоеВыполнение.Дата				= ТекущаяДатаСеанса() + ПараметрыСеанса.fast8ДельтаВремениССервером;
	НовоеВыполнение.Задание				= Задание;
	НовоеВыполнение.Исполнитель			= Исполнитель;
	НовоеВыполнение.Процесс				= Процесс;
	Если Выполнено Или Отменено Тогда
		НовоеВыполнение.ДатаВыполнения	= НовоеВыполнение.Дата + 1;
	КонецЕсли;
	НовоеВыполнение.Выполнено			= Выполнено;
	НовоеВыполнение.Отменено			= Отменено;
	НовоеВыполнение.Записать();
	
	Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(Задание);
	
	Возврат НовоеВыполнение;
	
КонецФункции // НовоеВыполнение()

Функция ОтметитьЗавершениеЗадания(ВыполнениеСсылка, Выполнено, Отменено) Экспорт

	Выполнение = ВыполнениеСсылка.ПолучитьОбъект();
	Выполнение.Выполнено				= Выполнено;
	Выполнение.Отменено					= Отменено;
	Выполнение.ДатаВыполнения			= ТекущаяДатаСеанса() + ПараметрыСеанса.fast8ДельтаВремениССервером;
	Выполнение.Записать();
	
	Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(Выполнение.Задание);
	
	Возврат Выполнение;
	
КонецФункции // ОтметитьЗавершениеЗадания()

Функция НоваяПроверкаЗадания(Процесс, Задание, Исполнитель, Выполнено, ВозвращеноНаДоработку) Экспорт

	НоваяПроверкаЗадания = Документы.fast8ПроверкаЗадания.СоздатьДокумент();
	НоваяПроверкаЗадания.Дата			= ТекущаяДатаСеанса() + ПараметрыСеанса.fast8ДельтаВремениССервером;
	НоваяПроверкаЗадания.Задание		= Задание;
	НоваяПроверкаЗадания.Процесс		= Процесс;
	НоваяПроверкаЗадания.Проверяющий	= ПараметрыСеанса.fast8ТекущийПользователь;
	НоваяПроверкаЗадания.Выполнено		= Выполнено;
	НоваяПроверкаЗадания.ВозвращеноНаДоработку	= ВозвращеноНаДоработку;
	НоваяПроверкаЗадания.Записать();
	
	Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(Задание);
	
	Возврат НоваяПроверкаЗадания;
	
КонецФункции // НоваяПроверкаЗадания()

Функция ЕстьНевыполненныеЗадания(Процесс) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	fast8ИсторияВыполненияЗаданийСрезПоследних.Задание
	|ИЗ
	|	РегистрСведений.fast8ИсторияВыполненияЗаданий.СрезПоследних(, Процесс = &Процесс) КАК
	|		fast8ИсторияВыполненияЗаданийСрезПоследних
	|ГДЕ
	|	НЕ fast8ИсторияВыполненияЗаданийСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Выполнено),
	|		ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Отменено), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.НаПроверке))";
	Запрос.УстановитьПараметр("Процесс", Процесс);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции // ЕстьНевыполненныеЗадания()

Процедура СозданиеЗаданийПоРасписанию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВремяНедели = 86400 * 7;
	Сегодня = НачалоДня(ТекущаяДатаСеанса());
	ДеньМесяца = День(Сегодня);
	ДеньГода = ДеньГода(Сегодня);
	ДеньНедели = ДеньНедели(Сегодня);
	Недельное = ПредопределенноеЗначение("Перечисление.fast8ВидыПериодов.Недельное");
	Месячное = ПредопределенноеЗначение("Перечисление.fast8ВидыПериодов.Месячное");
	Датой = ПредопределенноеЗначение("Перечисление.fast8ВидыПериодов.Датой");
	Неделя1 = НачалоНедели(НачалоМесяца(Сегодня));
	Неделя2 = Неделя1 + ВремяНедели;
	Неделя3 = Неделя2 + ВремяНедели;
	Неделя4 = Неделя3 + ВремяНедели;
	Неделя5 = Неделя4 + ВремяНедели;
	НачалоЭтойНедели = НачалоНедели(Сегодня);
	Если НачалоЭтойНедели = Неделя1 Тогда
		НомерНедели = 1;
	ИначеЕсли НачалоЭтойНедели = Неделя2 Тогда
		НомерНедели = 2;
	ИначеЕсли НачалоЭтойНедели = Неделя3 Тогда
		НомерНедели = 3;
	ИначеЕсли НачалоЭтойНедели = Неделя4 Тогда
		НомерНедели = 4;
	ИначеЕсли НачалоЭтойНедели = Неделя5 Тогда
		НомерНедели = 5;
	Иначе
		НомерНедели = 6;
	КонецЕсли;
	ДниНедели = Новый Соответствие;
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Понедельник"), 1);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Вторник"), 2);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Среда"), 3);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Четверг"), 4);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Пятница"), 5);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Суббота"), 6);
	ДниНедели.Вставить(ПредопределенноеЗначение("Перечисление.fast8ВидыЕдиницПериода.Воскресенье"), 7);
	
	РасписанияКЗапуску = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	fast8ПроцессыРасписание.Ссылка,
	|	fast8ПроцессыРасписание.НомерСтроки,
	|	fast8ПроцессыРасписание.Вид,
	|	fast8ПроцессыРасписание.Порядок,
	|	fast8ПроцессыРасписание.Единица
	|ИЗ
	|	Справочник.fast8Процессы.Расписание КАК fast8ПроцессыРасписание";
	ТаблицаРасписания = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТЧ Из ТаблицаРасписания Цикл
		Если СтрокаТЧ.Вид = Датой И СтрокаТЧ.Порядок = ДеньГода Тогда
			РасписанияКЗапуску.Добавить(СтрокаТЧ.Ссылка);
		ИначеЕсли СтрокаТЧ.Вид = Недельное Тогда
			Если ДниНедели.Получить(СтрокаТЧ.Единица) = ДеньНедели Тогда
				РасписанияКЗапуску.Добавить(СтрокаТЧ.Ссылка);
			КонецЕсли;
		ИначеЕсли СтрокаТЧ.Вид = Месячное Тогда
			Если СтрокаТЧ.Единица = Перечисления.fast8ВидыЕдиницПериода.День И СтрокаТЧ.Порядок = ДеньМесяца Тогда
				РасписанияКЗапуску.Добавить(СтрокаТЧ.Ссылка);
			ИначеЕсли ДниНедели.Получить(СтрокаТЧ.Единица) = ДеньНедели И СтрокаТЧ.Порядок = НомерНедели Тогда
				РасписанияКЗапуску.Добавить(СтрокаТЧ.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если РасписанияКЗапуску.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	fast8ПроцессыУчастники.Ссылка КАК Процесс,
		|	fast8ПроцессыУчастники.Пользователь КАК Пользователь,
		|	fast8ПроцессыУчастники.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_Участники
		|ИЗ
		|	Справочник.fast8Процессы.Участники КАК fast8ПроцессыУчастники
		|ГДЕ
		|	fast8ПроцессыУчастники.Ссылка В(&РасписанияКЗапуску)
		|	И fast8ПроцессыУчастники.ПоРасписанию
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Участники.Процесс КАК Процесс,
		|	КОЛИЧЕСТВО(ВТ_Участники.Пользователь) КАК КоличествоУчастников
		|ПОМЕСТИТЬ ВТ_КоличествоУчастников
		|ИЗ
		|	ВТ_Участники КАК ВТ_Участники
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Участники.Процесс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	fast8Задание.Процесс КАК Процесс
		|ПОМЕСТИТЬ ВТ_Задания
		|ИЗ
		|	Документ.fast8Задание КАК fast8Задание
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(fast8Задание.Дата, ДЕНЬ) = &Сегодня
		|	И fast8Задание.Процесс В(&РасписанияКЗапуску)
		|	И fast8Задание.Ответственный = ЗНАЧЕНИЕ(Справочник.fast8Пользователи.Сервер)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_КоличествоУчастников.Процесс КАК Процесс,
		|	ВТ_Участники.Пользователь КАК Пользователь,
		|	ВТ_КоличествоУчастников.КоличествоУчастников КАК КоличествоУчастников
		|ПОМЕСТИТЬ ВТ_Процессы
		|ИЗ
		|	ВТ_КоличествоУчастников КАК ВТ_КоличествоУчастников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Участники КАК ВТ_Участники
		|		ПО ВТ_КоличествоУчастников.Процесс = ВТ_Участники.Процесс
		|			И (ВТ_КоличествоУчастников.КоличествоУчастников = 1)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Задания КАК ВТ_Задания
		|		ПО ВТ_КоличествоУчастников.Процесс = ВТ_Задания.Процесс
		|ГДЕ
		|	ВТ_Задания.Процесс ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Процессы.Процесс КАК Процесс,
		|	ВТ_Участники.Пользователь КАК Пользователь,
		|	ВТ_Участники.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_ПроцессыПользователи
		|ИЗ
		|	ВТ_Процессы КАК ВТ_Процессы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Участники КАК ВТ_Участники
		|		ПО ВТ_Процессы.Процесс = ВТ_Участники.Процесс
		|			И (ВТ_Процессы.КоличествоУчастников > 1)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПроцессыПользователи.Процесс КАК Процесс,
		|	ВТ_ПроцессыПользователи.Пользователь КАК Пользователь,
		|	ВТ_ПроцессыПользователи.НомерСтроки КАК НомерСтроки,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ fast8ИсторияВыполненияЗаданий.Задание) КАК КоличествоВыполненных,
		|	ЕСТЬNULL(МАКСИМУМ(fast8ИсторияВыполненияЗаданий.Период), ДАТАВРЕМЯ(1, 1, 1)) КАК Период
		|ПОМЕСТИТЬ ВТ_ПроцессыПодробно
		|ИЗ
		|	ВТ_ПроцессыПользователи КАК ВТ_ПроцессыПользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.fast8ИсторияВыполненияЗаданий КАК fast8ИсторияВыполненияЗаданий
		|		ПО ВТ_ПроцессыПользователи.Процесс = fast8ИсторияВыполненияЗаданий.Процесс
		|			И (fast8ИсторияВыполненияЗаданий.Статус В (ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.НазначенИсполнитель), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.ПереданоВРаботу), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Выполняется), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.НаПроверке), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.ВозвращеноНаДоработку), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Выполнено)))
		|			И ВТ_ПроцессыПользователи.Пользователь = fast8ИсторияВыполненияЗаданий.Исполнитель
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ПроцессыПользователи.Процесс,
		|	ВТ_ПроцессыПользователи.Пользователь,
		|	ВТ_ПроцессыПользователи.НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПроцессыПодробно.Процесс КАК Процесс,
		|	МИНИМУМ(ВТ_ПроцессыПодробно.Период) КАК Период
		|ПОМЕСТИТЬ ВТ_ПроцессыПериод
		|ИЗ
		|	ВТ_ПроцессыПодробно КАК ВТ_ПроцессыПодробно
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ПроцессыПодробно.Процесс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПроцессыПодробно.Процесс КАК Процесс,
		|	МИНИМУМ(ВТ_ПроцессыПодробно.КоличествоВыполненных) КАК КоличествоВыполненных,
		|	ВТ_ПроцессыПодробно.Период КАК Период
		|ПОМЕСТИТЬ ВТ_ПроцессыПериодКоличествоВыполненных
		|ИЗ
		|	ВТ_ПроцессыПодробно КАК ВТ_ПроцессыПодробно
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПроцессыПериод КАК ВТ_ПроцессыПериод
		|		ПО ВТ_ПроцессыПодробно.Процесс = ВТ_ПроцессыПериод.Процесс
		|			И ВТ_ПроцессыПодробно.Период = ВТ_ПроцессыПериод.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ПроцессыПодробно.Процесс,
		|	ВТ_ПроцессыПодробно.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПроцессыПодробно.Процесс КАК Процесс,
		|	МИНИМУМ(ВТ_ПроцессыПодробно.НомерСтроки) КАК НомерСтроки,
		|	ВТ_ПроцессыПодробно.КоличествоВыполненных КАК КоличествоВыполненных,
		|	ВТ_ПроцессыПодробно.Период КАК Период
		|ПОМЕСТИТЬ ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки
		|ИЗ
		|	ВТ_ПроцессыПодробно КАК ВТ_ПроцессыПодробно
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПроцессыПериодКоличествоВыполненных КАК ВТ_ПроцессыПериодКоличествоВыполненных
		|		ПО ВТ_ПроцессыПодробно.Процесс = ВТ_ПроцессыПериодКоличествоВыполненных.Процесс
		|			И ВТ_ПроцессыПодробно.Период = ВТ_ПроцессыПериодКоличествоВыполненных.Период
		|			И ВТ_ПроцессыПодробно.КоличествоВыполненных = ВТ_ПроцессыПериодКоличествоВыполненных.КоличествоВыполненных
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ПроцессыПодробно.Процесс,
		|	ВТ_ПроцессыПодробно.КоличествоВыполненных,
		|	ВТ_ПроцессыПодробно.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПроцессыПодробно.Процесс КАК Процесс,
		|	ВТ_ПроцессыПодробно.Пользователь КАК Пользователь
		|ИЗ
		|	ВТ_ПроцессыПодробно КАК ВТ_ПроцессыПодробно
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки КАК ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки
		|		ПО ВТ_ПроцессыПодробно.Процесс = ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки.Процесс
		|			И ВТ_ПроцессыПодробно.Период = ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки.Период
		|			И ВТ_ПроцессыПодробно.КоличествоВыполненных = ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки.КоличествоВыполненных
		|			И ВТ_ПроцессыПодробно.НомерСтроки = ВТ_ПроцессыПериодКоличествоВыполненныхНомерСтроки.НомерСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_Процессы.Процесс,
		|	ВТ_Процессы.Пользователь
		|ИЗ
		|	ВТ_Процессы КАК ВТ_Процессы
		|ГДЕ
		|	ВТ_Процессы.КоличествоУчастников = 1";
		Запрос.УстановитьПараметр("РасписанияКЗапуску",	РасписанияКЗапуску);
		Запрос.УстановитьПараметр("Сегодня",			Сегодня);
		Выборка = Запрос.Выполнить().Выбрать();
		
		СозданыНовыеЗадания = Ложь;
		Пока Выборка.Следующий() Цикл
			НовоеЗадание = НовоеЗадание(Выборка.Процесс, Справочники.fast8Пользователи.Сервер);
			НовоеНазначение(Выборка.Процесс, НовоеЗадание.Ссылка, Выборка.Пользователь, НовоеЗадание.Дата + 1);
			СозданыНовыеЗадания = Истина;
		КонецЦикла;
		
		Если СозданыНовыеЗадания Тогда
			ОтправитьУведомленияВТелеграм();
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	fast8ИсторияВыполненияЗаданийСрезПоследних.Регистратор КАК Регистратор,
	|	fast8Полный.Ссылка КАК Узел
	|ИЗ
	|	РегистрСведений.fast8ИсторияВыполненияЗаданий.СрезПоследних КАК fast8ИсторияВыполненияЗаданийСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.fast8Процессы.Участники КАК fast8ПроцессыУчастники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.fast8Полный КАК fast8Полный
	|			ПО fast8ПроцессыУчастники.Пользователь.Наименование = fast8Полный.Наименование
	|		ПО fast8ИсторияВыполненияЗаданийСрезПоследних.Процесс = fast8ПроцессыУчастники.Ссылка
	|ГДЕ
	|	НЕ fast8ИсторияВыполненияЗаданийСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Отменено), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Выполнено))
	|ИТОГИ ПО
	|	Узел";
	ВыборкаУзел = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаУзел.Следующий() Цикл
		Узлы = Новый Массив;
		Узлы.Добавить(ВыборкаУзел.Узел);
		Выборка = ВыборкаУзел.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Выборка.Регистратор);
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьСпискиПоСтатусам(Ложь);
	
КонецПроцедуры // СозданиеЗаданийПоРасписанию()

Процедура ОтправитьУведомленияВТелеграм() Экспорт
	
	#Если Сервер И Не МобильноеПриложениеСервер Тогда
	УстановитьПривилегированныйРежим(Истина);
	
	Если СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() = Ложь Тогда
		ЗаписьЖурналаРегистрации("Отправка оповещения в Телеграм", УровеньЖурналаРегистрации.Предупреждение,,, "Информационная база не зарегистрирована в системе взаимодействия");
		Возврат;
	КонецЕсли;	
	
	Интеграции = СистемаВзаимодействия.ПолучитьИнтеграции();
	Если Интеграции.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Интеграция = Интеграции.Получить(0);
	
	Отбор = Новый ОтборОбсужденийСистемыВзаимодействия();
	//@skip-check property-not-writable
	Отбор.Интеграция = Интеграция.Идентификатор;
	
	Обсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
	
	Обсуждение = Неопределено;
	ЗаголовокОбсуждения = Константы.fast8ИмяГруппыТелеграм.Получить();
	Для Каждого СтрокаТЧ Из Обсуждения Цикл
		Если СтрокаТЧ.Заголовок = ЗаголовокОбсуждения Тогда
			Обсуждение = СтрокаТЧ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Обсуждение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПользовательСервер = ПользователиИнформационнойБазы.НайтиПоИмени("Сервер");
	ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(ПользовательСервер.УникальныйИдентификатор);
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Расчет.Пользователь КАК Пользователь,
	|	СУММА(Расчет.КоличествоНовые) КАК КоличествоНовые,
	|	СУММА(Расчет.КоличествоПросроченные) КАК КоличествоПросроченные
	|ИЗ
	|	(ВЫБРАТЬ
	|		fast8ЗадачиНаИсполнении.Пользователь КАК Пользователь,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаИсполнении.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК КоличествоНовые,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаИсполнении.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК КоличествоПросроченные
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаИсполнении КАК fast8ЗадачиНаИсполнении
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		fast8ЗадачиНаНазначении.Пользователь,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаНазначении.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаНазначении.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаНазначении КАК fast8ЗадачиНаНазначении
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		fast8ЗадачиНаПроверке.Пользователь,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаПроверке.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(fast8ЗадачиНаПроверке.Задание.Дата, ДЕНЬ) = &Сегодня
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ
	|	ИЗ
	|		РегистрСведений.fast8ЗадачиНаПроверке КАК fast8ЗадачиНаПроверке) КАК Расчет
	|
	|СГРУППИРОВАТЬ ПО
	|	Расчет.Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	fast8ИсторияВыполненияЗаданий.Исполнитель КАК Исполнитель
	|ИЗ
	|	РегистрСведений.fast8ИсторияВыполненияЗаданий КАК fast8ИсторияВыполненияЗаданий
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(fast8ИсторияВыполненияЗаданий.Период, ДЕНЬ) = &Сегодня
	|	И fast8ИсторияВыполненияЗаданий.Статус = ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.НазначенИсполнитель)
	|	И fast8ИсторияВыполненияЗаданий.Процесс.Наименование = ""Продежурить на кухне""";
	Запрос.УстановитьПараметр("Сегодня", НачалоДня(ТекущаяДатаСеанса()));
	Результат = Запрос.ВыполнитьПакет();
	
	Фрагменты = Новый Массив;
	Фрагменты.Добавить(Константы.fast8ЗаголовокСообщенияТелеграм.Получить());
	Фрагменты.Добавить("");
	Фрагменты.Добавить("Количество задач в работе (Н - новое, П - просрочено):");
	
	Выборка = Результат.Получить(0).Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.КоличествоНовые) И ЗначениеЗаполнено(Выборка.КоличествоПросроченные) Тогда
			Фрагменты.Добавить(СтрШаблон("%1: Н-%2 П-%3", Выборка.Пользователь, Выборка.КоличествоНовые,  Выборка.КоличествоПросроченные));
		ИначеЕсли ЗначениеЗаполнено(Выборка.КоличествоНовые) Тогда
			Фрагменты.Добавить(СтрШаблон("%1: Н-%2", Выборка.Пользователь, Выборка.КоличествоНовые));
		ИначеЕсли ЗначениеЗаполнено(Выборка.КоличествоПросроченные) Тогда
			Фрагменты.Добавить(СтрШаблон("%1: П-%2", Выборка.Пользователь, Выборка.КоличествоПросроченные));
		КонецЕсли;
	КонецЦикла;
	
	Выборка = Результат.Получить(1).Выбрать();
	Выборка.Следующий();
	
	Фрагменты.Добавить("");
	Фрагменты.Добавить(СтрШаблон("Дежурный на кухне сегодня %1", Выборка.Исполнитель));
	
	ТекстСообщения = СтрСоединить(Фрагменты, Символы.ПС);
						
	Сообщение = СистемаВзаимодействия.СоздатьСообщение(Обсуждение.Идентификатор);
	Сообщение.Дата = ТекущаяДатаСеанса();
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Автор = ИдентификаторПользователяСВ;
	Сообщение.Записать();
	#КонецЕсли
	
КонецПроцедуры // ОтправитьУведомленияВТелеграм()

Процедура ЗаполнитьСпискиПоСтатусам(ОтмечатьПрогресс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	fast8ИсторияВыполненияЗаданийСрезПоследних.Задание КАК Задание
	|ИЗ
	|	РегистрСведений.fast8ИсторияВыполненияЗаданий.СрезПоследних КАК fast8ИсторияВыполненияЗаданийСрезПоследних
	|ГДЕ
	|	НЕ fast8ИсторияВыполненияЗаданийСрезПоследних.Статус В (ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Отменено), ЗНАЧЕНИЕ(Перечисление.fast8СтатусыЗаданий.Выполнено))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиНаИсполнении.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиНаИсполнении КАК fast8ЗадачиНаИсполнении
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиНаКонтроле.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиНаКонтроле КАК fast8ЗадачиНаКонтроле
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиНаНазначении.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиНаНазначении КАК fast8ЗадачиНаНазначении
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиНаПроверке.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиНаПроверке КАК fast8ЗадачиНаПроверке
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиНаПросмотре.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиНаПросмотре КАК fast8ЗадачиНаПросмотре
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	fast8ЗадачиМоиНаПроверке.Задание
	|ИЗ
	|	РегистрСведений.fast8ЗадачиМоиНаПроверке КАК fast8ЗадачиМоиНаПроверке";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если ОтмечатьПрогресс = Истина Тогда
		Константы.fast8КоличествоЗаданийДляОбработки.Установить(Выборка.Количество());
		Обработано = 0;
	КонецЕсли;
	Пока Выборка.Следующий() Цикл
		Документы.fast8Задание.СформироватьЗаписиСписковЗаданий(Выборка.Задание);
		Если ОтмечатьПрогресс = Истина Тогда
			Обработано = Обработано + 1;
			Константы.fast8КоличествоОбработанныхЗаданий.Установить(Обработано);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСпискиПоСтатусам()

#КонецОбласти // ПрограммныйИнтерфейс
