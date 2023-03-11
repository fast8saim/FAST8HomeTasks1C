//MIT License
//
//Copyright (c) 2023 FAST8.RU
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#Область СобытияМодуля

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	fast8ПроцессыУчастники.ТребуетсяКонтроль КАК ТребуетсяКонтроль
	|ИЗ
	|	Справочник.fast8Процессы.Участники КАК fast8ПроцессыУчастники
	|ГДЕ
	|	fast8ПроцессыУчастники.Ссылка = &Процесс
	|	И fast8ПроцессыУчастники.Пользователь = &Исполнитель";
	Запрос.УстановитьПараметр("Процесс",		Процесс);
	Запрос.УстановитьПараметр("Исполнитель",	Исполнитель);
	ВыборкаПроцесс = Запрос.Выполнить().Выбрать();
	ВыборкаПроцесс.Следующий();
	
	Движения.fast8ИсторияВыполненияЗаданий.Записывать = Истина;
	
	Движение = Движения.fast8ИсторияВыполненияЗаданий.Добавить();
	Движение.Регистратор	= Ссылка;
	Движение.Период			= Дата;
	Движение.Процесс		= Процесс;
	Движение.Задание		= Задание;
	Движение.Статус			= ПредопределенноеЗначение("Перечисление.fast8СтатусыЗаданий.Выполняется");
	Движение.Исполнитель	= Исполнитель;
		
	Если Выполнено Тогда
		Движение = Движения.fast8ИсторияВыполненияЗаданий.Добавить();
		Движение.Регистратор	= Ссылка;
		Движение.Период			= ДатаВыполнения;
		Движение.Процесс		= Процесс;
		Движение.Задание		= Задание;
		Если ВыборкаПроцесс.ТребуетсяКонтроль = Истина Тогда
			Движение.Статус		= ПредопределенноеЗначение("Перечисление.fast8СтатусыЗаданий.НаПроверке");
		Иначе
			Движение.Статус		= ПредопределенноеЗначение("Перечисление.fast8СтатусыЗаданий.Выполнено");
		КонецЕсли;
		Движение.Исполнитель	= Исполнитель;
	ИначеЕсли Отменено Тогда
		Движение = Движения.fast8ИсторияВыполненияЗаданий.Добавить();
		Движение.Регистратор	= Ссылка;
		Движение.Период			= ДатаВыполнения;
		Движение.Процесс		= Процесс;
		Движение.Задание		= Задание;
		Движение.Статус			= ПредопределенноеЗначение("Перечисление.fast8СтатусыЗаданий.Отменено");
		Движение.Исполнитель	= Исполнитель;
	КонецЕсли;
		
КонецПроцедуры // ПриЗаписи()

#КонецОбласти // СобытияМодуля