Sekcja 1: Założenia
===================

Dla skupienia uwagi możemy projektować pod tę komorę:
	http://www.klimatest.eu/katalog/leaflets/espec/Komory_serii_AR_v2_0.pdf
Można założyć (w sposób bardzo konserwatywny):
	- time slice W = 5 sekund,
	- że po wyłączeniu grzania temperatura w komorze się ustabilizuje w czasie 
	mniejszym niż 10 minut (czyli po K = 120 jednostkach czasu),
	- ew. można te parametry skorygować, tak żeby tę liczbę 120 zmniejszyć, 
	te wartości tutaj są dosyć wyśrubowane.
	
Na razie pomijamy chłodzenie, żeby uprościć problem. W sumie to jednak 
dosyć dobrze pasuje do różnych systemów HVAC, które mogą działać bez 
klimatyzatora (np. w zimie).


Sekcja 2: Analiza wpływu grzania na przebieg temperatury w komorze
==================================================================

Na nią mogą bowiem wpływać decyzje podjęte później. Można to uchwycić matematycznie:

Dzielimy czas na jednostki o szerokości W. Zakładamy, że w obrębie każdej jednostki
moc grzałki oraz ew. innych urządzeń jest stała.
Kolejne jednostki są numerowane liczbami całkowitymi.

Rozważamy jednostkę o numerze k.

Przyrost temperatury podczas tej jednostki czasu jest równy:
∆T[k] = T[k+1] - T[k] ≈ \sum_{j=0}^{k} (ΔT[k] | P[j])

Gdzie:
	T[k] 	- temperatura na początku k-tej jednostki czasu,
	(ΔT[k] | P[j])
		- przyrost temperatury w k-tej jednostce czasu dzięki grzaniu w 
                j-tej jednostce czasu.
                - oczywiście k >= j

Jesteśmy w stanie bezpośrednio zmierzyć jedynie T[k], chcielibyśmy jednak znać
(ΔT[k] | P[j]).

Musimy więc założyć:
(ΔT[k] | P[j]) = P[j] * f(k-j)
 - gdzie P[j] - moc grzałki w danej jednostce czasu 
(bardziej chyba powinniśmy używać dostarczonego ciepła, ale to jest detal),
 - f(x)        
        - pewna funkcja dążąca do zera dla x dążącego do nieskończoności, 
         lim_{k -> +∞} (ΔT[k] | P[j]) = 0
        - zdefiniowana dla wartości nieujemnych,
        - f(0) - stosunek przyrostu temperatury w tym samym przedziale czasu kiedy
                 grzejemy do mocy grzałki 
                 (Jeśli przed obecnym przedziałem czasu układ znajdował się w
                 równowadze)
                 (dotyczy sytuacji kiedy przyrost temperatury jest w tej samej
                 jednostce czasu co grzanie)
        - po K = 120 okresach sytuacja się stabilizuje, z tego względu można
          uznać że f(x) ≡ 0 dla x > K )
                - czyli f(x) może być niezerowe dla x <= K
                - istnieje co najwyżej K+1 niezerowych wartości funkcji f(x):
                        0 oraz od 1 do K
                - jeden okres przeznaczony na grzanie który nie wlicza się do
                  czasu stabilizacji oraz K okresów przez które temperatura 
                  się stabilizuje
                //wyliczyłem to na kartce z nr 6 i zweryfikowałem niezależnie
                // na kartce nr 7
 	
Mamy więc po podstawieniu:
∆T[k] = T[k+1] - T[k] ≈ \sum_{j=0}^{k} P[j] * f(k-j)

Po przyjęciu że f(x) ≡ 0 dla x >= K + 1 mamy:
∆T[k] = T[k+1] - T[k] ≈ \sum_{j=k-K}^{k} P[j] * f(k-j)
        - czyli wewnętrzna suma przechodzi przez K + 1 wartości, zgadza się

Rozważymy teraz postać sumy dla niskich wartości k:
k = 0
∆T[0] = T[1] - T[0] ≈ \sum_{j=0}^{0} (ΔT[0] | P[j]) = (ΔT[0] | P[0]) = P[0] * f(0)
∆T[0] = T[1] - T[0] ≈ [P[0] * f(0)]

Dla k=1:
∆T[1] = T[2] - T[1] ≈ \sum_{j=0}^{1} (ΔT[1] | P[j]) = (ΔT[1] | P[0]) + (ΔT[1] | P[1]) = 
	= [ P[0] * f(1-0) + P[1] * f(1-1) ] = [ P[0] * f(1) + P[1] * f(0)]
