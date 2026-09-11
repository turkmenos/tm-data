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
VALUES ('AnnaSoltan Kekilowa')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @poet_id = (
    SELECT id
    FROM poets
    WHERE name = 'AnnaSoltan Kekilowa'
    LIMIT 1
);


INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Biz ýöräp barýarys',
    'Ýöräp barýas. Ýöräp barýas ikimiz,
Şagalaňly giň şähere syn edip.
Sen maňa bakaňda meň ýaş ýüregim,
Uçjak bolýar, al-asmana meýil edip.

Sen maňa bakaňda meň ýaş ýüregim,
Ganat kakýar ymaratlaň üstünde.
Sen maňa bakaňda meň ýaş ýüregim,
Ýüzüp ýördi goja Kaspiň üstünde.

Arzuwlarym pel-pelläp ýör gözlegde,
Görmek isläp täze-täze ýerleri.
Ah, doganlar, maňa belli bolsady,
Nätanyşlaň ýüreklerniň syrlary.

Biz ýöräp barýarys öýmüze sary,
Sen maňa gür berýäň jandan syzdyryp.
Hä bersem-de, göwnüm daglar başynda,
Ylham joşýar gyzyl ganym gyzdyryp.

Eger-de ylhama boýun egmeseň,
Aýlar bilen ýyllar menden öýkelär.
Eger-de ylhama boýun egmeseň,
Ýollar bilen iller menden öýkelär.

Biz öýmüze ýetdik. Düşdi garaňky,
Sen ýatyrsyň gülli ýorgan bürenip.
«Rahat ýat!» diýp, dileg edýär hüwdüläp,
Daşardaky belent çynar yranyp.

               18                     
Meni bolsa ylham saldy duzaga,
Men göwrämi seň ýanyňa taşladym.
Kalbym joşup, uzaklardan uzaga, —
Giň jahana seýil etmäge başladym.

Aýlanyp ümmülmez giden sährany,
Bagra basdym uç-gyraksyz düzleri.
Gözel-gözel şäherlerden göründi,
Uklap ýatan adamlaryň ýüzleri.

Gara baglar süýji uka batypdyr,
Eşdilenok bilbilleriň nagmasy.
Hüwdüleýär şagalaňly şäheri,
Şahyr ýüregimiň şowhunly sesi.

Ana, birden gündogardan gyzaran,
Ýalyn ýaly bolup şapak göründi.
Eý, ylhamym, ýyldyrym dek çalasyn,
Kalbymy ýaryma eltiber indi.

Aýlansam-da ylham bilen seýil edip,
Görülmedik täze-täze ýerleri.
Ýok, ýok! Enteklerem belli däl maňa,
Nätanyşlaň ýüreklerniň syrlary!..

Goşgy ýazdym, uzak gije ýatmadym,
Kalbym hemra boldy uzak ýollara.
Oýlanýaryn ünji edip bir zady,
«Ýazan goşgym ýararmyka illere?»

Ine, şeýdip, ir ertir hem giç agşam,
Poeziýa deňzinde dem alýaryn men.
Seni ýalňyz goýýan, nädeýin ýarym?
Ozalda näme üçin meni söýdüň sen?

               19                      
Daňam atdy. Horazlaram gygyrdy,
Gizlendi asmanda iň soňky ýyldyz.
Essalawmaleýkim, eziz adamlar!
Ir bilen sag-aman turduňyzmy siz?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýadygär galsyn',
    'Serediň, adamlar, sözleýär asman,
Sözleýär seslenip mawy bulutlar.
Serediň, serediň, baksaňyz her ýan,
Sözleýär seslenip bägüller, otlar.

Derýalar möwç urýar, deňizler joşýar,
Tolkunýar ol, mawy asman tolkunýar.
Tolkuna ýyldyzlaň suraty düşýär,
Serediň dostlarym, güneş galkynýar!

Toplanyşyp kökden uçýar durnalar,
Saýraýar serçemen baglaň guşlary.
Ganatlaryn gerip geçýär durnalar,
Seslenýär daglaryň belent başlary.

Bat bilen silkinip sözleýär Watan,
Näletläp ol elhenç atom bombasyn.
Ynsanlara gülüp gözleýär Watan,
«Eşitmek islämok» diýp, bombalaň sesin.

Gaýtalaýar muny enem — mähriban,
Gaýtalar çagalar dürli dillerde.
Atom bilen ýandyrylsa bu jahan,
Aýdyň ahyr, mekan tutjak nirede?

               20                     
Goý, güneş parlasyn, tebigat gülsün,
Ynsanlaň öňünde çöksün ol dyza.
Biziň döwrümizden ýadygär galsyn,
Päk parahat asman nesillermize!

               21                      ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Arzuwlarym',
    'Men rahat ýatyryn şirin ukuda,
Durmuş hüwdüleýär sallançagynda.
Meniň bilen arzuw ýatyr ukuda,
Duýgularmy gizläp giň gujagynda.

Käte öpýär, käte bagryna basýar,
Arzuwlam gijeler oýnap meň bilen.
Gudratlar baş egip, şemal öwüsýär,
Ana, şonda ýola düşýäs daň bilen,

Kalbymda bir owaz barha ýaňlanyp,
Şirin mukamyna bent etdi meni.
Arzuw bilen şol mukama diň salyp,
Geçirýäris ýol üstünde her güni.

Arzuwlar, arzuwlar, baky ýoldaşym,
Men siz bilen döredýärin, gurýaryn.
Umytlaryň gaýnap çykýan gözbaşy
Menzillerden — menzillere barýaryn.

                22                    ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Göçüp gitdik',
    'Göçüp gitdik ýanyňyzdan, ezizim,
Gül açanda bagyňyzyň almasy.
Göçüp gitdik ýanyňyzdan, ezizim,
Eşdilende bilbilleriň nagmasy.

Altyn ýaprak şahalarda seslenip,
Güýz gelende gelerin men beslenip.
Galdyr ýüzüň, gara gaşyň göreýin,
Çygly gülden çemen sowgat bereýin.

Gapyňyza gezdiremde gözümi,
Gol bulady howlyňyzyň üzümi.
Penjireden gördüm gülli keçäňiz..
«Ýaryň seni söýýär» diýdi köçäňiz.

Pyntyk açyp obamyzyň tutlary,
Ülpüldeşip suwly ýabyň otlary,
Öwsünişip şemal bilen bileje:
«Ýaryň seni söýýär» diýdi çalaja.

Kemerli dag seredip dur, gol bulap,
Gel-gel, oglan, ýere bakma öýkeläp.
Ugrat, ýarym, lälezardan ýöräli,
Gelerin men garalanda garaly.

             ***
Dostlar, birwagtlar jahyldyk bizem,
Göz astyndan syn ederdik gyzlara.
Taban murtlarmyzy şemala tutup,
Durmuşyň akyşyn almazdyk sere.

               23                     
Ýetginjekdik, bar küýümiz okuwdy,
Daşymyzdan guwanardy eneler.
Çärýeklerde ýaryşardyk, bäsdeşdik,
Dokuzynjy «a»-lar, onunjy «b»-ler.

Klaslarmyz bir-birine goňşudy,
Üýşüşerdik zalda jaňyň sesine.
Biz jedel ederdik oglanlar bolup,
Sapak başlar, gijä galardyk ýene.

Söýülsek-de, käýelsek-de o ýyllar,
Günsaýyn ösýärdik şatlykdan ýaýnap.
Biz gedemsijedik öz ýanymyzdan,
Boýny monjuklyja gyzlary saýlap.

Sapak gutarardy, gapyň agzynda,
Syrlyja ýylgyrşyp garaşýardyk kän.
Ine, şeýdip söýüpdik biz gyzlary,
Ýöne gyzlar bizi söýdülermikän?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Biz olary gözläris',
    'Iňrik garalanda daş çykdy aýal,
Oýlandy, köp dymdy, gör, näme hakda?
Kölgeli bulutlar elhenç ses edip,
Paralandy birden elhenç ses edip.

Ýok, şonda-da tisginmedi ol aýal,
Diňe dymmak bilen gynady jany.
Umytly gözlerin alysa dikip,
Synlady gaýtadan gözel asmany.

               24                    
Goý, ýyldyrym çaksyn, bolsun harasat,
Bu ýolda hiç tupan gorkuzmaz ony.
Gözlär ol ömürlik umytly gözler,
Urşa giden äri bilen ogluny.

Ol günleri, heý, unudyp, bolarmy,
Biz niçik gyşlapdyk ýyly gyşlary?
Nirä ýitrim boldy, gizlendi nirde,
Kyrk ikinji bahar, kyrk ikinji ýyl,
Ýetginjek ýigitleň ýylgyryşlary?

«Ýene-de şol hakda, uruş barada,
Ýatlamany bes ederis, belki, biz».
Men köplerden eşidipdim bu sözi,
Diýdiler: «Gozgamaň ýaralarmyzy».

Bu dogry. Biz gördük ol hakykaty,
Gerdende göterdik urşuň özüni.
Soň ekranda hem romanda, goşguda,
Irmän ýatlaýarys ol gaýly güni.

Belki, indi ýatlamany bes edip,
Sözlemmize goýarys biz nokady.
Ýöne bu nokatlar köpeler, lowlar,
Ýanar-da ýatladar ol hakykaty.

Goý, bu mukaddeslik ynsan ýüregne,
Ebedilik aýdym bolup ýazylsyn.
Öleňleň gaýraty diriler üçin,
Watan goragynda görelde bolsun!

                25                    
            ***
Gör, iller birýana howlugyp barýar,
Kim dostunyň, kim ýarynyň ýanyna.
Maňa bolsa garaşýan ýok dünýäde,
Şonda-da ýol söküp barýaryn öňe.

Diňe hol öňümde garantga deýin,
Hemra bolup barýar ýalňyz maksadym.
Diýýär ol: «Şol belent daglara çykyp,
Bu jahana göz ýetirip baksadym».',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Myrat bilen Gülälek',
    'Ýoluň öwrüminde dur äpet gaýa,
Göýä dünýämize bergili ýalak.
Iri harplar bilen ýylçyr göwsüne,
Ýazylypdyr «Myrat bilen Gülälek».

Adatdaky ýaly gündi ol günem,
Dünýe parahatdy, durudy asman.
Göýä gözellige gark bolan ýaly,
Durdy şu gaýada iki ýaş juwan.

Ah, olaň arzuwy niçiksi giňdi...
Ýigit başarmandy pikirin jemläp.
Diňe şeý diýipdi, gysgajyk sözde,
Gyzyň ýogyn saçlaryny gysymlap:

               26                     
    — Sen meňki bolarsyň...
                         Toýumyz bolar,
    Bu gözleri öperin men ömürlik.
    Bize sowgat galar ajap ýyllardan,
    Eşretli ýaşaýyş hem mydam birlik.

    Şonda gyz gülküsi daglara dolup,
    Batly ýaňlanypdy jadyly ýalak.
    Hawa, şol gün ýazylypdy bu ýazgam:
    Iri harplar — «Myrat bilen Gülälek».

    Olaryň duýgusy gözeldi şeýle,
    Durmuş!
    Romantika!
    Gaýgy-gam ýatdy,
    Aýralyk diýen zat ýatlanylmazdy.
    Ol söz söýülmeýän, elhenç bir zatdy.

    Emma olar duşuşmandy şondan soň,
    Ýigit urşa gitdi, aýralyk geldi.
    Diňe ýylçyr goja gaýaň ýüzünde,
    Umytly ýazylan ýazgylar galdy.

    Ýoluň öwrüminde dur äpet gaýa,
    Delminip birine garaşýan ýalak.
    Iri harplar bilen ýylçyr göwsünde,
    Ýazylypdyr «Myrat bilen Gülälek».',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Meniň göreçlemde kakam ýaşaýar',
    'Ol ýatyr. Ýan berip krowatynda,
    Onuň agras başy ýerden galanok.
    Lenç bolan ökjeler, ysgynsyz dyzlar,
    Ýöremek isleýär, ýöräp bilenok.

                   27                      
Ynjalyk tapmaýar şirin janyna,
Ýassygyn gujaklap agýar-da, dönýär.
Göýä oň göwnüne ýelek düşekçe,
Synanyň astynda göwreýär, ýanýar.

