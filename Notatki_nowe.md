
//proszę poczekać na załadowanie się wzorów matematycznych. W dolnym lewym
rogu jest pasek postępu.

//pisać coś o HVAC

//komora klimatyczna: kontrola też wilgotności
//komorat temperaturowa: kontrola tylko temperatury

Sekcja 1: Założenia
-------------------

Dla skupienia uwagi będziemy projektować pod komory temperaturowe
 serii AR, produkowane przez ESPEC Corporation.
Ich dokumentacja jest dostępna 
[tutaj](http://www.klimatest.eu/katalog/leaflets/espec/Komory_serii_AR_v2_0.pdf 
"Komory serii AR v2.0")
i [tutaj](http://www.klimatest.eu/katalog/Komory%20klimatyczne/_p/Komory%20klimatyczne%20i%20temperaturowe%20AR
"Komory serii AR v2.0").

Można założyć (w sposób dosyć agresywny):

* okres co jaki wykonuje się pętla kontrolna: $W = 5$ sekund,
       
  Pętla kontrolna składa się z następujących operacji: 

  - pobranie danych, 
  - przetwarzanie,
  - ustawienie wyjść. 

  Odstęp czasu między kolejnymi iteracjami pętli nazywamy przedziałem
  czasu albo jednostką czasu. Zakładamy, że w jednym przedziale czasu ustawienia 
  urządzeń wpływających na
  temperaturę w komorze (moc grzałki, wentylatora, itd) są stałe, a temperatura
  zmienia się jedynie w ograniczonym zakresie. 
  Przedziały czasu będziemy indeksować kolejnymi liczbami całkowitymi, poczynając od 0.

* po wyłączeniu grzania temperatura w komorze się stabilizuje w czasie 
  mniejszym niż 10 minut (czyli po K = 120 jednostkach czasu).
  Po tym czasie przestajemy śledzić konsekwencje grzania w przeszłości,

Wartości podane powyżej są dosyć wyśrubowane, można je złagodzić tak aby zmniejszyć
wartość K.

Ponadto:

* dokumentacja dla komór temperaturowych serii AR (pierwszy link, strona 5) podaje, 
  że "Odchyłka temperatury w przestrzeni" jest równa 3,0 K. Jest to wartość dosyć duża.
  Z tego względu wydaje się zasadne dopasowywanie bezpośrednio temperatury mierzonej
  przez termometr do temperatury zadanej przez charakterystykę czasową i pomijanie
  opóźnień na termometrze (wynikających raczej nie z natury samego termometru, ale
  z czasu potrzebnego na dotarcie ciepła z grzałki do termometru).  