∆T[1] = T[2] - T[1] ≈ [ P[0] * f(1) + P[1] * f(0)]


∆T[0] = T[1] - T[0] ≈ [P[0] * f(0)] 
∆T[1] = T[2] - T[1] ≈ [P[0] * f(1) + P[1] * f(0)]
∆T[2] = T[3] - T[2] ≈ [P[0] * f(2) + P[1] * f(1) + P[2] * f(0)]

Coś takiego nazywamy splotem (convolution).
http://en.wikipedia.org/wiki/Convolution#Discrete_convolution
∆T[2] = T[3] - T[2] ≈ (P * f)[2]

i ogólnie:
∆T[k] = T[k+1] - T[k] ≈ (P * f)[k]

W tym wypadku przy definicji splotu pomijamy składniki dla których f(x) = 0.

Mamy więc układ równań:
∆T[k] = T[k+1] - T[k] ≈ \sum_{j=k-K}^{k} P[j] * f(k-j) = (P * f)[k] = 

    k
=   ∑   P[j] f(k-j) =
  j=k-K

    K
=   ∑   P[k-j] f(j)
   j=0

Mamy tutaj K+1 niewiadomych - tyle ile niezerowych wartości funkcji f().
Dodatkowo, dla każdej danej historycznej (pary wartości P[j], T[j]) 
mamy zazwyczaj jedno równanie.
Jeżeli jednak system przy rozpoczęciu zbierania danych nie znajdował sie w stanie
równowagi termodynamicznej, musimy odrzucić pierwsze K pomiarów.


Można rozpisać funkcję f(x) na następujące składniki:
f(x) = g(x) * e^{-t/T} * c_1
Gdzie:
	g(x) < 1
	g(0) = 1	(tak żeby c_1 ustalić na sztywno)
                //jednak to by nie było dopuszczalne, ponieważ f(0) może być
                //stosunkowo małe, mniejsze niż g(1)
T - jakaś liczba.

Może to ew. pomóc przy rozwiązywaniu układu równań - można w ten sposób ograniczyć
wartości funkcji f(x) do rozsądnych wartości.

Może być jednak problem z uwzględnieniem g(x) < 1 przy rozwiązywaniu tego 
układu równań (mogłoby to wymagać innych metod).



Sekcja 3: Sterowanie przy użyciu wartości funkcji f - bez użycia wag
====================================================================

Znając wartości funkcji f() wyliczone na podstawie danych historycznych, można
przewidzieć przebieg temperatury towarzyszący procesom grzania i z tego
względu w sposób świadomy sterować grzałką.


 - w sumie można ograniczyć to do rekordów które były dawno, tak żeby nie było 
jakichś dziwnych (i trudnych do uchwycenia) interakcji między tym co się teraz 
dzieje a tym co było w niedawnej historii i co wpływa bezpośrednio na obecne 
decyzje.
 
Jesteśmy w chwili czasu i, mamy historię oraz przyszłość do decyzji.
(zmienne dobieram tak żeby intuicyjnie i <= j)

Oznaczenia:
	i - obecna chwila czasu, którą analizujemy
	j - indeksuje czas w którym przewidujemy że będziemy grzać,
	k - indeksuje temperaturę w przyszłości,

Przyjmujemy uproszczony model ogrzewania przedstawiony w sekcji 2:
∆T[k] = T[k+1] - T[k] ≈ \sum_{j=k-K}^{k} P[j] * f(k-j) = (P * f)[k]

Na podstawie tego modelu jesteśmy w stanie przewidzieć przebieg zmian temperatury
dla danego przebiegu mocy grzałki i w ten sposób zoptymalizować proces grzania
wybierając taki przebieg który jest najbliższy żądanemu.

Postępujemy podobnie jak doświadczony szachista, przewidujący
kilka ruchów naprzód a jednocześnie w każdym ruchu dostosowujący się do
działań rywala i aktualizującym swoją strategię odpowiednio.

//można w sumie wykorzystywać wartości wyliczone w poprzednim oknie czasowym,
//do przyśpieszenia rozwiązywania układu równań w następnym.
//Np. jeśli stosujemy metodę aproksymacyjną, możemy jako punkty startowe przyjąć
//wartości P[u] wyliczone w poprzednim oknie czasowym.

Niech U[k] = żądana temperatura na początku przedziału czasowego j.
Na podstawie wartości U[k] jesteśmy w stanie policzyć 
∆U[k] = U[k+1] - U[k]

Wtedy mamy układ równań:
∆U[k] ≈ \sum_{j=k-K}^{k} P[j] * f(k-j)
 - rozwiązujemy go za pomocą ważonej metody najmniejszych kwadratów