Elinde granat, bagryn ýere oýkap,
Gar üstünde süýşüp barýar ol ýene.
Bombalar ýarylyp, titreýär zemin.
Ýalaňaç döşlerde gülleler gyzyp,
Sanaýar ençeler iň soňky demin.

Käsi arkan, käsi ýüzin ýykylşyp,
Ýatyr ine, ene süýdün emenler.
Merdemsi kükregin al-gana boýap,
«Watan!» diýip gözün baky ýumanlar.

Eňräp ak bulutlar, garalýar asman,
Bagry bilen süýşüp barýar ol ýene.
Gam çekýär sähralar, aglaýar düzler:
«Adam ajal zyňýar adam üstüne.

Barýaryn ýanyna, sypaýan başyn, diýýän:
«Çaý demledim, tursana kaka!»
Kakam ses berenok, titreýär kakam,
Ýetişiň, adamlar, bu niçik waka?

Çykyp barýar göreçleri hanadan,
Bedeni gögerýär, ýüzi gögerýär.
Bilmen, ol näme üçin soňky deminde:
— Öňe! Öňe! Öňe! — diýip gygyrýar.

Olar ýola düşdi, barýarlar, ana...
Eginlerde atam bilen merdiwan.
Merdiwany alyp barýar gerçekler,
Biliň, meniň ömrüm size bendiwan.

               28                      
Göz öňümden ýitip barýar tabydyň,
«Eý, atam jan, gidip barýaň gelmeze!»
Iki ýoluň çatrygynda aljyrap,
Ine, men şeý diýip, çökmerin dyza...

Gözleriňi göreçlemde saklaryn,
Seň gözleriň küýsäp maňa seretsin.
Köp ýerde yz goýan agyr täleýiň,
Goý, rehimsiz ýüreklerem eretsin.

Habar berer göreçlerim görene,
Şol gaýly ýyllarda synaň owulşyn.
Synaň azar çekip krowatyňda
Damarlaň dartylyp käte düwülşin.

Men seni ýatlaryn, seni küýsärin,
Atam, bagtym üçin saňa minnetdar.
Aglamaň, jigilem, rahatlan, enem,
Meniň göreçlemde kakam ýaşaýar.

Güne öwşün atýan kümüş ýapraklar,
Hoşlaşmady, eziz atam, seň bilen.
«Ol adam guşlaryň ganatynda» diýp,
Saýrady bilbiller ala-daň bilen.

Sen entek-entekler ýaşamalysyň,
Öňde galdy ýaşamaly ýyllaryň.
Deňiz kenarynda, daglaň gerşinde,
Öçmändir henizem aýak yzlaryň.

Aýak yzlaryňy ýelden goraýar,
Patrak dek açylan erkin almalar.
Ýyllar gaýyp bolup geçip gitse-de,
Kökünde saklajak adyňy olar.

               29                    
Ýatlaýar dünýämiz, seni ýatlaýar,
Köne dörän, täze dörän şäherler.
Gyrmyzy gülünde adyň nagyşlap,
Ýatlaýar şol ýyllar, ala-baharlar.

Ýöne boşap galdy biziň dulumyz,
Men agyr oýlanyp, atyrdym daňy.
Şol säherde dünýä inen nesiller,
Dakynýarlar seniň eziz adyňy.

               30                    ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Iň ýakyn dostuma',
    'Bu gije nämüçin ýatyp bilemok,
Oýlanyp geçirýän uzak gijäni.
Syrly garaýşyňam maňa düşnüksiz,
Ýa galdyran bolaýmaýyn bijämi?

Daş çykýaryn haraý isläp asmandan,
Şemal alyp gidýär gursakdan gamy.
Eşdilýär gulagma ýeriň üstünden,
Uzakda ýaňlanýan dostlaň aýdymy.

Näçe diňlesem-de bu adamlary,
Seň syrly garaýşyň çykanok ýatdan.
Gursagyňda gor hem bolsa, ezizim,
Guý gujagma, heder etme hiç zatdan!

Guý gujagma, juwan göwün syrdaşym,
Düşün ahyr, geçip barýar ömrümiz.
Ýürekde syr gizläp birek-birekden,
Unudýas ajaýyp ýaşamany biz.

             31                    
Şoň üçin gijeler ýatyp bilemok,
Jahanda bar zatdan basylýar sustum.
Kyn bolýar ýaşama ýagty dünýäde,
Senden syr gizlese iň ýakyn dostuň.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Näme üçin?',
    'Ol kimden nägile? Alyp bukjasyn
Ýazdy epinlerin toý köýneginiň.
Başyn aşak salyp, gamlandy birden,
Diýdi: «Sen nirede, ýaşlygym meniň?»

Bu şeýle bolupdy: ýetişipdi ol,
Ýatlady gyz juwanlynyň geljegin.
Akyl goýalmandy, şonda-da päkdi,
Kim bilýär geljegniň näme boljagyn?

Solupdy ýürekde güllän söýgüsi,
Rehimsizlik bilen taşlanypdy ol.
Kalbyndaky söýgi zäherlense-de,
Duýgular diýdiler gyza: «Belent bol!»

Başarypdy giň hem belent bolmagy,
Gynasa-da solan söýgüsi ony.
Ne gözel gijeler geçenin ýatlap,
Az däldi ahmyrly geçiren güni.

Öldi söýgi. Ýandy söýgi, kül boldy.
Ýatlamalar ýaşaýar ol ýürekde.
Hawa, şol gözel gyz garrady bu gün,
Ahmyrly, şol köýen söýgüsi hakda.

              32                      
  Belki, ol ömründe köp şatlyk görüp,
  Başarandyr ýene-de bir söýmäni.
  Bilemok onçasyn, bilýärin şuny:
  Ilkinji söýgi üçin köp çekdi gamy.

  Käte şeýle bolýar. Ilçilik ahyr.
  Ýöne diýmäň muňa: «Pelek gerdişi».
  Aýdyň siz, nämüçin ol gözel gyzyň
  Toý köýnegin ýazyp, aglap oturşy?',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Adamlar ölmeýärler',
    'Ýyldyzlaň emeli giňeýär birden,
Bu meniň düýşümmi ýa-da hyýalym.
Adamlaň ýüregem giňeýärmikän?
Kimden sorasamkam düşmeýän dilim.

Adam gussa çekýär, daralýar dünýä,
Bulutlaň içinde Aý tutýar ýasy.
Bu şahyranalyk ýerliklimikän,
Niçikkä adamlaň içki dünýäsi.

Her kimiň özüniň aladasy bar,
Kim öňe ymtylýar, kim bolsa yza.
Adam kalbyndaky sansyz ýyldyzlar,
Gizlin dogup ýaşýar, görünmän göze.

Niçik çylşyrymly, uzak bu ýollar,
Ýollara maksatsyz ugramak bormy?
Adam aglamasa adam derdine,
Tebigat biz üçin çekermi gamy?

                33                      ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Näbelli mazarlar',
    'Ýatyr ol gijeleň sustlugyn diňläp,
Ýatlaýar gündizler nesillerini.
Eşretiň, durmuşyň aşygy bolup,
Baky gujaklapdyr ene ýerini.

Biziň planetada ýalňyz mazarlar,
Petir deýin örtüpdirler ýerleri.
Seçilýär üstüne älemgoşar dek,
Altyn pasyllaryň elwan zerleri.

Säginýän bir sellem ýeňsämi gaşap,
Soň baş egýän bu näbelli mazara.
Baş egýän jesediň adamlygy üçin,
Hawa, şeýle edýäs biz şu gün ara.

Nesilleň aýdymyn, ädimin diňläp,
Olar üçin baky ýatmak gylykdyr.
Näbelli mazarlaň barlygy bolsa,
Diriler siz üçin masgaralykdyr.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Enemiň oýlanmasy',
    'Penjireden Gün gyzaryp göründi,
Meň enem gorkuly tisgindi ýene.
Uzakdan gelýärdi awtomat sesi,
Urulýan dek taýly gezek maňlaýna.

Dymýar enem häzir, edil şu pursat,
Uzak ýollaň kültemini çözleýär.
Kowalanan jeren ýaly daljygyp,
Bagtymyzyň aýnasyny gözleýär.

               34                    
Bagtymyzyň aýnasyny gözleýär.
Yraň atýar sallançagyň hallany.
Başyn ýaýkap, ýakasyna tüýkürip,
Ol henizem ýatlap otyr allany.

Basgylaýar, gahar bilen zäheri,
Datmalymy ajy bilen süýjüni!
Enemiz biz üçin, hawa, biz üçin,
Ol köp ýerde synap gördi güýjüni.

Ol biz üçin sarp edipdi güýjüni,
Barmaklary bolsa ýaryk-ýarykdy.
Şol barmaklar bilen sypanda ýeri,
Ýygyrtlaň ýüzünden deri syrykdy,

Otyr enem ýatlamalar içinde,
Ýatlaýa gijäni-gijä ulaşyp,
Ol ýyllar...
Şol ýyllar...
Gazaply ýyllar...
Agyr daşy aýlap arpa üweşin.
Ajyndan surnugan çagajyklarna,
Şu gara gazanda guýmak bulaşyn.

              35                    ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Seniň suratyň',
    'Goşgy Beýik Watançylyk urşy ýyllarynda äri
         wepat bolan aýalyň dilinden ýazyldy.

Demli çaýy agdarýaryn, goýýaryn,
Göreçlem küýseýär seniň syratyň,
Gözüň gyýa bakyp, gaşlaň ýaýylyp,
Diwarymdan asylgy dur suratyň.
Uludan dem alýan, birden-de dymýan,
Göýä meň kükregim ýelleň mekany.
Diwarymdan asylgy dur suratyň,
Seniň keşbiň aýlaň, ýyllaň mekany.
Demli çaýy agdarýaryn men ýene,
Ýürek derdin dökýän ýaly hamala.
Birden kalbym gurşap sansyz arzuwlar,
Birden bolsa gaýyp gidýär şemala.
Demli çaýy agdarýaryn men ýene,
Göreçlem küýseýär seniň syratyň.
Gözüň gyýa bakyp, gaşlaň ýaýylyp,
Diwarymdan asylgy dur suratyň.

              36                    
Howandar çagama, howandar maňa,
Indi ýigrimi ýyldyr jansyz suratyň.
Gundagdaky oguljygyň ulaldy,
Aýak bitdi. «Kaka!» diýip dil açdy.
Gapymyzda ekip giden erigiň,
Boýun alyp, her baharda gül açdy.
Şuwlaýar şemala eken erigiň,
Nirde sen söýgülim, nirde geregim,
Nirede eý gören gözlerim meniň?
Demli çaýy agdarýaryn men ýene,
Gözlerim küýseýär gara gözleriň,
Gürsüldäp ýüregme urulýan ýaly,
Her äden ädimiň, aýak yzlaryň.
Diwarymdan asylgy dur suratyň.
Giň maňlaýda ýaýylypdyr gaşlaryň.
Sen diýip agardy meniň başymda,
Gulaçlap sypalan gara saçlarym.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Perzent',
    'Oglum Ýagmyra bagyşlaýaryn.

Owadan-la bu jaý!
Gözel-le bu jaý!
Bu jaý hormat bilen
Söýgüden doly
Munda ogul bolýar,
Gyz dünýä inýär.
Bu jaý geljek nesliň
Simwoly ýaly,
Akuşerka daýza,
Meniň çagamy
Getirsene bäri,
Göremok häli.

                37                    
Getirdiňmi? Sag bol,
Mähriban daýza.
Hany, meniň gujagyma bersene
Tolgunýar ýüregim,
Joşýar ýüregim,
Oň gürsüldäp urşuny bir görsene!
Salam!
Dünýä inen ýaşajyk çaga!
Enelik borjuny bagş etdiň maňa.
Ýagşy küýseýşi dek
Ene topragyň
Küýsäpdim...
Küýsedim,
Şonuň üçinem
Ýagmyr diýen ady dakýaryn saňa.
Enelik borjuny ederin berjaý —
Ýelden, ykdan gorap saklaryn seni,
Göwsümde ulalyp, kemala gelseň.
Kaýyl çykyp, begendirseň sen meni,
Şonda-da ýatlaryn bu gözel jaýy,
Seni söýüşim dek söýerin muny.
Açyk bolsun baky,
Ýaşasyn baky
Çagalaryň dünýä inýän mesgeni?

            ***
   Söýemok men bu jahanda,
   Ýaraňjaklap gün görmäni.
   Ýagşy görýän beýle günden,
   Öz ajalma jan bermäni.

               38                    
     Niçik bolar şemal ýaly,
     Çar tarapa öwsüp dursam?
     Ýan bermeli bolar onda,
     Garşymda gaý, tupan görsem.

     Dönmerin öz pikirimden,
     Atsalar-da ýanar oda.
     Ömrüm boýy hyzmat etjek.
     «Ynsan» diýlen belent ada!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garşylaň gyzlary',
    'Owadan siz, gyzlar, gözel siz, gyzlar,
