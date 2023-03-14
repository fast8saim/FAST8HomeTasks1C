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

Процедура fast8УстановитьПрефиксДокументаПриУстановкеНовогоНомера(Источник, СтандартнаяОбработка, Префикс) Экспорт

	Если ЗначениеЗаполнено(Префикс) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыСеанса.fast8Префикс) Тогда
		ВызватьИсключение "Не установлен префикс базы";
	КонецЕсли;
	
	Префикс = "" + ПараметрыСеанса.fast8Префикс + "-";
	
КонецПроцедуры // fast8УстановитьПрефиксДокументаПриУстановкеНовогоНомера()

Функция СериализоватьСсылку(СсылкаНаОбъект, ВОбъект) Экспорт
    
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, ?(ВОбъект, СсылкаНаОбъект.ПолучитьОбъект(), СсылкаНаОбъект));
		
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции // СериализоватьСсылку()

Функция ДесериализоватьДанные(ИсходныеДанные, ОписаниеТипаДанных) Экспорт

	ЧтениеJSON	= Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ИсходныеДанные);
	ОбъектБазы	= СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON, Тип(ОписаниеТипаДанных));
	
	Возврат ОбъектБазы;
	
КонецФункции // ДесериализоватьДанные()

#КонецОбласти // ПрограммныйИнтерфейс