* porównanie charakterystyk różnych mierników temperatury można znaleźć 
  [tutaj](http://cp.literature.agilent.com/litweb/pdf/5965-7822E.pdf).
  Zakładamy termistor, który wg nas jest najlepszy do zastosowania w omawianym urządzeniu.
  Posiada on przede wszystkim bardzo dużą szybkość działania oraz dużą dokładność.

* pomijamy chłodzenie, żeby uprościć problem. W sumie to jednak 
  dosyć dobrze pasuje do różnych systemów HVAC, które mogą działać bez 
  klimatyzatora (np. w zimie).

W pracy będziemy się starali ograniczyć drgania typu: 
grzanie -> chłodzenie (bo zbyt mocno ogrzaliśmy) -> grzanie (bo zbyt mocno ochłodziliśmy)

	

Sekcja 2: Analiza wpływu grzania na przebieg temperatury w komorze
------------------------------------------------------------------

Na zmiany temperatury w komorze mogą wpływać procesy (np. grzania) 
zachodzące stosunkowo dawno temu (wcześniej niż $K \cdot W$).
W tej sekcji postaramy się uchwycić to zachowanie komory w sposób matematyczny.

Rozważamy jednostkę czasu o numerze $k$.

Przyrost temperatury podczas tej jednostki można przybliżyć jako:

$${\Delta}T[k] = T[k+1] - T[k] \approx \sum\_{j=0}^{k} ({\Delta}T[k] \:|\: P[j])
\label{s2dec1}$$

(Na razie pomijamy upływ ciepła przez ściany komory. Pomijamy również ew. ciepło
wytwarzane w urządzeniu znajdującym się w komorze.)

Gdzie:

- $T[k]$ - temperatura na początku k-tej jednostki czasu,
- $({\Delta}T[k] \:|\: P[j])$ - przyrost temperatury w k-tej jednostce czasu dzięki grzaniu w 
                j-tej jednostce czasu. Oczywiście $k {\geq} j$ (grzanie nie może wpłynąć
                na zmianę temperatury przed jego rozpoczęciem).

Jesteśmy w stanie bezpośrednio zmierzyć jedynie $T[k]$, chcielibyśmy jednak znać
$({\Delta}T[k] \:|\: P[j])$.

Musimy więc założyć:

$$({\Delta}T[k] \:|\: P[j]) = P[j] f(k-j)\label{s2fdef}$$

Przy czym:

- $ P[j] $ - moc grzałki w jednostce czasu o indeksie $j$,
- $ f(x) $ - pewna funkcja dążąca do zera dla $x$ dążącego do nieskończoności:
 
  $$lim\_{k \to +\infty} ({\Delta}T[k] \:|\: P[j]) = 0$$

  Posiada ona następujące własności:

  - jest zdefiniowana wyłącznie dla wartości nieujemnych (grzanie nie może wpłynąć
                na zmianę temperatury przed jego rozpoczęciem),
  - jeśli na początku rozważanego przedziału czasu układ znajdował się w równowadze,
   	to wartość $f(0)$ jest równa stosunkowi przyrostu temperatury w rozważanym przedziale czasu
	do mocy grzałki w tym przedziale,
  - po K = 120 przedziałach czasu od rozpoczęcia grzania, ciepło wydzielone przez grzałkę zostaje 
	rozproszone w komorze i nie wpływa już na zmiany temperatury na termometrze.
	Z tego względu można uznać że $f(x) \equiv 0$ dla $x > K$:

    - czyli $f(x)$ może być niezerowe tylko dla $0 \leq x \leq K$,
    - istnieje co najwyżej K+1 niezerowych wartości funkcji $f(x)$:
      0 oraz od 1 do K,
                       
    - mamy zatem jeden okres czasu przeznaczony na grzanie, który nie wlicza się do
             czasu stabilizacji, oraz K okresów, przez które temperatura 
             się stabilizuje.
 	
Po podstawieniu $\ref{s2fdef}$ do $\ref{s2dec1}$ otrzymujemy:

$${\Delta}T[k] = T[k+1] - T[k] ≈ \sum\_{j=0}^{k} P[j] f(k-j)$$

Po przyjęciu że $f(x) \equiv 0$ dla $x {\geq} K + 1$ mamy:

$${\Delta}T[k] = T[k+1] - T[k] ≈ \sum\_{j=k-K}^{k} P[j] f(k-j)$$
	
(wewnętrzna suma przechodzi przez K + 1 wartości)

<br>

Rozważymy teraz dla przykładu postać sumy dla niskich wartości $k$:

Dla $k=0$:

${\Delta}T[0] = T[1] - T[0] ≈ \sum\_{j=0}^{0} ({\Delta}T[0] \:|\: P[j]) = ({\Delta}T[0] \:|\: P[0])$

${\Delta}T[0] = T[1] - T[0] ≈ P[0] f(0)$



Dla $k=1$:

${\Delta}T[1] = T[2] - T[1] ≈ \sum\_{j=0}^{1} ({\Delta}T[1] \:|\: P[j])$

${\Delta}T[1] = T[2] - T[1] ≈ ({\Delta}T[1] \:|\: P[0]) + ({\Delta}T[1] \:|\: P[1])$

${\Delta}T[1] = T[2] - T[1] ≈ ( P[0] f(1) + P[1] f(0) )$



I podsumowując, poprzez analogię:

$	{\Delta}T[0] = T[1] - T[0] ≈ (P[0] f(0))$

$	{\Delta}T[1] = T[2] - T[1] ≈ (P[0] f(1) + P[1] f(0))$

$	{\Delta}T[2] = T[3] - T[2] ≈ (P[0] f(2) + P[1] f(1) + P[2] f(0))$

$	{\Delta}T[3] = T[4] - T[3] ≈ (P[0] f(3) + P[1] f(2) + P[2] f(1) + P[3] f(0))$


Taką strukturę nazywamy 
[splotem (convolution)](http://en.wikipedia.org/wiki/Convolution#Discrete_convolution "Wikipedia: Convolution").

Mamy więc:

$$	{\Delta}T[3] = T[4] - T[3] ≈ (P \ast f)[3]$$
	
i ogólnie:
	
$$	{\Delta}T[k] = T[k+1] - T[k] ≈ (P \ast f)[k]$$

W tym wypadku przy definicji splotu pomijamy składniki dla których $f(x) \equiv 0$.

<br>

Ostatecznie mamy układ równań o postaci:

$${\Delta}T[k] = T[k+1] - T[k] ≈ \sum\_{j=k-K}^{k} P[j] f(k-j) = 
\sum\_{j=0}^{K} P[k-j] f(j) = (P \ast f)[k] \label{s2eqs}$$

Ten układ równań posiada $K+1$ niewiadomych - tyle ile niezerowych wartości funkcji $f()$.

Dla każdej danej historycznej (pary wartości $P[j]$, $T[j]$) 
mamy zazwyczaj jedno równanie.
Jeżeli jednak system przy rozpoczęciu zbierania danych nie znajdował sie w stanie
równowagi termodynamicznej, musimy odrzucić pierwsze K pomiarów.
Odrzucamy też ostatnie K pomiarów.


Można by rozpisać funkcję $f(x)$ na następujące składniki:

$$f(x) = g(x) e^{-\frac{t}{T}} c\_1$$

Przy czym:

 - $ g(x) < 1 $,
 - $ g(0) = 1 $	(tak żeby $c\_{1}$ ustalić na sztywno)
                //jednak to by nie było dopuszczalne, ponieważ f(0) może być
                //stosunkowo małe, mniejsze niż g(1)
 - $T$ - jakaś liczba.

Mogłoby to ew. pomóc przy rozwiązywaniu układu równań - można w ten sposób ograniczyć
wartości funkcji $ f(x) $.

Może być jednak problem z uwzględnieniem $g(x) < 1$ przy rozwiązywaniu tego 
układu równań (wymagałoby to użycia innych metod rozwiązywania układu równań niż 
powszechnie stosowane).



Sekcja 3: Uwzględnienie upływu ciepła
------------------------------------------------------------------

Model komory grzewczej przestawiony w poprzedniej sekcji nie uwzględnia upływu 
ciepła przez jej ścianki. 

Można założyć w dużym uproszczeniu, że szybkość upływu ciepła zależy wyłącznie 
od temperatury panującej w komorze. Uwzględnienie innych czynników (np. historii 
zmian temperatury) spowodowałoby znaczny wzrost liczby niewiadomych w układzie 
równań, co byłoby niekorzystne z dwóch względów:

- do wyliczenia układu równań potrzebnych byłoby bardzo wiele danych historycznych,
- spadłaby znacznie dokładność oszacowania wartości niewiadomych.

Niech $({\Delta}T[k] \:|\: T[k])$ - szybkość upływu ciepła z komory (zmiana temperatury zależna od 
obecnej temperatury w komorze).
Przyjmujemy, że $({\Delta}T[k] \:|\: T[k]) < 0$.

Równanie $\ref{s2dec1}$ uzupełnione o wpływ temperatury przyjmuje postać: 

  $${\Delta}T[k] = T[k+1] - T[k] ≈ ({\Delta}T[k] \:|\: T[k]) + \sum\_{j=0}^{k} ({\Delta}T[k] \:|\: P[j]) \label{s3eqs}$$

Żeby ograniczyć liczbę niewiadomych w układzie równań, można określić
$({\Delta}T[k] \:|\: T[k])$ co - powiedzmy - $L = 5\mathrm{°C}$ i wykonywać interpolację albo aproksymację 
dla pozostałych wartości
(trzeba tu zauważyć, że temperaturę będziemy znali z dokładnością co najmniej
0,1°C, zatem interpolacja lub aproksymacja i tak jest konieczna).

Szybkość ucieczki ciepła można aproksymować w podany poniżej prosty sposób:

 - definiujemy pewną funkcję $j(x)$ - określoną dla wartości x podzielnych przez 5,
 - dla $k$ nie należącego do dziedziny funkcji $j(x)$ mamy (zaokrąglamy $k$ w dół do liczby podzielnej przez 5):

$$m = T[k] - (k \bmod 5)$$

$$({\Delta}T[k] \:|\: T[k]) = \frac{j(m-5) + j(m) + j(m+5) + j(m+10)}{4}$$


 - dla $k$ należącego do dziedziny funkcji $j(x)$ mamy:
        
$$ ({\Delta}T[k] \:|\: T[k]) = \frac{j(T[k]-5) + j(T[k]) + j(T[k]+5)}{3}$$

Oznaczmy jako $w(t)$ szybkość upływu ciepła wyliczoną za pomocą powyższych równań.

<br>

Powyższe wzory można w prosty sposób uwzględnić w układzie równań $\ref{s2eqs}$:

$${\Delta}T[k] = T[k+1] - T[k] ≈ w(T[k]) + \sum\_{j=k-K}^{k} P[j] f(k-j) =
         w(T[k]) + \sum\_{j=0}^{K} P[k-j] f(j) = w(T[k]) + (P \ast f)[k] \label{s3eqs2}$$

Po rozwiązaniu go, otrzymujemy wartości funkcji $f(x)$ oraz $j(x)$, które będą potrzebne
do świadomego sterowania komorą.
















Sekcja 4: Sterowanie
--------------------

Znając wartości funkcji $f(x)$ oraz $j(x)$ wyliczone na podstawie danych historycznych,
można przewidzieć przebieg temperatury towarzyszący procesom grzania i z tego
względu w sposób świadomy sterować grzałką poprzez wybór najbardziej optymalnego
przebiegu.

Przy wyliczaniu wartości funkcji $f(x)$ oraz $j(x)$ jest zalecane ograniczenie się 
do wartości $T[k]$ oraz $P[k]$ dla $k$ występującego stosunkowo dawno, tak żeby 
nie występowały trudne do uchwycenia interakcje między tym co się teraz 
dzieje a tym co było w niedawnej historii i co wpływa bezpośrednio na obecne 
decyzje.
 
Jesteśmy w chwili czasu $i$, mamy historię oraz przyszłość do decyzji.
(zmienne są dobrane tak żeby intuicyjnie $i \leq j \leq k$)

Oznaczenia:

-	$i$ - obecna chwila czasu, którą analizujemy,
-	$j$ - indeksuje czas w którym przewidujemy że będziemy grzać,
-	$k$ - indeksuje temperaturę w przyszłości,

Przyjmujemy uproszczony model ogrzewania przedstawiony w sekcji 3 - wzór $\ref{s3eqs2}$

$${\Delta}T[k] = T[k+1] - T[k] ≈ w(T[k]) + \sum\_{j=0}^{K} P[k-j] f(j) = w(T[k]) + (P \ast f)[k] \label{s4eqs}$$

Będziemy postępowali podobnie jak doświadczony szachista, przewidujący
kilka ruchów naprzód a jednocześnie w każdym ruchu dostosowujący się do
działań rywala i aktualizujący odpowiednio swoją strategię.
Z drugiej strony będziemy postępowali podobnie jak przy sterowaniu rakietą.
Rakiety nie naprowadza się bowiem na
konkretną trasę, po prostu w każdej jednostce czasu 
wylicza się na podstawie obecnego położenia oraz innych czynników
nową trasę, która trochę się różni od starej i po niej rakietę prowadzi.

Niech $U[k]$ = żądana temperatura na początku przedziału czasowego $j$.
Na podstawie wartości $U[k]$ potrafimy policzyć 
$${\Delta}U[k] = U[k+1] - U[k]$$

Moglibyśmy tutaj ułożyć układ równań:
$${\Delta}U[k] = w(T[k]) + \sum\_{j=0}^{K} P[k-j] f(j) $$
a następnie rozwiązać go, uzyskując potrzebne wartości $P[j]$.
Posługiwanie się szybkością zmiany temperatury jest jednak kiepskim pomysłem, a to ze 
względu na jeden prosty problem: zastana 
temperatura w komorze klimatycznej może odbiegać
znacząco od $U[k]$ i w tym wypadku dążenie do ${\Delta}T[k] = {\Delta}U[k]$ traci
sens. Nie pomoże też korekta pierwszej wartości $\Delta U[k]$, ponieważ zagubi się ona
w układzie równań i nie wpłynie znacząco na wynik.

Niestety, dopasowywanie $T[k] = U[k]$ znacząco komplikuje równania.


Mamy zatem:
$$T[k] = T[i] + \sum\_{l=i}^{k-1} T[l+1] - T[l] = T[i] + \sum\_{l=i}^{k-1} \Delta T[l] \nonumber$$

Podstawiamy do powyższego równania równanie  $\ref{s3eqs2}$, zamieniając $k \to l$:

$$T[k] = T[i] + \sum\_{l=i}^{k-1} \left[ w(T[l]) + \sum\_{j=l-K}^{l} P[j] f(l-j) \right]$$
$$T[k] = T[i] + \sum\_{l=i}^{k-1} w(T[l]) + \sum\_{l=i}^{k-1} \sum\_{j=l-K}^{l} P[j] f(l-j)$$

Potrzebujemy teraz odwrócić kolejność sum w ostatnim składniku
powyższego równania, tak aby łatwo przejść do postaci macierzowej. 
Widzimy, że przy rozwinięciu sumy mamy wyrazy na $P$ od $P[i-K]$ do $P[k-1]$.
$P[j]$ występuje w składnikach sumy wyższego poziomu (indeksowanej przez $l$) dla 
$$l-K \leq j \leq l \label{s4sumsinvertion}$$
Każde $P[j]$ "widzi" więc takie wartości $l$. Trzeba jednak pamiętać że
wartości $l$ są dodatkowo ograniczone przez granice sumy zewnętrznej:

$$ i \leq l \leq k-1 \label{s4sumsinvertion2}$$



$P[j]$ jest więc mnożone przez
$\sum f(l-j)$ przy sumowaniu przez wszystkie wartości $l$ spełniające równania 
$\ref{s4sumsinvertion}$ oraz $\ref{s4sumsinvertion2}$. 
Po przekształceniach mamy więc następujące ograniczenia na $f(l-j)$:

$$
\begin {cases}
j \leq l \leq j+K       \\\\
i \leq l \leq k-1 
\end {cases}
$$

Oraz:
$$
\begin {cases}
0 \leq l-j \leq K       \\\\
i-j \leq l-j \leq k-j-1 
\end {cases}
$$
Pierwsze z tych równań jest ograniczeniem do niezerowej dziedziny funkcji $f(x)$.
W drugim równaniu pierwsza nierówność usuwa wyrazy $f(x)$ odnoszące 
się do zmian temperatury przed jednostką czasu $i$, druga nierówność - do 
zmian temperatury w jednostce czasu $k$ (przypominam że $T[k]$ = czas na początku
jednostki $k$) oraz po tej jednostce.

Ostatecznie mamy więc:
$$T[k] = T[i] + \sum\_{l=i}^{k-1} w(T[l]) + 
        \sum\_{j=i-K}^{k-1} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right] \label{s4equinverted}$$

* * *

W celu zapewnienia optymalnego sterowania, będziemy starali się dążyć do $T[k] = U[k]$.
Da się to uzyskać rozwiązując układ równań, uzyskany
po podstawieniu tego wyrażenia do równania
$\ref{s4equinverted}$:

$$U[k] = T[i] + \sum\_{l=i}^{k-1} w(T[l]) + 
        \sum\_{j=i-K}^{k-1} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right] \label{s4equToSolve}$$