Siz gülleň eýesi, guşlaň eýesi.
Hüşermäň oglanlar, göriplik etmäň,
Gözellik gyzlaryň baky mirasy.

Görýäs biz olary uly ýollarda,
Görýäris zawodlaň gyzgyn sehinde.
Görýäris asmanda, görýäris suwda,
Şadyýan gözlerin gyzlaň her günde.
Gyzlar baş darýarlar aýnaň öňünde.
Gün äpet göwresin sallanda ýere.
Goý, olar beslensin, goý, beslenmesin.
Deňemäň görklerin göwhere-zere.

Gün gizlenýär äpet gomlaň teýinde,
Barýar gyzlar köçelerden howlugyp.
Baýyrlaň üstümi, köprüleň gerşi,
Parhy ýok, oglanlar garşylaň gülüp.
Garşylaň siz syr saklamaň ýürekde.
Boluň siz näzijek gyzlaň eýesi.
Düşüniň, oglanlar, aýaň gyzlary,
Gözellik gyzlaryň baky mirasy.

                 39                      
            ***
         «Yşk derdin assalar gögüň boýnundan,
         gök titreýip çekebilmez bu derdi.»
                                          Magtymguly

Agaçlara gyraw sepip gijeler,
Şuwlaýar daşarda ýanwar şemaly.
Ümürleň içinde mawy ýyldyzlar,
Görünýär meň tukat ýüregim ýaly.
Men bu tukat gijä, bu ümsümlige,
Aslynda näm üçin boldum hyrydar?
Kalbynda gyş deýin doňan söýgüniň,
Barlygyna, bilmedim, kim günäkär?
Kim günäkär? Şol söýülen gözlermi?
Ýok, ol gözler maňa gülüp bakmandy.
Lälezar baharda golumdan tutup,
Ýigit meniň bilen seýle çykmandy.
Söýdüm men şonda-da,
Gaýybana söýdüm.
Söýdüm ol oglanyň görmek-görküni.
Wah, dagy nädeýin, gussa çeksem-de,
Bir şoňa baglapdyr ýürek örküni.
Näçe wagt geçdi ony söýenme,
Näçe ýagyş ýagdy, näçe gar ýagdy,
Bu ajap dünýäden ýüzüni gizläp,
Söýgi gursagymda Gün bolup dogdy.
Men duýdum söýgimi, syzdym söýgimi,
Syzdym oň ajaýyp gazaldygyny.
Şygyrlaň lezzeti şirin bolsa-da,
Görmedim söýginiň gözelligini.

              40                    
Gar gaýmalap penjiräniň öňünde,
Şuwlaýar daşarda ýanwar şemaly,
Meň söýgim ýürekde tukat dem alýar,
Gar bürän ýalaňaç agaçlar ýaly.
Men bu tukat gijä, bu ümsümlige,
Aslynda nämüçin boldum hyrydar?
Geçýär günler, emma meniň kalbymda,
Açylmadyk, eçilmedik söýgi bar!

             ***
Altyn ýüzük, gymmat baha sagady,
Nämüçin harç edip alýarsyň maňa?
Ýanymda ýantazy-selpäp ýörşüňe,
Men gahar edýärin şeýle bir saňa!
Irginsiz soraglaň lapym keç edip,
Atylan daş deýin ýüregme düşýär.
Ýatlamok. Bolan zat bolup geçipdir.
Bolgusyz sowgatdan çeke men, hüşgär.
Sil dek şaglap geçen juwan ýaşlygym,
Ýatlamak islänok hiç zat sen hakda.
Bar bilýänim diňe ýaşalan ýyllar,
Näletleýän seni biwepalykda!

               41                  ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Söýgi hakynda oýlanma',
    'Ýüregim erkime ýöretseň höküm,
Meň ony söýmäge barmyka hakym?
Sözle bu sowala jogap berjek kim?
Ýok, ýürek ýalňyşýaň sen az salym dym.
Pikirlen-de daş çyk,
Seret asmana.
Geňeş sal gudratly gara daglara,
Ýüzlen bu güneşe,
Ýüzlen äleme,
Dyza çök,
Alnyň goý mukaddes ýere!
Şonda-da hiç kimden tapmasaň jogap,
Ölçer-de syryň dök giň sähralara.
Göwnüne gelenin sözlesin her kim,
Ýürek, saňa boýun egermi erkim?
Bolsaň-da bu näzik synaň geregi,
Bolsaň-da bu gan damarmyň diregi,
Heý-de ýürek häkimligini çekermi,
Erke bekän şahyr gyzyň kükregi?

               42                   
Özüň görýäň,
Dogup-ýaşyp dur günler,
Ýaşaýar dünýäde juwan göwünler.
Dymanok bu günler,
Dymanok aýlar.

Dymanok gijeler,
Dymanok ýyllar.
Olar maňlaýmyzda gasyn atyp dur.
Duýanok, ýaşaýar juwan göwünler.
Daglar bar dünýäde belentden-belent,
Baglar bar dünýäde gözelden-gözel.
Ýollar bar dünýäde uzakdan-uzak,
Ýollar bar dünýäde inçeden-inçe.
Şu ýollardan ýöräp barýar adamlar,
Şu ýollardan döräp barýar adamlar.
Eşretli bu durmuş,
Bu durmuş gözel.
Durmuş, seniň üçin ýazmaly gazal.
Gijeler oturyp pikir etmeli,
Men entek-entekler köpe ýetmeli.
Ýüregim, erkime ýöretseň höküm,
Meň ony söýmäge barmyka hakym?
Ol gowy adam söýülmäge mynasyp,
Görk berýär ýüzüne saçlarnyň agy.
Ol saçlar meň üçin,
Hawa, meň üçin,
Tälim berip duran durmuş sapagy.
Aýtsyn erkim pikirlerniň baryny
Söýýän bolma, ýürek, özgäň ýaryny?
Sözle, ýürek, sözle.
Saňa garaşýan!

Sen özgäň ýaryna göwün bermersiň,
Şeýle ham-hyýala ulaşan bolsaň,
Nirde ursaňam gursagymda urmarsyň.

               43                  
Bolsaň-da bu näzik synaň geregi,
Bolsaň-da bu gan damaryň diregi.
Heý-de ýürek häkimligi çekermi,
Erke bekän şahyranyň kükregi?
Gijeler otyryp pikir etmeli,
Men entek-entekler köpe ýetmeli.

Düşün, bu sözlere,
Edemok oýun.
Bolmaly bolarsyň,
Erkime boýun!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dostluk aýdymy',
    'Howada gaýmalaýar ýeňiljek gar,
Sowukdan gyzdyrar ýaňaklarymyz.
Men barýan seň bilen, eziz dostum,
Dostlugmyz ýylydar ýüreklerimiz.

Gyş geçer, ýaz geler, garlar erär,
Gök öwsüp gül açar ýeriň ýüzi.
Dostlugymyz nur saçar kalbymyzda,
Göýä gök asmanyň ak ýyldyzy.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýaňlan aýdymym',
    'Ýap boýuna gülüp baran badyma,
Ýene gözel ýarym düşdi ýadyma.
Ýaprak ýolup atdym suwuň ýüzüne
Ýetsin diýip söýgülimiň özüne.

                44                   
 Ýaprak gaýyp gitdi suwuň ýüzünden,
 Şol suwuň ýüzünden, ýaryň yzyndan.
 Ýuwaşjadan aýdym aýtdym diň salyp,
 Ýarym geler aýdymyma diň salyp,

 Ýaňlan sen, aýdymym, ýar gulagynda,
 Oýar ony, birden uklap galmasyn.
 Akar bilen ýara ýollan ýapragym,
 Suw ýüzünden özge penje almasyn.

    Bu söýgi däl, jenaýat
Dursuň sen ýaýdanyp köçäň ugrunda,
Seredýäň tiz-tizden el sagadyňa.
Säginýäň kä öňe, kä yza ýöräp,
Sabyrsyz garaşýaň wagta hem oňa.

Gelýär gyz ýanyňa, gelýär ýylgyryp.
Syzýaň bu pursatlaň täk hezilligin.
Bahar gunçasy dek dünýäni bezýän,
Nowjuwan gözeliň päk gözelligin.

Näçe Ninalara, näçe Güllere,
Sen näçe köçede gülüp gözlediň.
Ýürekdäki elhenç nejis syrlary,
Şol gülkiň astynda bukduň, gizlediň.

Bu gün seň aýalyň şol gyzlaň biri,
Ýatyrsyň gujaklap tämiz düşekde.
Sypaýaň bedenin, öpýäň saçlaryn,
Gör, aýal söýmäge sen niçik ökde!

                 45                    
Ine-de, sen dursuň aýalyň bile,
Gelip sud öňünde bozýaň nikany.
Erkeklik adyna ysnat getirip,
Bu ajap dünýäni saýýarsyň pany.

Penjireden asman gümmezne gözläp,
Ýaşajyk çagaňyz gülüp dur, ine.
Enäň gözlerine elhenç bolsaň-da,
Özgeleň gözüne sada sen ýene.

Barýarsyň köneden agras ädimläp,
Çykýarlar öňüňden tanyşlaň bary.
Diýýärsiň: «Aýrylyşmak jenaýat iş däl».
Säginip halyňy soraýsa biri.

Hemmeleň ýüzüne bakýarsyň hyýrsyz,
Adamlardan gören ýaly hyýanat.
Gatyrganma, aýdylanda dogrusy,
Seniň söýgiň söýgi däl-de, jenaýat!

               ***
Meniň tanyşlarmyň köpüsi şahyr,
Bilýän, olar örän oňat ýigitler.
Penjirä söýenip garaşýaryn kän,
Açýaryn gözlerim, öňümde ekran,
Gel-de seret dostum, geçip barýarlar,
Şol meniň tanaýan tanyşlam olar.

Sen seret, men bolsa pikir edeýin,
Bir zatlar gynaýar kalbymyň öýün.
Belki muňa düşünýändir ýigitler,
Togalak kellämi gudratlar gaplap,
Damýar maňlaýymdan burçak-burçak der.

                 46                     
Damýar maňlaýymdan burçak-burçak der,
Dolýar sabyr käsäm, elenýär ýürek.
Köpden bäri garaşýaryn men oňa,
Hawa, garaşmanam başarmak gerek.

Gapdalymda ses çykanok, hiç zat ýok,
Gerdenimden basýan ýaly agyr ýük.
Ýatyr, ine, eginlermi ýassanyp,
Adama syr bermän elhenç ümsümlik.

Aljyrýan-da birden ýeňsäme bakýan,
Ine, gözüm düşýär türkmen iline.
Ýene köne umyt dogup gursakda,
Garaşýan «Şol ajap aýdymlaryny,
Göterip Pyragy geler» diýip ýene.

Pyragy gelmeýär, emma aýdymy,
Diňleýärin, eşdilip dur her öýden.
Bilýärin men. Ölmez asla, ol adam,
Garyba: «Aglama, şir sen» diýp aýdan.

Bu hut şeýle boldy. Şol döwür geldi,
Garyp aglamady. Garyp şir boldy.
Ah, ol niçik adam, ajaýyp adam,
Geljegiň syrlaryn döwründe bildi.

Şonuň üçin garaşýaryn men oňa,
Görmek isleýärin Magtymgulyny.
Atom asyrynda, hut öz döwrümde,
Poeziýa älemniň parlak gülüni.

Bilemok men. Haçan görüner ol gün?
Otyryn garaşyp, görerin ony.
Pikirlenmek hezil, garaşmak hezil,
Bir gün beýhuş eder ol gül-de meni.

                 47                     
