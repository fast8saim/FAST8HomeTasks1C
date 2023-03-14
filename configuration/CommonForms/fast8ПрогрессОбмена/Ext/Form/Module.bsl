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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Константы.fast8КоличествоЗаданийДляОбработки.Установить(0);
	Константы.fast8КоличествоОбработанныхЗаданий.Установить(0);
	КоличествоОбъектов = fast8ОбменКлиента.ПолучитьКоличествоНовыхДанных();
	ФоновыеЗадания.Выполнить("fast8ОбменКлиента.ЗапуститьПолучениеНовыхДанных");
		
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	глВыполняетсяОбмен = Истина;
	ПодключитьОбработчикОжидания("ПроверитьСостояниеОбмена", 1, Ложь);
	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И Не ОбменЗавершен Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПередЗакрытием()

#КонецОбласти // ОбработчикиСобытийФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьСостояниеОбмена()
	
	ПолучитьСостояниеОбмена();
	Если ОбменЗавершен Тогда
		глВыполняетсяОбмен = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры // ПроверитьСостояниеОбмена()

&НаСервере
Процедура ПолучитьСостояниеОбмена()
	
	ОбменЗавершен = Ложь;
	КоличествоЗагруженных = Константы.fast8КоличествоЗагруженных.Получить();
	КоличествоЗаданий = Константы.fast8КоличествоЗаданийДляОбработки.Получить();
	КоличествоОбработанных = Константы.fast8КоличествоОбработанныхЗаданий.Получить();
	ПрогрессЗагрузки = ?(КоличествоОбъектов = 0, 0, Окр(КоличествоЗагруженных / КоличествоОбъектов * 100, 0));
	ПрогрессЗаполненияСписков = ?(КоличествоЗаданий = 0, 0, Окр(КоличествоОбработанных / КоличествоЗаданий * 100, 0));
	АктивныеФЗ = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Состояние", СостояниеФоновогоЗадания.Активно));
	Если АктивныеФЗ.Количество() = 0 Тогда
		ОбменЗавершен = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПолучитьСостояниеОбмена()

#КонецОбласти // СлужебныеПроцедурыИФункции