W tym układzie równań niewiadomymi są wartości $P[j]$ dla $j \geq i$. 
Będziemy w nim uwzględniać $R$ równań o postaci takiej jak powyżej,
pisanych dla kolejnych wartości U[k], poczynając od U[i+1].
Ograniczymy również liczbę niewiadomych do $Q$, przyjmując że dla wyższych
wartości $P[j] \equiv 0$.

TODO: napisać dlaczego

Dla $K=120$ sensowne wartości tych parametrów to: $Q=80$ oraz $R=120$.

* * *

Po wprowadzeniu tych ograniczeń wiersz układu równań przyjmuje postać:
$$U[k] = T[i] + \sum\_{l=i}^{k-1} w(T[l]) + 
        \sum\_{j=i-K}^{\min(k-1,\;Q)} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right] \label{s4equToSolve2}$$

Musimy teraz przekształcić ten układ równań do postaci macierzowej
(używam oznaczeń jak na [Wikipedii](http://en.wikipedia.org/wiki/Linear_least_squares_%28mathematics%29#The_general_problem)):
$$\mathbf{y} = \mathbf{X} \mathbf{\beta} \label{s4equmartix}$$

Oznaczenia:

- $\mathbf{y}$ - wektor wyrazów wolnych,
- $\mathbf{\beta}$ - wektor niewiadomych,
- $\mathbf{X}$ - macierz współczynników. 


W tym celu zaczniemy od rozdzielenia wyrazów z $P[j]$ dla $j < i$ (których wartości
znamy) oraz pozostałych (niewiadomych):
$$U[k] = T[i] + \sum\_{l=i}^{k-1} w(T[l]) + 
        \sum\_{j=i-K}^{i-1} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right]
        +
        \sum\_{j=i}^{\min(k-1,\;Q)} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right]$$