Ynanýaryn meňem ýaşan döwrümde,
Hatardaky şahyrlaryň sany kän.
Ýa olaram öz ýanyndan meň ýaly,
Başga bir şahyra garaşýamykan?

      Türkmen oglany
Garaňkylyk sowlup gitdi bireýýäm,
Parlak gün lowurdap şöhlesin saçdy.
Kanalmyzyň köprüsiniň üstünden,
Kombinzonly türkmen oglany geçdi.

Güldürip owadan goýun gözlerin,
Daş köprüden bäri bakan pillesi.
Ol gözler şeýle bir jadylap meni,
Dikildi ýüregime yşkyň güllesi.

Töwerege aralaşyp ümsümlik,
Bulutlar seýl etdi mawy asmanda,
Ýüregimi ýesir edip ýüregne,
Özüm gitdim, ýürek galdy şol ýanda.

           Zenanlar
  Ýaňlandyryp ähli ülke, ýurtlary
  Hüwdüleýär balasyn biziň eneler.
  Eneleň aýdymnyň mukaddesligin,
  Gör, bar zatdan beter syzýar Ene ýer.

                48                    
Dem alýar dynçlykda
                     şeýle bir ümsüm,
Asyrlar zenanlaň yzlaryn yzlap,
Gaýgysyn, şatlygyn
                   Jadyly daş dek,
Şol aýal goýupdyr —
                 Göwsünde gizläp.

Geçýär günler,
              Gelýär täze nesiller,
Nesilleň bagty üçin ýaşaýar olar.
Äleme söýgini indereni üçin,
Biziň enelermiz ajaýypdyrlar.

Olaň ýürekleri duran bir dünýä,
Olaň göreçleri ylham meň üçin.
Beýik Magtymgulyň aýdany ýaly,
Olarsyz ömri-de pikir etmek kyn.

Olaň mertliginden jedel etsem-de,
Hiç haçan utanyp galmaryn gamda.
Zenanlar adyňyz belentlik bilen
Gaýtalanar durar meniň ýadymda.

       Üç gün bäri...
Üç gün bäri ýagyş ýagýar daşarda,
Penjirämden günem şöhle salanok.
Üç gün bäri seretsem-de ýollara,
Meň ýanyma gözel ýarym gelenok.

Oňa näm bolduka? Niredekä ol,
Öz ýanyndan meni ýatlaýarmyka?
Gaýgysyn, şatlygyn paýlaşar ýaly,
Syr alyp, syr berýän dosty barmyka?

               49                     
Mensiz gör, niçiksi gezýärkä ýalňyz,
Gijelerem oýlanýaryn şo hakda.
Ýaryň ady,
Arzuwlary,
Söýgüsi...
Üç gün bäri gaýtalanýar ýürekde.

Ine, ertir diňer irizen ýagyş,
Ýene penjirämden gün şöhle salar.
Ýöne menden göwni kineli ýarym,
Bilemok, dostlarym, gör haçan geler.

             ***
  Ol tomus günlerniň ak gijeleri
  Bize giňden gujagyny geripdi.
  Juwan gyzkam saçlarymy sypalap,
  Bu aýdymy ýarym aýdyp beripdi.

  Bu aýdymy ýarym aýdyp beripdi:
  «Gülüm, sensiz dünýä maňa dar» diýip,
  Bu aýdymy ýarym aýdyp beripdi:
  «Gözelim, gözleňde gudrat bar» diýip.

  Söýülýän gözeldim, begenýärdim men,
  Gyz üçin ajapdyr ýaşamak söýüp,
  Ah, ol günler pikir etjek zadymmy,
  Bu günki ýaňlanan ýaryň aýdymy,
  Bir wagt ýüregmi zäherlär diýip,

  Juwan ömrümiziň ajap ýyllary
  Biziň ýadymyzdan çykanok hergiz.
  Ah, gözeller, käte şeýle aýdymlaň,
  Mylaýymlygyna aldanýarys biz.

               50                      
Soň bolsa kyn düşýär söýen ýürege
Ölçerip dökäýmek kalbynyň derdin.
Ýene-de şu aýdym uzak wagtlap,
Ýaňlanyp dur maňa ak gijelerden.

Ol geçen tomuslaň ak gijeleri
Bize giňden gujagyny geripdi.
Juwan gyzkam saçlarymy sypalap,
Bu aýdymy ýarym aýdyp beripdi.

            51                    
  Magtymgula ýüzlenme
Köp zady yzarlap, tapmamsoň hiç zat,
Ýer tapamok boşap galan kalbyma.
Eý, siz asmandaky seýrek bulutlar,
Nämüçindir meňzeýäňiz siz maňa.

Geň däl maňa siziň seýrekligiňiz,
Geň däl maňa bilbilleriň owazam.
Tanyş ak gijeler, aýdyň ýyldyzlar,
Ir-iýmişli güýzem, gunçaly ýazam.

Diňe geň zat, al asmandan bürgütleň
Bulutlary böwsüp, atylyp barşy.
Alyslarda galdyrany bar ýaly,
Olar pel-pelleýär gör, nirä garşy.

Bilmän, bu durmuşda aljyran wagtym,
Beýik şahyr, bakmaň siz bir kembaha.
Aýdyň maňa bürgütleriň ugruny,
Olar uçma barýarmy ýa dowzaha?

                 52                    
Alysdaky ýarym hakda aýdymlar
   Ýarym maňa akja ýaglyk hödürläp:
   — Al öýmäňi atynma – diýip ýalbarma.
   Gyzyl, ýaşyl ketenimi söýmeseň,
   Özümi-de «söýýän» diýip gül berme!

   Bu öýmäniň güllerini höwesläp,
   Göwnüm isläp saýlap-saýlap aldym men.
   Pyragynyň, Ferdöwsiniň, Haýýamyň,
   Mekanyndan — Gündogardan geldim men.

   Bu öýmämi pasyrdadyp başymda,
   Köpetdagda garşyladym ýazy men.
   Durna gözli çeşmelerden suwlanyp,
   Obada boý alan ahal gyzy men.

   Çagajykkam aýajyklam ýalaňaç,
   Kän ylgardym baýyrlaryň üstünde.
   Adam hakda, asman hakda, dag hakda
   Aýdym aýdyp, şu öýmäniň astynda.

   Güýz gelende al öýmäme syn edip,
   Gök asmandan ak durnalar ötendir.
   Bu öýmäniň aşagynda gizlenip,
   Aýdylmadyk aýdym bary ýatandyr.

   Şoň üçinem talap edip bar zady,
   Birden göz gyzdyrma, ýarym, erkime.
   Sessiz-üýnsüz bagra basar bagtyny,
   Şeýle öýme nesip etse her kime.

                  53                     
              ***
Süýr günortan gün depämde gyzanda,
Alyslardan saýa salma sen maňa.
Aýralyk gussasyn guýma ýüregme,
Gel şat aýdym aýdyp bereýin saňa.

Sypalaýyn gursagymda yralap,
Garşyňda oturyp, läle kakaýyn.
Kalbymdaky gyzgyn Garagum ýaly,
Syrlarymy seň üstüňe dökeýin.

Gel indi, men garaşmakdan ýadadym,
Ynamlamam dönüp barýar hyýala,
Gara saçym ýaýyp dogduk obamda,
Her gün seni ýatlap, seredýän ýola.

Emma sen geleňok, ak köýnek geýip,
Emma, sen geleňok gara kostýumly.
Soň men aýdym aýdýan ýene sen hakda,
Gözlerim söýgüli, ýüregim gamly.

Ýa sen alyslarda uka batdyňmy,
Meniň aýdan aýdymlarma diň salyp,
Ýa sen her gün säher oýanan wagtyň,
Penjiräňden örýänmi men gün bolup.

Ýa seniň gursagyň söýgüden sowap,
Gözleriňden söýgi nury öçdümi.
Ýa başga bir gözel ajap ýylgyryp,
Saňa söýgiň täze älemin açdymy.

                54                    
Owadan gyz
 Galdyr başyň,
 Owadan gyz,
 Iller ap-ak
 Ýüzüň görsün,
 Göreçleňden
 Lezzet alyp,
 Gökde guşlar
 Ganat gersin.
 Aý-Gün saňa
 Nazar salyp,
 Gözelligne
 Başyn egsin.

 Galdyr başyň,
 Galdyr başyň,
 Goý, görünsin
 Ak ýaňaklar
 Seň görküňden,
 Goý uýalsyn
 Ýaz açylan
 Gülälekler.
 Gözelligňe
 Bäsdeş bolup,
 Goý, seretsin
 Joralaryň.

 Utanma-da,
 Owadan gyz,
 Bak jahana,
 Göter seriň.
 Müň näz bilen
 Oýna, jora,
 Näz ýaraşýar
 Sen dek gyza.

      55          
              Gözelligňi
              Paýla, jora,
              Gysganma-da
              Dünýämize.

Ajaýyp aýdymlar juwandyr mydam
   Bu niçik şowsuzlyk?
   Bu niçik habar?..
   Ýok, ynanmaýaryn eşdenlerme men.
   Güýz güni —
   Gijara.
         Gyzgyn gor deýin,
   Basyldyň kükregme,
                      Ah, şum habar sen.

   Mejalym çatmady gygyrmaga-da,
   Dymmakdanam ejiz gelýär ýüregim.
   Göýä harasat dek, inip depämden,
   Uzatdy gap-gara ellerin ölüm.

                 ***
   Sen hakda hiç kime aýtmadym hiç zat,
   Gizledim syrymy soranlardanam,
   Ol geçen baharyň süýji günlerin,
   Ezizim, gaýtadan ýatlaýan ýenem.

   Guşlar bolsa uçup barýar ugruna,
   Kä ýere golaýlap, kä göge salyp.
   Gynanýaryn, menem galan ömrümde
   Söhbet açmajagma, saňa duş gelip.

                   56                     
Şonda-da seýil edýän guşlara meňzäp.
Keşt edip ýörün men bu ene ýeri.
Ýüregim özünde göterýär baky
Sen hakda ajaýyp ýatlamalary.

              ***
Bir damjajyk bulutlardan bölünip,
Gözýaş deýin gaçdy ýeriň üstüne.
Gara gözlerňe-de bakmaryn gizlin.
Ýürek seni küýsäp, aglaýar ýene.

Aglaýar ol: — Ýalňyzlygyň hasratyn
Diýýär — Indi paýlaşaýyn kim bilen?
Hany öňki günler?! Süýji arzuwlar?
Ýa olar düýş deýin, boldumy ýalan?

Bilýän, indi görüşmeris ikimiz,
Gara gözlerňe-de bakmaryn gizlin.
Ah, dostum, gözleriň baky ýumulşyn
Ýatlamak meň üçin, gör niçiksi kyn.

              ***
  Çagam uklap ýatyr. Bu ümsüm gije
  Urýar penjireden güýzüň şemaly.
  Saralan ýapraklaň şowhunyn diňläp,
  Men welin ýatamok, ýatamok häli.

  Köýýär süýji uky göreçlerimde,
  Umytlyk älemne gark bolýar göwün.
  Nädeýin men, tanyş ýüzleň içinden
  Bir ýakyn dostumy ýitirdim bu gün.

                 57                    
 Agaçlaram aýdym aýdýar şo hakda,
 Şemalyň ugruna yrap başyny.
 Diýýär olar: — Dostuň hatyrasyna
 Görmedik gyz, seň gözüňde ýaşyňy.

 Ynanyň, agaçlar, ol dostum üçin
 Kalbymdaky söýgä, bolmasa-da çäk,
 Men onuň ajaýyp gözelligini
 Ejizläp gözýaşa ýuwjak bolamok.

 Ertir daň agaryp, görünende gün,
 Çagam oýanar-da, gujaklar meni.
 Şonda oňa aýtmaly men dostumyň,
 Soňlanmadyk ömri hakda aýdymy.

 Meniň şonda aýtjak aýdymlarymda
 Bolmaly däl, gaýgy-hasrat, gam-gussa.
 Ol aýdym dostumyň ölümin däl-de,
 Diriligin wasp etmeli iki esse.

              ***
Dostum, bir wagtlar, entek çagakam,
Men aýdym aýdypdym wasp edip seni.
Ýalňyşypdym deňäp äpet daglara,
Seň sada ýüregiň belentligini.

