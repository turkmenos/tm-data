-- tm-data
-- Turkmen Poetry Dataset
-- MySQL 8+

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS poets (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY uq_poets_name (name)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS poems (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    poet_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(500) NOT NULL,
    text LONGTEXT NOT NULL,
    source VARCHAR(1000) NULL,

    PRIMARY KEY (id),

    KEY idx_poems_poet_id (poet_id),
    KEY idx_poems_title (title),

    CONSTRAINT fk_poems_poet
        FOREIGN KEY (poet_id)
        REFERENCES poets(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

INSERT INTO poets (name)
VALUES ('Kemine')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'Kemine'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Diliň derdinden',
    'Aşygam, saklana bilmen
Saýraýan diliň derdinden;
Bilbilem, uklaýa bilmen
Gyrmyzy gülüň derdinden.

Sen Şasenem, men şasuwar,
Garybyň men, kyl istiwar,
Ýada salsam agzym suwar,
Dodakda balyň derdinden.

Ýaraşsyn ýagy illeriň,
Açylsyn batyl ýollaryň,
Näzikdir inçe billeriň,
Sallanan goluň derdinden.

Ýagşyny ýasan ussalar,
Pähm etmez akly gysgalar,
Galar gadymky nusgalar,
Hünärli goluň derdinden.

Armanam — öpüp, guçmadym,
Golundan şerap içmedim,
Ölinçäm sana geçmedim,
Bir ýyrtyk juluň derdinden.

            1         
Çagyrsam, asyl gelmer sen,
Gelseň-de, oýnap-gülmer sen,
Ne boldy, habar almar sen
Kemine guluň derdinden!

            2          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ärsarynyň gyzy',
    'Ýarym diýip, ýola çyksam,
Ýollar — ärsarynyň gyzy;
Jeren gözläp, çöle çyksam,
Çöller — ärsarynyň gyzy.

Çölüstanda bardyr baýlar,
Zyndan boldy maňa jaýlar,
Ötüp barýar ýyllar, aýlar,
Günler — ärsarynyň gyzy.

Alma-naryň ysy ýupar,
Ter mämeler goldan sypar,
Ýüzi görkli, eli çeper,
Çeper — ärsarynyň gyzy.

Ýerde ýatmaz ýazyň güli,
Saýraýyr bagyň bilbili,
Men islemen özge güli,
Güller — ärsarynyň gyzy.

Kemine bir dessan ýaýar,
Kimler dadar, kimler doýar,
Ýüregimde daglar goýar,
Çöller — ärsarynyň gyzy.

             3          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dilberim galdy',
    'Welaýatdan çykdym, gitdim,
Yzymda dilberim galdy;
Dostlar, bu jana jebr etdim,
Gara gözli ýarym galdy.

Hälä çekerin men zehmet,
Dogdy başyma kyýamat,
Ýene bolsa dem ganymat,
Meniň ahy-zarym galdy.

Göründi galanyň burçy,
Ýüregimde yşkyň berçi,
Agzy pisse, lebi harçy,
Aglap. söwer ýarym galdy.

Bu galaňyz perizatly,
Içi pereňli, ilatly.
Kemine, «Mähriban» atly
Bir peri-peýkerim galdy.

            4          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Emire meňzär',
    'Jem bolsa hatynlar bary,
Her biri emire meňzär:
Şol hatynlaryň barysy
Senetli wezire meňzär.

Birisi bardyr gezende,
«Gel» diýmezler, irizende,
Gözi bardyr gap-gazanda.
Zat tapsa gemire meňzär.

Birisiniň uzyn özi,
Kereşmeli, köpdür näzi,
Ukudan açylmaz gözi,
Elmydam bimara meňzär.

Biri bardyr gowy ýokdan,
Gaçawer, görseň yrakdan,
Har-hamyrdan, gökden-akdan,
Zat tapsa, ýamyra meňzär.

Birisi bardyr — horandyr,
Idelmez ýere barandyr,
Azyndan on bäş görendir,
Semreýir, hamyra meňzär.

            5           
Ýene hem birisi bardyr,
Jahyl görse, hyrydardyr,
Bir söz aýtsaň, minnetdardyr
Ýörişi haýýara meňzär.

Biri ýüz urar hünäre,
Hünär eder göre-göre,
Birisiniň reňgi gara,
Mysaly sygyra meňzär.

Birisiniň içi janly,
Gury agaçdan istihanly,
Birisi bar etli-ganly,
El ursaň, hamyra meňzär.

Biri bardyr çygry çykan,
Eden işi bir iç ýakan,
Daş işige külün döken,
Her ýygyrdy hyra meňzär.

Biri bardyr taýyn daýym,
Mydam gullugynda gaýym,
Kemally berse hudaýym,
«Öl» diýseň, jan biýre meňzär.

Biri bardyr, misli maýa,
Bir görmeseň, ömrüň zaýa,
Nazaryňa gelse göýä,
Akylyň dagyra meňzär.

            6           
Bolsa ýigidiň ýagşy aýaly,
Döwlet salar saňa ýoly,
Abraýyň doldyr goly,
Bir sahyby-pire meňzär.

Kemine diýr, bir söz bolar,
Kysmatda bary ýazylar,
Ýagşy gelin, ýagşy gyzlar,
Mysaly gülzara meňzär.

             7          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ak eder',
    'Eý, agalar, ýaman heleý
Sakgalyň çykmanka ak eder;
Abraýyňy ýere döker,
Ýürek-bagryňy dag eder.

Başy çykmaz hiç bir işden,
Emma görseň, aýal daşdan,
Ak ýüplükden, gök erişden,
Saçyna ýüpden bag eder.

Mydam iliň gepin bakar,
Gazananyň ýere döker,
Geýim geýse, ýarsyn ýakar,
Ýakasyn ýyrtyp, çäk eder.

Äri hem gazanyp getir,
Çuwala salmanka ötir,
Göreniň külünde otyr,
Diýr «Maňa ärim gyýk eder».

Bolmaz gepiniň saýagy,
Ilden ýygnanmaz aýagy,
Ýalandan çenäp taýagy,
Öz öýüni gum-guk eder.

            8            
Garyp alyň asly-zatyn,
Ýamandan al boýuň satyn,
Kemine diýr, selki hatyn
Alyn saçyň çym-ak eder.

           9         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Halal gezer',
    'Dünýe bir bimesrep jaýdyr,
Haram gezer, halal gezer;
Mal eýesi pylan baýdyr,
Adam ornuna mal gezer.

Şerigaty bilseň dogry,
Aýtmasaň, boldugyň ogry,
Kazy egri, müfti egri,
Elip ornuna dal gezer.

Galypdyr kelamyň sözi,
Kör begenmez gören gözi,
Pir bolar şeýtanyň özi,
Sopular hem haýal gezer.

Sena bolmaz subhy-şamda,
Til – gybatda, gulak – tamda,
Kemine diýr, şu eýýamda
Sogap ornuna kal gezer.

            10         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Kazym',
    'Müberek bolsun seýliňiz,
Azm edip siz ýola, kazym!
Agyr ýük syndyr biliňiz,
Diýsem, geler dile, kazym.

Külden depe beýik bolmaz,
Synsa köňül, seýik bolmaz.
Gara keýik keýik bolmaz,
Meger, girse çöle, kazym.

Diýsem kazylar kärini,
Aýdyp bolmaz-la ýaryny,
Ýalan sözleriň baryny
Satarsyňyz pula, kazym!

Kemine, gepim gep bolar,
Diýsem, dertlerim dep bolar,
Garyplar size çep bolar,
Çyn töhmet siz ile, kazym!

             11           ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Şol ýar öldürdi',
    'Telbe boldum, indi halym harapdyr,
Eý, agalar, meni şol ýar öldürdi;
Müşk alyban käkillerin darapdyr,
Jan agalar, meni şol ýar öldürdi.

Boýnuna gol salsaň barly, semerli,
Altyn-kümüş tamam endamy zerli,
Lagly-ýakut gerdeninde, tumarly,
Eý, agalar, meni şol ýar öldürdi.

Arzuw edip, aý jemalyn görmeli,
Ýüzde gülap, gözi-gaşy sürmeli,
Bir peridir, saçy sekiz örmeli,
Jan agalar, meni şol ýar öldürdi.

Kemine diýr, tagt üstünde jaýydyr,
Derýa düri, asman kuýaş-aýydyr,
Gyzlar hany, gözelleriň şaýydyr,
Jan agalar, meni şol ýar öldürdi.

                  12          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Boýuňa döneýin',
    'Sähra degresinde duran gül kamar,
Ýaşyl geýen al boýuňa döneýin!
Söz sözläňde katra-katra bal damar,
Ak ýüzüňde hal, boýuňa döneýin.

Meniň işim keçdir, şowuna düşmez,
Özge bilen hergiz sulhum alyşmaz,
Mal bereýin diýsem, küştüm ýetişmez.
Mende ýokdur mal, boýuňa döneýin.

Gyzyl meňzim sargarypdyr ar bilen,
Täleýim ýok, ykbalym ýok ýar bilen,
Ak göwsüň meňzetdim dagda gar bilen,
Mende tylla ýok, boýuňa döneýin.

Keminäniň göwni senden üzülmez,
Ýar zalymdyr, bize bagry ezilmez,
Çyn aşygyň eden hdi bozulmaz,
Bir kararda dur, boýuňa döneýin.

                 13         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Barsam ynanmaz',
    'Iş salyşdym bir biwepa ýar bilen,
«Ýarym» diýip, ýanyna barsam ynanmaz;
Süýekden syzdyryp ygtybar bilen,
Oda düşsem, bişsem, ýansam, ynanmaz.

Leýli—Mejnun kimin çöllere çyksam
Arzy—Ganbar deýin derýada aksam,
Perhat—Şirin deýin daglary ýyksam
Daşlaryň teýinde galsam, ynanmaz.

Gör, ne işler etdi Wamyku–Uzra,
Saýathan diýp goýdy ýaryny Hemra,
Depderde ýazylan Ýusup—Züleýha,
Olaryň hemrasy bolsam, ynanmaz.

Garyp bolup, Halap-Şirwana gaçsam,
Ýarym Şasenem diýp, örtenip-bişsem,
Şolar kimin ýedi ýylda gowuşsam,
Yzynda sargaryp-solsam, ynanmaz.

Men söwer ýarymy alabilmedim,
Şum rakyp tagn etdi, gülebilmedim,
Näzli ýaryň ugrun bilebilmedim,
Aglasam, aldanmaz, gülsem, ynanmaz.

                14         
Kemine diýr, arzym ýara ýetirsem,
Köňlümdäki syrym tile getirsem,
Iýmesem, içmesem, gözläp otursam,
Ajygsam, suwsasam, ölsem, ynanmaz.

                15        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Maňa garşy',
    'Söwer ýaryň tarypyny aýdaly,
Gitme, ak maralym, gel maňa garşy;
Altyn-kümüş zümerretden şaýlaly,
Ak goluň boýnuma sal, maňa garşy.

Men arzymy söwer ýara ýetirsem,
Tutsam ak mämeden, oýnap otursam,
Göwnümde bar maksat–işim bitirsem,
Emsem lebleriňden bal, maňa garşy.

Meniň arzym söwer ýaryň goýnunda.
Agzym ýaňagynda, elim boýnunda,
Assa-seýkin basyp, oýnan oýnunda,
Her jaýy-her jaýy, gel maňa garşy.

Kemine diýr, sen-sen wepaly ýarym,
Al-ýaşyl geýipdir towfyk nigarym,
Gözeller içinde sen intizarym,
Sen — Leýli, men — Mejnun, çöl maňa garşy.

                 16         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Sözüm bar saňa',
    'Gara gözli, galam gaşly perizat,
Aýdabilmen, birje sözüm bar saňa;
Yşkyňda köýüp men dat bilen bidat,
Iki çeşmim bir görmäge zar saňa!

Şikeste men, zülpleriňe baglama,
Hanjar alyp, ýürek-bagrym daglama,
Myhmanyň men işigiňden kowlama,
Gerek dälmi namys bilen ar saňa?

Dal gerdenden tylla heýkel dakmasaň,
Humaý gözüň süzüp, gaşyň kakmasaň,
Ýüz-müň suhan diýsem, bäri bakmasaň,
Neneň edip ýaranaýyn ýar saňa!

Kemine diýr, senden istedim wepa,
Wepa istäp geldim, sen berdiň jepa,
Yşkyňda hastaýam, sen bergil şypa,
Şypa istäp geldim, men bimar saňa!

                 17         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Sözler içinde',
    'Dostlar, bir gözeliň waspyn söýlär men,
Meşhur bolsun sözi sözler içinde;
Okar men, ýazar men, dessan eýlär men,
Bina bolsun ak kagyzlar içinde.

Seniň dek ter gunça baglarda bitmez,
Uzatsam almaga, gollarym ýetmez,
Uklasam, oýansam, ýadymdan gitmez,
Meger, mesgen tutmuş gözler içinde.

Şiriniň hemrasy, Leýliniň taýy,
Şöhläňden gizlener asmanyň aýy,
Her gije, her gündiz gördügim saýy,
Ýüzüň aýa meňzär ýüzler içinde.

Laçyn deý dalmynyp her ýan bakaňda,
Perizat sen zülpüň ýere dökeňde,
Seýr eýleýip, beýewana çykaňda,
Göýä ak jeren sen düzler içinde.

Kast edip bakar sen, periler hany,
Kirpikleriň saldy sansyz ýarany,
Akyp, eda boldy bagrymyň gany,
Dowamat jigerim duzlar içinde.

                 18          
Kemine diýr, wysal içre gezmäge,
Ylym gerek seniň waspyň düzmäge,
Yşk odundan galam titrär ýazmaga,
Dilim sözde, köňlüm közler içinde.

                19         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gyzlaryň',
    'Dagyň gary gardan-gara ulaşar,
Gijeler ýatyrmaz näzi gyzlaryň;
Birisi nuh edip, äre ýetişse,
Ol gün ýasaw tapar bary gyzlaryň.

Gül tikensiz bolmaz, daglar gaýasyz,
Ýüpüň hiç reňk almaz zäksiz, boýagsyz,
Sen bir eýjejik zat, galdyň eýesiz,
Düwme-düwme bolar nary gyzlaryň.

Baýyň gyzy şagalaňda şaýlanar,
Şaýlanybam beýleräge saýlanar,
Pukara ýigitler neneň öýlener,
Näzin artdyr keli, köri gyzlaryň.

Baýyň gyzy sürter haram teňňesin,
Birin alsaň, alyp bolmaz öňňesin,
Dost tutunsaň ýagşy gyzyň ýeňňesin,
Ýeňňesinde ygtyýary gyzlaryň.

Çöle çykarsyňyz goýun guzlanda,
Gülýakaň ýalkym atýar bäri gözläňde,
Janym alyp barýar şirin sözlände,
Düwme-düwme bolar nary gyzlaryň.

                  20          
Pasly-bahar bolsa, açylsa läle,
Bilbil huruç edip, geler hyýala,
Ýuka köýnek geýip, ýörse şemala,
Düwme-düwme bolar nary gyzlaryň.

               21        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gulpagyň',
    'Ne belaň bar, gutarmadyň zulumdan,
Görem, kulahyňy göter, gulpagyň;
Ýüregim dalmynyp, çykdy golumdan,
Janyma owsunlap ýeter gulpagyň.

Ak ýüzüň hallary nokatdan kiçi,
Gamzaň garakçydyr jan almak öji,
Mejnuny ýandyrdy Leýliniň saçy,
Leýliniň saçyndan artar gulpagyň.

Köňlüm bähre tapar oýnan oýnuňdan,
Sekiz jennet ysy geler goýnuňdan,
Ikisin örüp, birin goýber boýnuňdan,
Ýöräňde, sagryňa ýeter gulpagyň.

Ýelkildeşip, ýatlar bilen ýörülme,
Göze düşüp, göklügiňde orulma,
Sadagaň bolaýyn menden aýrylma,
Görse bir nämährem, gutar gulnagyň.

Yşkyň serişdesin erenler tutdy,
Aşyk bolan magşugyny unutdy.
Kemine diýr, menden ýigitlik ötdi,
Mundan hem ýakyndyr, öter gulpagyň.

                 22         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Mämeleriň',
    'On üç bilen on dört ýaşyň arasy,
Tözlenip galyşar, ýar, mämeleriň:
Örtenmekden gaýry bolmaz çäresi,
Gysymlap gyşarsam ak mämeleriň.

Gulman deý sallanyp, sagynyp duran,
Husnuňa bent olar bir gezek gören,
Gunçalap, düwmeläp, täze uç beren,
Garaňkyda gardan ak mämeleriň.

Iki aşyk bir-birine bezm eder,
Çola ýere barsa, jany hezl eder,
Köýneginden çykaýsam diýp azm eder,
Mutdaha bolanda, ýar, mämeleriň.

Sowsanmydyr, sünbülmidir geýgeniň,
Elenen ak çäge bolsun oýnagyň,
Eda bilen göter elwan köýnegiň,
Bal bilen ýugrulan ýag mämeleriň,

Ýaşymyň soňunda taşladym gurra,
Nesip bolsa, garry gurda ýaş berre,
Kemine, armanyň galmasyn zerre,
Gulende titreşer, gyz, mämeleriň.

                 23          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýel bile',
    'Ak ýüzünde gara zülpüň hünäri,
Dawa edip, jeň başlady ýel bile;
Älemi ýandyrar bilbiliň zary,
Meger, bäs eýlemiş gyzyl gül bile.

Aşyga ar getir lebzinden dänme,
Bir merde ýaraşmaz hiç soňun sanma,
Didara doýma ýok, şu mähre — ganma,
Ýör, boýuňa guwanaýyn, ýol bile.

Aşyklyk derdine tapylmaz çäre,
Gamzaň okdur, peýkam salypdyr ýara,
Üç ýogyn, üç inçe, üç ak, üç gara —
On iki syn ýaraşmyş niçe bil bile.

Aslyňy sorasam — iliň uşagy,
Biliňe urup sen tirme guşagy,
Meni ýakdy alkymlaryň aşagy,
Alma zenahdanlym, jüre hal bile.

Bu ne syrdyr, ýaýma ýakyna-ýada,
Delmirip gelip men gapyňa dada.
Ýakyp sen, örtäp sen, salyp sen oda,
Duzladyň söz bile, dildiň dil bile.

                  24          
Kemine diýr, eşit meniň pyganym,
Müjgäniň hanjardyr, akyzdy ganym,
Sen meni köýdürdiň, binurbat zalym!
Ak üstüne gyzyl geýdiň al bile.

                25         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Çykdy-da gitdi',
    'Eý, agalar, Ýolöteniň düzünden
Meniň sona boýlym çykdy-da gitdi;
Alma ýaňagyndan, ap-ak ýüzünden
Lagly-merjenleri dökdi-de gitdi.

Goş bilezik hup ýaraşar destinde,
Jellat gözler jan almanyň kastynda,
Aýjemalym akmaýanyň üstünde,
Bir keniz başyny çekdi-de gitdi.

Ýerden, gökden göterlipdir kararym,
Şana alyp, syýa zülpün daranym,
Aýjemalym, ap-ak ýüzli maralym
Gähin-gähin bärsin bakdy-da gitdi.

Jereni bar, owlagy bar çölüniň,
Ördegi bar, gazlary bar kölüniň,
Kemine diýr, sona boýly geliniň
Zarynlap gözýaşyn dökdi-de gitdi.

                26          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Güllere',
    'Huplaryň şiwesi gara göz bolar,
Gör, tomaşa et bilbil bilen güllere;
Gözeliň şiwesi şirin söz bolar,
Sözle, gurban olam şirin dillere!

Al-ýaşyl geýinip, kümüş guranda,
Şitde-şemle inçe bile oranda,
Suw sonasy ýaşylbaşy görende,
Laçyn köňlüm telwas eder köllere.

Aýra düşsem, elip katdym ýaý bolar,
Aýrylmasam, köňlüm ajap jaý bolar,
Gül ýüzüň görmesem, günüm aý bolar,
Aýym uzap gitdi ýyldan-ýyllara.

Kemine, goýmazlar ýar bilen ýary,
Pelekden dat eder geleniň bary,
Meniň dilim, seniň eliň hünäri
Nusga bolup galsyn ilden-illere.

                  27          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Akmeňli',
    'Ataşa — semender, yşga — perwana,
Ýanar men, köýer men günde, Akmeňli;
Her bir sözüň bermen ýüz-müň dessana,
Ýanar men, köýer men günde, Akmeňli!

Sen deýin görmedim ulusda-ilde,
Suraýy gerdende, bykynda, bilde,
Her ýaňagyň her reňde, her hilde,
Husnuň ile şöhle salar, Akmeňli.

Ýol ýöräňde iki goluň tellener,
Ak göwsüň üstünde mämäň ýellener,
Ilki agşamdan ýatjak ýeriň bellener,
Ýatsaň, ýanyň ýere degmez, Akmeňli.

Akmeňli, senden hem bu döwran öter,
Suraý gerdeniňde saçlaryň hatar,
Sypalap goýberseň, sagryňdan öter,
Tursaň, saçyň ýere deger, Akmeňli.

Saýrasa bilbiller, açylsa güller,
Aý geçer, gün geçer, öwrülmez ýyllar,
Huraman boýnuňa öwrülse gollar,
Zerre janda takat galmaz, Akmeňli.

                  28          
Ýüz-müň jilwe bilen kylar sen makam,
Goýnuň pasly-bahar, açykdyr ýakaň,
Ak mämäňe çybyn gonan oglankaň,
Ulalaňda, yzy mälim, Akmeňli.

Kemine diýr, her hil reňkde öwser sen
Kemansyz atar sen, tygsyz keser sen,
Ýalançy bäş gündür, messan basar sen,
Altynjy gün munda goýmaz, Akmeňli.

                 29         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ogulbeg',
    'Zeminiň lälesi, asmanyň aýy,
Dünýäniň göwheri-käni, Ogulbeg;
Gözüm röwşen tapar gördügim saýy,
Aýyň, günüň sen-sen taýy, Ogulbeg.

Bas gadam didäm üstüne,
Ýar basan aýajyklaryňdan,
Goýun sagmaga çykaňda,
Çör basan aýajyklaryňdan,
Aşygyna jilbe berip,
Dar basan aýajyklaryňdan.

Ertir turup, owlak-guza eseder,
Esedende, saç ujusy ses eder,
Her til bilen bir aşygny mes eder,
Dünýäniň göwheri-käni, Ogulbeg.

Bas gadam didäm üstüne,
Deň basan aýajyklaryňdan,
Gum basan aýajyklaryňdan,
Gül basan aýajyklaryňdan,
Bende Keminäniň jany, Ogulbeg.

                     30          
Güli-jennet perizadyň mislidir,
Ary toprak adamzadyň aslydyr,
Gelse ýigitlik ýaz gününiň paslydyr,
Bu dünýäni tutan barmy, Ogulbeg.

Gara-gara gözler bilen gözleşmeşek
                                     oýnagaly,
Şirin-şirin diller bilen sözleşmeşek
                                     oýnagaly,
Aýna kimin ýüzler bilen öpüşmeşek
                                     oýnagaly,
Bende Keminäniň jany, Ogulbeg.

                      31          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ogulmeňli',
    'Gapyl idim, bu gün geldim üstüňe,
Janym paýendazdyr, gyz Ogulmeňli;
Üç gündür, mes bolup, geldim özüme,
Dözebilmen, bagrym gan, Ogulmeňli.

Sözle, perim, sözle, nijeler Perhat,
Köýüňde gezer men dat bilen perýat,
Yklym içre gelmez sen deý perizat,
Yklymyň soltany, han Ogulmeňli.

Sözle, perim, sözle, sözle jahanda,
Mekge, Medinede, Rum-Ispyhanda,
Ogulmeňli atly köpdür jahanda,
Bir senden özgesi san, Ogulmeňli.

Her gören, görmeýen arzuwyň çeker,
Müjgeniň hanjardyr, bagrymny söker,
Elli gyz hyzmatkär, elli bäş nöker.
Ýüz bäşe taý geler, jan Ogulmeňli.

                  32         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Salma gözüňden',
    'Mürçe gözelleri şahandaz bolar,
Aşyklar ýanynda paýendaz bolar,
Bir ýerik kän barsaň, gadyryň az bol
Garry gadyrdany salma gözüňden.

Daýnanyň öňüniň beýik arçasy,
Dökülse dökülsin gülüň gunçasy,
Owarram ýykylsa garry Mürçesi,
Garry gadyrdany salma gözüňden.

Köp ýaşadym diýip, çekmegin arman,
Gara saçyň bolsam agyna gurban,
Çem gelen döwrany golundan bermän,
Garry gadyrdany salma gözüňden.

Kemine diýr, geplesem-de gep bolar,
Geplemesem, haýsy derdim dep bolar
Ýalançyda ýagşy-ýaman köp bolar,
Garry gadyrdany salma gözüňden.

                 33         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gelinler',
    'Hoş gelip siz, hoşluk bilen gider siz,
Dünýäniň seýline gelen gelinler!
Bozulgan şährimi abat eder siz,
Gamda galan köňlüm alan gelinler.

Ak öýüň eýesi, baýyň gyzlary,
Eýýamyň soltany diýrler sizleri,
Hyzmata mynasyp görüň bizleri,
Muhapbat saýasyn salan gelinler,

Äre güftar gerek, gözele — summat,
Her kime ýetdirmez, bahasy gymmat,
Uzyn boýly, giň gujakly, hoş surat,
Hezzeti-hormaty bilen gelinler.

Ak ýüzüne gara zülpün ýaýypdyr,
Göýä aýyň ýüzün bulut alypdyr,
Hassa janym, buşluk, tebip gelipdir!
Derdimiň dermany bolan gelinler.

Bag miwesi bolmaz şirin dil ýaly,
Belli-belli sözüň bardyr bal ýaly,
Kemine diýr, akly-gyzyl gül ýaly,
Aşygyň janyny alan gelinler.

                   34          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Jana söwdügim',
    'Ogryn-ogryn gözleýişiň
Ot saldy jana, söwdügim.
Gara gözli, näzik beden,
Bir bak bu ýana, söwdügim!

Aý jemalyň şöhle salar,
Jellat gözüň janym alar,
Haçan senden mährim ganar?
Gitme daş ýana, söwdügim!

Gamzaň oky bermez aman,
Nurbat, aman, dur bir zaman,
Kirpigi ok, gaşy keman,
Dişi dürdäne söwdügim.

Keminäniň ýok çäresi,
Gözeliň bolmaz harasy,
Uzyn-gysganyň arasy,
Orta miýana söwdügim.

           35            ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Janyň barynda',
    'Bu dünýäde gapyl boldum, oturdym,
Deprenmedim şirin janyň barynda;
Jahanyň gaýgysyn tartyp getirdim,
Dara düşdüm giň jahanyň barynda.

Dostlar bilen bir magrypet açmadym,
Gül ömrümde gül gunçasyn guçmadym,
Näzi-nygmat görüp, iýip-içmedim,
Aşsyz galdym aşyň, nanyň barynda.

Belent ýere çykyp, garandym daşym,
Köňlüm müň paradyr, ýalňyzdyr başym,
Hany meniň jana-janym, ýoldaşym?
Musapyr men Söýünhanyň barynda.

Göge uzatsam, göge elim ýetmeýär,
Ýere baksam, köňlüm karar etmeýär,
Seniň şu dünýäňe mährim gitmeýär,
Gara ýeriň — aždarhanyň barynda.

Garynjanyň öz ornunda sany bar,
Peşe uçsa, ganaty bar, jany bar,
Her öýüň bir adalatly hany bar,
Hansyz galdym begiň, hanyň barynda.

                36         
Bir kem otuz ýyldyr sürüşdim döwran,
Ýar, sensiz gerekmez bu pany jahan!
Kemine — bakardyň tawus dek her ýan,
Indi şatlyk ýokdur dünýe barynda.

                37        ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Baryp-geleniň galar',
    'Saglykda, ýigitler, baryp-gelişiň,
Dünýä öter, baryp-geleniň galar;
Bir dem ganymatdyr oýnap-gülüşiň.
Ahyry aglar sen, güleniň galar.

Pelek çarhyn çeker, öwrüler, tizdir,
Göçülen ýurtdur, ýörülen yzdyr,
Dünýä bir hoş surat owadan gyzdyr,
Gola düşmez, aşyk bolanyň galar.

Kemine diýr, hiç ýok ölmez gümanyň,
Soguryp alarlar emgenen janyň,
Terekä salarlar malu-mekanyň,
Oglan-uşak tamam bolanyň galar.

                 38          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Gezen ýagşydyr',
    'Gulak goýsaň, bu sözüme, adamzat,
Dünýäde bir pasyl gezen ýagşydyr;
Kimge paýan berdi bu çarhy-naşat?
Çem gelen döwrany süren ýagşydyr.

Gyşyk beklär nukrasyna gaş tapsa,
Sygyr çölde gezer, doňuz mäş tasa,
Haýryny gözlemez betden iş tapsa,
Hemmesinden çölde jeren ýagşydyr.

Bende çeker, herne gelse uludan,
Habar sorsaň, jogap bolmaz ölüden.
Azgyrlyp kyçgyran nije weliden,
Azm urup, gaçarak duran ýagşydyr.

Özün besläp, garşy çykar talaba,
Nadan orun tapsa, azar galaba,
Özüni ötgeren loly-jelebe
Bir agyz söz diýmän duran ýagşydyr.

Keşt edip gezer men ilden-illere,
Däli köňlüm talwas eder güllere,
Kemine diýr, nesihatym dullara,
Tiziräk bir äre baran ýagşydyr.

                 39          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garyplyk',
    'Günde müň gussam bar ýüz elem bilen,
Derdimiň baryndan beter garyplyk;
Soragy men boldum gaýgy-gam bilen,
Gelip düşer hatar-hatar garyplyk.

Pany dünýä zynat bilen, harç bilen,
Ýüregim maddadyr, bagrym berç bilen,
Wadasyz şum ölüm bergi-borç bilen,
Ýylba-ýyldan gaýym tutar garyplyk.

Iýmesem, içmesem, mydarym ötmez,
Bürenip ýatmaga kararym ýetmez,
Günde müň kowlasam, baýlara gitmez,
Goş basyp, dulumda ýatar garyplyk.

Tapypdyr her ýerde ýeke-ikini,
Çekipdir biline gaýyş çekini,
Alypdyr eline daşly sokyny,
Ýadaman, depämden urar garyplyk.

Ýylba-ýyldan meniň müflisim çykar,
Garybyň ýüzüne kim gülüp bakar?
Ýaryşsam ýüwrükdir, göreşsem ýykar,
Oýnasam, oýnumda utar garyplyk.

                 40        
Bir sözüm bar, saňa aýdaýyn, Durdyly,
Sakalym gyrawly, murtum burjuly,
On bäş köpek bile, otuz gürjüli,—
Gykuwlap yzymdan ýeter garyplyk.

Seýr etmedim sähralarda, çöllerde
Mestana gezmedim uly illerde,
Bir bilbildim, saýramadym güllerde,
Çag zeýnimi garar-gatar garyplyk.

Kemine diýr, geler bir gün şum olüm,
Kimsäge — toý-baýram, kimsäge — zulum,
Gyýylma, ynjama, sabr eýle, köňlüm!
Gelipdir — bir zaman öter garyplyk.

                 41          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bir tüýsli',
    'Ajap bir janawar, jaýy sürende,
Reňgi gara ýylçyr, tosy bir tüýsli;
Bürgüt dek howadan uçup gelende,
Periniň owazy-sesi bir tüýsli.

Mydam geler yk taýyňdan ys bilen,
Urup kowlamasaň, gitmez ses bilen,
Maslahaty bolmaz ýaru-dos bilen,
Bazarynda basa-basy bir tüýsli.

Nejasatdyr mydam iýýän höregi,
Kellesidir munuň uly ýaragy,
Ys almasa, ömür görmez garagy,
Kebzeden gaýrasy ýasy bir tüýsli.

Nejasatdan paýlap alar paýyny,
Höwründen azaşsa, tapmaz taýyny,
Urşanda goç kimin alar maýyny,
Esirän erkegniň mesi bir tüýsli.

Gözi yzyndadyr ýükli gidende,
Menzili şol ýerdir, özi ýetende.
Dürli nejasatlar bardyr bedende,
Burna golaý gelse, ysy bir tüýsli.

                 42           
Nejasatlar ýygnap hine doldurar,
Az ömrüne kanagatyn aldyrar,
Kim degse, saýyl dek golun galdyrar,
Gargyş etse, bet dogasy bir tüýsli.

Ganaty ýazylmaz nehoş bolanda,
Gözi açyk, armanlydyr ölende,
Gamy ýok harjyny hine salanda,
Ýataşärik bolan dosty bir tüýsli.

Emedekläp, aňmaz kör dek tutany,
Gaýgyrmaz bir-birin gurby ýeteni,
Çukra ýykylyp öler bagty ýatany,
Bolmaz togalagnyň kösi bir tüýsli.

Pirimiz Äraly, düşün bu söze —
Galdyrar aýagyn, pata biýr bize,
«Ylahy, omyn!» diýr, el sürtüp ýüze,
Sanan dogasynyň sesi bir tüýsli.

                 43          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Şahasy beýle',
    'Ylym bir daragtdyr, yslam—saýasy,
Ser çekmiş asmana şahasy beýle;
Imana kuwwat biýr onuň miwesi,
Pula laýyk gelmez, bahasy beýle.

Göz ýumup, açynça haýrul-mursalin,
Magraža ýetirdi Jebraýyl emin,
Dünýä diýip at biýrler, asmanu-zemin,
Şemala gurulmyş, binasy beýle.

Amalsyz mollalar, hökümsiz hatlar,
Yslamyň ýoluna salyp siz otlar,
«Arypulla men» diýr guýruksyz itler,
Gijeler ýatyrmaz — gowgasy beýle.

Ylym eýesi ylymlarna bakmazlar,
Haramdan ellerni hiç wagt çekmezler,
Salgyma çaparlar, haka bakmazlar,
Mollalaryň ynsap-haýasy beýle.

Aksakgal ederler oglan-uşakdan,
Maslahat sorarlar dondan-guşakdan,
Garyp bolsaň, ýagşy görmez eşekden,
Kazylaryň halka yzasy beýle.

                 44         
Aklyňa iş buýur, ejizlik etme,
Iş salyşsaň aždarhadan gaýytma,
Özgeler etse hem, sen özüň etme —
Söz bolar gybatyň enesi beýle.

Haramhor derwüşiň erimez bagry,
Zahyry ryýadyr, batyny — ogry,
Şerigat bir ýoldur, elip dek dogry,
Rast bolmaz Musanyň hasasy beýle.

Üýnün äşgär eden asyýa bolsa,
Özüni bileni rusyýa bolsa,
Peş geýeniň bary öwlüýä bolsa,
Köpelmezdi iliň günäsi beýle.

Ili aldar, batyr barmagyn bala,
Aýalyn okar sen, çermenip bile,
Bu dowzahy bolmaz sormagyň bile,
Işsiziň, elbetde, azasy beýle.

Milleti aldaýar işan-mollalar,
Eçilenne berer hüýr gyz, hülleler,
Hemmesi aňsatdyr gyzan pilleler,
Tutan orazasy, namazy beýle.

Behişdi eýlär sen hüşür alany,
Dowzahy diýer sen dutar çalany,
Bular — toýa, sen gözlär sen öleni,
Pirleriň dünýäde bolasy beýle.

                 45          
Zahyryn düzedip, mekrin hatm edip,
Perişan halyny ilden ketm edip,
Hyzmatyn etmeseň, kapyr hökm edip,
Gargyşdan ýamandyr dogasy beýle.

Kemine diýr, hata işim wapyrdyr,
Bendesi asydyr, özi gapyrdyr,
Musulmana «kapyr» diýen kapyrdyr,
Kapyryň dowzahda jezasy beýle.

               46         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Arzym aýdaýyn',
    'Dostlarym, geldim alysdan, hana
                       arzym aýdaýyn,
Döwleti–sahyp kerem, soltana
                       arzym aýdaýyn,
Gül içinde bir güli-reýhana
                       arzym aýdaýyn,
Peýkeri–sima melek ruhana
                       arzym aýdaýyn,
Köwserim, tuby kadym, ryzwana
                       arzym aýdaýyn.

Leýli hem Mejnun kibi
               çöllerge ugraşdym bu gün,
Wamyku–Uzra bolup,
               köp örtenip-bişdim bu gün,
Warka–Gülşadan beter
               hunabalar içdim bu gün,
Arzy–Ganbar, Zöhre–Tahyr dek
               ýanyp geçdim bu gün,
Çün olaryň yşkyna perwana,
                     arzym aýdaýyn.

                   47         
Aşygy–Perhady gör,
               Şirin zülaly istedi,
Dagy–daşy kül edip,
               zowky-wysaly istedi,
Gurbaty Ýusup–Züleýha
               ömri saly istedi,
Sagdyýu–Seýpelmelek,
               Medhaljemaly istedi,
Janymy gurban edip,
               janana arzym aýdaýyn.

Dawudyň ogly Süleýman
                bir perizady görüp,
Bihasap leşger bilen
                kyrk gije-gündiz ýol ýörip,
Çekdi Bylkysyň pyragyn,
                kähriba dek sargaryp,
Ýedi ýyldan bir gowuşdy
                Şasenem, aşyk Garyp,
Men gowuşmaý galdym,
                ol armana arzym aýdaýyn.

                   48          
Sen uçar sen, men ýorür men,
                sen — perizat, men — beşer,
Salmyşam söwda başymny
                herne gelse haýru-şer,
Geýdi çykdy aly-ýaşyl,
                göýä bir älemgoşar.
Gün gezer gögüň ýüzünde,
                şuglasy ýerge düşer,
Aýa aşyk bolmuşam,
                asmana arzym aýdaýyn.

Dolduryp yşkyň meýinden,
                 berseler tas bile,
Ýedi weli, dört ýaran,
                 ol Hyzyr–Ylýas bir tas bile,
Çagyryp perýat eder men
                 her säher yhlas bile,
Bahry-yşka gir, Kemine,
                 dür talap guwwas bile,
Şamçyrag göwher üçin ummana
                 arzym aýdaýyn.

                    49          ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garyp',
    'Ýalbaryr men «baý aga!» diýp,
               göýä ak mumdan beter,
Baýlaryň basgançagy boldum —
               gysym gumdan beter,
«Ber hakym!» diýp gyssasa,
               çişer otyr humdan beter,
Ogry şum, orramsy şum hem,
               belki, ol şumdan beter,
Bir hudanyň urgany,
               hiç ýerde sansyzdyr garyp.

Ýyl başyndan galla sorap,
                  işi gapy kakmak bolar,
Ýer çilim — ýanýoldaşy,
                  ýanynda bir çakmak bolar,
Tiz çeker gussa bilen,
                  öz gursagyn ýakmak bolar,
Geplese, bolman gepi hem özi
                  bir «akmak» bolar,
Il göçer, galar ýurtda,
                  diri çüýrändir garyp,

                   50          
Baýlar-a behbidin arar,
                  pukara — hupbul-watan,
Gark bolar diýrler şoňa,
                  kim iki gämini tutan,
Göze görnen gyzy bolsa,
                  hantamadyr her ýeten,
Hem garyplykdan Keminäň
                  içleri otly tütün,
Il göçer, galar ýurtda,
                  diri çüýrändir garyp.

                   51         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Içmek',
    'Agşam gelin oturdym, hiç gelmedi ýanyma,
«Ot gerekmi, suw gerek» diýmedi myhmanyna,
Egnime algaşdyrsam, ot goýberdi janyma,
Ýama saýy biri bar, bit bile doly içmek.

Meň köwlän çigildemim Töwrizde kyrkdan aşdy,
Uzyn gije büküşip, aýak kibtimden geçdi,
Eden işim bilmedim, aklym başymdan çaşdy,
Şokurdap, il ürküzer ogşuk bahaly içmek.

Ertir turup seretsem — dag keýginiň sarysy,
Saryna ýagyş degen, hiç galmandyr derisi,
Tüýli ýerinden känräk, tüýsüz ýeri—ýarysy,
Kimden galan ylhanat, ogşuk bahaly içmek.

Içmek, seniň taryhyň kyrk ýamalar görüpdir,
Synyn silkip, toýlarda niçe döwran sürüpdir,
Uk ýaly galdyrsam, «omyn» diýip durupdyr,
Ýel giren ýyrtyklaryň çişläp bogaly, içmek.

Bu-ýa bir şeýle possun, muny alyp saklasaň,
Kän görer sen peýdany, Hywa, Buhar ýükleseň,
Bir azrak kemi bar, guşuň dersin bekleseň,
Kimden galan şylha sen, şeýle «mazaly» içmek.

                     52          
Nuhuň gämisin tartan babamyza satandyr,
Ýel-ýagmyryň astynda ýetmiş ýyllap ýatandyr.
Alakadan, garsakdan çala başyn çatandyr,
Şondan galan ylhanat, ogşuk bahaly içmek.

Bu possuna taý ýokdur, barsaň yrak zemine,
Akmaklykda ýapynyp, düşdüň bitiň demine,
Bit-büräniň öýüdir, barma munuň çemine
Kimden galan şylha sen, şeýle «mazaly» içmek.

Kemine diýr, daň atar, alla maňa ýar bolsa,
Özge çatma gerekmez, pakyr çatma bar bolsa,
Içmek, seniň daşyňda iller hyrydar bolsa,
Il ýygnanyp, nyrh kesse — erkek bahaly içmek.

                     53         ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Örtär meni',
    'Eý, perim, salsaň nazar,
                 ýalkym düşer didaryňa.
Gözleýip göz gyýgy birle
                 bakyşyň örtär meni;
Beslenip öýden çykar sen,
                 sallanyp her bir ýaňa.
Bat alyp, misli jeren dek
                 böküşiň örter meni.

Dakynyp tylla, kümüş,
                billeriňe şitde orap,
Som daraýy parladyp,
                çyksaň başa şahy büräp,
Uz ýöräp, seýkin basyp, boýnuň burup,
                her ýan garap,
Sallanyp ulgam bilen,
                gyz çykyşyň örtär meni.

Simu-zerden bezenip,
                 gül ýüzüňe çalsaň gülap,
Ser salyp, çoh aýlanyp,
                 hiç tapmadym senden hylap,

                  54         
Belli bizni ýakmak üçin
                 zülpleriňi sypalap,
Iki bölüp, al ýaňakdan
                 doküşiň örtär meni.

Ýara «ýar!» diýp, waspyňy her dem ki
                çoh salsam tile,
Tolganyp, şugla jemalyň
                geçse ol gunça güle,
Bu saraýlar köşgi içre
                goşulyp hüýrler bile,
Süzülip humaý kibi,
                gaş kakyşyň örtär meni.

Tarypyňy sözlesem men, eý,
                ajap näzik nahal,
Egniňe dürli geýip,
                köňlümge çoh saldyň hyýal,
Sallanyp seýle çykaňda,
                zülplere degse şemal,
Diýr Kemine, müşku-anbar
                kokuşyň örtär meni.

                  55          
                 —
«» sahypasynyň kitaphanasy.
                 —',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