Można optymistycznie założyć, że $T[l] \approx U[l]$ i przybliżyć
$w(T[l])$ przez $w(U[l])$.
(to założenie jest tym bardziej uzasadnione, że funkcja $w(x)$ rośnie stosunkowo
wolno)
Jednocześnie 
przenosimy wszystkie składniki o znanej wartości na lewą stronę:

$$U[k] - T[i] - 
        \sum\_{l=i}^{k-1} w(U[l]) -
        \sum\_{j=i-K}^{i-1} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right]
        =
        \sum\_{j=i}^{\min(k-1,\;Q)} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right]$$


Element wektora wyrazów wolnych opisujący $U[k]$ ma więc postać
(przyjmujemy że macierze są indeksowane od 1):

$$\mathbf{y}[a] = 
        U[k] - T[i] - 
        \sum\_{l=i}^{k-1} w(U[l]) -
        \sum\_{j=i-K}^{i-1} \left[ 
        P[j] \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
        \right]
\qquad
        \textrm{przy czym } \quad k = i + a - 1
$$

Można tu zauważyć, że 
wektor $y$ odpowiada residualnej krzywej temperaturowej - poszczególne 
jego elementy zawierają informację o ile jeszcze musimy podnieść temperaturę w danym
przedziale czasowym.

Element wektora niewiadomych można zdefiniować jako:
$$\mathbf{\beta}[b] = P[j]      
\qquad
        \textrm{przy czym } \quad j = i + b - 1