Ýok, bu diňe ýalňyşlygam däl eken,
Bu bir çagalygmyň ejizligi eken.
Soň, men ýetişemsoň, ak saç eneleň,
Göremde maňlaýnyň gasynlaryny.

Şol çaga aýdymnyň ejizliginiň,
Kemter manysyna düşünipdim men.

                58                    
Günäli bolsam-da seniň öňüňde.
Şol aýdan aýdymmyň kemterligi üçin.
Bilýän indi, dostum, saňa mynasyp,
Ajap aýdym döredäýmek juda kyn.

Ýaz bu hakda iň bolmanda bir setir.
Indi janym, maňa sütem etme sen.
Gyzdyraýyn synaň sowanam bolsa,
Söýgi hakda ýazan aýdymlam bilen.

              ***
Tüm gijelik, meňzäp gara saçlarma,
Daglaň depesinden gerdi ganatyn.
Syryp gitdi gök asmanyň göwsünden
Ak ýyldyzlaň lowurdaşýan zynatyn.

Gök gürledi sarsyp bu äpet zemin,
Gapymyza ak jöwenek döküldi.
Seni ýatlap, alysdaky söýgülim,
Uzyn gije gözlerme çiş kakyldy.

Tümlükde daş çykyp, ýoluňa bakdym
Seniň gyzgyn mähriň ýadyma düşüp.
Mähir nire, ýar nirede tümlükde,
Gözden doly ýagýar, jahan gamaşyp.

Görünenok goňşy-golam, öýlerem.
Görünenok ala daglaň garasy.
Ýeri onsoň, seni nirden tapaýyn,
Arada ýatyrka Jeýhun derýasy?!

                59                    
               ***
Men köp daglar hakda gürrüň edemok,
Bu gezek wasp edýän Köpetdagymy.
Eneden dogamda, başga daglar däl,
Bilýän,
Eşidipdi diňe şu daglar,
Ilkinji,
Päkize,
Çaga agymy...

Indi men ýetişip, syn edýän bu gün.
Türkmen daglarynyň gözelligine.
Göwnüme bu daglar eýlenen ýaly
Aý şöhlesi bilen jöwzaly güne.

Hanha, güne ýanan guraksy daşlar
Keserlişip dem alýarlar belentde,
Ol ýerde bir wagt gurap gidipdir
Ýabany güljagaz,
Ýabany ot-da.

Aşakda çeşme bar,
Bilbil bar,
Gül bar.
Aşakda boý alýar müň dürli agaç.
Bu ajap gözellik,
Arman...
Etekde
Daglaň gerşi belent,
Başy ýalaňaç.

                 60                   
Ýalaňaç — diýip,
Gyýa bakyp geçäýmek
Aňsat däldir,
Daglar köpi ýatladýar.
Kä ýyldyrym çakyp,
Turanda tupan,
Ýylçyr gaýalaryň güýçli ýel öper.
Şuwlar...
Mukam dörär gaýalarynda,
Daglaň gudratyny duýarsyň şonda.

Etekde ýene-de çeşmeler joşýar,
Etekde al ýaňak almalar bişer.
Sen lezzet alarsyň görüp daşyndan,
Görersiň, gözellik döränligini
Şu gojaman daglaň ýylçyr başyndan.
Nem bolsa asmandan seýrek düşýändir,
Şonda-da daglarda gujur, güýç kändir.
Belentdir,
Mertdir,
Ýylçyrdyr başy,
Emma eteginde gül açar bagy,
Seredip otursaň, şundadyr asyl,
Bäbekkäm agymy diňlän daglaryň
Meniň üçin eziz, aýratynlygy.

            Gargalar
 Asmanda çaknyşyp sowuk bulutlar,
 Güýçli ýel sygyryp, gar köwsarlaýar.
 Meň kalbymda bolsa uçgun tutaşyp,
 Ýanyp duran küre ýaly lowlaýar.

                 61                     
Azaşýan ýol tapman doňak tokaýda,
Dodaklarym kepäp,
Ýalaýan gary.
Ýüregim gananok,
Ýene men teşne.
Gaýyp ýör depämde, gara gargalar,
Soraýan olardan:
— Nirede çeşme?!

Gargalar gygyrýar:
«Gak, gak-da, gak-gak».
Göwnüme bolmasa, diýýärler olar,
«Gözleme gyz, bu tokaýda çeşme ýok».

Onda men nätmeli,
Nirä gitmeli?!
Gargalar, tokaýdan
Ugradyň meni.

Gargalar gygyrýar ýene-de: — gak-gak! —
Belki diýýändirler:
— Ugratmarys, ýok.
Ah, bular göwnüme
Gury hyýaldyr.
Ol gargalar meni,
Görýänem däldir.

Sowuk ýel şuwlady,
Gargalaň sesi,
Bu uly tokaýda birhili, tukat.
Küýsäp, dury çeşmäň sowuk suwuny,
Ýene meň kalbymda lowlaýar şol ot.

               62                    
Daň agardy, ýatdy uly harasat,
Menem çykdym dury çeşmäň ýoluna.
Ýöne henizlerem ýatlap gynanýan —
Düşünemok gargalaryň diline.

              63                    
Biziň gapymyzdan daglar görünýär
   Biziň gapymyzdan daglar görünýär,
   Şol daglaň hem öz ýüregniň dagy bar.
   Çabgalar jar ýasan dereleriniň
   Almaly, injirli gözel bagy bar.

   Ugramakçy bolsam alys illere,
   Şu daglardan pata alýan hoşlaşyp.
   Galýar daglar meniň dogduk ilimde,
   Asmandaky bulutlara baş goşup.

   Galýar daglar, galýar äpet bürgütler,
   Gidýärin, alyslar garşylar meni.
   Ýene daglar göz öňümde janlanýar,
   Ýatlamda enemiň aýdymlaryny.

   «Bu daglaň gerşine näçe guş gondy,
   Bu daglardan uçup gitdi näçe guş.
   Näçe gezek bu daglarda buz doňup,
   Näçe gezek ýuwdy gerşini ýagyş.

                    64                     
Öpdükä gör, näçe ynsan aýagyn,
Bu daglaň göwsünde uzaýan ýollar?
Näçe gezek açyldyka gunçalap,
Sürçek gaýalarda ýylgyrýan güller».

Gaýtalap enemiň şu aýdymlaryn,
Bir wagtlar meňem ýumular gözüm.
Şonda daglar pata berer hoşlaşyp,
Asmandaky bulutlara baş goşup.

Biziň gapymyzdan daglar görünýär,
Şol daglaň hem öz ýüregniň dagy bar.
Kä egninde paralanyp bulutlaň,
Däli derelerniň joşýan çagy bar.

      Meniň topragym
Indim men duýdansyz bu uly dünýä;
Döwrüň aladalaryndan habarsyz.
Guşlaň owazyna meňzeş agyny,
Diňleýär meň bilen biziň asyrmyz.

Asyrmyz diňleýär.
                  Emma meň üçin
Bu pursat jedelem, pikirlerem ýat.
Uklap ýatyr, çal dumana bürenip,
Geljekki ýaşaýyş,
                 geljekki şöhrat...

Bar zat öňde —
            Salgymlaryň içinde,
Gara daglar deýin ýatyr garalyp,
Soň daglara tarap bir ädim ädip,
Ömri dowam edýän, ölüp-direlip.

                 65                    
Tapylýan özüme kybapdaş dost, ýar.
Synlaýan hezil edip aýdyň gözleri,
Bir jahyl ýigit dek,
                   Ene topragym,
Gyzgyn gujagynda göterýär meni.

Topragmyň üstünde
Bulutlary synlap, ylgaýan her ýan.
Ýagşylygy aýap göreçlerimde,
Döwrüme ýüzlenýän, döwrüme garýan.

Döwür maňa aýdyň jogap berenok,
Ýene sorag, ýene batýaryn gama.
Agyr oýlar, bir yzgytsyz adam dek,
Urýar ýumrugyny zenan maňlaýma.

Şonda-da ruhum bu urgulardan,
Ak kepderiler dek, belende gaýýar.
Men dogduk topragym meniň kalbymy,
Bir jahyl ýigit dek ýyladýar, çoýýar.

             Alada
  Şat aýdymlar aladasyz döränok,
  Dünýäň özi durşy bilen alada.
  Aladalar bizi käte gagşadyp,
  Aladalar bizi kä atýar oda.

  Sähramyzyň gülälegne çalym edip,
  Asyrlaň ýüzünem bezýär alada.
  Aladalar bürgüt kimin uçup ýör,
  Ene zemin bilen asman arada.

               66                    
   Tupan tursa gyzgyn Garagummyzda,
   Aladasyz äpet gomlar göçenok,
   Gaçanda-da, kowanda-da alada,
   Aý ýyllaram aladasyz geçenok.

   Çabga ýagmazdan öň düzleriň ýüzün,
   Tutýar çal duman dek agras alada.
   Çabga gelýär, älemgoşar lowurdap,
   Sähramyzda nurun saçýar ýene-de.

   Aladalar döredýärkä şatlygy,
   Biziň bilen hemra bolsun ol mydam.
   Atlanalyň alakalaň gerşine,
   Aşagynda galmalyň biz aladaň.

               ***
Hiç haçan men seniň duşmanyň däldim,
Batga bolup garalmandym öňüňde.
Onda nämüçin sen bukdaklap ýörsüň,
Köýüp giden aryň bar ýaly mende.

Ne-hä sen bir penje urýaň ýeňsämden,
Ne-de aýdyp bilýäň ötgür sözüňi.
Oýunjak gurjaklaň açaryn towlap,
Perdäň aňyrsyndan dikýäň gözüňi.

Soň gurjaklar maňa oýun görkezip
Seň sözüň gaýtalap azar berýärler.
Towy gutaransoň jansyz şeýtanlar,
Ýene seniň huzuryňa barýarlar.

                  67                    
Men ýatdan çykarman gurjaklaň oýnun,
Men seniň kölgäňem çykarman ýatdan.
Kölgeler gurjaklar bilen garpyşyp,
Iripdirin ýöne ownuk azapdan.

Eger-de meň boljak bolsa duşmanym,
Aždarha dek, belent bolsun dünýäde.
Kül üstünde oturandan bimaza,
Gowudyr özüňi oklanyň oda.

              ***
 Gelme meň ýanyma, saklan şol ýerde,
 Butnama, butnama, duran ýeriňden.
 Näme diýjek nirä barýaň diýseler,
 Birden nätanyşlar çykyp öňüňden.

 Meň ýanan ýüregim salgy berjekmi,
 Ýa-da, görkezjekmi solan ýüzümi.
 Ýa-da söhbet açyp namartlygyňdan,
 Nätanyşa tanatjakmy özüňi.

 ...Isläniň et —
 Ýöne meniň öýüme,
 Uzýan ýollaň bary ýapyk seň üçin.
 Göreňokmy goýup giden günäňi,
 Zenan gerdenlemde götermek ne kyn.

 Goý, kyn bolsa bolsun meniň özüme,
 Ýöne meň oduma köýmesin özge.
 Ajal ysy gelýär gara kölgäňden,
 Görünme,
 Görünme meniň gözüme.

                 68                    
              ***
Söýgülim, reňkiň agarypdyr seň,
Gowuşgynsyz sandyrap dur ellerňem.
Gara bulut ýaly haýsy asmandan,
Seň ýüregňe aralaşdy gaýgy-gam.

Hany seniň öňki gujur-gaýratyň,
Hany? —
Nirä uçgun ýaly syçrady.
Sözle ýogsam gözleriňden aňmadym,
Juwan başyň haýsy derde uçrady.

Geç düşege, dynç al, düýş gör-de oýan,
Turýançaň ýanyňda hemraň bolaýyn.
Sen gam çekýän bolsaň ýagşylyk üçin,
Onda gussaň ýarsyn bölüp alaýyn.

Diňe aýt sen maňa, aýt sen, dogrusyn,
Näm bolanam bolsa, ýalan sözleme.
Biz alys ýollary bilen gitmeli,
Şoň üçin, sen syryň menden gizleme.

              ***
