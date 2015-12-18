--TRIGGERs para as SEQUENCEs
DROP TRIGGER TriggerGrupoId;
DROP TRIGGER TriggerPessoaId;
DROP TRIGGER TriggerEstadioId;
DROP TRIGGER TriggerJogoId;
DROP TRIGGER TriggerTipoId;
DROP TRIGGER TriggerPatrocinadorId;

CREATE OR REPLACE TRIGGER TriggerGrupoId
	BEFORE INSERT ON Grupo
	FOR EACH ROW 
BEGIN 
    IF( :new.id IS NULL ) THEN 
		SELECT SEQGRUPOID.NEXTVAL 
		INTO   :new.id 
		FROM   dual; 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER TriggerPessoaId
	BEFORE INSERT ON Pessoa
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPessoaId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER TriggerEstadioId
	BEFORE INSERT ON Estadio
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqEstadioId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER TriggerJogoId
	BEFORE INSERT ON Jogo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqJogoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER TriggerTipoId
	BEFORE INSERT ON Tipo
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqTipoId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

CREATE OR REPLACE TRIGGER TriggerPatrocinadorId
	BEFORE INSERT ON Patrocinador
	FOR EACH ROW
BEGIN
	IF(:new.id is NULL) THEN
		SELECT SeqPatrocinadorId.NEXTVAL
		INTO :new.id
		FROM dual;
	END IF;
END;
/

--Grupo
ALTER TABLE Grupo
			DROP CONSTRAINT GrupoFKGrupo;	--Necessário para a inserção dos dados, já que a tabela referencia a si mesma.

INSERT INTO Gru(par) -- Grupo A
			VALUES (2);
INSERT INTO Gru(par) -- Grupo B
			VALUES (1);
INSERT INTO Gru(par) -- Grupo C
			VALUES (4);
INSERT INTO Gru(par) -- Grupo D
			VALUES (3);
INSERT INTO Gru(par) -- Grupo E
			VALUES (6);
INSERT INTO Gru(par) -- Grupo F
			VALUES (5);
INSERT INTO Gru(par) -- Grupo G
			VALUES (8);
INSERT INTO Gru(par) -- Grupo H
			VALUES (7);

ALTER TABLE Grupo
			ADD CONSTRAINT GrupoFKGrupo FOREIGN KEY (par) REFERENCES Grupo(id); -- Recolocação da CONSTRAINT GrupoFKGrupo no atributo par.

--Nacao
----Grupo A
INSERT INTO Nac(nome, bandeira)
			VALUES ('Uruguai', EMPTY_BLOB());