$$

I wreszcie:
$$
\mathbf{X}[a,b] = 
        \sum\_{l=\max(0,\; i-j)}^{\min(K,\; k-j-1)} f(l) 
\qquad
        \textrm{przy czym } \quad j = i + b - 1
        \quad \textrm{oraz } \quad k = i + a - 1
$$

We współrzędnych elementu wektora podajemy najpierw wiersz a później kolumnę.
Element $\mathbf{X}[a,b]$ jest mnożony z
$\mathbf{\beta}[b]$ a iloczyn ma być równy $\mathbf{y}[a]$.

Gdybyśmy macierze indeksowali od zera, wówczas $k = i+a$ oraz $j = i+b$.













Po skonstruowaniu w powyższy sposób macierzy X oraz wektora y oraz rozwiązaniu
układu równań y = X {\cdot} \beta otrzymujemy wektor \beta i ostatecznie wartość P[i].
Wyliczona wartość P[i] jest mocą grzałki którą należy ustawić w obecnej chwili
czasu tak aby zapewnić optymalne sterowanie.
Jeśli P[i] < 0, grzanie w obecnej jednostce czasu wyłączamy.

Sekcja 5: Sterowanie przy użyciu wartości funkcji f - liczenie wag
--------------------------------------------------------------------

 - rozwiązujemy go za pomocą ważonej metody najmniejszych kwadratów