- wagi są konieczne, bo musimy jakoś w sensowny sposób odciąć wartości j,
- problem: mogą wyjść liczby ujemne,

Mamy więc równanie macierzowe (na razie pomijam wagi):
 - oznaczenia jak na http://en.wikipedia.org/wiki/Least_squares
y = X * β

Dla K=3
oraz i = 9 mamy:
(celowo nie piszę równania dla ∆U[9]):
∆U[10] ≈ P[7]*f(3) + P[8]*f(2) + P[9]*f(1) + P[10]*f(0)
∆U[11] ≈             P[8]*f(3) + P[9]*f(2) + P[10]*f(1) + P[11]*f(0)
∆U[12] ≈                         P[9]*f(3) + P[10]*f(2) + P[11]*f(1) + P[12]*f(0)
∆U[13] ≈                                     P[10]*f(3) + P[11]*f(2) + P[12]*f(1) + P[13]*f(0)
itd.

Przy czym znamy P[7] i P[8], a więc należy to przekształcić jako:
∆U[10] - P[7]*f(3) - P[8]*f(2) ≈ P[9]*f(1) + P[10]*f(0)
∆U[11]             - P[8]*f(3) ≈ P[9]*f(2) + P[10]*f(1) + P[11]*f(0)
∆U[12]                         ≈ P[9]*f(3) + P[10]*f(2) + P[11]*f(1) + P[12]*f(0)
∆U[13]                         ≈             P[10]*f(3) + P[11]*f(2) + P[12]*f(1) + P[13]*f(0)



Czyli:
y = [
        ∆U[10] - P[7]*f(3) - P[8]*f(2)
        ∆U[11]             - P[8]*f(3)
        ∆U[12]                        
        ∆U[13]                        
]

Wektor y odpowiada residualnej krzywej temperaturowej - 

- na podstawie historii oraz wartości funkcji f liczymy zmiany temp w przyszłości 
  które wynikają z tego co już grzaliśmy,
- mamy residualną krzywą temperaturową,

β = [
        P[9];
        P[10];
        P[11];
        P[12];
        P[13]
] 

X = [
 f(1), f(0), 0,    0,    0;
 f(2), f(1), f(0), 0,    0;
 f(3), f(2), f(1), f(0), 0;
 0,    f(3), f(2), f(1), f(0);
]

Niech L = przesunięcie od którego zaczynamy uwzględniać równania w układzie
równań.
Pierwsze równanie które uwzględniamy w układzie równań, jest na
∆U[i+L]
W powyższym przykładzie oczywiście L = 1.

Podaję teraz ogólne wzory na elementy powyższych wektorów y, \beta oraz macierzy X:
(indeksy liczymy od 1!!!, jak jest przyjęte w matematyce)

Wektor y:
        Równanie dla wiersza macierzy y który dotyczy ∆U[k]:
        y[k - (i + L) + 1] = ∆U[k] - \sum_{n=k-K}^{i-1} P[n] * f(k-n)
               //sprawdziłem powyższe na kartce dla k=10, i=9, L=1, K=3
        Gdy chcemy uzyskać y[u], liczymy:
                k = u - 1 + (i+L)
                        //jest to naturalne, pierwszy wiersz macierzy y dotyczy k = i+L,
                        //dalej wartość k rośnie z u
                y[u] = ∆U[k] - \sum_{n=k-K}^{i-1} P[n] * f(k-n)


Wektor β:
        β[1] = P[i]
        β[u] = P[i + u-1]

Macierz X:
        X[u,v] oznacza element w u-tym wierszu i v-tej kolumnie.
        //X[1,1] jest mnożony z P[9] = P[i],
        //      czyli musi mieć postać f(i+L - i) = f(L)
        X[u,v] = f(L+u-v)

        Oczywiście jeśli L+u-v < 0 albo L+u-v > K+1, to 
        komórce X[u,v] przypisujemy 0 (i traktujemy jako pustą komórkę w macierzy
        rzadkiej - sparse matrix).


Po skonstruowaniu w powyższy sposób macierzy X oraz wektora y oraz rozwiązaniu
układu równań y = X * β otrzymujemy wektor β i ostatecznie wartość P[i].
Wyliczona wartość P[i] jest mocą grzałki którą należy ustawić w obecnej chwili
czasu tak aby zapewnić optymalne sterowanie.
Jeśli P[i] < 0, grzanie w obecnej jednostce czasu wyłączamy.

Sekcja 4: Sterowanie przy użyciu wartości funkcji f - liczenie wag
====================================================================

Pojawia się jednak problem, jak daleko w przód przewidujemy nasze ruchy.

