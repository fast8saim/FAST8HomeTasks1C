// MIT License
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

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
    Движения.fast8ИсторияВыполненияЗаданий.Записывать = Истина;
	
	Движение = Движения.fast8ИсторияВыполненияЗаданий.Добавить();
	Движение.Регистратор	= Ссылка;
	Движение.Период			= Дата;
	Движение.Процесс		= Процесс;
	Движение.Задание		= Задание;
	Движение.Статус			= ПредопределенноеЗначение("Перечисление.fast8СтатусыЗаданий.НазначенИсполнитель");
	Движение.Исполнитель	= Исполнитель;
	Движение.Ответственный	= Ответственный;
	
КонецПроцедуры // ПриЗаписи() 

#КонецОбласти // ОбработчикиСобытий