Jahanda paýhasly iň gözel oglan,
Gel, dünýäň gapysyn aç sen öňümde!
Men aýak ýalaňaç zemini söküp,
Göterdim hasraty bu gerdenimde.

Ýollarda ýadawlyk kalbymy gurşap,
Aýagma dolaşdy açylan güller.
Daşbasma ýazgy dek meň görejimde
Galdy duýgudaşlyk eden göwünler.

                 69                      
Biljek bolup dünýämiziň syryny
Halys meniň öňki süňňüm owuldy.
Kä öňümde aç möjekler uwlasa,
Kä elimden gaçyp käsäm döwüldi.

Alaňdan alaňa, belentden pese
Ylgap köp zadymy döwdüm, ýitirdim,
Ýöne welin moý atdyrman hiç ýerde,
Umydymy huzuryňa getirdim.

Doňan derýalardan taýyp geçdim men,
Gördüm daglaň gar örtülen gerşini.
Aç dünýäň gapysyn paýhasly oglan,
Diňläýin oň ýüreginiň urşuny.

    Elweraň aýdymlary
 Bir zatlar gynaýar meniň ýüregmi,
 Hiç gelip bilemok belli karara.
 Kalbymda lowlaýan düşnüksiz ýalyn
 Aýlaýar ýaş başym biderek ýere.

 Kesek bolsa çar tarapdan ýagyp dur,
 Ýa-da bular görünýärmi gözüme.
 Ah, gardaşym, hopugýaryn gijeler.
 Göz ýetirip bilmän özüm-özüme.

 Aklym diýýär maňa: — Samsyjak gözel,
 Gör ömrüňden hoşal ahyr Aý-Günem.
 Kaýyl bol-da bu durmuşyň emrine,
 Boluşyna görä ýaşaber senem.

                70                     
Ýürek diýýär: — Bolmasady hyjuwlar,
Onda kyn düşmezdi beýdip gün görmek.
Bolmaz ahyr hak aýdymlaň deregne
Agzyňa gelenin şagladyp ýörmek.

Ine, şeýdip aklym bilen ýüregim
Aýra düşüp barýar biri-birinden.
Ajal bolsa somlap elhenç penjesin,
Jan gardaşym, elin üzenok menden!

Kesek diýseň çar tarapdan ýagyp dur,
Ýa-da bular görünýärmi gözüme.
Kimkäm men?
Nämekä isleýän zadym,
Düşünip bilemok özüm-özüme.

              ***
Ol gün ýel ösdümi ýa-da gar ýagdy,
Kim maňa at goýdy, kim pata berdi.
Gadyrsyz perzendi bagyşlap dünýä,
Bilmen haýsy ene meni dogurdy.

Bulary bilmäkäm ýetişdim dogan,
Soň çaga bolýarmyň...
                      Gelensoň ýaşlyk,
Ozal näme gördüm?
                     Görjegim näme?!
Bu pikirler, gör, nähili bulaşyk.

Ýadymda gazaply Ýanwar gijesi,
Meni lenç edeni penjesin gerip,
Soň men öldürildim...
                   ...Ölüp ýaşadym,
Ýaşlygmyň adyna ysnat getirip.

                 71                      
Ýok aýdyp biljek däl, mundan artykmaç,
Söhbet açyp, geçmiş hakda aýdymy,
Ýa bu damardaky ýaşlygyň gany,
Joşgun bilen gaýnamasyn goýdumy?!

Maýsa kösüklände gülli sährada,
Günden sorasynlar meniň derdimi.
Haýsy ýerde, nirelerde bolsam-da,
Ruhum bilen söýýändirin ýurdumy.

         Biz gyrnak
Biz gyrnak,
Bilýäris
         gyrnaklygmyzy,
Şoň üçin dört ýere bölýäs ýüregmiz.
Ine, ýüregmiziň bir böleginde
Gussaly ýaşlygmyz hem ajal ýatyr.
Gün gerekmi?! –
Tümlük?
Isläniň saýla!
Çözmesi kyn.
Elhenç...
Şu jedel ýatyr.

Ýüregimiziň beýleki bir bölegi
Eýlenipdir sowuk garaýyşlara.
Zynjyrsyz baglanan
El-aýaklarmyz –
              Ýan bermelimişin,
                               Gara gyşlara.

               72                     
Üçünji bölegi ýüreklermiziň
Tutuşlygna eýlenipdir hyjuwa.
Bu ýerde ýigrenç bar gyrnaklygmyza,
«Baky» berilipmi gyrnaklyk bize?!

Ine ýüregmiziň soňky bölegi,
Bu ýerde näm bolýar?! —
Semiz jenaplar...
Dar kabinetlerde möhür basýarlar,
Basgylap,
Iň oňat aýdymlarmyza
Gyrnaklygmyz bilen,
Baha kesýärler.

Olar baha kesýär enelerine,
Olar baha kesýär ene ýerine,
Olar baha kesýär öz-özlerine
Olar möhür basýar öz ýüzlerine.

Biziň ýüreklermiz bitewilikde
Ýene aýdym aýdýar gyrnaklyk hakda.
Müňläp kemsidilýän ykballarymyz
Asyrlardan galan sowgatmy ýere.

Gyrnak ýüreklermiz ýaşamalymy,
Meňzäp asmandaky ýedigenlere.
Gan algysy barmy, asyrlaň bizden,
Biz şuny soraýas ogullarmyzdan?!

             ***
Giň asmana ak bulutlar düşelip,
Durnalaň hatary gizlenýär gökde.
Gör, kimler bu pursat ýeriň üstünde
Ajap düýş görýärler geljegi hakda.

               73                     
Adamlar, belent siz. Bilýärin muny,
Ýöne siziň garaýşyňyz dogrumy?!
Ene ýatlanylsa, söýülse Watan,
Aýal gyrnak bolup, çekermi gamy.

Är ýigitler heý-de ýaşap bilermi,
Taşlap gam deňzine naçar uýasyn?
Aýdyň, ak bulutlar, Elwera gyza,
«Biz gyrnaklar» diýip, ol aglamasyn.

      Jonuň arzuwy
Jon mele saçlyja namysjaň oglan,
Ol kiçijik, emma belent hyýaly.
Ädim ädip Amerikanyň göwsünde,
Nýu-Ýorkdan syryp barýar şa ýoly.

Gidip barýar, giň äleme göz aýlap,
Ýagşyny, ýamany saýgarýar akly.
Barýar arzuwlarny ýele güjeňläp,
Ýüregi aýdymly, arkasy ýükli.

Zähmet hopba bolup onuň egnine,
Işleýär, ýük çekýär, gidýänçä eňki.
Şol halda-da, ynam edip bar zada
Uklaýar.
Düýş görýär.
             Gözellik oňky.
Kepderlerem oňky,
                   Güllerem oňky.

Alaç ýok. Dünýäniň gurluşy şeýle
Bar durmuşa her kimiň öz hyýaly.
Kim watanyn söýýär, söýýär bilbili,
Kim bolsa jan berýär gujaklap puly.

               74                      
Jon millioner bolmak arzuw etmeýär,
Ol aýdymçy boljak.
                  Söýýär owazy.
Bulutlaň kerwenem, onuň göwnüne,
Çalyp dur, çaknyşyp,
                   ajap bir kazy.

Hiç kim oň arzuwna etmeýär paýhas,
Geçýär jentelmenler ýüz öwrüp göge.
Ümsüm gije, Nýu-Ýorkuň göwsünde,
Arzuwyn wasp edýär bir ejiz çaga.

              75                  
       Gyzyň päkligi
Sen gör, kime gulluk edip ýaşaýaň?
Erkinlik gerekmi?
                Maksadyň näme?
Ýadaw gözleriňi asmana dikip,
Garaňky köçede uklaýaň ýene.

Bah, sen kime gerek
                    Sen kime gerek,
Durmuşa söýgiň bar,
                    Başyň bolsa ýaş.
Şonda-da basgylap aladalary,
Geçirýäň günleri yranyp serhoş.

Sen hiç kime namysyňy satmadyň,
Muny päklik hasapladyň özüňe.
Wyždan kemsidilýän şeýle mekanda
Gör, näme getirdi bu päklik saňa.

               76                      
Giň dünýäde nägile sen bar zatdan,
Bir hossarsyz naçar köçede galan.
Şol belent päkligiň tukat gijeler.
Hasrat çekip aglaýar gyz sen bilen.

             ***
Güwleýärdi deňiz, gopgunly gije
Tolkunlaň üstünden ösüp batly ýel.
Senem ýele meňzäp, wagşylyk bilen
Kakdyň meň gapymy nirden tapyp ýol!

Diýdiň: — Mümkinmi, gyz, seniň ýanyňa,
Wah, gülüm, nämüçin otyrsyň ýalňyz?
Gel, bu uzak ýoluň hatyrasyna
Adama bir bulgur götereli biz! —

«Adama bir bulgur götereli biz»,
Ýaňlandy daşarda gyryksy sesiň.
Sowgat üçin doldurypsyň gujagňa,
Gruzinleň çakyryn, gyzyl almasyn.

Öýe saldym, garşyladym men seni,
Atalaryň nakyllaryn edip ýat.
Diýerdiler: «Myhman ataňdan uly».
Myhmanlygyň üçin boldum örän şat.

Oturdyk biz bir stoluň başynda,
Sen serhoş bolýançaň al şerap içdiň.
Soň eziz dostlarmyň gybatyn edip,
Ýary gijä çenli ýüregme düşdüň.

                77                     
Bu häsiýetiňmidi, ýanyma gelip,
Elleriň taşladyň, egnime meniň.
Diýdim, saňa biraz gaýra çekilip,
— Ýaşuly, siz ýaşyňyzdan utanyň.

Şonda-da düşmediň aýdylan söze,
Şol bir hereketiň gaýtalap ýene,
Sarnadyň bir zatlar düşnüksiz dilde,
Laňkyldap söýginiň hatyrasyna.

Gör, meniň nähili kejebäm gysyp,
Seni basym ýola salasym geldi.
Görüp wagşylygyň çydaman wyždan,
Ganym gyzyp, gahar kükregme doldy.

Entirekläp çykyp gitdiň gapydan,
Aýdylan sözlerden almadyň many.
Bilmedim, menden soň kim garşylady,
Gije gelen päli ýaman myhmany.

Bu gün seni ýene gördüm köçede,
Urunýaň her ýana, çaýkanjyrap zol.
Saňa ýaşaýşyňda medet berýän zat,
Adam ýüregi däl, wezipe stol.

Emma, meň üçin sen şol günki myhman,
Gopgunly gijäni edenimde ýat.
Edil ýele meňzäp, wagşylyk bilen,
Batly gapy kakan çal býurokrat.

                78                     
              Umyt
Ozal sende sansyz umytlar bardy,
Söýgi hakda, Watan hakda, il hakda.
Durmuşyň lezzetem başgaça bolýar,
Umyt ganat gerse juwan ýürekde.

Indi weli seň öçüksi gözüňde,
Galmandyr ol sansyz umytdan nyşan.
Umytlar dünýäsin sowgat beräýsem,
Sen kabul edermiň, sözle mähriban?

Eger kabul etmän beren sowgadym,
Başyň ýaýkap, hyrçyň dişläp otursaň,
Niçiksi bor, umytlardan ýüz öwrüp,
Terkidünýälikde günüň ötürseň?

Onda meniň üçin kyn bor ýaşaýyş,
Zor salar synama hyjuwlaň ody.
Joşdurar kalbymy ömrümiň boýy,
Saňa umyt sowgat bermek umydy.

              ***
Mylaýymlyk bilen goňras bulutlar,
Kerwen tutup, çöküp barýar pessaýa.
Asmanyň perdesi daglaň gerşine,
Başyn diräp, bölünýärler set para.

Kakyp ýyljak ýagyş penjireleri,
Derelerden akyp gelýär sil ana.
Şatlanýar bulutlar,
Gülýär bulutlar
Dünýä gelen ine, sil bolanyna,

                 79                    
Şatlanýar bulutlar ujypsyz ömri,
Sarp edip bilenne gözellik üçin,
Belli zat. Sil bolup äpet daglardan,
Ýuwha ýylanlary ýok edäýmek kyn.

Kyn bu ömri geçiräýmek ýerlikli,
Aňsat däl biläýmek dünýäniň syryn.
Ýöne adamlaryň daban yzyna,
Dökmesin ýylanlar ajy zäherin.

