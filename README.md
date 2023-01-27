# Projekt BD1 *(łączony z PAP)*

### SWiZLE - System Wymian i Zapisów na Lektoraty Elektroniczny

##### Autorzy: Bartosz Kisły, Wojciech Zarzecki, Patryk Filip Gryz

## Opis projektu

```WIP```

## Analiza krytyczna

```WIP```

## Skrypty i model ER

### Model ER

Diagram związków encji znajduje się w pliku [ER.png](ER.png)

### DDL i DML

W pliku [ddl.sql](ddl.sql) znajdują się wszystkie polecenia odpowiadają za utworzenie tabel
wykorzystywanych w projekcie oraz niezbędnych sekwencji (potrzebne są one do tworzenia unikalnych kluczy niektórych
tabel)
Natomiast w pliku [dml_sample_data.sql](dml_sample_data.sql) znajdują się skrypty wstawiające przykładowe dane do tabeli

### PL/SQL

Plik [procedural.sql](procedural.sql) zawiera definicję wykorzystanych wyzwalaczy, procedur oraz funkcji. W aplikacji
użyto:

- wyzwalacza zajmującego się zapisywaniem historii zapisów na lektoraty (podczas zapisywania się i wypisywania się z
  lektoratu)
- wyzwalacza zajmującego się zapisywaniem historii ofert (podczas dodawania, usuwania oferty, lecz nie podczas dokonania
  wymiany)
- procedury zmiany hasła użytkownika
- procedury zaakceptowania oferty przez użytkownika, która dokona zamiany lektoratów pomiędzy użytkownikami oraz usunie
  powiązane z wymianą oferty z bazy danych oraz zapisze tą operacje w historii ofert
- funkcji hashującej wartość (hasło) z solą
- funkcji znajdującą najlepszą ofertę, która pasuje użytkownikowi (którą można zaacektować). Funkcja wewnętrznie
  wykorzystuje kursory

### Testy

**Złączenia**

- Zapytania łączące dane
- Zapytania wykonujące nietrywialne złączenia pomiędzy tabelami

**Zapytania statystyczne:**

- Statystykę lektoratów ze względu na dzień tygodnia
- Statystykę ilości lektoratów na użytkownika
- Statystykę średniej długości opinii na lektorat
- Statystykę ilości opinii ze względu na lektorat
- Statystykę ilości lektoratów z więcej niż jedną opinią
- Statystykę sumarycznej długości lektoratów na dzień tygodnia

**Filtrowanie**

- Filtrowanie lektoratów po nazwie
- Filtrowanie sesji logowania należących do danego użytkownika
- Filtrowanie opinii dotyczących danego lektoratu
- Filtrowanie ofert pasujących do już istniejącej oferty
- Filtrowanie lektoratów na które zapisany jest użytkownik

**Testowanie PL/SQl**

- Testy wyzwalacza tg_lectures_history poprzez dodawania i usuwanie zapisów na lektorat
- Testy wyzwalacza tg_offers_history poprzez dodawanie i usuwanie ofert wymiany
- Testy procedury zmiany hasła
- Testy procedury akceptującej ofertę przez użytkownika
- Testy funkcji znajdującej najlepsze ofertę dla użytkownika gotową do zaakceptowania
- Testy mieszane, testujące zdolność do zaakceptowania znalezionej najlepszej oferty dla użytkownika