----Grupo B
INSERT INTO Nac(nome, bandeira)
			VALUES ('Argentina', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Coréia do Sul', EMPTY_BLOB());
			
----Grupo C
INSERT INTO Nac(nome, bandeira)
			VALUES ('Inglaterra', EMPTY_BLOB());

----Grupo D
INSERT INTO Nac(nome, bandeira)
			VALUES ('Alemanha', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Guana', EMPTY_BLOB());

----Grupo E
INSERT INTO Nac(nome, bandeira)
			VALUES ('Holanda', EMPTY_BLOB());

----Grupo F
INSERT INTO Nac(nome, bandeira)
			VALUES ('Eslováquia', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Paraguai', EMPTY_BLOB());
----Grupo G
INSERT INTO Nac(nome, bandeira) 
			VALUES ('Brasil', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Portugal', EMPTY_BLOB());

----Grupo H
INSERT INTO Nac(nome, bandeira) 
			VALUES ('Espanha', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Chile', EMPTY_BLOB());

----Países dos Árbitros/Jogadores
INSERT INTO Nac(nome, bandeira)
			VALUES ('Japão', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('El Salvador', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('México', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Húngria', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Uzbequistão', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Guatemala', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Bélgica', EMPTY_BLOB());
INSERT INTO Nac(nome, bandeira)
			VALUES ('Itália', EMPTY_BLOB());

--Selecao
----Grupo A
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Uruguai', 1, 'Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Libertad, libertad Orientales!
Este grito à la Patria salvó.
Que a sus bravos en fieras batallas
De entusiasmo sublime inflamó.
Libertad, libertad Orientales!
Este grito à la Patria salvó.
Que a sus bravos en fieras batallas
De entusiasmo sublime inflamó.
De este don sacrosanto la gloria
Merecimos: tiranos temblad!
Tiranos temblad!
Tiranos temblad!
Libertad en la lid clamaremos,
Y muriendo, también libertad!
Libertad en la lid clamaremos,
Y muriendo, también libertad!
Y muriendo, también libertad!
También libertad!
También libertad!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Orientales la Patria o la Tumba!
Libertad o con gloria morir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Es el voto que el alma pronuncia,
Y que heroicos sabremos cumplir!
Que sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!
Sabremos cumplir!', 'América do Sul');

----Grupo B
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Argentina', 2, 'Oíd, mortales, el grito sagrado:
"¡Libertad! ¡Libertad! ¡Libertad!"
Oíd el ruido de rotas cadenas
ved en trono a la noble igualdad

Ya su trono dignísimo abrieron
las Provincias Unidas del Sud
y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"
"¡Al gran pueblo argentino, salud!"
Y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"
Y los libres del mundo responden:
"¡Al gran pueblo argentino, salud!"

Sean eternos los laureles,
que supimos conseguir,
que supimos conseguir.
Coronados de gloria vivamos...
o juremos con gloria morir!
O juremos con gloria morir!
O juremos con gloria morir!', 'América do Sul');

INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Coréia do Sul', 2, '동해 물과 백두산이 마르고 닳도록
하느님이 보우하사 우리나라 만세
무궁화 삼천리 화려 강산
대한 사람 대한으로 길이 보전하세
남산 위에 저 소나무 철갑을 두른 듯
바람서리 불변함은 우리 기상일세
가을 하늘 공활한데 높고 구름 없이
밝은 달은 우리 가슴 일편단심일세
이 기상과 이 맘으로 충성을 다하여
괴로우나 즐거우나 나라 사랑하세', 'Ásia');

----Grupo C
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Inglaterra', 3, '1.
God save our gracious Queen,
Live long our noble Queen,
God save the Queen!
Send her victorious,
Happy and glorious,
Long to reign over us,
God save the Queen.
2.
Thy choicest gifts in store
On her be pleased to pour,
Long may she reign;
May she defend our laws,
And ever give us cause
To sing with heart and voice,
God save the Queen!
3.
God bless our native land,
May heaven''s protective hand
Still guard our shore;
May peace her power extend,
Foe be transformed to friend,
And Britain''s power depend
On war no more.
4.
May just and righteous laws
Uphold the public cause,
And bless our isle.
Home of the brave and free,
Fair land and liberty,
We pray that still on thee
Kind heaven may smile.
5.
And not this land alone-
But be thy mercies known
From shore to shore.
Lord, make the nations see
That men should brothers be,
And from one family
The wide world o''er.', 'Europa');
			
----Grupo D
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Alemanha', 4, 'Deutschland, Deutschland über alles,
Über alles in der Welt,
Wenn es stets zu Schutz und Trutze
Brüderlich zusammenhält.
Von der Maas bis an die Memel,
Von der Etsch bis an den Belt,
Deutschland, Deutschland über alles,
Über alles in der Welt!
Deutsche Frauen, deutsche Treue,
Deutscher Wein und deutscher Sang
Sollen in der Welt behalten
Ihren alten schönen Klang,
Uns zu edler Tat begeistern
Unser ganzes Leben lang.
Deutsche Frauen, deutsche Treue,
Deutscher Wein und deutscher Sang!
Einigkeit und Recht und Freiheit
Für das deutsche Vaterland!
Danach lasst uns alle streben
Brüderlich mit Herz und Hand!
Einigkeit und Recht und Freiheit
Sind des Glückes Unterpfand;
Blüh'' im Glanze dieses Glückes,
 Blühe, deutsches Vaterland!', 'Europa');
 
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Guana', 4, 'God bless our homeland Ghana
And make our nation great and strong,
Bold to defend forever
The cause of Freedom and of Right;
Fill our hearts with true humility,
Make us cherish fearless honesty,
And help us to resist oppressors'' rule

With all our will and might for evermore.
Hail to thy name, O Ghana,
To thee we make our solemn vow:
Steadfast to build together
A nation strong in Unity;
With our gifts of mind and strength of arm,
Whether night or day, in the midst of storm,
In every need, whate''er the call may be,

To serve thee, Ghana, now and evermore.
Raise high the flag of Ghana
and one with Africa advance;
Black star of hope and honour
To all who thirst for liberty;
Where the banner of Ghana freely flies,
May the way to freedom truly lie;
Arise, arise, O sons of Ghana land,

And under God march on for evermore!', 'África');
 
----Grupo E
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Holanda', 5, 'Wilhelmus van Nassouwe
ben ik, van Duitsen bloed,
den vaderland getrouwe
blijf ik tot in den dood.
Een Prinse van Oranje
ben ik, vrij, onverveerd,
den Koning van Hispanje
heb ik altijd geëerd.
In Godes vrees te leven
heb ik altijd betracht,
daarom ben ik verdreven,
om land, om luid gebracht.
Maar God zal mij regeren
als een goed instrument,
dat ik zal wederkeren
in mijnen regiment.
Lijdt u, mijn onderzaten
die oprecht zijt van aard,
God zal u niet verlaten,
al zijt gij nu bezwaard.
Die vroom begeert te leven,
bidt God nacht ende dag,
dat Hij mij kracht zal geven,
dat ik u helpen mag.
Lijf en goed al te samen
heb ik u niet verschoond,
mijn broeders hoog van namen
hebben ''t u ook vertoond:
Graaf Adolf is gebleven
in Friesland in de slag,
zijn ziel in ''t eeuwig leven
verwacht de jongste dag.
Edel en hooggeboren,
van keizerlijke stam,
een vorst des rijks verkoren,
als een vroom christenman,
voor Godes woord geprezen,
heb ik, vrij onversaagd,
als een held zonder vreze
mijn edel bloed gewaagd.
Mijn schild ende betrouwen
zijt Gij, o God mijn Heer,
op U zo wil ik bouwen,
Verlaat mij nimmermeer.
Dat ik doch vroom mag blijven,
uw dienaar t''aller stond,
de tirannie verdrijven
die mij mijn hart doorwondt.
Van al die mij bezwaren
en mijn vervolgers zijn,
mijn God, wil doch bewaren
de trouwe dienaar dijn,
dat zij mij niet verrassen
in hunne boze moed,
hun handen niet en wassen
in mijn onschuldig bloed.
Als David moeste vluchten
voor Sauel de tiran,
zo heb ik moeten zuchten
als menig edelman.
Maar God heeft hem verheven,
verlost uit alle nood,
een koninkrijk gegeven
in Israël zeer groot.
Na ''t zuur zal ik ontvangen
van God mijn Heer het zoet,
daarnaar zo doet verlangen
mijn vorstelijk gemoed:
dat is, dat ik mag sterven
met ere in dat veld,
een eeuwig rijk verwerven
als een getrouwe held.
Niets doet mij meer erbarmen
in mijne wederspoed
dan dat men ziet verarmen
des Konings landen goed.
Dat u de Spanjaards krenken,
o edel Neerland zoet,
als ik daaraan gedenke,
mijn edel hart dat bloedt.
Als een prins opgezeten
met mijner heireskracht,
van de tiran vermeten
heb ik de slag verwacht,
die, bij Maastricht begraven,
bevreesden mijn geweld;
mijn ruiters zag men draven
zeer moedig door dat veld.
Zo het de wil des Heren
op die tijd was geweest,
had ik geern willen keren
van u dit zwaar tempeest.
Maar de Heer van hierboven,
die alle ding regeert,
die men altijd moet loven,
Hij heeft het niet begeerd.
Zeer christlijk was gedreven
mijn prinselijk gemoed,
standvastig is gebleven
mijn hart in tegenspoed.
De Heer heb ik gebeden
uit mijnes harten grond,
dat Hij mijn zaak wil redden,
mijn onschuld maken kond.
Oorlof, mijn arme schapen
die zijt in grote nood,
uw herder zal niet slapen,
al zijt gij nu verstrooid.
Tot God wilt u begeven,
zijn heilzaam woord neemt aan,
als vrome christen leven,-
''t zal hier haast zijn gedaan.
Voor God wil ik belijden
en zijne grote macht,
dat ik tot gene tijden
de Koning heb veracht,
dan dat ik God de Here,
de hoogste Majesteit,
heb moeten obediëren
in de gerechtigheid.
WILLEM VAN NAZZOV', 'Europa');

----Grupo F
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Eslováquia', 6, 'Nad Tatrou sa blýska, hromy divo bijú, 
nad Tatrou sa blýska, hromy divo bijú.
Zastavme ich bratia, veď sa ony stratia, Slováci ožijú, 
zastavme ich bratia, veď sa ony stratia, Slováci ožijú.
To Slovensko naše dosiaľ tvrdo spalo, 
to Slovensko naše dosiaľ tvrdo spalo.
Ale blesky hromu vzbudzujú ho k tomu, aby sa prebralo, 
ale blesky hromu vzbudzujú ho k tomu, aby sa prebralo.', 'Europa');

INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Paraguai', 6, 'Paraguayos, ¡República o Muerte!
nuestro brío nos dio libertad;
ni opresores, ni siervos alientan
donde reinan unión e igualdad.
A los pueblos de América, infausto
tres centurias un cetro oprimió,
mas un día soberbia surgiendo,
"¡Basta!" —dijo, y el cetro rompió.
Nuestros padres, lidiando grandiosos,
ilustraron su gloria marcial;
y trozada la augusta diadema,
enalzaron el gorro triunfal.
Nueva Roma, la Patria ostentará
dos caudillos de nombre y valer,
que rivales —cual Rómulo y Remo—
dividieron gobierno y poder.
Largos años —cual Febo entre nubes—
viose oculta la perla del Sud.
Hoy un héroe grandioso aparece
realzando su gloria y virtud...
Con aplauso la Europa y el Mundo
la saludan, y aclaman también;
de heroísmo: baluarte invencible,
de riquezas: magnífico Edén.
Cuando entorno rugió la Discordia
que otros Pueblos fatal devoró,
paraguayos, el suelo sagrado
con sus alas un ángel cubrió.
¡Oh! cuán pura, de lauro ceñida,
dulce Patria te ostentas así
En tu enseña se ven los colores
del zafiro, diamante y rubí.
En tu escudo que el sol ilumina,
bajo el gorro se mira el león.
Doble imagen de fuertes y libres,
y de glorias, recuerdo y blasón.
De la tumba del vil feudalismo
se alza libre la Patria deidad;
opresores, ¡doblad rodilla!,
compatriotas, ¡el Himno entonad!
Suene el grito: "¡República o muerte!",
nuestros pechos lo exhalen con fe,
y sus ecos repitan los montes
cual gigantes poniéndose en pie.
Libertad y justicia defiende
nuestra Patria; tiranos, ¡oíd!
de sus fueros la carta sagrada
su heroísmo sustenta en la lid.
Contra el mundo, si el mundo se opone,
Si intentare su prenda insultar,
batallando vengar la sabremos
o abrazo con ella expirar.
Alza, oh Pueblo, tu espada esplendente
que fulmina destellos de Dios,
no hay más medio que libre o esclavo
y un abismo divide a los dos.
En las auras el Himno resuene,
repitiendo con eco triunfal:
¡a los libres perínclita gloria!,
¡a la Patria laurel inmortal!', 'América do Sul');

----Grupo G
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente) 
			VALUES ('Brasil', 7, 'Ouviram do Ipiranga as margens plácidas
De um povo heroico o brado retumbante,
E o sol da Liberdade, em raios fúlgidos,
Brilhou no céu da Pátria nesse instante.

Se o penhor dessa igualdade
Conseguimos conquistar com braço forte,
Em teu seio, ó Liberdade,
Desafia o nosso peito a própria morte!

Ó Pátria amada,
Idolatrada,
Salve! Salve!

Brasil, um sonho intenso, um raio vívido,
De amor e de esperança à terra desce,
Se em teu formoso céu, risonho e límpido,
A imagem do Cruzeiro resplandece.

Gigante pela própria natureza,
És belo, és forte, impávido colosso,
E o teu futuro espelha essa grandeza.

Terra adorada
Entre outras mil
És tu, Brasil,
Ó Pátria amada!

Dos filhos deste solo
És mãe gentil,
Pátria amada,
Brasil!
Deitado eternamente em berço esplêndido,
Ao som do mar e à luz do céu profundo,
Fulguras, ó Brasil, florão da América,
Iluminado ao sol do Novo Mundo!

Do que a terra mais garrida
Teus risonhos, lindos campos têm mais flores,
"Nossos bosques têm mais vida",
"Nossa vida" no teu seio "mais amores".

Ó Pátria amada,
Idolatrada,
Salve! Salve!

Brasil, de amor eterno seja símbolo
O lábaro que ostentas estrelado,
E diga o verde-louro dessa flâmula
- Paz no futuro e glória no passado.

Mas se ergues da justiça a clava forte,
Verás que um filho teu não foge à luta,
Nem teme, quem te adora, a própria morte.

Terra adorada
Entre outras mil
És tu, Brasil,
Ó Pátria amada!

Dos filhos deste solo
És mãe gentil,
Pátria amada,
Brasil!', 'América do Sul');

INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Portugal', 7, 'Heróis do mar, nobre povo,
Nação valente, imortal,
Levantai hoje de novo
O esplendor de Portugal!
Entre as brumas da memória,
Ó Pátria, sente-se a voz
Dos teus egrégios avós,
Que há-de guiar-te à vitória!
Às armas, às armas!
Sobre a terra, sobre o mar,
Às armas, às armas!
Pela Pátria lutar!
Contra os canhões, marchar, marchar!
Desfralda a invicta Bandeira,
À luz viva do teu céu!
Brade a Europa à terra inteira:
Portugal não pereceu
Beija o solo teu jucundo
O Oceano, a rugir d''amor,
E teu braço vencedor
Deu mundos novos ao Mundo!
Saudai o Sol que desponta
Sobre um ridente porvir;
Seja o eco de uma afronta
O sinal do ressurgir.
Raios dessa aurora forte
São como beijos de mãe,
Que nos guardam, nos sustêm,
Contra as injúrias da sorte.', 'Europa');

----Grupo H
INSERT INTO Sel(nomeNacao, idGrupo, hino, continente) 
			VALUES ('Espanha', 8, '¡Viva España!
Cantemos todos juntos
con distinta voz
y un solo corazón.
¡Viva España!
Desde los verdes valles
al inmenso mar,
un himno de hermandad.
Ama a la Patria
pues sabe abrazar,
bajo su cielo azul,
pueblos en libertad.
Gloria a los hijos
que a la Historia dan
justicia y grandeza
democracia y paz.', 'Europa');

INSERT INTO Sel(nomeNacao, idGrupo, hino, continente)
			VALUES ('Chile', 8, 'Puro, Chile, es tu cielo azulado.
Puras brisas te cruzan también.
Y tu campo de flores bordado
Es la copia feliz del Edén.
Majestuosa es la blanca montaña
Que te dio por baluarte el Señor
Que te dio por baluarte el Señor,
Y ese mar que tranquilo te baña
Te promete un futuro esplendor
Y ese mar que tranquilo te baña
Te promete un futuro esplendor.
Dulce Patria, recibe los votos
Con que Chile en tus aras juró:
Que o la tumba serás de los libres
O el asilo contra la opresión
Que o la tumba serás de los libres
O el asilo contra la opresión
Que o la tumba serás de los libres
O el asilo contra la opresión
O el asilo contra la opresión
O el asilo contra la opresión.', 'América do Sul');

--Pessoa
----Árbitros
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 1
			VALUES ('A', 'Yuichi Nishimura', '3332', to_date('17/04/72', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 2
			VALUES ('A', 'Joel Aguilar', '5545', to_date('02/07/75', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 3
			VALUES ('A', 'Benito Archundia', '8787', to_date('21/03/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 4
			VALUES ('A', 'Howard Webb', '141524124', to_date('14/07/71', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 5
			VALUES ('A', 'Viktor Kassai', '490112412', to_date('10/09/75', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 6
			VALUES ('A', 'Ravshan Irmatov', '014241241', to_date('09/07/77', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 7
			VALUES ('A', 'Carlos Batres', '1231241', to_date('02/04/68', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 8
			VALUES ('A', 'Olegário Benquerença', '23124141', to_date('18/10/69', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 9
			VALUES ('A', 'Héctor Baldassi', '2315555124', to_date('05/01/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 10
			VALUES ('A', 'Frank De Bleeckere', '211516661', to_date('01/07/66', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 11
			VALUES ('A', 'Alberto Undiano Mallenco', '05501241', to_date('08/10/73', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 12
			VALUES ('A', 'Roberto Rosetti', '12412415', to_date('18/09/67', 'dd/mm/yy'));

----Jogadores
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 13
			VALUES ('J', 'Thomas Müller', '321314', to_date('13/09/89', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento) 		-- 14
			VALUES ('J', 'Kaká', '5547', to_date('22/04/82', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 15
			VALUES ('J', 'David Villa', '12151251', to_date('03/12/81', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 16
			VALUES ('J', 'Wesley Sneijder', '124152516', to_date('09/06/84', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 17
			VALUES ('J', 'Diego Fórlan', '15581922', to_date('19/05/79', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 18
			VALUES ('J', 'Manuel Neuer', '241411251', to_date('27/03/86', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 19
			VALUES ('J', 'Eljero Elia', '30912300131', to_date('13/02/87', 'dd/mm/yy'));
INSERT INTO Pes(subclasse, nome, passaporte, nascimento)		-- 20
			VALUES ('J', 'Luis Suárez', '13134141', to_date('24/01/87', 'dd/mm/yy'));

--PertenceA
----Árbitros
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (1, 'Japão');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (2, 'El Salvador');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (3, 'México');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (4, 'Inglaterra');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (5, 'Húngria');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (6, 'Uzbequistão');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (7, 'Guatemala');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (8, 'Portugal');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (9, 'Argentina');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (10, 'Bélgica');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (11, 'Espanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (12, 'Itália');

----Jogadores
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (13, 'Alemanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (14, 'Brasil');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (15, 'Espanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (16, 'Holanda');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (17, 'Uruguai');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (18, 'Alemanha');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (19, 'Holanda');
INSERT INTO PertA(idPessoa, nomeNacao)
			VALUES (20, 'Uruguai');

--Jogador
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Thomas Müller // Maior número de gols da World Cup 2010: 5
			VALUES (13, 'Alemanha', 74, 1.86);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Kaká // 
			VALUES (14, 'Brasil', 74, 1.76);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- David Villa // Maior número de gols da World Cup 2010: 5
			VALUES (15, 'Espanha', 69, 1.75);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Wesley Sneijder // Maior número de gols da World Cup 2010: 5
			VALUES (16, 'Holanda', 67, 1.70);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Diego Fórlan // Maior número de gols da World Cup 2010: 5
			VALUES (17, 'Uruguai', 75, 1.80);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Manuel Neuer // Goleiro da Alemanha
			VALUES (18, 'Alemanha', 92, 1.93); 
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Eljero Elia //
			VALUES (19, 'Holanda', 77, 1.76);
INSERT INTO Jogd(idPessoa, nomeSelecao, peso, altura) -- Luis Suárez //
			VALUES (20, 'Uruguai', 81, 1.81);

			
--Estadio
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 1
			VALUES ('Nelson Mandela Bay Stadium', 'Port Elizabeth', 48000, 'Prince Alfred Road', 'North End', 6001);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 2
			VALUES ('Loftus Versfeld Stadium', 'Pretoria', 51000, 'Kirkness St.', 'Arcadia', 440);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 3
			VALUES ('Cape Town Stadium', 'Cape Town', 69000, 'Fritz Sonnenberg Rd.', 'Green Point', 8051);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 4
			VALUES ('Moses Mabhida Stadium', 'Durban', 70000, 'Masabalala Yengwa Ave', 'Stamford Hill', 4025);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro) 	-- 5
			VALUES ('Ellis Park Stadium', 'Johannesburg', 59611, 'Doornfontein', '47 North Park Lane', 2028);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 6
			VALUES ('Soccer City', 'Johannesburg', 94736, 'Stadium Avenue', 'Nasrec', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 7
			VALUES ('Peter Mokaba Stadium', 'Polokwane', 41733, 'Magazin St.', 'Polokwane Central', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 8
			VALUES ('Mbombela Stadium', 'Nelspruit', 40929, 'Masafeni Rd.', 'N/A', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 9
			VALUES ('Free State Stadium', 'Bloemfontein', 48000, 'Kings Way', 'Westdene', 0);
INSERT INTO Est(nome, cidade, capacidade, rua, bairro, nro)		-- 10
			VALUES ('Royal Bafokeng Stadium', 'Phokeng', 42000, 'Sun City Rd.', 'N/A', 0);

--Jogo
----Oitavas de Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 1 Uruguai x Coréia do Sul
			VALUES(1, '11:00', to_date('26/06/10', 'dd/mm/yy'), 'O', 4589550, 30597);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 2 EUA x Guana
			VALUES(10, '15:30', to_date('26/06/10', 'dd/mm/yy'), 'O', 5246400, 34976);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 3 Alemanha x Inglaterra
			VALUES(9, '11:00', to_date('27/06/10', 'dd/mm/yy'), 'O', 6076500, 40510);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 4 Argentina x México
			VALUES(6, '15:30', to_date('27/06/10', 'dd/mm/yy'), 'O', 9265655, 84377);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 5 Holanda x Eslováquia
			VALUES(4, '11:00', to_date('28/06/10', 'dd/mm/yy'), 'O', 9294300, 61962);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 6 Brasil x Chile
			VALUES(5, '15:30', to_date('28/06/10', 'dd/mm/yy'), 'O', 8114400, 54096);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 7 Paraguai x Japão
			VALUES(2, '11:00', to_date('29/06/10', 'dd/mm/yy'), 'O', 5511300, 36742);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 8 Espanha x Portugal
			VALUES(3, '15:30', to_date('29/06/10', 'dd/mm/yy'), 'O', 9443250, 62955);

----Quartas-de-Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 9 Holanda x Brasil
			VALUES(1, '11:00', to_date('02/07/10', 'dd/mm/yy'), 'Q', 6027900, 40186);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 10 Uruguai x Guana
			VALUES(6, '15:30', to_date('02/07/10', 'dd/mm/yy'), 'Q', 9260255, 84017);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 11 Argentina x Alemanha
			VALUES(3, '11:00', to_date('03/07/10', 'dd/mm/yy'), 'Q', 9615000, 64100);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 12 Paraguai x Espanha
			VALUES(5, '15:30', to_date('03/07/10', 'dd/mm/yy'), 'Q', 8303850, 55359);
			
----Semi-final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 13 Uruguai x Holanda
			VALUES(3, '15:30', to_date('06/07/10', 'dd/mm/yy'), 'S', 9371850, 62479);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 14 Alemanha x Espanha
			VALUES(4, '15:30', to_date('07/07/10', 'dd/mm/yy'), 'S', 9144000, 60960);

----Final
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 15 Uruguai x Alemanha
			VALUES(1, '15:30', to_date('10/07/10', 'dd/mm/yy'), 'F', 5438100, 36254);
INSERT INTO Jog(idEstadio, hr, dt, fase, renda, publicoPresente) -- 16 Holanda x Espanha
			VALUES(6, '15:30', to_date('11/07/10', 'dd/mm/yy'), 'F', 1267350, 84490);

--Enfrenta
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 1 [Holanda x Brasil]
			VALUES (9, 5, 6, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 2 [Uruguai x Guana]
			VALUES (10, 1, 2, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 3 [Argentina x Alemanha]
			VALUES (11, 3, 4, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- 4ªs-de-Final 4 [Paraguai x Espanha]
			VALUES (12, 7, 8, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Semi-Final 1 [Uruguai x Holanda]
			VALUES (13, 9, 10, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Semi-Final 2 [Alemanha x Espanha]
			VALUES (14, 11, 12, 'V');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Final 1 [Uruguai x Alemanha]
			VALUES (15 , 13, 14, 'F');
INSERT INTO Enf(fasePosterior, faseAnteriorJ1, faseAnteriorJ2, vencedor) -- Final 2 [Holanda x Espanha]
			VALUES (16 , 13, 14, 'V');

--Informacao
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (1, 'Uruguai', 'Coréia do Sul');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (3, 'Alemanha', 'Inglaterra');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (5, 'Holanda', 'Eslováquia');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (6, 'Brasil', 'Chile');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (8, 'Espanha', 'Portugal');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (9, 'Holanda', 'Brasil');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (10, 'Uruguai', 'Guana');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (11, 'Argentina', 'Alemanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (12, 'Paraguai', 'Espanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (13, 'Uruguai', 'Holanda');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (14, 'Alemanha', 'Espanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (15, 'Uruguai', 'Alemanha');
INSERT INTO Info(idJogo, nomeSelecao1, nomeSelecao2)
			VALUES (16, 'Holanda', 'Espanha');

--Tipo
INSERT INTO Tp(descritor)
			VALUES ('Gol');
INSERT INTO Tp(descritor)
			VALUES ('Lance de Perigo');
INSERT INTO Tp(descritor)
			VALUES ('Cartão Amarelo');
INSERT INTO Tp(descritor)
			VALUES ('Cartão Vermelho');
INSERT INTO Tp(descritor)
			VALUES ('Substituição');

--Árbitro
INSERT INTO Arb(idPessoa)
			VALUES (1);
INSERT INTO Arb(idPessoa)
			VALUES (2);
INSERT INTO Arb(idPessoa)
			VALUES (3);
INSERT INTO Arb(idPessoa)
			VALUES (4);
INSERT INTO Arb(idPessoa)
			VALUES (5);
INSERT INTO Arb(idPessoa)
			VALUES (6);
INSERT INTO Arb(idPessoa)
			VALUES (7);
INSERT INTO Arb(idPessoa)
			VALUES (8);
INSERT INTO Arb(idPessoa)
			VALUES (9);
INSERT INTO Arb(idPessoa)
			VALUES (10);
INSERT INTO Arb(idPessoa)
			VALUES (11);
INSERT INTO Arb(idPessoa)
			VALUES (12);
			
--JogouEm
----Thomas Müller (Alemanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Alemanha
			VALUES (15, 13, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Argentina x Alemanha
			VALUES (11, 13, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Inglaterra
			VALUES (3, 13, 'S');
----Kaká (Brasil)
INSERT INTO JgEm(idJogo, idJogador, titular) --Brasil x Chile
			VALUES (6, 14, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Brasil
			VALUES (9, 14, 'S');
----David Villa (Espanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 15, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Paraguai x Espanha
			VALUES (12, 15, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Espanha x Portugal
			VALUES (8, 15, 'S');
----Wesley Sneijder (Holanda)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Holanda
			VALUES (13, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Brasil
			VALUES (9, 16, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Eslováquia
			VALUES (5, 16, 'S');
----Diego Fórlan (Uruguai)
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Alemanha
			VALUES (15, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Holanda
			VALUES (13, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Guana
			VALUES (10, 17, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Uruguai x Coréia do Sul
			VALUES (1, 17, 'S');
----Manuel Neuer (Alemanha)
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Espanha
			VALUES (14, 18, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Argentina x Alemanha
			VALUES (11, 18, 'S');
INSERT INTO JgEm(idJogo, idJogador, titular) --Alemanha x Inglaterra
			VALUES (3, 18, 'S');
----Eljero Elia (Holanda)
INSERT INTO JgEm(idJogo, idJogador, titular) --Holanda x Espanha
			VALUES (16, 19, 'N');

			
--Lance
----Müller
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (15, '00:19', 1, 'Gol realizado por Müller da Alemanha aos 19 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '00:03', 1, 'Gol realizado por Müller da Alemanha aos 3 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '00:35', 3, 'Cartão amarelo recebido por Müller da Alemanha aos 35 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (11, '01:24', 5, 'Müller da Alemanha é substituído aos 39 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (3, '01:12', 5, 'Müller da Alemanha é substituído aos 27 minutos do segundo tempo.');
----Sneijder
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '01:10', 1, 'Gol realizado por Sneijder da Holanda aos 25 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '00:29', 3, 'Cartão amarelo recebido por Sneijder da Holanda aos 29 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (9, '00:53', 1, 'Gol realizado por Sneijder da Holanda aos 8 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (9, '01:08', 1, 'Gol realizado por Sneijder da Holanda aos 23 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (5, '01:24', 1, 'Gol realizado por Sneijder da Holanda aos 39 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (5, '01:32', 5, 'Sneijder da Holanda é substituído aos 2 minutos na prorrogação.');
----Fórlan
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (15, '00:51', 1, 'Gol realizado por Forlán do Uruguai aos 6 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (13, '00:41', 1, 'Gol realizado por Fórlan do Uruguai aos 41 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (10, '00:55', 1, 'Gol realizado por Fórlan do Uruguai aos 10 minutos do segundo tempo.');
----Villa
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (16, '01:46', 5, 'Villa da Espanha é substituído a 1 minuto do segundo tempo adicional.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (12, '01:21', 1, 'Gol realizado por Villa da Espanha aos 36 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (8, '01:03', 1, 'Gol realizado por Villa da Espanha aos 18 minutos do segundo tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (8, '01:28', 5, 'Villa da Espanha é substituído aos 43 minutos do segundo tempo.');
----Kaká
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (6, '00:30', 3, 'Cartão amarelo recebido por Kaká do Brasil aos 30 minutos do primeiro tempo.');
INSERT INTO Lan(idJogo, tempo, idTipo, descricao)
			VALUES (6, '01:21', 5, 'Kaká do Brasil é substituído aos 36 minutos do segundo tempo.');
			
--ParticipaDe
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (15, '00:19', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '00:03', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '00:35', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (11, '01:24', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (3, '01:12', 13);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (6, '00:30', 14);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (6, '01:21', 14);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (16, '01:46', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (12, '01:21', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (8, '01:03', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (8, '01:28', 15);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '01:10', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '00:29', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (9, '00:53', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (9, '01:08', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (5, '01:24', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (5, '01:32', 16);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (15, '00:51', 17);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (13, '00:41', 17);
INSERT INTO PartDe(idJogo, tempo, idJogador)
			VALUES (10, '00:55', 17);
			
			
--Apita
INSERT INTO Apt(idArbitro, idJogo, funcao) 
			VALUES (1, 9, 'Principal');		-- Yuichi Nishimura, Holanda x Brasil.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (1, 16, 'Reserva'); 		-- Yuichi Nishimura, Holanda x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (2, 1, 'Reserva');		-- Joel Aguillar, Uruguai x Coréia do Sul.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (3, 12, 'Reserva');		-- Benito Archundia, Paraguai x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (3, 15, 'Principal');	-- Benito Archundia, Uruguai x Alemanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (4, 16, 'Principal');	-- Howard Webb, Holanda x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (4, 6, 'Principal');		-- Howard Webb, Brasil x Chile.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (5, 2, 'Principal');		-- Viktor Kassai, EUA x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (5, 14, 'Principal');	-- Viktor Kassai, Alemanha x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (6, 11, 'Principal');	-- Ravshan Irmatov, Argentina x Alemanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (6, 13, 'Principal');	-- Ravshan Irmatov, Uruguai x Holanda.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (7, 8, 'Reserva');		-- Carlos Batres, Espanha x Portugal.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (7, 12, 'Principal');	-- Carlos Batres, Paraguai x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (8, 10, 'Principal');	-- Olegário Benquerença, Uruguai x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (9, 8, 'Principal');		-- Héctor Baldassi, Espanha x Portugal.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (10, 7, 'Principal');	-- Frank De Bleeckere, Paraguai x Japão.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (10, 14, 'Reserva');		-- Frank De Bleeckere, Alemanha x Espanha.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (11, 5, 'Principal');	-- Alberto Undiano Mallenco, Holanda x Eslováquia.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (11, 10, 'Reserva');		-- Alberto Undiano Mallenco, Uruguai x Guana.
INSERT INTO Apt(idArbitro, idJogo, funcao)
			VALUES (12, 4, 'Principal');	-- Roberto Rosetti, Argentina x México.
			
--Patrocinador
INSERT INTO Pat(nome)
			VALUES ('Coca-Cola');
INSERT INTO Pat(nome)
			VALUES ('Adidas');
INSERT INTO Pat(nome)
			VALUES ('VISA');
INSERT INTO Pat(nome)
			VALUES ('SONY');
INSERT INTO Pat(nome)
			VALUES ('McDonald''s');
			
--Interesse
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(1, 'Brasil');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(2, 'Holanda');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(3, 'Alemanha');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(4, 'Uruguai');
INSERT INTO Inter(idPatrocinador, nomeSelecao)
			VALUES(5, 'Espanha');
			
--DivulgadoEm
----Coca-Cola, Interesse: Brasil, Tuplas: 2
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 6);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 9);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 12);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(1, 16);
----Adidas, Interesse: Holanda, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 5);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 9);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 13);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(2, 16);
----VISA, Interesse: Alemanha, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 3);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 11);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 14);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(3, 16);
----SONY, Interesse: Uruguai, Tuplas: 4
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 1);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 10);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 13);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 15);
INSERT INTO DivEm(idPatrocinador, idJogo)
			VALUES(4, 16)