Şoň üçin pes ýere çökýär bulutlar,
Şoň üçin toprakdan boý alýar otlar.
Ah, men düşünemok, başda nämüçin
Bile gelenmişin biziň jahana.

Adamlar,
Ýylanlar,
Bulutlar,
Itler...

Ýöne bilbillerem unudamok men,
Bilýärin dünýämde gülleň barlygyn.
Şoň üçin, ynanyň, diňe şoň üçin,
Gyzyl ýalyn bilen buzuň üstünden,
Bulut bolup, alyp barar bu göwün.

Gynanamok. Göwnüň bulutlygynda,
Ömür üçin, dünýänem saýamok pany.
Diňe bir dilegim, ynsan ýüregim
Başarsady,
Başarsady, daglardan
Sil dek joşup,
Sil bolubam inmäni.

                 80                    
Gözledim seni
Bahar güller açanda,
Saýrap guşlar uçanda,
Güneş nurun saçanda,
Janym, gözledim seni.

Ýodalardan, ýollardan
Uzak-uzak illerden,
Gülälekli gollardan
Gülüm gözledim seni.

Bakdym belent daglara,
Serçemenli baglara,
— Gel, Läläm gara maňa! –
Diýip, yzladym seni.

Ýürek aglar gün-günden,
Aý gyz gizlenme menden,
Gara gözler içinden
Saýlap gözledim seni.

         81                 
    Gülälekli meýdan
Säher bilen çyg otlary sypalap,
Men geçen günleri salýaryn ýada.
Hany meniň gulpaklyja joralam,
Şagalaňly çagalygym nirede?

Wagt şeýle bir tiz geçip gidipdir,
Kä oturyp pikir etsem ol güni.
Bizi öz akymna iteklän eken
Ýetginjeklik ýyllarymyň ýelgini.

Hany indi ol oglanlar, o gyzlar,
Bile oýnan boýdaşlarym nirede?
Geçip giden şagalaňly ýaşlygym,
Galdy meniň şu meýdanda, şu ýerde.

Her kim durmuş gurdy başardygyndan,
Oglanlar är çykdy, gyzlaram ene.
Ýöne şol ýyllardan üýtgemän galdy,
Gülälekli meýdan öňküligine.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Dostumyň ýadygärligine',
    'Sen gitdiň.
Seň bilen uly bir dünýä,
Alyslara tarap uzady gitdi.
Bu şahyr kalbymyň çuňluklarynda
Rehimsiz tukatlyk höküm ýöretdi.

                82                   
Göýä bir gyş güni
                 açylan gül dek,
Aňzak bilen göreş etdim,
Açyldym.
Şonda maňa adamlaryň garaýşam
Geň ýalydy,
Geňliginem soň bildim.

Dogrusy, men köp zatlary soň bildim...
Şu dünýäde.
Sensiz galan dünýäde.
Gyýa garaýyşlaň düşnüksizligin
Maňa sowgat goýan
Senmidiň ýa-da...?!

            ***
Aşyk men, äleme keşt edip ýörün,
Çalym edip çöldäki boz jerene.
Kemerli daglary, ymgyr düzleri
Söýseň senem, ýarym, ýör meniň bile.

Gel, gel, ýarym, ümürlikde gizlenme,
Hanha, dogdy gijäň aýdyň ýyldyzy.
Görüp ýüregmiziň näzik söýgüsin,
Bagt gujak açyp garşylar bizi.

Bagt-gözel dünýä, bagt-söýgimiz,
Gel bagtyň öňünde başyň eg, oglan.
Älemi küýseýän giň gujagymda
Ýanyp duran ýyldyz bolup dog, oglan.

               83                      
                 ***
     Maňa nämä gerek bolgusyz dostlar,
     Nämä gerek, olaň boş gürrüňleri.
     Ýalan töhmetlere, ajy gybata
     Zäherletmek ajap duýgularymy.

     Baryn undup, açyk aýdyň ýaşaýyn,
     Öwreneýin ýyldyzlaryň syryny.
     Gijäň ümsümligi, jedelli ýollar,
     Bilýän, çagalykdan söýüpdi meni.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Düýşümde-de ýaňagymdan ogşama',
    'Merjen monjuk, ýakut gaşly gülýaka
    Sowgat alyp dakma oglan döşüme.
    Söýgiň gudratyndan sergezdan bolup,
    Gijelerem girme meniň düýşüme.

    Gujak açyp suwly ýaplaň boýunda,
    Hyýalyňda gujagyňda göterme.
    Ýok, ýok, sypalama gara saçlarmy
    Ýalbarýan ýürekden ýanymda durma.

    Meňzetme sen meni daň säherine,
    Meňzetme sen meni aýly agşama.
    Mähir bilen demiň çaýyp ýüzüme,
    Düýşümde-de ýaňagymdan ogşama.

    Goý, gama batmasyn gara gözleriň,
    Unut meni, örteme öz bagryňy.
    Düşün ahyr, meň ýüregim küýseýär,
    Alyslarda galan şahyr ýarymy.

                   84                     ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Ýabany akja gül hakda ballada',
    'Men ak gül,
 Men ak gül,
 Ýönekeý ak gül,
 Açylýan türkmenleň Köpetdagynda.
 Aýdym aýdýan, şemal bilen baş goşup,
 Dürli pasyllaryň ajal çagynda.

 Ýüregim gysanok, darygamok men,
 Gorkamogam tüweleýleň badyndan.
 Aýdym aýdyp dünýä salam ýollaýan
 Şu kemerli gara daglaň adyndan.

 Dogry, alysdaky baglaň güli dek,
 Şahandaz gök ýapraklarym ýok meniň.
 Suwsuzlykdan saralsa-da gül meňzim,
 Daş güli men, aslyýetim ak meniň.

 Säher bilen seýle çykan gyzlar hem
 Dag üstüne galyp meni ýolanok.

 Biliň meniň keşbim henize çenli
 Dar kabinetlere bezet bolanok.
 Deňiz hol aşakda haýbat atsa-da,
 Şat bilbiller saýramaýar men hakda.

 Guş-gumrular meni görüp bilenok,
 Men daş güli, men olardan uzakda.

 Mümkin, meň baramda ajy gybatlar
 Seň öýüňe ýalyn bolup barýandyr.
 Bilbiller ömründe görmedik gülün
 Mahabatlap, taryp edip berýändir.

                  85                    
Sen gijä-de,
Gündize-de ynanma.
Eger meni söýseň, özüň gelip gör.
Çyk-da çal dumanly daglaň başyna,
Meň boý alan mekanymda bolup gör.

Tapmasaňam salgy bererler saňa
Howandar dereler, hossarym daşlar,
Gözlemeseň, uka batyrar seni
Kiçijik gül hakda uly myş-myşlar.

              ***
Seň ýanyňdan çykyp gaýtdym hoşlaşyp,
Syzyp duşuşygyň süýji lezzetin.
Şol gün seň mähriňe gark etdi meni
Bu giň dünýä,
Giden umman —
Gözýetim.

Dogduň sen meň asmanymda Gün bolup,
Çoguň bilen kükregimi tendirdiň.
Jöwzaly tomusyň, boz meýdanlary
Howra gaplap,
            ýakyşy dek ýandyrdyň.

Gije düşdi, uka batan sähralar
Sary gulpaklaryň sypap oýandy.
Seniň ak saçlaryň aýyň ýüzünden
Süýnüp gelýän ap-ak buluda döndi.

Oýandym men, seni Aýdan gabanyp,
Kalbym paralandy gahardan ýaňa.
Ak saçlarňy öpmek üçin topuldym,
Zeminden el üzüp, aýdyň asmana.

                 86                    
Birden daň agaryp, bu aralykda
Gyrmyzy köýnegin geýdi Gündogar.
Säherde ýalkymyn ýaýan al şapak
Seniň gyzgyn göreçleňden nur alar,
Ezizim, owadan gözleriň ogşap,
Depeleriň aňyrsynda Gün dogar.

Asman öz ýaryny gabanyp senden,
Mukaddes güneşin garşylar gülüp.
Günem öz ýarynyň gujagna dolar.
Arassa çaga deý ýalaňaçlanyp.

Bu süýji pursatlar gözlerim ýumup,
Maňa gabanjaňlyk derdin çekme kyn.
Gel, men seni asman bolup öpeýin,
Sen Gün bolup gelseň duşuşmak üçin.

               ***',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Turdy güýçli harasat',
    'Bir wagtlar şu ýerde.
         Şol gün şaglap sil akdy
         Şu daglar, şu derede.

         Dagdan indi sil bilen
         Bir äpet gara ýylan.
         Tolkunlaryň içinde
         Uzak owsundy her ýan.
         Akyp akym tersine,
         Tolkunlaryň güjeňläp.
         Arkan gaýşyp, ar alyp,
         Älemi çakjak boldy.

                  87                  
Işi başa barmady,
Ýylan owsuňsa-da köp.
Akdy sil öz ugruna,
Tolkunlaryn güjeňläp,
Akdy sil,
         baý, akdy sil,
Akdy ýeriň pesine.
Sokdy eltip ýylany
Iki daşyň astyna.

Geçdi gitdi sil şaglap,
Ýatdy güýçli harasat.
Iki daşa gysylyp,
Ol ýylan etdi perýat.

Gapdalynda gökje ot
Ygşyldaýar şemala,
Ak bulutlar eçilip,
Geçip barar bir ýana
Alysdaky mekana.
Gördi ýylan uzakda
Salgym dek gaýalary.

Ol ýer dünýäň örküji,
Gözüniň gören ýeri.
Ýylçyr daşlaň ýüzünde
Häkimlik süren ýeri.

Onuň bütin dünýäsi
Şu daglar, şu dereler.
Hemem hol dury çeşme,
Şu baýyrlar, şu ýerler.

         88               
Niçik tukat bu waka,
Aýra düşmek mekandan.
Güller, guşlar ömrüni
Güjeňleýär her ýandan.

Jyklap dagyň gerşinden
Çogly Kuýaş ýylgyrýar.
Agyr daşlar ýylanyň
Bilini ýolup gelýär.

Ýylan ýaryp daşlary,
Ýene-de çykjak boldy.
Janhowluna topulyp,
Kuýaşy çakjak boldy.
Gün ýaşdy, gün gizlendi,
Ýylan elhenç gygyrdy.
Daglar ýalňyz galdy diýp
Daş astynda jan berdi.

Diňe ýyldyzlar gördi
Ol ýylanyň ölenni,
Iki daşa gysylyp
Ömürbaky süýnenni.

Emma ýylan bilmedi,
Alysda, bir ülkede,
Edil şeýle derede,
Özi ýaly ýylanyň
Täze dünýä inenni.

        89                 ',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Garagol oglanjyk',
    'Eý, garagol oglanjyk,
 Derede garaş maňa.
 Döwüp piliň aýagyn,
 Aşyk getirin sana.

 Saňa beren wadamy,
 Çykarmaryn ýadymdan.
 Eý, garagol oglanjyk,
 Aýlanaýyn adyňdan.

 Eý, garagol oglanjyk,
 Gidýän seniň ýanyndan.
 Sen meň Watanmyň nesli,
 Sen eziz meň janymdan.

 Ynanmagyň eger-de,
 Maňa «öldi» diýseler.
 «Seni taşlap alysda,
 Baky galdy» diýseler.

 Ynanmagyn jahanda,
 Ýazyň, güýzüň oýnuna.
 Girmegin «ýarym» diýip,
 Her ýeteniň goýnuna.

 Ulalarsyň bu ýollar,
 Seň öňüňde uzalar.
 Daşdan gaty bu durmuş,
 Başyňa oýun salar.

         90                
        Oýlanaryn men mydam,
        Oýlanaryn sen hakda.
        Aýdan aýdymlarymyň,
        Bary seňki — ýürekde.

        Eý, garagol oglanjyk,
        Derede garaş maňa.
        Derede ýüzer ýaly,
        Gämi getirin saňa.

              ***
Taňrym, ne gudratlar saldyň ýüregme,
Saňa bir tükenmez uly arzym bar.
Özgäň gujagyna saldyň ýarymy,
Men bolsa oň mawy gözlerine zar.