- wagi są konieczne, bo musimy jakoś w sensowny sposób odciąć wartości j,
- problem: mogą wyjść liczby ujemne,

Pojawia się jednak problem, jak daleko w przód przewidujemy nasze ruchy.

Najlepiej prawdopodobnie stopniowo zmniejszać wagę kolejnych pomiarów, tak
żeby dopasowywanie się do żądanej temperatury miało mniejszą wagę w przyszłości,
gdzie przewidywanie temperatury będzie trudniejsze a i tak będziemy mogli
zareagować.

Rozwiązywanie układu równań z uwzględnieniem wag błędów jest opisane tutaj:
http://math.stackexchange.com/a/709683
http://en.wikipedia.org/wiki/Linear_least_squares_%28mathematics%29#Weighted_linear_least_squares
(na Wikipedii oraz StackExchange są inne oznaczenia.
Na StackExchange minimalizujemy W(Ax−b), na Wikipedii: W^{1/2}(X\beta - y)
W^{1/2} oznacza niezależny pierwiastek z każdej z wartości.

Tutaj konsekwentnie używamy oznaczeń z Wikipedii.
)

Potrzebujemy macierz wag W.
Jest to macierz diagonalna (z wartościami niezerowymi tylko na przekątnej).
Definiujemy wektor błędu jako:
e = W^{1/2}(X {\cdot} \beta - y)
 - błąd mierzymy jako różnicę różnicy temperatur {\Delta}U[k] którą mamy uzyskać w
   k-tym oknie czasowym a tym co uzyskamy.

Minimalizujemy sumę kwadratów błędów, minimalizując e^{T} e.
(to z tym T to transpozycja).

Na podstawie tego wszystkiego otrzymujemy normalny układ równań (normal equations):
X^{T} {\cdot} W {\cdot} X {\cdot} \beta = X^{T} {\cdot} W {\cdot} y
//przypominam że mnożenie macierzy nie jest łączne: (A {\cdot} B) {\cdot} C nie musi być 
//równe A {\cdot} (B {\cdot} C)

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


<!--      vim: set spelllang=pl filetype=markdown :    -->