Najlepiej prawdopodobnie stopniowo zmniejszać wagę kolejnych pomiarów, tak
żeby dopasowywanie się do żądanej temperatury miało mniejszą wagę w przyszłości,
gdzie przewidywanie temperatury będzie trudniejsze a i tak będziemy mogli
zareagować.

Rozwiązywanie układu równań z uwzględnieniem wag błędów jest opisane tutaj:
http://math.stackexchange.com/a/709683
http://en.wikipedia.org/wiki/Linear_least_squares_%28mathematics%29#Weighted_linear_least_squares
(na Wikipedii oraz StackExchange są inne oznaczenia.
Na StackExchange minimalizujemy W(Ax−b), na Wikipedii: W^{1/2}(Xβ - y)
W^{1/2} oznacza niezależny pierwiastek z każdej z wartości.

Tutaj konsekwentnie używamy oznaczeń z Wikipedii.
)

Potrzebujemy macierz wag W.
Jest to macierz diagonalna (z wartościami niezerowymi tylko na przekątnej).
Definiujemy wektor błędu jako:
e = W^{1/2}(X * β - y)
 - błąd mierzymy jako różnicę różnicy temperatur ∆U[k] którą mamy uzyskać w
   k-tym oknie czasowym a tym co uzyskamy.

Minimalizujemy sumę kwadratów błędów, minimalizując e^{T} e.
(to z tym T to transpozycja).

Na podstawie tego wszystkiego otrzymujemy normalny układ równań (normal equations):
X^{T}*W*X * β = X^{T}*W * y
//przypominam że mnożenie macierzy nie jest łączne: (A * B) * C nie musi być 
//równe A * (B * C)

Ten układ równań potrafimy rozwiązać w sposób dokładny (w tym układzie równań
mamy n = m) i w ten sposób uzyskać "optymalne" rozwiązanie dla \bety  

Pozostaje jeszcze kwestia wyboru wag.
Wikipedia zaleca żeby wagi były odwrotnością wariancji pomiarów.

Nie można dać wariancji z którą znamy funkcję f()???

- w każdym razie, 1/u^2 maleje zbyt szybko, żeby to było do stosowania,

 - co my chcemy dokładnie (dla K = 120):
        - ma maleć do zera, powiedzmy dla K > 80 wartości mają już być
          pomijalne,
        - nie może aż tak mocno 

        - dla K = 120
                w[u] = (u+10)^{-1.2} 
                
                wygląda sensownie
        - czyli ogólnie mamy heurystykę
                w[u] = (u+ K/12 )^{-1.2} 
                //pomijamy tutaj wpływ L


- jeszcze jest kwestia tego że ten układ równań musi być nadmiernie
  zdefiniowany, żeby wagi miały znaczenie,
- przydałyby się dodatkowe parametry,

Powiedzmy P=80         - liczba zmiennych
          R=120        - liczba równań,
- może powiedzmy dajemy tylko do 80 ze 120 równaniami,


- dobra, to w sumie wsz. ustalone







	
	

	- tak jak ze sterowaniem rakietą, rakiety nie naprowadza się na
	  konkretną trasę, po prostu w każdej jednostce czasu (time slice)
          wylicza się na podstawie obecnego położenia oraz innych czynników
          nową trasę, która trochę się różni od starej i po niej rakietę prowadzi.
	
	
	
	
Dawid Nowak
a czy my uwzględniamy tutaj temperaturę rzeczywistą, tzn. zmierzoną przez czujnik ?
dzieje się to aby na pewno dynamicznie ?
09:41
Ja
"dzieje się to aby na pewno dynamicznie ?" - nie rozumiem?
09:43
Dawid Nowak
bo np. jak włożymy do komory jakieś urządzenie do zbadania jak się zachowuje w różnych warunkach temperaturowych i jeżeli ono będzie emitować jakieś ciepło 
09:45
czy my bierzemy pod uwagę temperaturę w jakiejś chwili bieżącej t ?
czy tylko na podstawie danych historycznych ?
09:45
Ja
Ew. możemy założyć termistor, one mają b. dużą szybkość działania.
Zasadniczo wydaje mi się założenie że temp. na termistorze = taka jaką chcemy mieć.
09:46
Dawid Nowak
w sumie dowolny czujnik temperatury
09:46
Ja
Czyli nie przejmujemy się zbytnio tym że termistor mierzy "inną temperaturę" niż jest w komorze.
I tak różnice temp. wewnątrz komory są stosunkowo duże (wyżej jest oczywiście cieplej), musimy względem czegoś kalibrować / jakiegoś punktu.


//      vim: spelllang=pl