Bulgurlary al şerapdan dolduryň,
Bagyşla sen bigünä janseregňi.
Al şeraba çalyşmasam nädeýin,
Özgäň gursagynda galan ýüregmi?!',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Bagt guşum',
    'Gijä galyp aglap geldim bu jaýa,
 Kalbym otdan doly gözlerim ýaşly.
 Meni kabul etdi özgäň egninde,
 Ýolun tapman gonan ol bagt guşum.

 Gözlerim gözlerne sataşan bada,
 Köýdi kalbymdaky ajap aýdymlar.
 «Taňry seň bagtyňy özgäň gujagna,
 taşlady» diýp, sandyrady ene ýer.

                 91                    
 Bu duşuşyk ýasa döndi meň üçin,
 Asman aglap zemin bilen çaknyşdy.
 Bu jahanda meniň ýalňyz umydym —
 Bagt guşum özgäň gujagna düşdi.

 Daş dek dymyp doňup galdym köçede,
 Meniň halym soramady geçenler.
 Aýym, Günüm ýitdi özgäň goýnunda,
 Indi meň syrdaşym gara gijeler.

 Ýok,
 Şonda-da kinäm ýok meň taňrydan,
 Göriplik edemok özge gözele.
 Ýöne meň kalbymyň azaşan guşy,
 Daşa dönüp agram salýar gursagma.

 Her kimiň öz işi, goý, söýen söýsün,
 Indi söýgi düşenok meň ýadyma.
 Kalbymyň lälesi özgäň öýünde,
 Men bolsa taşlanan ajy ýatlama.',
    ''
);

INSERT INTO poems (
    poet_id,
    title,
    text,
    source
) VALUES (
    @poet_id,
    'Akja kebelege ýüzlenme',
    'Ne parhy bar meniň ýatan ýerimiň,
Daş çykyp bilmesem, gezip bilmesem.
Ne peýda bar islämde-de ölümi,
Ajaly gujaklap ölüp bilmesem.

Ne peýda bar uçup giden bürgütden,
Penjesinde alyp gitmese meni.
Nädeýin men gargalaryň şalygyn,
Öwrenip bilmesem olaň dilini.

                 92                     
Ne peýda bar maňa biwepa ýardan,
Bir nadan oguldan, gadyrsyz gyzdan.
Çat açan ýüregim ýeriň üstünde,
Gitmek islän wagty ýaz bilen güýzden.

Nädeýin men gök agaçlaň saýasyn,
Uzaklardan maňa ýat Gün görünýär.
Penjiräň öňünde akja kebelek,
Pelpelläpler, iki ýana urunýar.

Bu jahanda ýalňyz syrdaşym meniň,
Kebelejik, deň sen dünýe malyna.
Sen-ä meň halyma dözmän urunýaň,
Men bolsa aglaýan seniň halyňa.

              ***
Jebir gördüm bu diwardan aňyrda,
Zulum gördüm bu diwardan aňyrda.
Ölüm gördüm bu diwardan aňyrda,
Hapa boldum men bir suwa düşeýin.

              ***
Diýmen Men ýeke.
Meň bilen söýgim.
Ölýär göz gyzdyrman
                      Dünýe malyna.

Rehimsiz ynsanlar,
                   Az ömrüňizde
Siz gözläp ölýäňiz, dünýe baýlygyn,
Baýlykdan ne peýda.
                     Rehim bolmasa?..

                93                      
             ***
Tapmasam men bu tokaýdan adalat,
Geregi ýok ol tokaýyň baýlygy.
Şahyryň üstünden häkimlik sürýär,
Maslyk sorýan gargalaryň şalygy.

               94                   
                             Düzüjiden

Hormatly okyjylar! Annasoltan Kekilowanyň eserleri iň soňky gezek 21 ýyl
mundan ozal çap edilipdir. «Turkmenistan» neşirýatynyň neşir eden «Öm-
rüzaýa ýyldyzym» atly bu ýygyndysy şu döwrüň içinde onuň eserlerini toplap
halka ýetirmek üçin edilen ilkinji synanyşykdyr. Bu kitap hakdaky oýlanma-
laryňyz, pikirleriňiz, bellikleriňiz biziň üçin örän gymmatly. Häzirki wagtda
Annasoltan Kekilowanyň proza eserlerinden ybarat uly bir ýygyndysy top-
lanýar. Bu ýygynda onuň hekaýalary, romandan bölekleri, hatlary, gündelik
ýazgylary we Annasoltanyň durmuşyndan gürrüň berýän başga-da ençeme
materiallar giriziler. Gelejekde bu ýygyndy hem okyjylara ýeter diýip umyt ed-
ýäris. Şonuň üçinem eliňizdäki kitap barada-da, indiki neşir ediljek ýygyndy
barada-da bellikleriňiz, teklipleriňiz bolsa ýa-da Annasoltanyň döredijiligine
degişli eserler, ýazgylar sizde saklanyp galan bolsa, onda neşirýatyň adresine
ýa-da şu aşakdaky adrese ýollamagyňyzy soraýarys.

—
744000, Aşgabat şäheri,
Magtymguly prospekti, 90, TMÝAB,
«Annasoltan Kekilowanyň arhiwi üçin».

                                     95                      
                       Mazmuny

Men ýola düşýärin, gidemok ýalňyz . . . . . . . . . . . . . . 17
Biz ýöräp barýarys . . . . . . . . . . . . . . . . . . . . . . . 18
Ýadygär galsyn . . . . . . . . . . . . . . . . . . . . . . . . . 20
Arzuwlarym . . . . . . . . . . . . . . . . . . . . . . . . . . 22
Göçüp gitdik . . . . . . . . . . . . . . . . . . . . . . . . . . 23
Dostlar, birwagtlar jahyldyk bizem . . . . . . . . . . . . . . 23
Biz olary gözläris . . . . . . . . . . . . . . . . . . . . . . . . 24
Gör, iller birýana howlugyp barýar . . . . . . . . . . . . . . 25
Myrat bilen Gülälek . . . . . . . . . . . . . . . . . . . . . . 26
Meniň göreçlemde kakam ýaşaýar . . . . . . . . . . . . . . . 27
Iň ýakyn dostuma . . . . . . . . . . . . . . . . . . . . . . . 31
Näme üçin? . . . . . . . . . . . . . . . . . . . . . . . . . . . 32
Adamlar ölmeýärler . . . . . . . . . . . . . . . . . . . . . . 33
Näbelli mazarlar . . . . . . . . . . . . . . . . . . . . . . . . 34
Enemiň oýlanmasy . . . . . . . . . . . . . . . . . . . . . . . 34
Seniň suratyň . . . . . . . . . . . . . . . . . . . . . . . . . . 36
Perzent . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 37
Söýemok men bu jahanda . . . . . . . . . . . . . . . . . . . 38
Garşylaň gyzlary . . . . . . . . . . . . . . . . . . . . . . . . 39
Agaçlara gyraw sepip gijeler . . . . . . . . . . . . . . . . . . 39
Altyn ýüzük, gymmat baha sagady . . . . . . . . . . . . . . 41
Söýgi hakynda oýlanma . . . . . . . . . . . . . . . . . . . . 42
Dostluk aýdymy . . . . . . . . . . . . . . . . . . . . . . . . 44
Ýaňlan aýdymym . . . . . . . . . . . . . . . . . . . . . . . . 44

                              96                     
Bu söýgi däl, jenaýat . . . . . . . . . . . . . . . . . . . . . .    45
Meniň tanyşlarmyň köpüsi şahyr . . . . . . . . . . . . . . .         46
Türkmen oglany . . . . . . . . . . . . . . . . . . . . . . . .       48
Zenanlar . . . . . . . . . . . . . . . . . . . . . . . . . . . .     48
Üç gün bäri... . . . . . . . . . . . . . . . . . . . . . . . . . .   49
Ol tomus günlerniň ak gijeleri . . . . . . . . . . . . . . . . .     50
Magtymgula ýüzlenme . . . . . . . . . . . . . . . . . . . . .        52
Alysdaky ýarym hakda aýdymlar . . . . . . . . . . . . . . .          53
Süýr günortan gün depämde gyzanda . . . . . . . . . . . . .          53
Owadan gyz . . . . . . . . . . . . . . . . . . . . . . . . . .       55
Ajaýyp aýdymlar juwandyr mydam . . . . . . . . . . . . . .           56
Sen hakda hiç kime aýtmadym hiç zat . . . . . . . . . . . . .        56
Bir damjajyk bulutlardan bölünip . . . . . . . . . . . . . . .       57
Çagam uklap ýatyr. Bu ümsüm gije . . . . . . . . . . . . . .         57
Dostum, bir wagtlar, entek çagakam . . . . . . . . . . . . . .       58
Tüm gijelik, meňzäp gara saçlarma . . . . . . . . . . . . . .        59
Men köp daglar hakda gürrüň edemok . . . . . . . . . . . .           59
Gargalar . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   61
Biziň gapymyzdan daglar görünýär . . . . . . . . . . . . . .         64
Meniň topragym . . . . . . . . . . . . . . . . . . . . . . . .       65
Alada . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    66
Hiç haçan men seniň duşmanyň däldim . . . . . . . . . . . .          67
Gelme meň ýanyma, saklan şol ýerde . . . . . . . . . . . . .         68
Söýgülim, reňkiň agarypdyr seň . . . . . . . . . . . . . . . .       68
Jahanda paýhasly iň gözel oglan . . . . . . . . . . . . . . . .      69
Elweraň aýdymlary . . . . . . . . . . . . . . . . . . . . . . .      70
Ol gün ýel ösdümi ýa-da gar ýagdy . . . . . . . . . . . . . .         71
Biz gyrnak . . . . . . . . . . . . . . . . . . . . . . . . . . . .   72
Giň asmana ak bulutlar düşelip . . . . . . . . . . . . . . . .       73
Jonuň arzuwy . . . . . . . . . . . . . . . . . . . . . . . . . .     74
Gyzyň päkligi . . . . . . . . . . . . . . . . . . . . . . . . . .    76
Güwleýärdi deňiz, gopgunly gije . . . . . . . . . . . . . . . .      77
Umyt . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     79
Mylaýymlyk bilen goňras bulutlar . . . . . . . . . . . . . . .       79
Gözledim seni . . . . . . . . . . . . . . . . . . . . . . . . .      81
Gülälekli meýdan . . . . . . . . . . . . . . . . . . . . . . . .     82
Dostumyň ýadygärligine . . . . . . . . . . . . . . . . . . . .     82
Aşyk men, äleme keşt edip ýörün . . . . . . . . . . . . . . .      83
Maňa nämä gerek bolgusyz dostlar . . . . . . . . . . . . . .       83
Düýşümde-de ýaňagymdan ogşama . . . . . . . . . . . . . .          84
Ýabany akja gül hakda ballada . . . . . . . . . . . . . . . . .    85
Seň ýanyňdan çykyp gaýtdym hoşlaşyp . . . . . . . . . . . .        86
Turdy güýçli harasat . . . . . . . . . . . . . . . . . . . . . .   87
Garagol oglanjyk . . . . . . . . . . . . . . . . . . . . . . . .   90
Taňrym, ne gudratlar saldyň ýüregme . . . . . . . . . . . . .      91
Bagt guşum . . . . . . . . . . . . . . . . . . . . . . . . . . .   91
Akja kebelege ýüzlenme . . . . . . . . . . . . . . . . . . . .     92
Jebir gördüm bu diwardan aňyrda . . . . . . . . . . . . . . .      93
Diýmen Men ýeke. . . . . . . . . . . . . . . . . . . . . . . .     93
Tapmasam men bu tokaýdan adalat . . . . . . . . . . . . . .        94
    Bu kitapdaky maglumat "bolşy ýaly" esaslarda, kepilliksiz getiril-
ýär. Bu iş taýýarlananda ähli seresaplyk çäreleri görlen hem bolsa, ne
awtor(lar), ne «» sahypasy bu işdäki informasiýa sebäpli
çekilen göni ýa gytaklaýyn ýitgi ýa zelel üçin hiç bir adamyň ýa gurama-
nyň öňünde jogapkärçilik çekmeýär.

             «» sahypasynyň kitaphanasy.

                          17-nji oktaýbr 2022',
    ''
);

SET FOREIGN_KEY_CHECKS = 1;
