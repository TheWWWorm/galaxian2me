extends RefCounted
## Reference prose in Portuguese. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Primeiros passos", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Projetos e produção", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/combat": {"title": "Combate", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Naves e equipamentos", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/flight": {"title": "Voo", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Trabalhos freelance", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medalhas", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/mining": {"title": "Mineração", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navegação", "subtitle": "Guia", "category": "guide", "from": 0},
	"guide/trading": {"title": "Comércio", "subtitle": "Guia", "category": "guide", "from": 0},
	"step/0": {"title": "Recompensa no cinturão de asteroides"},
	"step/1": {"title": "Encontrado à deriva"},
	"step/10": {"title": "Encontro com o comandante"},
	"step/11": {"title": "Uma estação silenciosa"},
	"step/12": {"title": "Relatório ao comandante"},
	"step/13": {"title": "À espera do comboio"},
	"step/14": {"title": "O comboio terrano"},
	"step/15": {"title": "Preso"},
	"step/16": {"title": "Defendendo a estação"},
	"step/17": {"title": "A história dos Voids"},
	"step/18": {"title": "Encontro com um cientista"},
	"step/19": {"title": "O sequestro"},
	"step/2": {"title": "A primeira carga de minério"},
	"step/20": {"title": "Instalando as bombas"},
	"step/21": {"title": "Neutralizando os sequestradores"},
	"step/22": {"title": "O cientista resgatado"},
	"step/23": {"title": "A estação de pesquisa secreta"},
	"step/24": {"title": "Recolhendo destroços dos Voids"},
	"step/25": {"title": "Perdidos em um espaço estranho"},
	"step/26": {"title": "Despistando os perseguidores"},
	"step/27": {"title": "Uma nova missão"},
	"step/28": {"title": "De volta ao buraco de minhoca"},
	"step/29": {"title": "Lançando a sonda"},
	"step/3": {"title": "Entregando o minério"},
	"step/30": {"title": "Uma ligação de um velho amigo"},
	"step/31": {"title": "Uma surpresa prometida"},
	"step/32": {"title": "O cientista Grey"},
	"step/33": {"title": "Cristais do Void"},
	"step/34": {"title": "Um plano para a vitória"},
	"step/35": {"title": "Encontro com o comandante vossk"},
	"step/36": {"title": "Uma disputa entre pilotos"},
	"step/37": {"title": "Contato com o quartel-general"},
	"step/38": {"title": "Recuperando o comboio"},
	"step/39": {"title": "Últimos preparativos"},
	"step/4": {"title": "Um porão de carga cheio"},
	"step/40": {"title": "Escolta até o buraco de minhoca"},
	"step/41": {"title": "Ataque à nave-mãe"},
	"step/42": {"title": "Fuga do espaço do Void"},
	"step/43": {"title": "Uma comemoração"},
	"step/44": {"title": "A manhã seguinte"},
	"step/45": {"title": "Epílogo"},
	"step/5": {"title": "Fuga para a estação"},
	"step/6": {"title": "Armando a nave"},
	"step/7": {"title": "O esconderijo dos piratas"},
	"step/8": {"title": "Depois da batalha"},
	"step/9": {"title": "Acertando as contas"},
	"world/galaxy": {"title": "A galáxia", "subtitle": "Ambientação", "category": "world", "from": 0},
	"world/history": {"title": "História", "subtitle": "Ambientação", "category": "world", "from": 0},
	"world/voids": {"title": "Os Voids", "subtitle": "Ambientação", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] é um agente niveliano no lounge de [[station/3]], no sistema oculto [[system/0]]. Ele vende o projeto do laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] é um agente niveliano no lounge de [[station/8]], no sistema oculto [[system/1]]. Ele vende o projeto do blaster [[item/15]], uma arma que ele descreve como rara.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] é um agente terrano que vive entre os vossk, no lounge de [[station/59]], em [[system/20]]. Ele vende o projeto do dispositivo de camuflagem [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] é o comerciante de minério [[character/2]], que aparece no lounge da sua própria estação, [[station/78]], em [[system/15]]. Ele vende o projeto do [[item/90]], seu próprio laser de mineração, a um preço muito acima do de qualquer outro agente. Como [[system/15]] não tem conexões por portal, chegar até ele mais adiante no jogo exige um motor de salto.", false],
		[10, "", "Ele cumprimenta [[character/0]] como o viajante do tempo e começou a produzir a broca que antes guardava só para si.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] é um agente vossk no lounge de [[station/18]], em [[system/3]]. Ele vende as coordenadas do sistema oculto [[system/0]], elogiando suas muitas estações avançadas.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] é um agente boboliano no lounge de [[station/26]], em [[system/5]]. Ele vende as coordenadas do sistema oculto [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] é um agente ciborgue no lounge de [[station/65]], em [[system/13]]. Ele vende as coordenadas de [[system/10]], mas admite que não faz ideia de como chegar lá. Sem um motor de salto as coordenadas não servem para nada, já que o sistema não tem conexões por portal.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] é um agente vossk no lounge de [[station/88]], em [[system/17]]. Ele vende as coordenadas do sistema oculto [[system/21]], que ele chama de seu lar. Depois de conhecido, o sistema pode ser alcançado por portal a partir de [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] é um agente midoriano no lounge de [[station/20]], em [[system/4]]. Ele vende o projeto do [[item/25]], o projeto de arma mais barato oferecido por um agente, sem contar o foguete de [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] é um agente terrano no lounge de [[station/10]], em [[system/6]]. Ele vende o projeto do [[item/27]], um acelerador de massa de disparo rápido.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] é um agente terrano no lounge de [[station/43]], em [[system/8]]. Ele vende o projeto do [[item/33]], o projeto mais barato oferecido por qualquer agente.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] é um agente vossk no lounge de [[station/54]], em [[system/10]], um sistema que só se alcança com um motor de salto. Ele vende o projeto do torpedo teleguiado [[item/37]], que nenhuma loja tem em estoque.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] é o único multípode do jogo. Ele fica no lounge de [[station/61]], em [[system/12]], e vende o projeto da arma nuclear [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] é um agente terrano no lounge de [[station/72]], em [[system/14]]. Ele vende o projeto do [[item/54]], um escudo potente.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] é um agente vossk no lounge de [[station/84]], em [[system/16]]. Ele vende o projeto da [[item/59]], uma placa de blindagem vossk que nunca foi vendida em lojas. É o projeto mais caro vendido por um agente, depois da broca de [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] é um agente terrano no lounge de [[station/90]], em [[system/18]]. Ele vende o projeto do [[item/67]], um compressor de carga que ele recomenda a todo comerciante.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] é o protagonista e o personagem que você controla. Ele é um piloto de caça [[faction/0]] que ganha a vida caçando [[faction/8|piratas]] pelas recompensas por suas cabeças. É confiante, sarcástico e não foge de uma briga.", false],
		[1, "Perdido", "A caminho de Eden Prime, onde o almirante Smith tem uma missão especial para ele, seu hiperpropulsor é danificado em um ataque pirata. O piloto automático o leva, inconsciente, até [[station/78]].", false],
		[2, "", "Lá ele é resgatado pelo comerciante de minério [[character/2]], que reivindicou sua nave como salvamento e o põe para trabalhar como minerador.", false],
		[8, "", "Keith é um veterano da Frota Espacial Terrana, onde serviu sob o comando do almirante Smith.", false],
		[9, "", "Ele descobre que o almirante morreu de velhice e que agora é o ano de 3624.", false],
		[10, "", "Cerca de 35 anos se passaram desde o acidente, ao que parece por causa de uma falha no hiperpropulsor, mas Keith não envelheceu nada. Perdido no remoto sistema [[system/15]], ele recomeça com a [[ship/0]], um presente de Gunant.", false],
		[16, "A guerra contra os Voids", "Depois de uma prisão por engano, ele reencontra seu velho amigo [[character/1]] em [[station/98]] e trava sua primeira batalha contra os [[faction/9|Voids]].", false],
		[18, "", "Brent o recruta como piloto para a organização de pesquisa Deep Science, que investiga os Voids.", false],
		[24, "", "Em [[station/10]] ele conhece [[character/6]], a líder do projeto, e logo se sente atraído por ela.", false],
		[26, "", "Ele e Carla são puxados por um buraco de minhoca dos Voids até o setor de origem deles e encontram um caminho de volta.", false],
		[36, "", "O comandante vossk [[character/7]] conhece o serviço anterior de Keith em Novaterra.", false],
		[43, "", "Keith escolta o cargueiro que destrói a nave-mãe dos Voids e põe fim aos ataques, embora Errkt morra na ofensiva.", false],
		[45, "Depois", "Sua recompensa é uma noite com Carla, que depois desaparece rumo a outro projeto secreto e lhe deixa um último pagamento. Com o trabalho concluído, Keith fica livre para percorrer a galáxia.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] é um velho amigo de Keith de antes do acidente. Nos 35 anos que Keith perdeu, Brent chegou a capitão-tenente e chefe da Agência de Segurança Interestelar. Ele é simpático, falante e adora contar longas histórias pessoais.", false],
		[18, "A crise dos Voids", "Como chefe de segurança, ele preside a equipe de crise que coordena a resposta aos [[faction/9|Voids]]. Ele recruta Keith para a Deep Science e garante que ele seja bem pago. A nave de Keith é repintada por ordem dele.", false],
		[19, "", "Quando o cientista [[character/5]] é sequestrado, Brent apoia o plano de resgate de Keith e fornece bombas de EMP em [[station/55]].", false],
		[32, "", "Sua equipe desenvolve o sistema de alerta antecipado que mostra onde os Voids vão abrir seu próximo buraco de minhoca.", false],
		[35, "", "Junto com [[character/6]], ele elabora o plano para destruir a nave-mãe dos Voids com um cargueiro cheio de explosivos e negocia o acordo com o comandante vossk [[character/7]].", false],
		[43, "Depois", "Depois que a nave-mãe é destruída, Brent comemora a vitória com Keith em [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] é um comerciante de minério [[faction/2]] que administra uma pequena estação de mineração em [[station/78]], no sistema [[system/15]]. Ele encontra os destroços da nave de [[character/0]], salva o piloto e reivindica a nave como salvamento. Rude e prático, ele faz Keith pagar sua dívida minerando com a [[ship/0]], uma nave velha que ele mesmo remendou.", false],
		[8, "", "Quando Keith o ajuda a destruir um esconderijo pirata perto de sua estação, Gunant passa a respeitá-lo.", false],
		[10, "", "Em gratidão, ele dá a [[ship/0]] a Keith com um propulsor melhor e o envia ao seu amigo [[character/3]]. O próprio Gunant é membro da [[faction/3|Confederação Mido]]. Ele projeta seus próprios lasers de mineração e, como o agente [[agent/11]], vende o projeto de um deles, o [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] é um cientista dos [[faction/7|Grey]] que trabalha para a Deep Science. Ele pede para encontrar [[character/0]] em [[station/10]].", false],
		[33, "", "Khador fala com uma cortesia rebuscada. Depois de estudar os destroços dos Voids, ele acredita que cristais encontrados apenas no setor dos Voids guardam o segredo de seus buracos de minhoca. Ele passou anos desenvolvendo um propulsor capaz de levar uma nave instantaneamente a qualquer ponto do espaço e pede a Keith que colete 50 [[item/164]] para ele.", false],
		[34, "", "Quando Keith entrega os cristais, Khador o recompensa com uma cópia do projeto do propulsor que leva o seu nome, o [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] é um capitão humano que se juntou à [[faction/3|Confederação Mido]] e agora comanda [[station/79]]. [[character/2]] o recomenda a Keith como alguém que pode ajudá-lo a voltar ao espaço terrano.", false],
		[11, "", "Norris recebe Keith bem e explica a história do sistema [[system/15]]. Ele se oferece para pôr Keith em contato com a Frota Espacial Terrana se Keith antes investigar o silêncio em [[station/76]].", false],
		[13, "", "Ele combina para Keith encontrar um comboio terrano que passa pelo sistema e sugere que ele aceite trabalhos freelance enquanto espera.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] é um traficante famoso que Keith conheceu muito tempo atrás. Keith o encontra em [[station/76]], onde ele forneceu neuroalgas a toda a tripulação, uma droga com efeitos colaterais desagradáveis. Mkkt se lembra de Keith e fica curioso para saber por que ele não envelheceu.", false],
		[13, "", "Ao ouvir o relatório de Keith, [[character/3]] promete dar um jeito nele.", false],
	],
	"character/5": [
		[18, "", "Tommy é o Ten. Thomas Boyle, um cientista que trabalha para a Deep Science. [[character/1]] combina que ele encontre Keith em [[station/56]] e o guie até a estação de pesquisa secreta da organização.", false],
		[19, "", "Boyle é sequestrado por piratas perto de [[station/55]] antes do encontro, e eles exigem um resgate por ele.", false],
		[23, "", "Depois que Keith desativa a nave dos sequestradores, Boyle é resgatado. Ele dá a Keith as coordenadas do sistema [[system/6]] e viaja com ele até [[station/10]].", false],
	],
	"character/6": [
		[23, "", "A Dra. Paolini é a cientista da Deep Science que espera Keith e Boyle em [[station/10]].", false],
		[24, "", "A Dra. Carla Paolini lidera o projeto da Deep Science sobre os [[faction/9|Voids]]. Determinada e trabalhadora, ela insiste em ver os Voids com os próprios olhos e por isso voa com [[character/0]] em sua primeira missão de recolhimento de destroços. Keith se sente atraído por ela desde o primeiro encontro.", false],
		[26, "", "Ela e Keith são puxados por um buraco de minhoca até o setor de origem dos Voids e escapam juntos por pouco.", false],
		[28, "", "Sua equipe constrói uma sonda para analisar a nave-mãe dos Voids. Ela aceita sair com Keith se ele voltar vivo da missão.", false],
		[34, "", "Ocupada demais com a pesquisa para cumprir o encontro, ela elabora com [[character/1]] um plano para atacar a nave-mãe.", false],
		[44, "Depois", "Depois da vitória, ela se junta a Keith e Brent em [[station/98]] para o encontro tão adiado.", false],
		[45, "", "Na manhã seguinte ela se foi, deixando um bilhete: partiu para outro projeto secreto e pede a Keith que não a procure.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] é um comandante [[faction/1]] responsável por [[station/29]], no sistema [[system/5]]. Ele fornece o cargueiro K'Sarr para o ataque à nave-mãe dos Voids, em troca de prisioneiros.", false],
		[36, "", "Orgulhoso e formal, ele acredita que só um vossk sabe pilotar direito uma nave vossk e insiste em pilotar o cargueiro pessoalmente. Ele põe à prova a habilidade de Keith antes de aceitá-lo como escolta.", false],
		[37, "", "Depois que Keith o vence em uma disputa em um esconderijo pirata, Errkt passa a tratá-lo com respeito.", false],
		[40, "", "Antes da missão ele está calmo e reservado, o que Brent interpreta como determinação.", false],
		[42, "Morte", "Errkt pilota o cargueiro através do buraco de minhoca e contra a nave-mãe. Quando sua cápsula de fuga é destruída, ele se recusa a voltar e morre na explosão, depois de mandar Keith para um lugar seguro.", false],
		[43, "", "Brent promete relatar seu sacrifício ao Império Vossk.", false],
	],
	"character/8": [
		[40, "", "O Ten. [[character/8]] lidera o esquadrão de reforços que se junta a Keith para proteger o cargueiro vossk a caminho do buraco de minhoca.", false],
		[41, "", "Seu esquadrão não consegue atravessar o buraco de minhoca antes que ele se feche, então Keith e [[character/7]] enfrentam os Voids sozinhos.", false],
	],
	"chart": [
		[0, "", "O mapa da galáxia lista todos os sistemas com sua facção, nível de segurança, número de estações e posição no mapa. A posição é dada por dois números de 0 a 100: o primeiro conta a partir da borda esquerda do mapa estelar, o segundo a partir do topo. Sistemas com números parecidos ficam próximos uns dos outros.", false],
		[0, "", "No jogo, abra o mapa estelar a partir de uma estação ou durante o voo. Uma linha tracejada liga o seu sistema atual a todos os sistemas que o portal de salto dele alcança; as demais rotas de portal aparecem como linhas finas. As estrelas que você pode alcançar agora ficam brilhantes, as outras ficam esmaecidas. Marcadores indicam o sistema da sua missão da história e do seu trabalho atual, e uma linha colorida tracejada mostra a rota de portais mais curta até lá. Uma linha dourada desbotada traça suas últimas viagens.", false],
		[0, "", "Selecione um sistema para ver sua facção, nível de segurança e distância. Aproxime para ver as estações, o nível tecnológico delas e marcadores para estações que você visitou, objetivos de missão e o portal de salto. Sistemas ocultos não aparecem até você descobrir as coordenadas deles; veja [[world/galaxy]].", false],
		[32, "", "Depois que você recebe o sistema de alerta antecipado em [[step/31]], o mapa estelar também marca o sistema e a estação onde o próximo buraco de minhoca dos Voids vai se abrir.", false],
	],
	"faction/0": [
		[0, "", "Os terranos são humanos, e [[character/0]] é um deles. Eles controlam dez sistemas, mais do que qualquer outra facção, espalhados pelo centro, pelo lado direito e pela parte de baixo do mapa, com [[system/19]] e [[system/14]] como núcleo. O espaço terrano é a parte mais segura da galáxia: os dois sistemas Seguros são terranos.", false],
		[0, "", "As estações terranas vendem a maior variedade de naves e equipamentos. Os vendedores de naves fora do espaço vossk oferecem uma ampla gama de cascos. Os rivais tradicionais dos terranos são os [[faction/1]]: a reputação ganha com um é perdida com o outro.", false],
		[16, "", "A Frota Espacial Terrana ainda é a força em que [[character/0]] serviu, mas 35 anos se passaram. Quando ele finalmente encontra um comboio terrano, o comboio confunde sua velha nave de origem pirata com um inimigo e o prende.", false],
		[18, "", "Os terranos lideram a defesa contra os Voids. [[character/1]], agora chefe da Agência de Segurança Interestelar, preside uma equipe de crise, e o grupo de pesquisa Deep Science trabalha no problema a partir de uma estação secreta.", false],
	],
	"faction/1": [
		[0, "", "Os vossk são um povo alienígena organizado como um império. Eles controlam seis sistemas no canto inferior direito do mapa, de [[system/3]] e [[system/12]] até o remoto [[system/21]]. Quatro deles são classificados como Perigosos ou Arriscados. [[system/10]] não tem nenhuma conexão por portal.", false],
		[0, "", "Os vendedores de naves vossk vendem um único casco, a [[ship/9]], um modelo adaptado para outras raças. As estações vossk também oferecem armas e equipamentos que não se encontram em nenhum outro lugar. Os vossk são os rivais tradicionais dos [[faction/0|terranos]], por isso suas naves podem se juntar aos atacantes no espaço terrano, e vice-versa.", false],
		[18, "", "As relações entre os terranos e o Império Vossk continuam frias e imprevisíveis, mas os ataques dos Voids também atingem sistemas vossk.", false],
		[36, "", "Na história, os vossk se mostram orgulhosos e presos à honra. O comandante deles, [[character/7]], insiste em pilotar pessoalmente o cargueiro com a bomba e põe [[character/0]] à prova em uma disputa antes de aceitá-lo como escolta.", false],
		[42, "", "[[character/7]] dá a vida para destruir a nave-mãe dos Voids, e os terranos prometem relatar seu feito ao Império Vossk.", false],
	],
	"faction/2": [
		[0, "", "Os nivelianos são um povo alienígena que controla quatro sistemas no lado esquerdo do mapa: [[system/2]], [[system/9]], [[system/17]] e o oculto [[system/0]]. Suas estações vão de pequenos postos avançados a algumas das mais avançadas da galáxia. Seus rivais são os [[faction/3|midorianos]].", false],
		[2, "", "A primeira pessoa que [[character/0]] encontra é um niveliano, o comerciante de minério [[character/2]]. [[character/0]] não tem boa opinião sobre os modos nivelianos, enquanto [[character/2]] insiste que é um homem de negócios honesto.", false],
		[11, "", "Uma guerra civil niveliana deu origem à [[faction/3|Confederação Mido]]. Os nivelianos nunca aceitaram sua independência e ainda reivindicam o sistema [[system/15]].", false],
		[35, "", "O plano contra a nave-mãe dos Voids depende de explosivos nucleares nivelianos.", false],
	],
	"faction/3": [
		[0, "", "Os midorianos são o povo da [[faction/3|Confederação Mido]]. Eles controlam dois sistemas no canto superior esquerdo do mapa, [[system/15]] e [[system/4]], ambos classificados como Perigosos. Suas estações são em geral pequenas e de baixo nível tecnológico. Seus rivais são os [[faction/2|nivelianos]].", false],
		[11, "", "A Confederação foi fundada por refugiados e foras da lei terranos e nivelianos durante a Guerra Civil Niveliana. Ela mantém o mínimo de contato com outros sistemas. [[character/3]], comandante de [[station/79]], é um de seus membros, assim como [[character/2]].", false],
		[38, "", "A Confederação não é amiga dos nivelianos. Suas naves capturam o comboio que transporta os explosivos nivelianos destinados à nave-mãe dos Voids, e [[character/0]] precisa recuperá-lo perto de [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Os multípodes são uma raça menor sem sistemas próprios. O único multípode que você encontra é o agente [[agent/6]], que vende um projeto no lounge de [[station/61]], no sistema [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Os ciborgues não têm território. O único ciborgue do jogo é o agente [[agent/14]], no lounge de [[station/65]], que negocia as coordenadas de um sistema oculto.", false],
	],
	"faction/6": [
		[0, "", "Os bobolianos são uma raça menor sem sistemas próprios. O agente [[agent/13]], um boboliano, fica no lounge de [[station/26]], no espaço vossk, e vende as coordenadas de um sistema oculto.", false],
	],
	"faction/7": [
		[0, "", "Os Grey são uma raça sem sistemas, estações ou naves próprios. Eles não têm nenhum papel no comércio nem no combate.", false],
		[32, "", "O único Grey da história é [[character/20]], um cientista que trabalha com a Deep Science.", false],
		[33, "", "Ele estuda os restos das naves dos Voids e desenvolve a partir deles um novo tipo de propulsor.", false],
	],
	"faction/8": [
		[0, "", "Os piratas são foras da lei de todas as raças. Eles não controlam sistemas, mas aparecem em toda parte e são sempre hostis. A frequência com que ficam de tocaia perto de uma estação depende do nível de segurança do sistema. Muitos trabalhos freelance pedem que você os cace, e os destroços de suas naves podem ser saqueados em busca de carga.", false],
		[0, "", "A história começa com [[character/0]] perseguindo uma gangue de piratas pela recompensa por suas cabeças.", false],
		[2, "", "A [[ship/0]], a nave que [[character/2]] empresta a [[character/0]], já foi uma nave pirata.", false],
		[16, "", "É por isso que os terranos mais tarde o confundem com um pirata.", false],
		[19, "", "Piratas também sequestram [[character/5]] perto de [[station/55]] e exigem um resgate.", false],
	],
	"faction/9": [
		[0, "", "Os Voids são uma força hostil que ataca sem aviso. Eles não controlam nenhum sistema do mapa, e suas naves abrem fogo contra todos. O caça deles, a [[ship/8]], é o casco com a blindagem mais pesada do jogo. Veja [[world/voids]].", false],
		[2, "", "Em [[system/15]], os Voids são conhecidos apenas por boatos e por raros avistamentos.", false],
		[16, "", "Um esquadrão dos Voids ataca [[station/98]] enquanto [[character/0]] está lá. Suas mensagens de rádio alegam intenções pacíficas enquanto eles atiram.", false],
		[18, "", "Os Voids chegam por buracos de minhoca que se abrem perto das estações por pouco tempo. Eles atacam igualmente sistemas terranos, nivelianos e vossk e parecem estar atrás de minério. Ninguém sabe de onde vêm.", false],
		[24, "", "Perto de [[station/48]], eles transmitem uma afirmação mais estranha: que vêm do futuro e que são tudo o que resta das civilizações da galáxia.", false],
		[26, "", "Um buraco de minhoca leva ao setor deles, onde uma enorme nave-mãe lança seus caças.", false],
		[35, "", "A nave-mãe parece ser a origem dos buracos de minhoca.", false],
		[42, "", "A destruição da nave-mãe em [[step/41]] fecha os buracos de minhoca e põe fim aos ataques, pelo menos por enquanto.", false],
	],
	"guide/basics": [
		[0, "A abertura", "Um novo jogo começa no espaço, e não em uma estação. [[character/0]] está perseguindo um bando de piratas por um campo de asteroides, e o primeiro voo é um combate curto que ensina a pilotar, mirar e atirar. Enquanto ele dura, só a mira e os marcadores de naves aparecem na tela. Destrua os piratas e deixe a cena seguir; depois disso, a história avança sozinha.", false],
		[2, "", "Depois da abertura, você acorda em [[station/78]], uma pequena estação de mineração administrada por [[character/2]]. Ele lhe empresta a [[ship/0]], uma nave desarmada com um laser de mineração, e as primeiras etapas ensinam a minerar, usar o piloto automático e atracar. As armas, o mapa e o resto da estação são liberados conforme a história avança.", false],
		[0, "Atracar", "Para atracar, mantenha a mira sobre uma estação até travar e pressione Atirar: o piloto automático assume e leva você para dentro. Você também pode entrar na estação por conta própria; a nave atraca no instante em que toca o casco. É ao atracar que acontece a maior parte da contabilidade. Seu casco, blindagem e escudos são restaurados de graça, entregas e passageiros são repassados, os produtos de projetos concluídos são recolhidos, novas medalhas são concedidas e o jogo salva automaticamente.", false],
		[0, "Telas da estação", "Uma estação em que você atracou oferece seis seções: Hangar, Space Lounge, Mapa, Missions, Status e Game Options. No início da história, algumas delas ficam bloqueadas e aparecem com um cadeado. O Hangar é liberado em [[step/5]], o Mapa em [[step/9]], e o Space Lounge e Missions em [[step/13]]. Status e Game Options estão sempre disponíveis.", false],
		[0, "", "O Hangar reúne a loja (Shop: compra e venda de mercadorias e equipamentos), Nave (instalar e remover equipamentos), Naves (o vendedor de cascos, nas estações que têm um) e Projetos (produção). O Space Lounge é onde esperam clientes, negociantes e pilotos de aluguel. O Mapa mostra a galáxia e permite escolher um destino. Missions lista o objetivo atual da história e o trabalho freelance que você aceitou. Status mostra seu histórico de piloto, sua reputação com as quatro grandes raças e suas medalhas. A barra superior mostra o Tec Level (nível tecnológico) da estação, que define o que a loja pode ter em estoque.", false],
		[0, "Saindo de uma estação", "Pressione Depart para decolar. Cada voo começa com alguns segundos mostrando sua nave partindo, com os dados do sistema e uma dica; qualquer tecla, clique ou toque pula essa cena. Se você escolheu um destino no Mapa antes de sair, o piloto automático traça o curso até ele assim que a decolagem termina. Não é possível sair com mais carga do que o porão comporta, então venda ou instale o excedente antes.", false],
		[0, "Salvar", "O jogo salva automaticamente depois de cada atracação concluída, quando as recompensas e a próxima etapa da história já foram resolvidas. Você também pode salvar manualmente em um de três espaços pelo Game Options enquanto está atracado, e carregar qualquer espaço ou o salvamento automático por ali ou pela tela de título. Fora da versão para navegador, o Game Options também permite exportar um salvamento para um arquivo e importá-lo de volta. Os salvamentos pertencem aos dados de jogo com que foram criados.", false],
		[0, "", "Se sua nave for destruída, o voo termina e você continua a partir da estação do seu último salvamento automático, ou recomeça se não houver nenhum. Tudo o que você conquistou desde aquela atracação é perdido, então atraque de vez em quando durante viagens longas.", false],
		[0, "Nível do piloto", "Seu piloto tem um nível, mostrado na tela Status. A experiência vem de abates, trabalhos freelance (cada um vale dois pontos), núcleos minerados, cada cinquenta toneladas de minério extraídas e cada dois alas contratados. O nível sobe um ponto sempre que a experiência passa de 1,3 vez o valor que tinha na última subida, e isso é verificado quando você atraca. Um nível mais alto deixa os inimigos mais fortes, mas também aumenta as recompensas freelance e o preço dos pilotos de aluguel.", false],
	],
	"guide/blueprints": [
		[0, "Projetos", "Algumas das melhores armas e equipamentos nunca são vendidos em lojas. Em vez disso, são fabricados a partir de projetos. Um projeto lista as mercadorias necessárias e em que quantidades. Os projetos são comprados de agentes com nome no Space Lounge, que aparecem depois que a história passa de [[step/16]]; cada agente vende um projeto, uma única vez.", false],
		[34, "", "O projeto do motor de salto [[item/85]] não é vendido por ninguém: a história o entrega em [[step/34]].", false],
		[0, "Produção", "A produção acontece na aba Projetos do Hangar. Escolha um projeto e entregue ingredientes do seu porão. Você pode entregá-los em partes, ao longo de várias visitas. A estação onde você faz a primeira entrega passa a ser a estação de produção daquele lote. Ingredientes entregues em qualquer outra estação são enviados para lá por 10 créditos por tonelada, então compensa levar tudo para o mesmo lugar.", false],
		[0, "Produtos acabados", "Quando o último ingrediente é entregue, o lote fica pronto. As armas secundárias são fabricadas de dez em dez; todo o resto, uma unidade por vez. Se você concluir na estação de produção, os produtos vão direto para o porão, mesmo que isso o deixe lotado além da conta. Caso contrário, eles ficam esperando na estação de produção e são entregues na próxima vez que você atracar lá. Um projeto nunca se esgota: depois que um lote fica pronto, você pode começar o seguinte.", false],
		[0, "Medalhas", "Possuir projetos conta para [[medal/13]], e concluir projetos diferentes conta para [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Armas primárias", "As armas primárias são canhões fixos que atiram para a frente: lasers, blasters, autocanhões e armas térmicas. Cada uma tem seu próprio dano, cadência de tiro, alcance e velocidade de projétil, e todas as primárias instaladas atiram juntas. Alguns blasters, como o [[item/16]], são armas de EMP que drenam a energia de uma nave em vez do casco. O Tiro automático mantém as armas disparando contra o alvo sem precisar segurar o botão.", false],
		[0, "Escudos, blindagem e casco", "O dano primeiro esgota o escudo, depois a placa de blindagem e só então o próprio casco. Um escudo se recarrega por completo ao longo do seu tempo de recarga; a blindagem e o casco não. Um robô de reparos conserta lentamente o casco e a blindagem durante o voo. Atracar restaura tudo de graça. Quando o casco acaba, a nave é destruída.", false],
		[0, "EMP", "Toda nave tem uma reserva de energia. As armas de EMP a drenam, e uma nave cuja energia se esgota fica desativada: ela fica à deriva, indefesa, até a energia se recompor. Uma nave desativada pode ter sua carga roubada com um raio trator, e alguns trabalhos exigem que uma nave seja desativada em vez de destruída. Equipamentos de proteção contra EMP, como o [[item/60]], têm um valor de defesa contra EMP.", false],
		[0, "Armas secundárias", "As armas secundárias disparam dos espaços secundários e consomem munição, que se acumula no espaço. Os foguetes voam em linha reta. Os torpedos seguem o travamento do radar pouco depois do lançamento. Bombas de EMP e bombas nucleares explodem sobre uma área e atingem tudo dentro do raio da explosão, com menos força perto da borda; as bombas de EMP não afetam asteroides, enquanto as nucleares os despedaçam. Escolha qual lançador usar pelo menu Ações; até você escolher, a tecla Arma secundária dispara o primeiro carregado.", false],
		[0, "Torretas", "Cascos maiores têm espaços para torretas. Com uma torreta instalada, a tecla Visão traseira passa para a visão da torreta: a nave mantém o curso enquanto você gira a torreta e atira com ela, o que permite revidar contra naves na sua cola.", false],
		[0, "Alas", "A partir de [[step/16]], é possível encontrar pilotos de aluguel no Space Lounge. Um contrato cobre de uma a três naves por dez minutos de voo, e elas voam com você aonde for até o contrato acabar. Dê ordens a elas pelo menu Ações: atirar à vontade, atacar seu alvo, proteger o próximo ponto de missão ou alternar entre o laser e o blaster de EMP delas. Veja [[guide/lounge]].", false],
		[0, "Piratas", "Os piratas atacam estações, com mais frequência em sistemas perigosos, e ficam de tocaia à espera de pilotos que levam frete ou passageiros. Muitos trabalhos freelance consistem em combatê-los. Atirar em piratas não irrita ninguém; isso melhora um pouco sua reputação com a raça que governa o sistema.", false],
		[0, "Reputação", "Sua reputação é registrada em duas escalas, cada uma de -100 a 100: uma entre as raças [[faction/0]] e [[faction/1]], a outra entre as raças [[faction/2]] e [[faction/3]]. Prejudicar uma raça move a escala em direção à rival: desativar ou roubar uma de suas naves custa 2 pontos, e um abate custa 5. Concluir um trabalho freelance move a escala 2 pontos em direção à raça do cliente. Quando uma escala passa de 60 em qualquer direção, a raça do lado perdedor se torna hostil, e suas naves atacam você assim que o veem.", false],
		[0, "", "Uma raça hostil envia um diplomata aos Space Lounges, que se oferece para zerar a escala mediante uma taxa que cresce conforme o quanto ela avançou: no máximo 16.000 créditos. A tela Status mostra as duas escalas. Levar uma escala além de 60 também rende [[medal/28]].", false],
		[0, "Fogo amigo", "As naves da própria raça de um sistema toleram tiros perdidos só até certo ponto. Depois que você tira um terço do casco ou da energia de uma nave local, ela revida e avisa você pelo rádio. Ao chegar a dois terços do casco, ou quando você a desativa, todas as naves daquela raça no sistema se voltam contra você. As naves de outras raças são menos sensíveis, mas um abate sempre custa reputação.", false],
	],
	"guide/fitting": [
		[0, "Cascos", "O casco de uma nave define sua blindagem (a resistência do próprio casco), seu porão de carga, sua manobrabilidade e seus espaços: armas primárias, armas secundárias, torretas e equipamentos. Um casco melhor significa principalmente mais espaços. As páginas de naves comparam todos os cascos.", false],
		[0, "Espaços e a tela Nave", "Os itens comprados vão para o porão e depois são instalados na tela Nave, no Hangar. Cada espaço aceita um item da sua categoria; instalar algo em um espaço ocupado devolve o item antigo ao porão. Cada tipo de equipamento só pode ser instalado uma vez, exceto os tipos empilháveis, como unidades de compressão de carga, cabines e proteção contra EMP, dos quais é possível instalar vários, cada um em seu próprio espaço. A munição secundária de um mesmo tipo divide um único espaço. Um item instalado também pode ser vendido direto do espaço, pelo preço da estação.", false],
		[0, "Tipos de equipamento", "Os escudos absorvem dano e se recarregam. As placas de blindagem aumentam a resistência do casco. A proteção contra EMP protege contra a drenagem de energia. A compressão de carga amplia o porão. Os raios tratores puxam a carga de destroços e naves desativadas; sem um deles, nada pode ser recolhido no espaço. Os turbos dão explosões de velocidade. Os robôs de reparos consertam a nave durante o voo. Os bocais de direção melhoram a manobrabilidade. Os scanners reduzem o tempo para travar um alvo, e os melhores mostram a carga do alvo. Os lasers de mineração perfuram asteroides. As cabines transportam passageiros. Os dispositivos de camuflagem escondem a nave por um tempo. Um motor de salto viaja sem portais.", false],
		[0, "Comprar um casco", "As estações com vendedor mostram uma aba Naves no Hangar com até cinco cascos à venda. Os vendedores [[faction/1]] oferecem apenas o casco da própria raça, a [[ship/9]]. Um vendedor desconta do preço de tabela uma porcentagem igual ao nível tecnológico da estação, então estações de alta tecnologia vendem cascos mais baratos. Seu casco antigo é aceito como parte do pagamento por quatro quintos do preço de tabela. Tudo o que estava instalado vai para o porão, então verifique se cabe ou venda algo antes de sair. Não é possível trocar de casco com passageiros a bordo, e as cabines não podem ser removidas enquanto estão em uso.", false],
		[5, "Primeiras armas", "Quando o hangar de [[station/78]] é liberado pela primeira vez, a prateleira tem um laser, um autocanhão e uma placa de blindagem, de graça. Instale uma arma e a placa antes de partir para a próxima missão.", false],
		[0, "Cascos raros", "Alguns cascos nunca são oferecidos por vendedores comuns. Um piloto que conquistou todas as medalhas em ouro recebe a oferta de um protótipo, a [[ship/8]], em [[station/10]]; veja [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Pilotagem", "A nave sempre voa para a frente. Você a vira para a esquerda e para a direita e levanta ou abaixa o nariz; quando você solta os controles, ela nivela as asas sozinha. A rapidez com que ela vira depende da manobrabilidade do casco e de algum bocal de direção instalado. Em Opções, Controles, a Resposta do leme pode ser Direta, que vira na taxa máxima de imediato, ou Suave, que entra e sai das curvas de forma gradual. Com a pilotagem com mouse, as teclas esquerda e direita podem deslocar a nave para o lado em vez de virá-la.", false],
		[0, "Acelerador", "Acelerar e Desacelerar mudam o acelerador em passos de um quarto, e manter a tecla pressionada continua mudando. A nave leva cerca de um segundo para se estabilizar na nova velocidade. O piloto automático e o turbo sempre voam com aceleração máxima, e reduzir o acelerador durante o turbo o encerra.", false],
		[0, "Turbo", "Com um turbo instalado, a tecla Turbo dá uma explosão de velocidade extra. Cada explosão dura o tempo de duração do turbo e é seguida de um tempo de recarga antes da próxima; o HUD mostra se ele está pronto. Turbos melhores são mais rápidos, duram mais ou recarregam antes. O turbo é útil para fugir de um combate e para percorrer as longas distâncias dentro de um sistema.", false],
		[0, "Piloto automático", "A tecla Piloto automático entrega o comando ao computador da nave, e pressioná-la de novo devolve o controle a você. Ele voa até o que estiver travado ou, se nada estiver, até o destino escolhido no Mapa: o portal de salto quando o destino fica em outro sistema, ou o planeta do destino quando fica neste. A Lista do piloto automático oferece as opções que existem onde você está: o destino programado, o portal de salto, esta estação, o campo de asteroides e o próximo ponto de missão. Voar até uma estação travada termina em atracação.", false],
		[0, "Velocidade do tempo", "A tecla Velocidade do tempo faz o voo correr mais rápido. A velocidade dupla está sempre disponível durante o voo. Quatro e oito vezes só são oferecidas enquanto o piloto automático está voando, não há inimigos por perto e nada mais está em andamento, como mineração, atracação ou salto.", false],
		[0, "Mira e travamento", "Para travar um objeto, mantenha-o sob a mira até o escaneamento terminar. O scanner instalado define quanto tempo isso leva, de vários segundos com um modelo básico a menos de dois com o melhor. Próximo alvo percorre os objetos próximos sem precisar mirar neles. Estações, portais de salto e as estrelas que marcam outros planetas travam com um único toque. O que Atirar faz depende do travamento: em uma nave, atira; em uma estação, atraca; em um portal, salta; em uma estrela, viaja até aquele planeta; e em um asteroide, começa a mineração. Scanners melhores também mostram a carga de uma nave travada.", false],
		[0, "Marcadores e radar", "As naves têm colchetes na tela, e setas na borda da tela apontam para o alvo, a estação e ameaças próximas fora do campo de visão. Inimigos são marcados em vermelho, aliados em verde, naves neutras em amarelo e pontos de missão em azul; a opção para daltônicos em Opções, Interface troca essas cores por inimigos em laranja e aliados em azul. Uma nave próxima mostra duas barrinhas ao lado do colchete: o casco e, em azul, a energia de EMP. A tela de voo Ampliada acrescenta placas com os números exatos e um radar circular; a tela Original mantém os painéis de canto do próprio jogo.", false],
		[0, "Olhar ao redor", "A Visão traseira vira a câmera para trás da nave. Se houver uma torreta instalada, a mesma tecla passa para a visão da torreta: a nave mantém o curso enquanto você gira a torreta e atira com ela. Você também pode olhar ao redor da nave sem pilotar segurando Alt e movendo o mouse, com o analógico direito do controle ou arrastando um dedo em um espaço livre da tela.", false],
		[0, "Camuflagem", "Um dispositivo de camuflagem esconde sua nave das outras naves enquanto dura, e quem estiver caçando você perde o rastro na hora. Pressione a tecla Dispositivo de camuflagem de novo para desligá-lo antes. Depois do uso, ele precisa de tempo para recarregar antes de funcionar outra vez.", false],
		[0, "Atracar e viajar", "Trave a estação e pressione Atirar, ou simplesmente entre nela, para atracar. As outras estações do sistema aparecem como estrelas brilhantes; trave uma e pressione Atirar para viajar até aquele planeta. A maioria dos sistemas tem um portal de salto, perto de uma de suas estações, para viajar a outros sistemas; veja [[guide/navigation]]. Enquanto houver um combate freelance em andamento em uma estação, você não pode atracar, viajar nem saltar até que ele seja vencido ou perdido.", false],
	],
	"guide/help": [
		[0, "Teclado", "Estas são as teclas padrão. Todas as ações de voo podem ser remapeadas em Opções, Controles, Teclado, onde Restaurar teclas padrão desfaz as alterações.", false],
		[0, "", "Virar à esquerda / Virar à direita: setas esquerda e direita, ou A e D.", true],
		[0, "", "Nariz para cima / Nariz para baixo: setas para cima e para baixo.", true],
		[0, "", "Acelerar / Desacelerar: W e S.", true],
		[0, "", "Atirar / usar: Espaço ou Ctrl. Dispara as armas, ou atraca, salta, viaja ou minera quando uma estação, portal, estrela ou asteroide está travado.", true],
		[0, "", "Arma secundária: E.", true],
		[0, "", "Turbo: Shift.", true],
		[0, "", "Piloto automático: Q. Lista do piloto automático: R. Com Segurar piloto automático para a lista ativado, segurar Q por meio segundo abre a lista.", true],
		[0, "", "Próximo alvo: Tab.", true],
		[0, "", "Tiro automático: F.", true],
		[0, "", "Visão traseira: C. Com uma torreta instalada, passa para a visão da torreta.", true],
		[0, "", "Ações / motor de salto: M. Abre o menu Ações: escolha da arma secundária, camuflagem, ordens aos alas e o motor de salto.", true],
		[0, "", "Mapa de rotas: N.", true],
		[0, "", "Dispositivo de camuflagem: V.", true],
		[0, "", "Velocidade do tempo: T.", true],
		[0, "", "Modo foto: P. Congela o voo e oculta a interface; arraste ou use as setas para girar a câmera e a roda do mouse ou + e - para dar zoom.", true],
		[0, "", "Menu de pausa: Escape. F11 alterna a tela cheia em sistemas desktop.", true],
		[0, "", "Nos menus, as setas movem entre as opções, Enter seleciona e Escape volta.", true],
		[0, "Mouse", "Com a Pilotagem com mouse ativada, mover o mouse pilota a nave. Durante o voo, o ponteiro fica capturado, então a nave vira conforme você o move; Capturar o ponteiro em voo pode ser desativado, e menus e pausas sempre liberam o ponteiro. O botão esquerdo atira, o direito lança a arma secundária, e segurar Alt enquanto move o mouse olha ao redor da nave. Enquanto o mouse pilota, as teclas esquerda e direita deslocam a nave para o lado; Teclas esquerda / direita, em Opções, Controles, pode fazê-las sempre deslocar para o lado (Sempre lateral) ou sempre virar (Sempre virar). A Sensibilidade do mouse define quanto a nave vira para cada movimento.", false],
		[0, "Controle", "O analógico esquerdo pilota e o direito olha ao redor da nave. RT ou RB atira, LB lança a arma secundária, A aciona o turbo, Y liga e desliga o piloto automático, X seleciona o próximo alvo, clicar no analógico direito dá a visão traseira ou da torreta, Back abre o menu Ações e Start pausa. Nos menus, o direcional move, A seleciona e B volta. Em Opções, Controles, Controle, você ajusta a zona morta do analógico e a vibração.", false],
		[0, "Toque", "Em telas sensíveis ao toque, os controles aparecem na tela quando Controles de toque está em Automático ou Sim. Um analógico de um lado pilota; por padrão, ele vai até o seu polegar onde quer que este toque naquele lado, e Analógico fixo o mantém no lugar. Pilotar de qualquer lugar permite que um dedo em qualquer parte livre da tela pilote. Os botões do outro lado cobrem Atirar / usar, Secundária, Turbo, Piloto automático, Alvo, Visão traseira, Ações, Pausa e, durante mensagens de rádio, Próximo rádio. Um controle deslizante ajusta o acelerador, e um botão Mais rápido acelera o tempo.", false],
		[0, "", "Toque em Atirar duas vezes rapidamente para ativar o tiro automático; um toque o interrompe. Arrastar um dedo em um espaço livre da tela olha ao redor da nave, e ao soltar a visão volta para a frente. Layout para canhotos troca os lados, Tamanho dos controles de toque muda a escala dos controles, e Ajustar posição dos controles permite mover cada um. Celulares e tablets também podem pilotar por inclinação: ative Pilotar inclinando, segure o dispositivo como ao jogar e calibre.", false],
		[0, "Opções", "Opções pode ser acessado pela tela de título, pelo menu de pausa e pelo Game Options em uma estação. Há cinco páginas. Áudio ajusta o volume da música e dos sons. Tela trata da janela, da taxa de quadros, da proporção de tela e das predefinições e detalhes gráficos. Controles trata da pilotagem, do mouse, do controle, do toque e das teclas do teclado. Interface trata do tamanho da interface, da tela de voo Original ou Ampliada, do tamanho e da opacidade do HUD, das janelas de ajuda, das sequências de decolagem e de entrada na estação, do radar circular, dos rótulos, do tamanho do texto e de opções de acessibilidade como cores para daltônicos, redução de clarões, tremor de tela e duração das mensagens. Jogo define o idioma do motor e permite importar outro arquivo de jogo ou gerenciar mods.", false],
		[0, "Ajuda", "A Ajuda, acessível dos mesmos lugares, mostra os tópicos de ajuda e as dicas de carregamento do próprio jogo, uma lista das teclas configuradas no momento e uma tabela que traduz as teclas de celular citadas nos textos do jogo para as teclas, botões e controles de toque usados aqui.", false],
	],
	"guide/jobs": [
		[0, "Encontrar trabalho", "Os trabalhos freelance são oferecidos por frequentadores do Space Lounge. O cliente descreve o serviço e o pagamento. Antes de aceitar um trabalho em outro lugar, você pode perguntar onde ele é e quão difícil será; também pode pedir para ouvir a oferta de novo ou recusá-la. Você só pode ter um trabalho por vez, e a tela Missions o mostra com o destino e a quantos saltos por portal ele fica.", false],
		[0, "Tipos de trabalho", "Existem treze tipos. Até [[step/16]], e em cópias do jogo sem a campanha completa, só cinco são oferecidos: [[job/11]], [[job/0]], [[job/7]], [[job/4]] e [[job/12]]. Depois aparece a variedade completa: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] e [[job/10]], além de compradores que querem mercadorias ([[job/8]]).", false],
		[0, "Dificuldade e recompensa", "Os primeiros trabalhos têm dificuldade um ou dois; os posteriores chegam a nove. A recompensa base de um trabalho é de 1.500 créditos mais até 5.500 conforme a dificuldade. Ela então aumenta com a distância até o destino (dobra a 1.200 km), e são somados 200 créditos por nível de piloto. A remoção de lixo paga 30 por cento menos, as escoltas pagam 20 por cento mais, a recuperação e o resgate pagam o dobro, e os trabalhos de passageiros pagam uma base menor mais um valor por passageiro. As recompensas são arredondadas para múltiplos de cinquenta créditos.", false],
		[0, "Realizar um trabalho", "Trabalhos de entrega e de passageiros são concluídos ao atracar no destino com o frete ou os passageiros a bordo. Trabalhos de compra são concluídos ao atracar de novo na estação do comprador com as mercadorias no porão. Todos os outros trabalhos são combates na estação de destino, preparados quando você chega lá; enquanto um deles está em andamento, você não pode atracar, viajar nem saltar. Contêineres recuperados e reféns precisam depois ser levados de volta à estação onde você aceitou o trabalho. Quando um trabalho é concluído, a recompensa é paga na hora, sua reputação com a raça do cliente melhora e o trabalho conta para [[medal/16]].", false],
		[0, "Fracasso", "Um combate fracassa se a condição dele for perdida: todas as naves que você protege são destruídas, o contêiner se perde, o tempo acaba ou o rival abate mais que você. Um trabalho fracassado é cancelado sem pagamento. Você também pode abandonar um trabalho pela tela Missions; o frete, se houver, é recolhido. Se sua nave for destruída, você continua a partir do último salvamento automático.", false],
	],
	"guide/lounge": [
		[0, "Frequentadores", "Toda estação tem um Space Lounge, liberado a partir de [[step/13]]. Lá ficam de três a cinco frequentadores, que mudam toda vez que você atraca. A maioria pertence à raça que governa o sistema, mas alguns vêm de qualquer lugar. Converse com um frequentador para saber o que ele quer; cada resposta e decisão conta para uma das medalhas de conversa.", false],
		[0, "Respostas", "\"OK\" aceita uma oferta, \"No, thanks\" a recusa e \"How was that again?\" a repete. Para um trabalho em outro lugar, você pode perguntar \"Can you show it on the map?\" para saber o destino e \"Will it be difficult?\" para saber quão difícil ele é. Os negociantes deixam você ver as mercadorias antes. Recusar ofertas, pedir repetições e aceitar sem perguntar contam para [[medal/32]], [[medal/33]], [[medal/34]] e [[medal/35]]; conversar com frequentadores que têm uma oferta conta para [[medal/26]].", false],
		[0, "Clientes e conversadores", "Muitos frequentadores oferecem trabalhos freelance; veja [[guide/jobs]]. Outros só conversam e passam adiante boatos, que às vezes citam estações ou minérios que vale a pena conhecer.", false],
		[0, "Negociantes e compradores", "Os negociantes vendem um único lote: um equipamento ou algumas unidades de uma mercadoria, por qualquer valor entre 40 e 160 por cento do preço normal. A partir de [[step/16]], também aparecem compradores, que pedem uma quantidade de um item a ser trazida para a mesma estação; veja [[job/8]].", false],
		[0, "Pilotos de aluguel", "A partir de [[step/16]], um frequentador por lounge pode oferecer alas: de um a três pilotos por um preço de 700 a 1.999 créditos por piloto, por dez minutos de voo. Pilotos [[faction/1]] nunca são contratáveis. Você só pode ter um grupo por vez. Um piloto que tem todas as medalhas encontra admiradores, que pagam para voar junto.", false],
		[0, "Agentes", "Depois que a história passa de [[step/16]], agentes com nome esperam em certas estações e fazem um único negócio cada. A maioria vende um projeto; quatro vendem as coordenadas de um sistema oculto, que então aparece no mapa. Cada agente vai embora depois do negócio. Os agentes têm suas próprias páginas.", false],
		[0, "Diplomatas", "Quando uma das quatro grandes raças se torna hostil, um de seus diplomatas fica em cada lounge. Por uma taxa que cresce conforme o quanto sua reputação caiu, até 16.000 créditos, o diplomata zera essa escala de reputação.", false],
	],
	"guide/medals": [
		[0, "Níveis", "A maioria das medalhas tem três níveis: bronze, prata e ouro. Cada nível tem sua própria meta, e alcançar um nível superior substitui a medalha inferior. Algumas medalhas têm um único nível. As páginas de medalhas mostram a meta de cada nível.", false],
		[0, "Quando as medalhas são concedidas", "Seu histórico é verificado quando você se aproxima de uma estação, antes de a atracação consertar sua nave, e medalhas novas ou melhoradas são anunciadas depois que você atraca. Nada é concedido em voo, então uma meta alcançada no espaço só conta na próxima atracação. A tela Status lista todas as medalhas que você tem, o nível de cada uma e o motivo da concessão.", false],
		[0, "A primeira e a última", "[[medal/0]] é sua desde o início do jogo. [[medal/36]] é concedida automaticamente quando você tem todas as outras medalhas.", false],
		[0, "Recompensas", "Ter todas as medalhas muda a forma como os pilotos do Space Lounge tratam você: admiradores pagam para voar ao seu lado como alas, em vez de cobrar. Ter todas as medalhas em ouro rende a oferta da [[ship/8]], um protótipo vendido em [[station/10]]. Na tela Status, [[character/0]] usa óculos escuros quando tem todas as medalhas, e óculos dourados quando todas elas são de ouro.", false],
	],
	"guide/mining": [
		[0, "Asteroides", "O espaço de cada estação tem asteroides em dois campos: um perto da estação e outro mais afastado, até onde a Lista do piloto automático pode levar você. Os minérios que um campo contém dependem da proximidade entre o sistema e o sistema de origem de cada minério, então nem todo minério é encontrado em toda parte. Os asteroides também podem ser destruídos a tiros; às vezes isso deixa um pouco de minério solto no espaço, e asteroides destruídos contam para [[medal/29]].", false],
		[0, "Começar a minerar", "Minerar exige um laser de mineração e espaço livre no porão. Trave um asteroide mantendo-o sob a mira e pressione Atirar. A nave voa até a rocha e a perfuração começa; o voo fica bloqueado até você terminar. O HUD mostra o minério e a classe do asteroide depois de travado.", false],
		[0, "A perfuração", "Um medidor mostra as camadas de rocha do asteroide empilhadas umas sobre as outras, cada uma mais estreita que a anterior. A broca desliza para um lado e muda de direção ao acaso a cada meio segundo a dois segundos e meio. Pilote para a esquerda e para a direita para mantê-la dentro da área verde da camada atual. A primeira camada leva seis segundos de perfuração, e cada camada mais profunda leva cerca de um sexto a menos de tempo que a anterior. O minério se acumula enquanto você permanece no verde, e mais rápido nas camadas profundas.", false],
		[0, "Zonas vermelhas", "O tempo passado fora da área verde conta como dano, e as zonas vermelhas do medidor crescem. Depois de dois segundos e meio no vermelho no total, o asteroide se despedaça e tudo o que foi extraído dele se perde. Pressione Atirar a qualquer momento para parar e ficar com o minério reunido até então. Cada asteroide só pode ser minerado uma vez.", false],
		[0, "Classes e núcleos", "Asteroides maiores têm mais camadas, de duas a sete. Os maiores, de classe A, têm todas as sete, e perfurar cada uma delas rende um núcleo além do minério. Núcleos valem muito mais que minério e contam para [[medal/3]] e [[medal/7]]. Minérios contam para [[medal/2]] e [[medal/6]].", false],
		[0, "Lasers de mineração", "Um laser de mineração tem dois valores. O rendimento faz a broca deslizar mais devagar e responder com mais precisão, o que facilita mantê-la no verde. A velocidade aumenta o ritmo de acúmulo do minério. Os lasers vão do [[item/86]] ao [[item/89]]; o [[item/90]] é fabricado a partir de um projeto.", false],
		[0, "Carga", "Minério e núcleos vão direto para o porão, e você só fica com o que couber. Quando o porão está cheio, o HUD avisa e você precisa vender ou descarregar em uma estação. Unidades de compressão de carga ampliam o porão em uma fração da capacidade do casco, e várias podem ser instaladas ao mesmo tempo. Um casco maior é o que mais ajuda.", false],
	],
	"guide/navigation": [
		[0, "O mapa da galáxia", "A seção Mapa de uma estação, e a tecla Mapa de rotas em voo, mostram a galáxia: cada sistema conhecido em seu lugar, as conexões por portal entre eles, a raça que governa e a segurança do sistema. Escolher um sistema dá zoom nele e mostra suas estações; escolher uma estação ali a define como seu destino. O mapa também mostra a distância até um sistema em quilômetros, marca as estações que você visitou e indica onde a história e seu trabalho atual continuam. Uma caixa de busca encontra estações conhecidas pelo nome. A página [[chart]] lista todos os sistemas.", false],
		[0, "", "No início da história, você fica preso à órbita da sua primeira estação. O mapa é liberado em [[step/9]], e depois disso você pode voar para os outros planetas do sistema.", false],
		[0, "Sistemas e segurança", "Cada sistema é governado por uma das quatro grandes raças e tem um nível de segurança: Seguro, Médio, Arriscado ou Perigoso. Ataques de piratas e de inimigos são muito mais frequentes em sistemas perigosos, enquanto os sistemas seguros são em geral tranquilos. A maioria dos sistemas tem várias estações, cada uma orbitando seu próprio planeta, com loja, lounge e nível tecnológico próprios.", false],
		[0, "Portais de salto", "As viagens entre sistemas passam por portais de salto. Um sistema tem no máximo um portal, que fica no espaço de uma de suas estações e só se liga a sistemas vizinhos. Para saltar, escolha um destino em um sistema vizinho no Mapa, voe até o portal (o piloto automático leva você), trave-o e pressione Atirar quando estiver dentro da zona dele. Viagens mais longas são feitas um portal de cada vez; a tela Missions mostra quantos saltos por portal um destino exige pelos sistemas que você conhece.", false],
		[0, "Sistemas ocultos", "Cinco sistemas não aparecem no mapa no início: [[system/0]], [[system/1]], [[system/6]], [[system/10]] e [[system/21]]. Um sistema oculto aparece depois que você esteve lá ou comprou suas coordenadas. Quatro agentes no Space Lounge as vendem: [[agent/12]] para [[system/0]], [[agent/13]] para [[system/1]], [[agent/14]] para [[system/10]] e [[agent/15]] para [[system/21]]. Os agentes com nome só aparecem depois que a história passa de [[step/16]]. [[system/10]] não tem nenhuma conexão por portal e só pode ser alcançado com um motor de salto.", false],
		[23, "", "O caminho até [[system/6]] é entregue a você pela história em [[step/22]].", false],
		[0, "Motor de salto", "Um motor de salto leva a nave diretamente a uma estação de qualquer sistema conhecido, sem portais. O único é o [[item/85]], que nunca é vendido em lojas e precisa ser fabricado a partir do seu projeto. Use-o pelo menu Ações durante o voo. Um salto não gasta combustível nem custa taxa. Ele não fica disponível enquanto houver um combate freelance em andamento na sua estação, mas trabalhos de entrega e de passageiros não o impedem.", false],
		[34, "", "A história lhe entrega o projeto do [[item/85]] em [[step/34]], com parte dos ingredientes já entregue.", false],
		[0, "Distância", "As distâncias entre sistemas são dadas em quilômetros, medidas a partir da posição dos sistemas no mapa. A distância importa para o comércio, porque os preços sobem conforme a distância da origem de um item, e para os trabalhos freelance, cuja recompensa aumenta com a distância até o destino.", false],
	],
	"guide/tips": [
		[0, "", "Leia a página de um item antes de uma viagem comercial: ela indica o sistema onde o item é mais barato e a direção em que ele fica mais caro.", true],
		[0, "", "As estações compram e vendem pelo mesmo preço, então uma carga só dá lucro depois de se afastar da sua origem.", true],
		[0, "", "Ao minerar, reaja na hora a cada mudança de deslizamento. O tempo no vermelho se soma ao longo de toda a perfuração, então pequenos deslizes custam tanto quanto um longo.", true],
		[0, "", "Se a broca já passou muito tempo no vermelho, pare com Atirar e fique com o que tem, em vez de perder toda a carga.", true],
		[0, "", "Procure os maiores asteroides quando quiser núcleos: só as rochas de classe A têm um, e só se você atravessar as sete camadas.", true],
		[0, "", "Instale cedo um raio trator. Sem ele, a carga de destroços e de naves desativadas não pode ser recolhida de jeito nenhum.", true],
		[0, "", "Um scanner melhor se paga em combate: ele trava alvos mais rápido, e os melhores mostram o que uma nave carrega antes de você atacá-la.", true],
		[0, "", "Atracar conserta sua nave de graça, então vale a pena parar em uma estação entre combates em vez de seguir com o casco danificado.", true],
		[0, "", "Atraque com regularidade em viagens longas. Só uma atracação concluída gera um salvamento automático, e uma nave destruída leva você de volta ao último.", true],
		[0, "", "Acompanhe sua reputação na tela Status. Tiros perdidos em naves locais se somam, e uma raça inteira pode se tornar hostil.", true],
		[0, "", "Pergunte ao cliente onde é o trabalho e quão difícil ele será antes de aceitar, a menos que esteja colecionando as medalhas por não perguntar.", true],
		[0, "", "Abra espaço no porão antes de aceitar um trabalho de entrega e instale cabines antes de um trabalho de passageiros: nenhum dos dois pode ser aceito sem o espaço.", true],
		[0, "", "Para trabalhos de recuperação e de resgate, leve uma arma de EMP, um scanner que mostre a carga, um raio trator e algum espaço livre no porão.", true],
		[0, "", "Leve todos os ingredientes de um projeto à estação onde você o iniciou e evite a taxa de envio.", true],
		[0, "", "Contrate alas pouco antes de um combate difícil: o contrato só corre enquanto você voa.", true],
	],
	"guide/trading": [
		[0, "Como os preços são definidos", "Cada item tem um preço mínimo, um preço máximo e um sistema de origem. Na origem, ele é vendido pelo preço mínimo; quanto mais longe da origem fica uma estação, maior o preço, até chegar ao preço máximo a uma distância definida. Além disso, cada estação aplica sua própria variação fixa de até cerca de cinco por cento para mais ou para menos. As páginas de itens mostram onde um item é mais barato e em que direção fica mais caro.", false],
		[0, "Comprar e vender", "Uma estação compra pelo mesmo preço que vende, então o lucro vem apenas de transportar mercadorias: compre perto da origem de um item e venda longe dela. As mercadorias que você vende vão para a prateleira da estação. A loja também guarda o menor e o maior preço que você viu para cada item, e em qual sistema, e os mostra ao lado do item. Algumas cargas não podem ser vendidas, como os fretes de entrega e os contêineres que você transporta para um cliente.", false],
		[0, "O que uma loja tem em estoque", "Cada estação tem um nível tecnológico. Sua prateleira contém itens desse nível ou abaixo; estações de nível quatro ou mais deixam de fora os itens abaixo da metade do seu próprio nível. Cada item também tem uma chance de estar em determinada prateleira, então as prateleiras mudam de uma visita para outra. Alguns itens estão sempre à venda em uma estação específica. Algumas mercadorias só são vendidas em sistemas [[faction/1]], e os produtos de projetos nunca são vendidos.", false],
		[0, "", "As mercadorias comuns aparecem em quantidades maiores, e em quantidades muito maiores perto da origem. Armas e equipamentos costumam vir de um a três por vez, enquanto foguetes, torpedos e bombas vêm em lotes maiores. A prateleira é reabastecida toda vez que você atraca, exceto nas últimas três estações que você visitou, que mantêm as prateleiras como você as deixou.", false],
		[0, "Bebidas", "Cada sistema tem sua própria bebida local, vendida apenas nele, como [[item/132]] em [[system/0]] ou [[item/146]] em [[system/14]]. As bebidas são mercadorias comuns. Comprá-las em lojas conta para [[medal/8]]; possuir tipos diferentes comprados de negociantes do lounge ou recuperados de destroços conta para [[medal/9]].", false],
		[0, "Outras fontes", "Os negociantes do Space Lounge oferecem lotes avulsos por qualquer valor entre 40 e 160 por cento do preço normal, então vale a pena comparar as ofertas. As naves carregam cargas que podem ser recolhidas com um raio trator quando são destruídas ou desativadas, e o minério pode ser extraído. Compradores no lounge pedem uma quantidade de um item específico e pagam bem acima do valor dele; veja [[job/8]].", false],
	],
	"home": [
		[0, "", "Esta referência trata de Galaxy on Fire 2, um jogo espacial de comércio, mineração, combate e exploração. Você pilota como [[character/0]], um piloto veterano perdido longe de casa, por 22 sistemas estelares controlados por humanos e raças alienígenas. Entre as missões da história, você pode aceitar trabalhos freelance, minerar asteroides, negociar mercadorias, fabricar equipamentos a partir de projetos e comprar naves cada vez melhores.", false],
		[0, "", "As páginas são montadas a partir do jogo que você importou. Nomes, números, preços e diálogos vêm dele, e as explicações que os acompanham foram escritas para esta referência. Detalhes da história além do ponto que o seu salvamento alcançou ficam ocultos até você chegar lá. Bons pontos de partida são [[world/galaxy]], o [[chart]] e [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Agentes são negociantes que ficam em determinados Space Lounges e vendem algo que não se compra em lojas: um projeto raro ou as coordenadas de um sistema oculto. Eles aparecem a partir de [[step/17]], e cada um vende apenas uma vez. Fale com eles no lounge da estação deles para ver a oferta; veja [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Os itens de projeto nunca são vendidos em lojas. Cada um é fabricado a partir de uma receita de mercadorias depois que você tem o projeto, que normalmente é comprado de um agente no Space Lounge. O funcionamento da produção é explicado em [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Estas são as pessoas que [[character/0]] conhece em sua jornada: comerciantes, oficiais, cientistas e companhias mais estranhas. Cada biografia cresce à medida que a história avança, então você só fica sabendo sobre um personagem o que o próprio Keith descobriu.", false],
	],
	"intro/equipment": [
		[0, "", "Os equipamentos ocupam os espaços de equipamento de uma nave: escudos e placas de blindagem para proteção, compressores de carga, raios tratores para recolher contêineres, turbos, bocais de direção, scanners, lasers de mineração, cabines de passageiros, dispositivos de camuflagem, um robô de reparos e o motor de salto. Cada peça ocupa um espaço, então o número de espaços limita o quanto uma nave pode ser completa. Os preços variam conforme o sistema, e as lojas só têm itens até o nível tecnológico da sua estação. Algumas das melhores peças são fabricadas a partir de projetos, e várias são feitas pelos [[faction/1|vossk]] e vendidas apenas nos sistemas deles.", false],
	],
	"intro/factions": [
		[0, "", "Dez facções aparecem no jogo. Quatro delas possuem sistemas e estações: os terranos, os vossk, os nivelianos e os midorianos. As outras não têm território e só aparecem como indivíduos ou como inimigos. Sua reputação com as quatro grandes potências é registrada em duas escalas, terranos contra vossk e nivelianos contra midorianos; veja [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Mercadorias são tudo o que se leva no porão para comerciar. Produtos e bebidas são comprados barato em um sistema e vendidos caro em outro (veja [[guide/trading]]); cada sistema tem sua própria bebida. Os minérios são extraídos de asteroides, e perfurar todas as camadas de um asteroide de classe A rende um núcleo de valor muito maior (veja [[guide/mining]]). Produtos, minérios e núcleos também são os ingredientes para fabricar itens a partir de projetos. Algumas mercadorias, como [[item/116]] e [[item/131]], só aparecem por meio de trabalhos ou da história e não podem ser compradas.", false],
	],
	"intro/guide": [
		[0, "", "Estas páginas explicam como o jogo funciona: voo e combate, mineração e comércio, as telas da estação, trabalhos freelance, produção e medalhas. Os números citados aqui seguem as regras do motor; as tabelas nas páginas de itens, naves e medalhas vêm dos dados do seu próprio jogo. Comece por [[guide/basics]] e [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Trabalhos freelance são serviços extras oferecidos por clientes no Space Lounge, de transportar frete a caçar criminosos procurados. Eles rendem créditos, reputação com a raça do cliente e experiência. Existem treze tipos; como eles são oferecidos e pagos é explicado em [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "As medalhas recompensam o histórico de um piloto: combate, mineração, comércio, viagens e até a forma como você conversa com as pessoas no Space Lounge. A maioria tem níveis de bronze, prata e ouro. Elas são verificadas sempre que você atraca; veja [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "As naves diferem em blindagem, espaço de carga, manobrabilidade e número de suportes: suportes primários para armas frontais, suportes secundários para foguetes, torpedos e bombas, um suporte de torreta opcional e espaços de equipamento para todo o resto. Os preços sobem muito, de menos de 20.000 créditos pelos cascos menores a vários milhões pelos melhores caças. Os vendedores fora dos sistemas [[faction/1|vossk]] mostram até cinco cascos a cada visita; os vendedores [[faction/1|vossk]] vendem apenas a [[ship/9]]. Um vendedor desconta do preço de tabela uma porcentagem igual ao nível tecnológico da estação e paga quatro quintos do preço de tabela pelo seu casco antigo. A [[ship/0]] e a [[ship/10]] nunca são vendidas. Veja [[guide/fitting]] para saber como equipar uma nave.", false],
	],
	"intro/stations": [
		[0, "", "Toda estação tem uma loja, um hangar, um vendedor de naves e um Space Lounge. Seu nível tecnológico, de 1 a 10, define quão avançados podem ser as mercadorias e os equipamentos à venda, e o vendedor desconta essa mesma porcentagem do preço de tabela das naves. O estoque muda a cada visita. As estações citadas na história ou que abrigam um agente têm uma breve descrição aqui.", false],
	],
	"intro/story": [
		[0, "", "A história acompanha [[character/0]], um piloto terrano cuja caçada a piratas dá muito errado, ao longo de 45 etapas. A página de cada etapa mostra a tarefa e, depois que você a conclui, o que aconteceu. As páginas revelam apenas o que o seu salvamento já alcançou; [[world/history]] conta a história até agora em um só lugar.", false],
	],
	"intro/systems": [
		[0, "", "A galáxia tem 22 sistemas estelares. Cada um pertence a uma facção, tem um nível de segurança que define com que frequência aparecem atacantes e abriga até cinco estações, uma das quais tem o portal de salto. As conexões por portal determinam entre quais sistemas você pode viajar; alguns sistemas são ocultos ou não têm nenhuma conexão. Veja [[world/galaxy]] e o [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "As armas se dividem em dois grupos. As armas primárias (lasers, blasters, autocanhões e armas térmicas) atiram sem munição a partir dos suportes frontais; elas diferem em dano por disparo, cadência de tiro e alcance. As armas secundárias (foguetes, torpedos, bombas de EMP e bombas nucleares) são compradas por unidade e disparadas dos suportes secundários. As torretas precisam de um suporte próprio e podem atirar em qualquer direção. Algumas armas drenam a energia de uma nave em vez de danificá-la, ou além disso; uma nave sem energia fica desativada por algum tempo. Várias das melhores armas nunca são vendidas em lojas e precisam ser fabricadas a partir de projetos (veja [[guide/blueprints]]). Muitos modelos são fabricados pelos [[faction/1|vossk]] e só estão à venda nos sistemas deles. Veja [[guide/combat]] para táticas.", false],
	],
	"intro/world": [
		[0, "", "Estas páginas descrevem a ambientação do jogo: a galáxia e sua disposição, sua história e as forças que a moldam. Elas complementam as páginas de sistemas, estações e facções com uma visão mais ampla.", false],
	],
	"item/0": [
		[0, "", "O [[item/0]] é o laser de entrada: 3 de dano por disparo a cada 0,4 s, com o alcance de 2.000 unidades comum a todos os primeiros lasers. É o laser mais fraco do jogo, mas é barato e quase toda loja o tem. O [[item/1]] e o [[item/2]] mantêm a mesma cadência de tiro e aumentam o dano.", false],
		[6, "", "É uma das três peças que [[character/2]] oferece de graça em seu hangar em [[station/78]] antes do ataque ao esconderijo dos piratas, junto com o [[item/22]] e o [[item/55]].", false],
	],
	"item/1": [
		[0, "", "O [[item/1]] é o segundo degrau da linha Nirai. Ele atira tão rápido quanto o [[item/0]] (a cada 0,4 s), mas causa 5 de dano por disparo em vez de 3, com o mesmo alcance. É uma melhoria barata até o [[item/2]] caber no orçamento.", false],
	],
	"item/10": [
		[0, "", "O [[item/10]] causa 34 de dano a cada 1,4 s, com alcance de 2.600. Ele bate mais forte por disparo que o [[item/9]] e alcança mais longe, com uma cadência um pouco mais lenta. É o laser mais forte vendido em lojas.", false],
	],
	"item/11": [
		[0, "", "O [[item/11]] é o laser mais forte do jogo: 45 de dano a cada 1,5 s, com alcance de 2.600, o disparo individual mais pesado de todas as armas primárias. Ele nunca é vendido pronto. Seu projeto vem de [[agent/0]], em [[station/3]], e fabricá-lo consome um [[item/9]] junto com [[item/155]] e várias mercadorias.", false],
	],
	"item/116": [
		[0, "", "Contêineres seguros são fretes lacrados que só aparecem em trabalhos freelance. Aceitar um trabalho de [[job/0]] coloca no seu porão a quantidade combinada, que ocupa espaço de carga; eles não podem ser vendidos e são entregues no destino. Eles também representam as mercadorias roubadas nos trabalhos de [[job/3]], em que a nave que os transporta precisa ser desativada em vez de destruída.", false],
	],
	"item/117": [
		[0, "", "Uma cabine segura é uma carga especial que só aparece em trabalhos freelance, nos trabalhos de [[job/5]] que pedem que você liberte um prisioneiro de uma entre várias naves e o traga de volta. Assim como um [[item/116]], ela não pode ser comprada nem vendida.", false],
	],
	"item/12": [
		[0, "", "O [[item/12]] é o blaster [[faction/1|vossk]] básico: 11 de dano a cada 0,6 s, com alcance de 1.500. Os blasters alcançam menos que os lasers, mas causam mais dano ao longo do tempo; até este primeiro modelo supera ligeiramente o melhor laser Nirai. Ele também é necessário para fabricar o [[item/15]]. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/13": [
		[0, "", "O [[item/13]] é um blaster [[faction/1|vossk]] que causa 12 de dano a cada 0,5 s, com alcance de 1.500, um avanço claro em relação ao [[item/12]] em cadência e dano. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/131": [
		[0, "", "Os [[item/131]] são os destroços de caças [[faction/9|Void]]. Cada nave [[faction/9|Void]] hostil destruída solta um contêiner com um a três deles, que só pode ser recolhido com um raio trator (veja [[item/68]]). Eles são vendidos pelo preço fixo de 199 créditos, e recolhê-los conta para a medalha [[medal/21]].", false],
		[24, "", "[[character/6]] precisa desses restos para sua pesquisa e envia [[character/0]] para recolhê-los perto de [[station/48]].", false],
		[25, "", "Enquanto [[character/0]] os leva de volta, os restos não podem ser vendidos.", false],
		[28, "", "Eles são entregues à equipe de [[character/6]] na chegada a [[station/10]].", false],
	],
	"item/14": [
		[0, "", "O [[item/14]] é um blaster [[faction/1|vossk]] que atira a cada 0,4 s, com 10 de dano. Ele causa um pouco mais de dano ao longo do tempo que o [[item/13]], mas seu alcance de 1.000 é curto, então convém a pilotos que se aproximam dos alvos. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/15": [
		[0, "", "O [[item/15]] é o melhor blaster [[faction/1|vossk]]: 10 de dano a cada 0,3 s, com alcance de 1.500. Ele combina a cadência dos blasters mais rápidos com o alcance do [[item/12]]. Ele nunca é vendido pronto. Seu projeto vem de [[agent/1]], em [[station/8]], e fabricá-lo consome um [[item/12]] e um [[item/166]], além de várias mercadorias.", false],
	],
	"item/154": [
		[0, "", "O [[item/154]] é o minério comum mais valioso. Os campos de asteroides favorecem minérios cujo sistema de origem fica por perto, e a origem dele é [[system/9]], onde ele também é mais barato. Ele é necessário em grande quantidade para fabricar o [[item/27]]. Perfurar até o fim um asteroide de [[item/154]] de classe A rende um [[item/165]].", false],
	],
	"item/155": [
		[0, "", "O [[item/155]] é um minério de preço intermediário cujo sistema de origem é [[system/21]], onde é vendido mais barato. É ingrediente do [[item/11]] e do [[item/90]]. Seu núcleo é o [[item/166]].", false],
	],
	"item/156": [
		[0, "", "O [[item/156]] é o minério mais barato, com origem em [[system/0]]. Seu baixo valor o torna uma carga ruim para vender, mas ele é ingrediente da placa de blindagem [[item/59]]. Seu núcleo é o [[item/167]].", false],
	],
	"item/157": [
		[0, "", "O [[item/157]] é um minério de preço intermediário cujo sistema de origem é [[system/7]]. Junto com seu núcleo, o [[item/168]], ele é necessário para fabricar a placa de blindagem [[item/59]].", false],
	],
	"item/158": [
		[0, "", "O [[item/158]] é um minério de preço intermediário cujo sistema de origem é [[system/4]]. É um dos minérios necessários para o [[item/85]]. Seu núcleo é o [[item/169]].", false],
	],
	"item/159": [
		[0, "", "O [[item/159]] é um minério de preço intermediário cujo sistema de origem é [[system/18]]. Nenhum projeto o usa, então ele é minerado apenas para venda ou para as medalhas de minério. Seu núcleo é o [[item/170]].", false],
	],
	"item/16": [
		[0, "", "O [[item/16]] é o primeiro blaster de EMP. Ele não causa dano ao casco nem à blindagem; em vez disso, cada acerto drena 3 pontos da energia de uma nave, e uma nave cuja energia chega a zero fica desativada por algum tempo. Armas de EMP são necessárias quando um alvo precisa ser parado em vez de destruído. Este modelo atira a cada 0,3 s, mas alcança apenas 1.200 unidades. O [[item/17]] e o [[item/18]] alcançam mais longe e drenam mais por disparo.", false],
	],
	"item/160": [
		[0, "", "O [[item/160]] é um minério de preço baixo cujo sistema de origem é [[system/13]]. É um dos minérios necessários para o [[item/85]]. Seu núcleo é o [[item/171]].", false],
	],
	"item/161": [
		[0, "", "O [[item/161]] é um minério de preço intermediário cujo sistema de origem é [[system/19]]. Nenhum projeto o usa. Seu núcleo é o [[item/172]].", false],
	],
	"item/162": [
		[0, "", "O [[item/162]] é um minério de preço intermediário cujo sistema de origem é [[system/14]]. Nenhum projeto o usa. Seu núcleo é o [[item/173]].", false],
	],
	"item/163": [
		[0, "", "O [[item/163]] é um minério de preço intermediário cujo sistema de origem é [[system/5]]. É o principal ingrediente do [[item/54]], que exige 80 t dele, e também é necessário para o [[item/85]]. Seu núcleo é o [[item/174]].", false],
	],
	"item/164": [
		[0, "", "Os [[item/164]] são um minério que nunca aparece nos campos de asteroides dos sistemas habitados. Ao contrário de outros minérios, um asteroide de cristal não deixa nada para trás quando é destruído a tiros, então os cristais precisam ser extraídos com a broca. Eles são o ingrediente principal do [[item/85]], que exige 50 deles.", false],
		[25, "", "Todos os asteroides no espaço de origem dos [[faction/9|Voids]], alcançado pelos buracos de minhoca deles, são feitos desses cristais.", false],
		[33, "", "[[character/20]] pede a [[character/0]] que lhe traga pelo menos 50 cristais, que ele acredita guardarem o segredo dos buracos de minhoca dos [[faction/9|Voids]].", false],
	],
	"item/165": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/154]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/9]]. É o núcleo mais valioso depois do [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/155]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/21]]. Ele é necessário para fabricar o [[item/15]] e, dez de cada vez, o [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/156]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/0]]. É o núcleo menos valioso.", false],
	],
	"item/168": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/157]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/7]]. São necessários quinze deles para fabricar o [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/158]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/4]].", false],
	],
	"item/17": [
		[0, "", "O [[item/17]] drena 5 de energia por acerto a cada 0,5 s e alcança 2.000 unidades, muito mais longe que o [[item/16]]. Ele não causa dano ao casco. Ele drena energia mais ou menos no mesmo ritmo que o Mk I, mas pode fazer isso de uma distância mais segura.", false],
	],
	"item/170": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/159]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/160]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/161]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/162]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Este núcleo é o raro centro de um asteroide de [[item/163]] de classe A. Ele é obtido perfurando todas as sete camadas desse asteroide, e de vez em quando um cai quando um asteroide de classe A é destruído a tiros. É vendido por várias vezes o preço do próprio minério, mais barato em [[system/5]].", false],
	],
	"item/175": [
		[0, "", "O [[item/175]] é o núcleo de um asteroide de [[item/164]] de classe A. Como os asteroides de cristal não deixam nada quando destruídos a tiros, a única forma de obtê-lo é perfurar todas as sete camadas. É vendido pelo preço fixo de 5.000 créditos, mais de cinco vezes o melhor preço de qualquer outro núcleo.", false],
		[25, "", "Ele só pode ser encontrado no espaço de origem dos [[faction/9|Voids]].", false],
	],
	"item/18": [
		[0, "", "O [[item/18]] é o blaster de EMP mais forte: 8 de energia por acerto a cada 0,5 s, com alcance de 2.000, o que desativa naves bem mais rápido que o [[item/17]]. Como os outros blasters de EMP, ele não causa dano ao casco.", false],
	],
	"item/19": [
		[0, "", "O [[item/19]] causa 15 de dano a cada 0,3 s, com alcance de 1.400. Ao longo do tempo, ele bate muito mais forte que qualquer laser. O [[item/20]] e o [[item/21]] atiram mais rápido, mas alcançam apenas 1.000 unidades.", false],
	],
	"item/2": [
		[0, "", "O [[item/2]] é o melhor laser Nirai: 7 de dano a cada 0,4 s. Cada disparo é mais fraco que os dos lasers Berger, mas, como ele atira cerca de duas vezes mais, causa mais dano ao longo do tempo que qualquer um deles, incluindo o [[item/8]]. Só os lasers de feixe M6 (o [[item/9]] e seus sucessores) claramente o superam.", false],
	],
	"item/20": [
		[0, "", "O [[item/20]] atira a cada 0,2 s, com 13 de dano. Ao longo do tempo, ele causa mais dano que o [[item/19]], mas seu alcance é de apenas 1.000 unidades, então funciona melhor a curta distância.", false],
	],
	"item/21": [
		[0, "", "O [[item/21]] causa 14 de dano a cada 0,2 s, o maior dano ao longo do tempo de todas as armas frontais. Como o [[item/20]], ele alcança apenas 1.000 unidades. Também é o blaster mais raro nas lojas.", false],
	],
	"item/22": [
		[0, "", "O [[item/22]] é a arma mais fraca do jogo: 2 de dano a cada 0,4 s, com alcance de 1.000. Os autocanhões disparam projéteis pequenos e rápidos; batem pouco, mas alguns modelos atiram muito rápido. Este primeiro modelo é só um quebra-galho.", false],
		[6, "", "É uma das três peças que [[character/2]] oferece de graça em seu hangar em [[station/78]] antes do ataque ao esconderijo dos piratas, junto com o [[item/0]] e o [[item/55]].", false],
	],
	"item/23": [
		[0, "", "O [[item/23]] dobra o dano do [[item/22]] para 4 por disparo e atira um pouco mais rápido (a cada 0,3 s), ainda com alcance de 1.000. É uma arma barata para o início.", false],
	],
	"item/24": [
		[0, "", "O [[item/24]] causa 6 de dano a cada 0,3 s, com alcance de 1.200. É um autocanhão sólido de categoria intermediária e iguala o dano ao longo do tempo do [[item/25]], que alcança mais longe.", false],
	],
	"item/25": [
		[0, "", "O [[item/25]] causa 8 de dano a cada 0,4 s e alcança 1.400 unidades, o maior alcance entre os autocanhões. Ao longo do tempo, causa o mesmo dano que o [[item/24]]. Ele nunca é vendido pronto. Seu projeto vem de [[agent/2]], em [[station/20]], e ele é fabricado só com mercadorias, sem minério.", false],
	],
	"item/26": [
		[0, "", "O [[item/26]] atira a cada 0,2 s, com 5 de dano e alcance de 1.000. Sua cadência rápida lhe dá mais dano ao longo do tempo que os railguns, à custa do alcance.", false],
	],
	"item/27": [
		[0, "", "O [[item/27]] atira a cada 0,1 s, a maior cadência entre os autocanhões, com 6 de dano por projétil. Seu dano ao longo do tempo se aproxima do dos melhores blasters, mas seu alcance de 900 é o menor de todas as armas. Ele nunca é vendido pronto. Seu projeto vem de [[agent/3]], em [[station/10]], e fabricá-lo exige [[item/154]], entre outras mercadorias.", false],
	],
	"item/28": [
		[0, "", "O [[item/28]] é a primeira arma térmica. As armas térmicas disparam tiros leves e rápidos com alcance de 1.000; esta causa 3 de dano a cada 0,3 s. Apesar do nível tecnológico alto, ela é mais fraca ao longo do tempo que a maioria dos blasters e autocanhões intermediários.", false],
	],
	"item/29": [
		[0, "", "O [[item/29]] causa 4 de dano a cada 0,2 s, com alcance de 1.000, o dobro do dano ao longo do tempo do [[item/28]].", false],
	],
	"item/3": [
		[0, "", "O [[item/3]] é um laser [[faction/1|vossk]] que causa 7 de dano a cada 0,5 s. Isso iguala o [[item/2]] por disparo, mas ele atira um pouco mais devagar, então fica um pouco atrás ao longo do tempo. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
		[0, "", "A [[ship/10]] de [[character/0]] leva dois deles na cena de abertura.", false],
	],
	"item/30": [
		[0, "", "O [[item/30]] atira a cada 0,1 s, com 3 de dano, a mais rápida das armas térmicas. Ao longo do tempo, causa mais dano que o [[item/29]], mas menos que os melhores blasters, como o [[item/21]].", false],
	],
	"item/31": [
		[0, "", "O [[item/31]] é o foguete [[faction/1|vossk]] básico e a munição secundária mais barata: 60 de dano por acerto, um lançamento a cada 1,2 s, alcance de 1.200. Os foguetes voam em linha reta e não seguem o alvo, então funcionam melhor a curta distância. Qualquer foguete ou torpedo que atinja um asteroide o despedaça. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/32": [
		[0, "", "O [[item/32]] é o foguete não guiado comum: 70 de dano por acerto, um lançamento a cada 0,9 s e alcance de 1.200. Ele bate mais forte e é lançado mais rápido que o [[item/31]], e é vendido em muitos lugares.", false],
	],
	"item/33": [
		[0, "", "O [[item/33]] causa 72 de dano e também drena 34 de energia, então pode tanto danificar quanto ajudar a desativar um alvo. Ele recarrega devagar (2 s) e alcança 1.000 unidades. Ele nunca é vendido pronto. Seu projeto vem de [[agent/4]], em [[station/43]], e um lote exige apenas algumas mercadorias baratas.", false],
	],
	"item/34": [
		[0, "", "O [[item/34]] serve para desativar, e não para destruir: ele drena 45 de energia e causa apenas 10 de dano por acerto, com um lançamento a cada segundo. O [[item/35]] drena mais e causa mais dano.", false],
	],
	"item/35": [
		[0, "", "O [[item/35]] drena 60 de energia e causa 30 de dano por acerto, com um lançamento a cada segundo e alcance de 1.000. Ele desativa naves mais rápido que o [[item/34]], enquanto continua desgastando o casco delas.", false],
	],
	"item/36": [
		[0, "", "O [[item/36]] é o torpedo básico. Os torpedos voam em linha reta durante os primeiros 1,5 s e depois perseguem o alvo. O [[item/36]] causa 70 de dano com alcance de 3.000 unidades, mas é lento e só é lançado a cada 3 s. O [[item/38]] dobra o dano dele.", false],
	],
	"item/37": [
		[0, "", "O [[item/37]] é o torpedo mais rápido: causa 100 de dano, drena 50 de energia e alcança 4.000 unidades. É lançado a cada 4 s. Ele nunca é vendido pronto. Seu projeto vem de [[agent/5]], em [[station/54]], e um lote exige apenas algumas mercadorias.", false],
	],
	"item/38": [
		[0, "", "O [[item/38]] é o torpedo que mais bate, com 140 de dano por acerto e alcance de 4.000. É lento em voo e é lançado a cada 4 s. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/39": [
		[0, "", "O [[item/39]] é um torpedo teleguiado para desativar naves: drena 100 de energia e não causa dano. Com alcance de 5.000, é uma forma barata de parar um alvo de longe. O [[item/40]] acrescenta 120 de dano à mesma drenagem de energia.", false],
	],
	"item/4": [
		[0, "", "O [[item/4]] é o laser [[faction/1|vossk]] mais forte: 10 de dano a cada 0,6 s. Seu dano ao longo do tempo é quase exatamente o do [[item/2]], com disparos mais pesados, porém menos frequentes, que os do [[item/3]]. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/40": [
		[0, "", "O [[item/40]] combina 120 de dano com uma drenagem de 100 pontos de energia em um único torpedo teleguiado, com alcance de 5.000 e um lançamento a cada 5 s. Custa mais que o dobro do [[item/39]].", false],
	],
	"item/41": [
		[0, "", "O [[item/41]] é a menor bomba de EMP. A bomba é lançada com um toque e detonada com um segundo; a explosão drena a energia de todas as naves dentro do raio, com mais força perto do centro, e poupa a nave que a lançou. Os asteroides não são afetados. Este modelo drena até 80 de energia em um raio de 22.000. O [[item/42]] e o [[item/43]] são mais fortes e mais amplos.", false],
		[20, "", "A segurança [[faction/0|terrana]] deixa dez dessas bombas de graça em [[station/55]], para que [[character/0]] possa desativar a nave dos sequestradores sem destruí-la.", false],
	],
	"item/42": [
		[0, "", "O [[item/42]] drena até 150 de energia em um raio de 30.000, quase o dobro da força do [[item/41]] e com uma explosão muito mais ampla.", false],
	],
	"item/43": [
		[0, "", "O [[item/43]] é a bomba de EMP mais forte: drena até 300 de energia em um raio de 37.000. Ele recarrega um pouco mais rápido que o [[item/42]], mas custa quase o dobro.", false],
	],
	"item/44": [
		[0, "", "O [[item/44]] é a menor bomba nuclear. Como uma bomba de EMP, ele é lançado e depois detonado com um segundo toque, mas sua explosão causa dano real: até 200 em um raio de 20.000, menos perto da borda. Ele também despedaça asteroides. A nave que o lança não sofre dano.", false],
	],
	"item/45": [
		[0, "", "O [[item/45]] causa até 560 de dano em um raio de 30.000, quase três vezes a potência do [[item/44]], em uma explosão mais ampla.", false],
	],
	"item/46": [
		[0, "", "O [[item/46]] é a arma mais destrutiva do jogo: até 950 de dano em um raio de 40.000. Ele nunca é vendido pronto. Seu projeto vem de [[agent/6]], em [[station/61]], e fabricá-lo exige materiais radioativos e explosivos, entre outras mercadorias.", false],
	],
	"item/47": [
		[0, "", "O [[item/47]] é a torreta básica. Uma torreta fica em um suporte próprio, que só alguns cascos têm, e pode girar por completo, então consegue atingir alvos ao lado ou atrás da nave; enquanto você mira com ela, a nave segue voando sozinha. Este modelo causa 6 de dano a cada 0,3 s, com alcance de 2.000, e gira devagar (manobrabilidade 40).", false],
	],
	"item/48": [
		[0, "", "O [[item/48]] causa 10 de dano a cada 0,2 s, com alcance de 2.500, e gira mais rápido que o [[item/47]] (manobrabilidade 60). Custa mais de três vezes mais.", false],
	],
	"item/49": [
		[0, "", "O [[item/49]] é a melhor torreta: 12 de dano a cada 0,1 s, com alcance de 3.000 e o giro mais rápido (manobrabilidade 100). Também é muito caro, custando cerca do dobro do [[item/48]]. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/5": [
		[0, "", "O [[item/5]] abre a linha de lasers Berger, que troca cadência de tiro por disparos mais pesados e um alcance um pouco maior (2.200). Ele causa 8 de dano a cada 0,9 s, o que dá menos dano ao longo do tempo que o [[item/2]], mais barato. Sua vantagem é o alcance maior.", false],
	],
	"item/50": [
		[0, "", "O [[item/50]] é o escudo básico. Um escudo absorve o dano recebido antes que a blindagem e o casco sofram qualquer dano, e se recarrega sozinho ao longo do seu tempo de carga. O Targe comporta só 50 pontos, mas se recarrega por completo em 20 s, mais rápido que qualquer outro escudo.", false],
	],
	"item/51": [
		[0, "", "O [[item/51]] comporta 80 pontos, mas precisa de 46 s para se recarregar por completo. Ele absorve mais que o [[item/50]] em um único combate, mas se recupera muito mais devagar entre os ataques.", false],
	],
	"item/52": [
		[0, "", "O [[item/52]] é um escudo [[faction/1|vossk]] que comporta 120 pontos e se recarrega em 58 s. Ele absorve muito mais que o [[item/51]], mas o [[item/53]] comporta mais e se recarrega mais rápido. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/53": [
		[0, "", "O [[item/53]] comporta 150 pontos e se recarrega em 45 s, então supera o [[item/52]] nos dois aspectos. É o melhor escudo vendido em lojas.", false],
	],
	"item/54": [
		[0, "", "O [[item/54]] é o escudo mais forte: 220 pontos, com recarga em 60 s. Ele nunca é vendido pronto. Seu projeto vem de [[agent/7]], em [[station/72]], e fabricá-lo exige uma grande quantidade de [[item/163]], além de eletrônicos, nanotecnologia e microchips.", false],
	],
	"item/55": [
		[0, "", "O [[item/55]] é a placa de blindagem básica. Uma placa soma seus pontos à blindagem da nave; depois do escudo, ela recebe o dano antes do casco e, ao contrário do escudo, não se recarrega. A E2 acrescenta 40 pontos, uma boa parcela para uma nave inicial leve como a [[ship/32]], que tem 100 próprios.", false],
		[6, "", "É uma das três peças que [[character/2]] oferece de graça em seu hangar em [[station/78]] antes do ataque ao esconderijo dos piratas, junto com o [[item/0]] e o [[item/22]].", false],
	],
	"item/56": [
		[0, "", "O [[item/56]] acrescenta 80 pontos de blindagem, o dobro do [[item/55]], por um preço modesto.", false],
	],
	"item/57": [
		[0, "", "O [[item/57]] acrescenta 110 pontos de blindagem. É a melhor placa vendida fora dos sistemas [[faction/1|vossk]].", false],
	],
	"item/58": [
		[0, "", "O [[item/58]] é uma placa [[faction/1|vossk]] que acrescenta 160 pontos de blindagem, muito mais que o [[item/57]]. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/59": [
		[0, "", "O [[item/59]] é a melhor placa de blindagem: acrescenta 250 pontos, tanto quanto a blindagem básica da [[ship/9]] e mais que a de qualquer outro casco, exceto a [[ship/8]]. Ele nunca é vendido pronto. Seu projeto vem de [[agent/8]], em [[station/84]], e fabricá-lo exige [[item/157]], [[item/168]] e [[item/156]], além de mercadorias.", false],
	],
	"item/6": [
		[0, "", "O [[item/6]] causa 9 de dano a cada 0,8 s, com alcance de 2.200. É um pequeno avanço em relação ao [[item/5]], e seu preço quase não varia entre os sistemas.", false],
	],
	"item/60": [
		[0, "", "O [[item/60]] é o mais fraco dos três módulos de proteção contra EMP, com defesa contra EMP de 20. Nenhum dos três tem preço, e nenhuma loja os tem em estoque.", false],
	],
	"item/61": [
		[0, "", "O [[item/61]] é o módulo intermediário de proteção contra EMP, com defesa contra EMP de 40, o dobro do [[item/60]]. Como os outros dois, não tem preço e não está à venda nas lojas.", false],
	],
	"item/62": [
		[0, "", "O [[item/62]] é o módulo de proteção contra EMP mais forte, com defesa contra EMP de 60. Como o [[item/60]] e o [[item/61]], não tem preço e não está à venda nas lojas.", false],
	],
	"item/63": [
		[0, "", "O [[item/63]] é o compressor de carga básico. Um compressor amplia o porão em uma porcentagem da capacidade do próprio casco; este acrescenta 15 %. É barato e vale a pena para qualquer comerciante ou minerador.", false],
	],
	"item/64": [
		[0, "", "O [[item/64]] amplia o porão em 25 %, um avanço claro em relação ao [[item/63]] por um preço baixo.", false],
	],
	"item/65": [
		[0, "", "O [[item/65]] amplia o porão em 40 %. Em um cargueiro grande, ele acrescenta tanto espaço quanto o porão inteiro de uma nave pequena.", false],
	],
	"item/66": [
		[0, "", "O [[item/66]] amplia o porão em 75 %, o máximo entre os compressores vendidos em lojas.", false],
	],
	"item/67": [
		[0, "", "O [[item/67]] dobra o porão, acrescentando 100 % da capacidade do casco: com ele, uma [[ship/36]] leva 700 t. Ele nunca é vendido pronto. Seu projeto vem de [[agent/9]], em [[station/90]], e ele é fabricado só com mercadorias.", false],
	],
	"item/68": [
		[0, "", "O [[item/68]] é o raio trator básico. Sem um raio trator, nenhum contêiner flutuante pode ser recolhido; voar contra ele não adianta nada. Com o Retractor, você mantém o contêiner sob a mira por 4 s, e depois disso ele é puxado. O [[item/69]] precisa de menos tempo, e o [[item/70]] funciona automaticamente.", false],
		[24, "", "[[character/6]] pede a [[character/0]] que instale um raio trator antes da primeira expedição contra os [[faction/9|Voids]], para que ele possa recolher os restos das naves deles. Até então, as lojas têm boa chance de ter um Retractor além do estoque habitual.", false],
	],
	"item/69": [
		[0, "", "O [[item/69]] funciona como o [[item/68]], mas precisa do alvo sob a mira por apenas 3 s antes de puxar o contêiner.", false],
	],
	"item/7": [
		[0, "", "O [[item/7]] causa 10 de dano a cada 0,8 s, com alcance de 2.200. Ao longo do tempo, ele se iguala ao [[item/1]], então seu valor está em acertos menos frequentes e mais pesados a longa distância.", false],
	],
	"item/70": [
		[0, "", "O [[item/70]] é o raio trator automático: ele recolhe qualquer contêiner no campo de visão frontal sem precisar ser apontado e mantido, o que economiza muito tempo ao saquear um campo de batalha. É bem mais caro que o [[item/69]].", false],
	],
	"item/71": [
		[0, "", "O [[item/71]] é o turbo básico. Um turbo dá uma breve explosão de velocidade extra e depois precisa de tempo para recarregar. Este acrescenta 60 % de velocidade por 3 s e recarrega em 8 s.", false],
	],
	"item/72": [
		[0, "", "O [[item/72]] é classificado com 80 % de velocidade extra por 4,4 s, com recarga de 10 s. Em voo, sua explosão atinge a mesma velocidade máxima que a do [[item/71]]; o que ele acrescenta é uma explosão mais longa.", false],
	],
	"item/73": [
		[0, "", "O [[item/73]] mais que dobra o ganho dos turbos mais baratos: 160 % de velocidade extra por 5,6 s, com recarga em 12 s.", false],
	],
	"item/74": [
		[0, "", "O [[item/74]] é o turbo mais forte: 200 % de velocidade extra por 6 s. Ele precisa da recarga mais longa, 16 s. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/75": [
		[0, "", "O [[item/75]] é o único robô de reparos do jogo e ocupa um espaço de equipamento. Enquanto você voa, ele restaura um ponto de casco a cada 0,6 s e um ponto da placa de blindagem a cada segundo, então o dano desaparece entre os combates sem precisar atracar. É barato e está à venda na maioria das lojas.", false],
	],
	"item/76": [
		[0, "", "O [[item/76]] é o bocal de direção básico. Um bocal soma seu valor à manobrabilidade da nave, que assim vira mais rápido. Este acrescenta 20, um ganho pequeno para caças ágeis, mas perceptível em um cargueiro lento.", false],
	],
	"item/77": [
		[0, "", "O [[item/77]] acrescenta 40 de manobrabilidade, o dobro do [[item/76]], por um preço baixo.", false],
	],
	"item/78": [
		[0, "", "O [[item/78]] é um bocal [[faction/1|vossk]] que acrescenta 70 de manobrabilidade. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/79": [
		[0, "", "O [[item/79]] é um bocal [[faction/1|vossk]] que acrescenta 100 de manobrabilidade, o suficiente para fazer um cargueiro pesado virar como um caça ágil. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/8": [
		[0, "", "O [[item/8]] é o último e mais forte laser Berger: 12 de dano por disparo a cada 0,9 s, com alcance de 2.200. É o laser convencional que mais bate por disparo, mas o [[item/2]], mais rápido, ainda causa mais dano ao longo do tempo. Os lasers de feixe M6 que vêm depois dele (a partir do [[item/9]]) batem mais que o dobro por disparo.", false],
	],
	"item/80": [
		[0, "", "O [[item/80]] é o melhor bocal de direção, acrescentando 130 de manobrabilidade. Ele eleva a [[ship/36]], o casco que vira mais devagar, de 45 para 175, mais do que qualquer caça tem sem bocal. É raro nas lojas.", false],
	],
	"item/81": [
		[0, "", "O [[item/81]] é o scanner básico. Um scanner define quanto tempo leva para travar um alvo, como uma nave, uma estação ou um asteroide; o Quickscan precisa de 4 s. O [[item/82]] trava mais rápido e também mostra o que as outras naves carregam.", false],
		[2, "", "A nave de mineração de [[character/2]], a [[ship/0]], já vem com um instalado.", false],
	],
	"item/82": [
		[0, "", "O [[item/82]] trava em 3 s e mostra a carga levada pelas naves visadas, o que ajuda na busca por saque.", false],
	],
	"item/83": [
		[0, "", "O [[item/83]] trava em 1,8 s, um tempo de travamento igualado apenas pelo [[item/84]], e também mostra a carga dos alvos.", false],
	],
	"item/84": [
		[0, "", "O [[item/84]] trava tão rápido quanto o [[item/83]] e mostra a carga, além de marcar os asteroides de classe A, os únicos que podem render um núcleo (veja [[guide/mining]]). É o scanner preferido dos mineradores.", false],
	],
	"item/85": [
		[0, "", "O [[item/85]] é o único motor de salto do jogo. Com ele instalado, você pode viajar a partir do mapa estelar diretamente para uma estação de outro sistema, sem passar por portais de salto. Ele não pode ser usado durante algumas missões. Nunca é vendido pronto, e nenhum agente vende o seu projeto. Fabricá-lo exige [[item/164]], [[item/158]], [[item/160]] e [[item/163]], além de grandes quantidades de mercadorias.", false],
		[33, "", "Seu inventor, [[character/20]], pede a [[character/0]] 50 [[item/164]] para seu trabalho em um propulsor capaz de chegar a qualquer lugar do espaço.", false],
		[34, "", "Em troca dos cristais, [[character/20]] dá a [[character/0]] uma cópia do projeto. Os 50 cristais entregues contam para o motor, então só é preciso fornecer os ingredientes restantes.", false],
	],
	"item/86": [
		[0, "", "O [[item/86]] é o laser de mineração básico. Um laser de mineração é necessário para extrair minério de asteroides. Seu rendimento define com que firmeza a broca mantém o curso, e cada modelo também tem sua própria velocidade de perfuração (veja [[guide/mining]]). Este tem rendimento 30 e é difícil de manter na trilha nas camadas profundas.", false],
	],
	"item/87": [
		[0, "", "O [[item/87]] tem rendimento 50. É visivelmente mais firme que o [[item/86]], embora perfure um pouco mais devagar.", false],
	],
	"item/88": [
		[0, "", "O [[item/88]] é um laser de mineração [[faction/1|vossk]] com rendimento 80, a broca mais firme vendida em lojas. Sua desvantagem é ser o mais lento na extração de minério. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/89": [
		[0, "", "O [[item/89]] tem rendimento 60, menos firme que o [[item/88]], mas extrai minério muito mais rápido que qualquer outro laser vendido em lojas. Ele convém a mineradores que conseguem manter a broca na trilha por conta própria.", false],
	],
	"item/9": [
		[0, "", "O [[item/9]] é o primeiro dos lasers de feixe M6. Eles atiram raramente, mas batem com muita força: 27 de dano a cada 1,2 s, com alcance de 2.400, maior que o de qualquer laser anterior. A pontaria precisa importa, já que um erro desperdiça uma longa recarga. Ele também é a peça básica para fabricar o [[item/11]].", false],
	],
	"item/90": [
		[0, "", "O [[item/90]] é o melhor laser de mineração: rendimento 100 e a perfuração mais rápida de todos os modelos. Ele nunca é vendido pronto. Seu projeto vem de [[agent/11]], em [[station/78]], e fabricá-lo exige grandes quantidades de nanotecnologia, suprimentos mecânicos e hidráulica, além de [[item/155]] e dez [[item/166]].", false],
		[2, "", "O laser da primeira nave de mineração de [[character/0]] é o protótipo feito à mão por [[character/2]] desta broca.", false],
		[10, "", "Quando [[character/2]] dá a [[ship/0]] a [[character/0]], ele fica com o protótipo, o único que tem, e sugere uma visita futura, quando talvez já tenha construído mais.", false],
	],
	"item/91": [
		[0, "", "O [[item/91]] acomoda 3 passageiros. As cabines são necessárias para os trabalhos de [[job/11]], e o espaço de várias cabines se soma. O [[item/92]] e o [[item/93]] acomodam mais.", false],
	],
	"item/92": [
		[0, "", "O [[item/92]] acomoda 5 passageiros, dois a mais que o [[item/91]].", false],
	],
	"item/93": [
		[0, "", "O [[item/93]] acomoda 10 passageiros, o dobro do [[item/92]], o que abre caminho para os trabalhos de passageiros maiores.", false],
	],
	"item/94": [
		[0, "", "O [[item/94]] é o dispositivo de camuflagem básico. Enquanto a camuflagem está ativa, as outras naves não conseguem ver você. Este esconde a nave por 15 s e depois precisa de 18 s para recarregar. O tempo passado camuflado conta para a medalha [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "O [[item/95]] é um dispositivo de camuflagem [[faction/1|vossk]] que esconde a nave por 28 s e recarrega em 32 s, quase o dobro da cobertura do [[item/94]]. Só as lojas dos sistemas [[faction/1|vossk]] o têm.", false],
	],
	"item/96": [
		[0, "", "O [[item/96]] é o melhor dispositivo de camuflagem: esconde a nave por 46 s e recarrega em apenas 40 s, então pode ficar ativo mais tempo do que inativo. Ele nunca é vendido pronto. Seu projeto vem de [[agent/10]], em [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Um trabalho de entrega pede que você leve um carregamento de contêineres de frete lacrados a outra estação. Os contêineres são colocados no seu porão quando você aceita, então é preciso espaço livre suficiente; eles não podem ser vendidos. O trabalho é concluído quando você atraca no destino com o frete a bordo. Às vezes há piratas de tocaia à espera dos entregadores. O frete entregue conta para [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "Em um trabalho de defesa, uma estação está prestes a ser atacada, e você é contratado para ajudar os caças dela a repelir os atacantes. Os atacantes costumam ser piratas; caso contrário, são naves da raça rival. Voe até a estação e destrua todos os atacantes; os abates dos caças aliados também contam. Trabalhos mais difíceis trazem mais atacantes.", false],
	],
	"job/10": [
		[0, "", "Em um trabalho de interceptação, um comboio de dois ou três cargueiros com carga ilegal está longe de uma estação, protegido por caças. Siga os pontos de navegação e destrua os cargueiros. Os guardas deles esperam ao longo do caminho e ao redor do comboio.", false],
	],
	"job/11": [
		[0, "", "Um trabalho de passageiros pede que você leve um grupo de pessoas a outra estação. Você precisa de cabines com espaço para todos no momento em que aceita; enquanto eles estão a bordo, as cabines não podem ser removidas e o casco não pode ser trocado. Atraque no destino para entregá-los. A recompensa base é menor, mas cada passageiro a aumenta. Os passageiros entregues contam para [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Um desafio é uma disputa de tiro proposta por outro piloto no Space Lounge. Vocês dois partem da mesma estação até um grupo de piratas espalhados ao longo de uma rota, e vence quem abater mais deles. O rival não pode ser destruído e atinge com a mesma força das suas armas. Você só recebe se fizer mais abates; o número de piratas é sempre ímpar, então não há empates.", false],
	],
	"job/2": [
		[0, "", "Um trabalho de proteção envia você para guardar naves mineradoras que trabalham em um campo de asteroides perto de uma estação. Atacantes chegam e avançam contra a estação e os mineradores. Destrua todos antes que eles acabem com os mineradores; se todas as naves mineradoras forem perdidas, o trabalho fracassa.", false],
	],
	"job/3": [
		[0, "", "Em um trabalho de recuperação, mercadorias roubadas estão sendo levadas por uma das naves de um grupo de piratas perto de uma estação. Você precisa recuperar o contêiner sem destruí-lo: desative a nave que o carrega com uma arma de EMP e puxe o contêiner com um raio trator. Um scanner que mostre a carga ajuda a encontrar a nave certa. O contêiner se perde se a nave que o carrega for destruída ou se não houver espaço para ele no seu porão. Depois de pegá-lo, volte à estação onde aceitou o trabalho para receber. A recuperação paga o dobro.", false],
	],
	"job/4": [
		[0, "", "Caçar piratas significa limpar um esconderijo pirata perto de uma estação. Os piratas esperam no campo de asteroides ou ao longo de uma rota de dois ou três pontos de navegação, e só reagem quando veem você. Siga os pontos de navegação e destrua todos os piratas. Uma dificuldade maior significa mais piratas.", false],
	],
	"job/5": [
		[0, "", "Um trabalho de resgate é um salvamento: um refém está preso a bordo de uma das naves de um grupo perto de uma estação. Como em um trabalho de recuperação, desative a nave do sequestrador com EMP e use um raio trator para trazer o refém a bordo; destruir essa nave encerra o trabalho. Depois, leve o refém de volta à estação onde você aceitou o trabalho. O resgate paga o dobro.", false],
	],
	"job/6": [
		[0, "", "Um trabalho de procurado indica um criminoso perigoso que foi visto perto de uma estação. O alvo espera em um ponto distante e só reage quando você aparece no campo de visão dele. Ele é muito mais resistente que um pirata comum, e fica ainda mais resistente com a dificuldade do trabalho e o seu nível de piloto. Destrua-o para receber a recompensa.", false],
	],
	"job/7": [
		[0, "", "A remoção de lixo pede que você limpe uma nuvem de lixo espacial perto de uma estação em cerca de dois minutos. Todas as peças precisam ser destruídas antes que o tempo acabe; em dificuldades maiores, alguns piratas entram na disputa. Paga menos que a maioria dos trabalhos, mas é rápido, e o lixo destruído conta para [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Um trabalho de compra vem de um comprador no Space Lounge que quer certa quantidade de um item específico. Consiga as mercadorias, em lojas, com negociantes ou minerando, e atraque de novo na estação do comprador com elas no porão. As mercadorias são entregues e você recebe metade da recompensa normal de um trabalho mais três vezes o valor médio das mercadorias, então um comprador costuma pagar muito mais que qualquer loja. Os compradores aparecem a partir de [[step/16]].", false],
	],
	"job/9": [
		[0, "", "Um trabalho de escolta pede que você proteja um comboio de cinco cargueiros perto de uma estação. Conforme os cargueiros avançam, atacantes que esperam ao longo da rota se aproximam. Destrua todos os atacantes. Se todos os cargueiros forem perdidos, o trabalho fracassa. As escoltas pagam um quinto a mais que a maioria dos trabalhos.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] tem esta medalha desde o início do jogo, por seus serviços anteriores. Não é preciso fazer nada para conquistá-la.", false],
	],
	"medal/1": [
		[0, "", "Concedida por chegar a uma estação com muito pouco casco restante. A verificação é feita quando você se aproxima, antes de a atracação consertar a nave, e usa a resistência do próprio casco, não a placa de blindagem. Quanto menor a fração restante, melhor o nível.", false],
	],
	"medal/10": [
		[0, "", "Concedida por destruir lixo espacial, como o encontrado nos trabalhos de [[job/7]]. Cada peça que você abate conta.", false],
	],
	"medal/11": [
		[0, "", "Concedida pelo número de estações diferentes em que você atracou.", false],
	],
	"medal/12": [
		[0, "", "Concedida pelo número de sistemas diferentes que você visitou. Os sistemas ocultos contam depois que você chega a eles.", false],
	],
	"medal/13": [
		[0, "", "Concedida pelo número de projetos que você possui. Os projetos são comprados de agentes no Space Lounge; veja [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Concedida pelo número de projetos diferentes que você concluiu pelo menos uma vez. Fabricar o mesmo item de novo não aumenta a contagem.", false],
	],
	"medal/15": [
		[0, "", "Concedida pelo tempo que você passou jogando, em horas. O jogo conta o tempo passado em voo.", false],
	],
	"medal/16": [
		[0, "", "Concedida pelo número de trabalhos freelance concluídos. Trabalhos fracassados e abandonados não contam.", false],
	],
	"medal/17": [
		[0, "", "Concedida pelo número de vezes que você viajou por um portal de salto. Saltos com motor de salto não contam.", false],
	],
	"medal/18": [
		[0, "", "Concedida pelo número de passageiros entregues em trabalhos de [[job/11]]. Mais espaço em cabines significa grupos maiores.", false],
	],
	"medal/19": [
		[0, "", "Concedida pelo total de minutos passados camuflado. Instale um dispositivo de camuflagem e use-o sempre que estiver carregado.", false],
	],
	"medal/2": [
		[0, "", "Concedida por minerar tipos diferentes de minério. Cada tipo conta uma vez, não importa quanto você extraia dele. Como os campos contêm os minérios cuja origem fica por perto, você vai precisar minerar em várias partes da galáxia.", false],
	],
	"medal/20": [
		[0, "", "Concedida pelo número de bombas de EMP e bombas nucleares lançadas.", false],
	],
	"medal/21": [
		[0, "", "Concedida pelas toneladas de [[item/131]] recolhidas com um raio trator de destroços e naves desativadas.", false],
	],
	"medal/22": [
		[0, "", "Uma medalha de nível único por voar sem nenhuma arma, ou sem nenhum equipamento, instalado, verificada na próxima atracação. Ela não pode ser conquistada no início da história: até [[step/8]], a nave sempre conta como armada.", false],
	],
	"medal/23": [
		[0, "", "Concedida pelo número de armas primárias instaladas ao mesmo tempo, verificado quando você atraca. Os níveis mais altos exigem um casco com muitos espaços primários. Assim como [[medal/22]], ela só conta a partir de [[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Concedida pelas toneladas de carga recolhidas com um raio trator de destroços e naves desativadas.", false],
	],
	"medal/25": [
		[0, "", "Concedida pela maior quantia de créditos que você teve de uma só vez. Gastar dinheiro depois não a tira de você.", false],
	],
	"medal/26": [
		[0, "", "Concedida por conversar com frequentadores do Space Lounge que têm algo a oferecer. Cada frequentador conta uma vez, na primeira vez que você fala com ele.", false],
	],
	"medal/27": [
		[0, "", "Concedida pelo número de alas que você contratou no Space Lounge, contando cada piloto de cada grupo.", false],
	],
	"medal/28": [
		[0, "", "Uma medalha de nível único por voltar uma das quatro grandes raças contra você, levando uma das duas escalas de reputação além de 60 em qualquer direção. Veja [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Concedida pelo número de asteroides destruídos pelas suas armas. Asteroides despedaçados na mineração não contam.", false],
	],
	"medal/3": [
		[0, "", "Concedida por minerar tipos diferentes de núcleo. Os núcleos só vêm da perfuração de todas as sete camadas de um asteroide de classe A, então isso exige paciência e um bom laser de mineração, além de viagens.", false],
	],
	"medal/30": [
		[0, "", "Uma medalha de nível único concedida por concluir a história.", false],
	],
	"medal/31": [
		[0, "", "Concedida pelo maior espaço livre de carga que você teve de uma só vez. Um casco grande com unidades de compressão de carga e o porão vazio rende os níveis mais altos.", false],
	],
	"medal/32": [
		[0, "", "Concedida pelo número de ofertas que você recusou com \"No, thanks\" no Space Lounge.", false],
	],
	"medal/33": [
		[0, "", "Concedida pelo número de vezes que você pediu a um frequentador do Space Lounge que repetisse uma oferta com \"How was that again?\".", false],
	],
	"medal/34": [
		[0, "", "Concedida por aceitar trabalhos em outras estações sem antes perguntar ao cliente se serão difíceis.", false],
	],
	"medal/35": [
		[0, "", "Concedida por aceitar trabalhos em outras estações sem antes pedir ao cliente que mostre o destino no mapa.", false],
	],
	"medal/36": [
		[0, "", "Concedida automaticamente quando você tem todas as outras medalhas, em qualquer nível. Ter todas elas também traz outras recompensas; veja [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Concedida pelo número de naves que você destruiu, contado ao longo de todo o jogo. Piratas, inimigos e alvos de trabalhos, tudo conta.", false],
	],
	"medal/5": [
		[0, "", "Concedida pelas toneladas de frete entregues em trabalhos de [[job/0]]. Cargas de entrega grandes contam mais, então um porão grande ajuda.", false],
	],
	"medal/6": [
		[0, "", "Concedida pelo total de toneladas de minério extraídas ao longo de todo o jogo.", false],
	],
	"medal/7": [
		[0, "", "Concedida pelo número de núcleos minerados ao longo de todo o jogo. Cada asteroide de classe A perfurado até o fim rende um.", false],
	],
	"medal/8": [
		[0, "", "Concedida pelas toneladas de bebidas compradas nas lojas das estações. A bebida local de qualquer sistema conta.", false],
	],
	"medal/9": [
		[0, "", "Concedida por possuir tipos diferentes de bebida. Os tipos são contados quando você os compra de negociantes no Space Lounge ou os recolhe de destroços com um raio trator.", false],
	],
	"ship/0": [
		[0, "", "A [[ship/0]] é o casco mais fraco da tabela de naves: blindagem 95, porão de 25 t, um suporte primário, um secundário e três espaços de equipamento. Sua manobrabilidade de 140 é respeitável para uma nave inicial, mas a [[ship/32]], o casco mais barato à venda, tem os mesmos suportes com mais blindagem, espaço de carga e agilidade. Nenhum vendedor oferece a [[ship/0]]; ela só chega ao jogador pela história.", false],
		[2, "", "[[character/2]] é dono desta antiga nave [[faction/8|pirata]] remendada e coloca [[character/0]] nela em [[station/78]], pintada com cores piratas e equipada com um laser de mineração e um [[item/81]], mas sem armas. O laser é um protótipo dele, o modelo que ele mais tarde vende como [[item/90]].", false],
		[10, "", "Depois do ataque ao esconderijo dos piratas, [[character/2]] dá a nave definitivamente a [[character/0]], com um propulsor mais potente para viajar entre os planetas do sistema, mas fica com o protótipo do laser. Keith continua a pilotá-la depois de chegar ao espaço [[faction/0|terrano]].", false],
		[18, "", "Em [[station/98]], [[character/1]] manda repintar o casco com as cores [[faction/0|terranas]] para que as patrulhas parem de confundi-lo com uma nave pirata.", false],
	],
	"ship/1": [
		[0, "", "A [[ship/1]] é o casco mais barato com quatro suportes secundários, e também tem suporte de torreta, duas armas primárias e sete espaços de equipamento. A blindagem (192) e o porão (65 t) são sólidos. Sua manobrabilidade de 106 é lenta, então ela luta melhor com torpedos e com a torreta. Por um pouco mais de dinheiro, a [[ship/9]] oferece muito mais blindagem e agilidade, mas sem torreta e com apenas dois suportes secundários.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/10": [
		[0, "", "A [[ship/10]] é a nave do próprio [[character/0]] na cena de abertura, armada com dois lasers [[item/3]]. Ela une uma blindagem sólida (200) e um porão de 100 t a quatro suportes secundários e manobrabilidade de 150, o que a torna muito mais ágil que a [[ship/11]], o casco mais próximo dela em preço de tabela. Seu ponto fraco é o pequeno número de espaços de equipamento: apenas cinco. Os vendedores comuns nunca a oferecem.", false],
		[2, "", "Uma falha no hiperpropulsor leva [[character/0]] até [[station/78]], onde [[character/2]] recolhe os destroços e os desmonta para aproveitar as peças. A nave nunca volta às mãos de Keith.", false],
	],
	"ship/11": [
		[0, "", "A [[ship/11]] é um cargueiro pesado bem equipado: porão de 180 t, blindagem 210, suporte de torreta, dois suportes primários e dois secundários e oito espaços de equipamento. Sua manobrabilidade de 75 é fraca. Em relação à [[ship/7]], mais barata, ela abre mão de 60 t de espaço de carga em troca de um suporte secundário e um espaço de equipamento extras.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/12": [
		[0, "", "A [[ship/12]] é um caça construído em torno das armas secundárias: três suportes secundários, duas armas primárias, seis espaços de equipamento, blindagem 175 e manobrabilidade de 132. Seu porão de 30 t é muito pequeno, então ela é pouco adequada para comércio ou mineração. A [[ship/30]] custa mais e oferece menos blindagem e um suporte secundário a menos.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/16": [
		[0, "", "A [[ship/16]] é um caça carregado de mísseis, com quatro suportes secundários, duas armas primárias, dez espaços de equipamento, blindagem 180 e manobrabilidade de 120. Seu porão de 45 t é pequeno. A [[ship/21]], mais cara, acrescenta mais duas armas primárias e um espaço de equipamento.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/17": [
		[0, "", "A [[ship/17]] leva quatro armas primárias, dois suportes secundários e dez espaços de equipamento. Para uma nave desse preço, a blindagem (145), o porão (65 t) e a manobrabilidade (95) são fracos, então ela depende dos equipamentos, principalmente escudos e placas de blindagem. A [[ship/19]], mais barata, tem mais blindagem e espaço de carga, com um espaço de equipamento a menos.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/18": [
		[0, "", "A [[ship/18]] é uma nave pequena e ágil (manobrabilidade 145) com oito espaços de equipamento; nenhum casco mais barato tem tantos. Sua blindagem de 115 e o porão de 28 t são fracos, e ela tem apenas dois suportes primários e dois secundários. Ela convém a um piloto que confia em escudos, camuflagem e outros equipamentos mais que na blindagem.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/19": [
		[0, "", "A [[ship/19]] é uma nave de ataque pesada com quatro suportes primários, dois secundários, nove espaços de equipamento, blindagem 225 e porão de 105 t. Sua manobrabilidade de 90 é lenta. É a única nave com quatro armas frontais e um porão de mais de 100 t.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/2": [
		[0, "", "A [[ship/2]] é uma nave versátil e ágil entre os cascos baratos: blindagem 155, porão de 52 t, um suporte primário e dois secundários, quatro espaços de equipamento e manobrabilidade de 150. Ela se iguala à [[ship/35]] em tudo, menos no espaço de carga, em que leva 12 t a mais. Pilotos que querem uma segunda arma preferem a [[ship/5]] ou a [[ship/6]].", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/20": [
		[0, "", "A [[ship/20]] é um caça leve que reúne seis espaços de equipamento em um casco pequeno e rápido (manobrabilidade 155). Ela leva duas armas primárias, mas apenas um suporte secundário, blindagem 125 e um porão de 25 t, que empata com o da [[ship/0]] como o menor da tabela. Ela convém a pilotos que querem escudos, turbos e outros equipamentos cedo e não pretendem transportar carga.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/21": [
		[0, "", "A [[ship/21]] é o casco mais barato com quatro suportes primários e quatro secundários. Ela ainda tem onze espaços de equipamento, blindagem 195 e porão de 70 t. Sua manobrabilidade de 100 é mediana. É uma nave de combate completa, um degrau abaixo da [[ship/29]].", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/22": [
		[0, "", "A [[ship/22]] tem o maior porão entre as naves que custam mais de um milhão de créditos (130 t), além de três suportes primários e três secundários, nove espaços de equipamento e manobrabilidade de 118. Sua blindagem de 160 é baixa para o preço. Ela convém a pilotos que comerciam e lutam com a mesma nave.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/23": [
		[0, "", "A [[ship/23]] é o casco mais barato com suporte de torreta, e sua blindagem de 205 é a mais alta entre as naves abaixo de 100.000 créditos. Ela soma dois suportes primários e dois secundários, cinco espaços de equipamento, porão de 55 t e manobrabilidade de 128, o que a torna uma nave versátil e robusta de categoria intermediária. Seu principal limite é o pequeno número de espaços de equipamento.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/24": [
		[0, "", "A [[ship/24]] é uma nave comercial armada: três armas primárias, dois suportes secundários, uma torreta, oito espaços de equipamento e porão de 95 t. Sua blindagem de 170 é mediana, enquanto a manobrabilidade de 125 é boa para uma nave que carrega tanto. Ela atende igualmente bem ao comércio, à mineração e ao combate.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/25": [
		[0, "", "A [[ship/25]] é uma lançadora de mísseis: quatro suportes secundários, oito espaços de equipamento e manobrabilidade de 130, mas apenas uma arma primária. Sua blindagem de 124 e o porão de 52 t são fracos para o preço, então ela depende de torpedos e escudos. A [[ship/1]] oferece o mesmo número de suportes secundários mais uma torreta por um terço do preço, com menos espaços de equipamento.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/26": [
		[0, "", "A [[ship/26]] é o casco mais barato com sete espaços de equipamento. No mais, é uma nave versátil mediana: blindagem 152, porão de 64 t, dois suportes primários e dois secundários e manobrabilidade de 108. Ela convém a pilotos que querem um conjunto completo de equipamentos antes de poder pagar por uma nave mais pesada.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/27": [
		[0, "", "A [[ship/27]] é o casco mais barato com três suportes primários. Ela os combina com blindagem 176, dois suportes secundários, seis espaços de equipamento e porão de 50 t. Sua manobrabilidade de 113 é um tanto lenta, então ela troca golpes em vez de superar os inimigos nas curvas.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/28": [
		[0, "", "A [[ship/28]] é a nave versátil mais completa à venda: três suportes primários e quatro secundários, uma torreta, doze espaços de equipamento e porão de 110 t. Nenhuma outra nave à venda tem uma torreta e tantos espaços de equipamento. Sua blindagem de 195 é boa e a manobrabilidade de 92 é lenta. A [[ship/29]] luta melhor, mas carrega muito menos.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/29": [
		[0, "", "A [[ship/29]] é a nave mais cara vendida pelos vendedores comuns e o melhor caça deles: quatro suportes primários e quatro secundários, doze espaços de equipamento, blindagem 240 e manobrabilidade de 118. Seu porão de 75 t é modesto, e ela não tem torreta. Só a [[ship/8]] a supera em combate.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/3": [
		[0, "", "A [[ship/3]] é uma nave versátil e equilibrada para o início: dois suportes primários e dois secundários, cinco espaços de equipamento, blindagem 135 e porão de 55 t. Sua manobrabilidade de 112 é lenta para uma nave pequena. Ela custa mais ou menos o mesmo que a [[ship/6]], que vira muito mais rápido, mas tem menos blindagem, menos espaço de carga e um suporte secundário a menos.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/30": [
		[0, "", "A [[ship/30]] é um caça mediano: blindagem 165, porão de 45 t, dois suportes primários e dois secundários, seis espaços de equipamento e manobrabilidade de 128. Ela não tem nenhum ponto forte especial para o preço; a [[ship/12]], mais barata, tem mais blindagem e um suporte secundário extra, e a [[ship/23]] acrescenta uma torreta.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/31": [
		[0, "", "A [[ship/31]] é um cargueiro leve com porão de 110 t, suporte de torreta, duas armas primárias e seis espaços de equipamento. Sua blindagem (156), o único suporte secundário e a manobrabilidade de 102 são modestos. Ela concorre com a [[ship/33]], mais barata, que tem um pouco menos de espaço de carga e uma arma a menos, mas mais blindagem e melhor manobrabilidade.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/32": [
		[0, "", "A [[ship/32]] é o casco mais barato vendido por qualquer vendedor e a primeira compra habitual. É pequena e pouco protegida (blindagem 100, porão de 30 t, um suporte primário e um secundário, três espaços de equipamento), mas com manobrabilidade de 160 só a [[ship/4]] vira mais rápido. Em comparação com a [[ship/0]], ela tem um pouco mais de blindagem e espaço de carga e é mais manobrável. A [[ship/35]] custa cerca de 8.000 créditos a mais e traz uma blindagem muito melhor, um segundo suporte secundário e um quarto espaço de equipamento.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/33": [
		[0, "", "A [[ship/33]] é o casco mais barato com mais de 100 t de espaço de carga (108 t), e ainda tem suporte de torreta, blindagem 176 e seis espaços de equipamento. Com apenas uma arma primária e manobrabilidade de 112, é mais uma nave comercial capaz de se defender do que um caça. A [[ship/31]] é uma rival próxima, com uma segunda arma e um porão um pouco maior, mas é mais fraca e mais lenta.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/34": [
		[0, "", "A [[ship/34]] é uma nave de ataque com quatro suportes primários, um secundário, seis espaços de equipamento, porão de 60 t e manobrabilidade de 130. Em comparação com a [[ship/4]], mais barata, ela abre mão de blindagem (135 contra 170) e de agilidade em troca de mais espaço de carga e um espaço de equipamento extra.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/35": [
		[0, "", "A [[ship/35]] é um caça leve no fim da lista de preços. Pelo valor, oferece boa blindagem (155), um suporte primário e dois secundários, quatro espaços de equipamento e uma manobrabilidade rápida de 150, mas apenas um porão de 40 t. A [[ship/2]] é quase a mesma nave com 12 t a mais de espaço de carga por alguns milhares de créditos a mais, enquanto a [[ship/5]] troca agilidade por mais blindagem, carga e uma segunda arma.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/36": [
		[0, "", "A [[ship/36]] é o maior cargueiro do jogo, com porão de 350 t. Ela não tem nenhum suporte primário e depende de seus quatro suportes secundários e de uma torreta para se defender. Sete espaços de equipamento e blindagem 200 são bons, mas sua manobrabilidade de 45 é a mais baixa da tabela. A [[ship/7]] leva menos, mas mantém duas armas frontais e vira melhor.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/4": [
		[0, "", "A [[ship/4]] é o casco mais barato com quatro suportes primários e, com manobrabilidade de 162, é a nave mais ágil do jogo. Sua blindagem de 170 é boa para o preço. O custo é um porão de 38 t, um único suporte secundário e cinco espaços de equipamento, o que faz dela uma nave de combate pura. A [[ship/34]] também leva quatro armas, com mais espaço de carga e de equipamento, mas menos blindagem e agilidade.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/5": [
		[0, "", "A [[ship/5]] é o casco mais barato com dois suportes primários, e sua blindagem de 170 é alta para o preço. Um porão de 60 t também a torna útil para comércio e mineração no início. As desvantagens são um único suporte secundário, apenas quatro espaços de equipamento e uma manobrabilidade lenta de 115. Pilotos que valorizam a agilidade mais que a blindagem escolhem a [[ship/2]] ou a [[ship/35]], por um preço parecido.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/6": [
		[0, "", "A [[ship/6]] é um caça leve e rápido com dois suportes primários, um secundário, cinco espaços de equipamento e manobrabilidade de 148. Sua blindagem de 105 é muito fina; só a [[ship/0]] e a [[ship/32]] têm menos, então ela depende mais da velocidade que da resistência. Por quase o mesmo preço, a [[ship/3]] oferece mais blindagem, mais espaço de carga e um segundo suporte secundário, à custa da manobrabilidade.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/7": [
		[0, "", "A [[ship/7]] é um cargueiro pesado com porão de 240 t, blindagem 220, suporte de torreta, duas armas primárias, um suporte secundário e sete espaços de equipamento. Com manobrabilidade de 65, ela vira devagar. Em comparação com a [[ship/36]], ela abre mão de 110 t de espaço de carga em troca de armas frontais e melhor manobrabilidade; a [[ship/11]], mais cara, acrescenta um espaço de equipamento e um segundo suporte secundário.", false],
		[0, "", "Qualquer vendedor fora dos sistemas [[faction/1|vossk]] pode tê-la em estoque.", false],
	],
	"ship/8": [
		[0, "", "A [[ship/8]] é um caça [[faction/9|Void]] restaurado e a nave mais forte do jogo. Sua blindagem de 450 é quase o dobro da de qualquer outro casco, ela tem quatro suportes primários e quatro secundários e quinze espaços de equipamento, e sua manobrabilidade de 155 está entre as melhores. O único ponto fraco é um porão de 30 t. Seu preço de tabela, de mais de oito milhões de créditos, é quase o dobro do da [[ship/29]].", false],
		[0, "", "Os vendedores comuns não a vendem. Ela só é oferecida em [[station/10]], como protótipo, quando o jogador tem todas as medalhas em ouro (veja [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "A [[ship/9]] é a única nave que os vendedores [[faction/1|vossk]] vendem, e eles não vendem mais nada. Sua blindagem de 250 é a mais alta de todos os cascos, exceto a [[ship/8]], e ela a combina com uma manobrabilidade rápida de 152, dois suportes primários e dois secundários, sete espaços de equipamento e porão de 65 t. Pelo preço, é o caça mais resistente disponível, embora não tenha a torreta e os suportes extras da [[ship/1]].", false],
		[36, "", "[[character/7]] explica que as naves [[faction/1|vossk]] normalmente só são pilotadas pela própria raça; esta nave é a exceção, um projeto adaptado para poder ser vendido a outras raças.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] abriga o portal de salto de [[system/0]]. O período de espera de [[step/13]] está registrado nesta estação, mas essa etapa é concluída terminando trabalhos do lounge em qualquer lugar, e nada acontece aqui.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] é a única estação de [[system/6]] e abriga o portal de salto do sistema. Trabalhos freelance nunca enviam você para cá. O agente [[agent/3]] vende um projeto no lounge, e quando todas as medalhas forem de ouro a estação oferece um protótipo da [[ship/8]].", false],
		[23, "", "A estação é a base de pesquisa secreta da Deep Science, liderada por [[character/6]]. [[character/0]] chega lá com [[character/5]] em [[step/23]] e volta várias vezes: para planejar a expedição até os Voids, para encontrar [[character/20]] e para entregar seus cristais.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] é uma estação vossk modesta em [[system/3]]. O agente [[agent/12]] vende as coordenadas de [[system/0]] no lounge dela.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] abriga o portal de salto de [[system/4]]. O agente midoriano [[agent/2]] vende o projeto de uma arma no lounge dela.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] é a estação mais avançada de [[system/4]].", false],
		[38, "", "Em [[step/38]], o comboio com os explosivos nivelianos é avistado perto da estação sob escolta de caças midorianos. [[character/0]] precisa afastar a escolta sem destruir o comboio.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] é uma estação vossk de tecnologia máxima em [[system/5]]. O agente boboliano [[agent/13]] vende as coordenadas de [[system/1]] no lounge dela.", false],
	],
	"station/27": [
		[36, "", "Perto de [[station/27]], [[character/7]] e [[character/0]] atacam um esconderijo pirata em [[step/36]]; vence quem destruir mais piratas.", false],
		[37, "", "[[character/0]] vence e conquista o direito de escoltar o cargueiro vossk. Daqui ele faz seu relatório a [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] é a estação do comandante vossk [[character/7]], que concordou em fornecer um cargueiro K'Sarr para o ataque aos Voids. [[character/0]] o encontra aqui em [[step/35]].", false],
		[36, "", "[[character/7]] não permite que ninguém além de um vossk pilote o cargueiro e desafia [[character/0]] a provar seu valor como piloto de escolta.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] é uma estação niveliana de alta tecnologia no sistema oculto [[system/0]]. Seu lounge abriga o agente [[agent/0]], que vende o projeto de uma arma.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] espera em [[station/30]] em [[step/34]] com um plano contra a nave-mãe dos Voids.", false],
		[35, "", "O plano é lançar um cargueiro pesado cheio de explosivos nucleares nivelianos contra a nave-mãe.", false],
		[39, "", "Os explosivos recuperados chegam aqui e são carregados no cargueiro vossk. Em [[step/39]], [[character/1]] explica a operação final.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] é uma pequena estação terrana em [[system/8]]. O agente [[agent/4]] vende o projeto barato de um foguete no lounge dela.", false],
	],
	"station/48": [
		[24, "", "Naves dos Voids foram avistadas perto de [[station/48]]. Em [[step/24]], [[character/0]] traz [[character/6]] até aqui para observá-las e recolher destroços com um raio trator.", false],
		[25, "", "No fim do recolhimento, um buraco de minhoca engole a nave de [[character/0]] com [[character/6]] a bordo.", false],
		[27, "", "Quando eles voltam por outro buraco de minhoca, caças dos Voids os seguem, e [[character/0]] precisa destruí-los aqui antes de voltar a [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] é uma estação vossk de tecnologia máxima em [[system/10]], um sistema que só se alcança com um motor de salto. O agente vossk [[agent/5]] vende o projeto de um míssil no lounge dela.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] abriga o portal de salto de [[system/11]].", false],
		[19, "", "Os piratas que mantêm [[character/5]] como refém em troca de resgate são encontrados perto da estação. A Deep Science deixa bombas de EMP no hangar dela para [[character/0]].", false],
		[22, "", "Depois do resgate, [[character/0]] encontra o oficial libertado na estação e recebe as coordenadas de [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] é o ponto de encontro onde [[character/0]] deveria buscar um oficial da Deep Science em [[step/18]].", false],
		[19, "", "O oficial nunca chega. Em vez disso, uma mensagem de [[character/1]] informa que piratas o sequestraram.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] é uma pequena estação no sistema vossk [[system/20]]. Seu lounge recebe um terrano, o agente [[agent/10]], que vende o projeto de um dispositivo de camuflagem.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] é uma das duas únicas estações de [[system/12]]. O agente multípode [[agent/6]] vende o projeto de uma arma nuclear no lounge dela.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] abriga o portal de salto de [[system/13]]. O agente ciborgue [[agent/14]] vende as coordenadas de [[system/10]] no lounge dela.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] é uma pequena estação terrana no sistema seguro [[system/14]]. O agente [[agent/7]] vende o projeto de um escudo no lounge dela.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] é uma estação de [[system/15]] que parou de responder às chamadas. Em [[step/11]], [[character/3]] envia [[character/0]] para descobrir por quê.", false],
		[12, "", "A estação está intacta. A tripulação simplesmente não tem condições de trabalhar, graças a um carregamento de neuroalgas entregue pelo traficante [[character/4]], um velho conhecido de [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] é a pequena estação de mineração do comerciante de minério niveliano [[character/2]] em [[system/15]]. A história começa em sua órbita.", false],
		[1, "", "A nave danificada de [[character/0]] chega aqui à deriva no piloto automático, e [[character/2]] a recolhe, com piloto e tudo.", false],
		[2, "", "[[character/2]] desmonta os destroços e põe [[character/0]] para minerar nos asteroides próximos com a [[ship/0]].", false],
		[8, "", "Depois de escapar de um ataque pirata, [[character/0]] instala sua primeira arma e ajuda [[character/2]] a destruir o esconderijo pirata perto da estação.", false],
		[10, "", "[[character/2]] então lhe dá a nave e o envia a [[station/79]].", false],
		[0, "", "Mais adiante no jogo, [[character/2]] vende o projeto de sua broca de mineração no lounge da estação.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] é uma estação de [[system/15]] e a sede do seu comandante, [[character/3]].", false],
		[10, "", "[[character/2]] envia [[character/0]] para cá em [[step/9]] para encontrar [[character/3]], um humano que pode ajudá-lo a chegar ao espaço terrano.", false],
		[11, "", "[[character/3]] explica o que é a [[faction/3|Confederação Mido]] e, em troca de sua ajuda, pede que ele verifique o que houve em [[station/76]].", false],
		[13, "", "Depois do relatório sobre [[station/76]], [[character/3]] promete pô-lo em contato com um comboio terrano que deve passar pela estação.", false],
		[15, "", "Quando o comboio chega em [[step/14]], ele confunde [[character/0]] com um pirata, desativa sua nave e o leva a bordo.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] é uma estação terrana no sistema oculto [[system/1]]. O agente niveliano [[agent/1]] vende um projeto no lounge dela.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] é uma estação terrana em [[system/16]]. O agente vossk [[agent/8]] vende o projeto de uma blindagem vossk no lounge dela.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] é uma pequena estação niveliana em [[system/17]]. O agente vossk [[agent/15]] vende as coordenadas de [[system/21]] no lounge dela.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] abriga o portal de salto de [[system/18]]. O agente [[agent/9]] vende o projeto de um compressor de carga no lounge dela.", false],
	],
	"station/91": [
		[28, "", "Em [[step/28]], há relatos de atividade dos Voids perto de [[station/91]]. [[character/0]] abre caminho lutando até um buraco de minhoca aqui para levar uma sonda até a nave-mãe dos Voids.", false],
		[31, "", "De volta do setor dos Voids, [[character/0]] recebe aqui uma ligação de [[character/1]], que o convida a ir a [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] é uma estação terrana em [[system/19]]. O cruzador que prendeu [[character/0]] o traz para cá, e ele descobre que seu velho amigo [[character/1]] está no comando.", false],
		[16, "", "Caças dos Voids atacam a estação durante a conversa dos dois, e [[character/0]] ajuda a repeli-los.", false],
		[18, "", "[[character/1]] o informa sobre os Voids e o recruta para a Deep Science.", false],
		[32, "", "Em [[step/31]], [[character/1]] instala na nave de [[character/0]] o sistema de alerta antecipado e lhe fala de [[character/20]].", false],
		[44, "", "Depois da vitória, [[character/0]] e [[character/1]] comemoram na estação, e [[character/6]] se junta a eles.", false],
		[45, "", "Na manhã seguinte, [[character/6]] se foi, deixando um bilhete e um último pagamento da Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] persegue um bando de [[faction/8|piratas]] por um cinturão de asteroides para receber a recompensa por suas cabeças. Você precisa encontrar e destruir todas as naves piratas.", false],
		[1, "", "Resolvido o problema dos piratas, Keith segue para Eden Prime, onde o almirante Smith quer vê-lo para tratar de uma missão especial. Quando o hiperpropulsor é ativado, um último disparo atinge sua nave. O propulsor falha, o suporte de vida fica gravemente danificado e o piloto automático leva o piloto inconsciente até a estação mais próxima, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "O piloto automático colocou a nave avariada de Keith em órbita de [[station/78]], com o piloto inconsciente a bordo.", false],
		[2, "", "Keith acorda em uma pequena estação de mineração administrada por [[character/2]], um comerciante de minério [[faction/2]]. Gunant desmontou a nave e a reivindica pelo direito de salvamento. Ele ri da ideia de chegar a Eden Prime, que fica no outro extremo da galáxia, e se surpreende que Keith nunca tenha ouvido falar dos Voids, seres hostis que agora aparecem até no sistema [[system/15]].", false],
		[2, "", "Keith não tem dinheiro nem nave, então precisa trabalhar para Gunant minerando com uma nave desarmada.", false],
	],
	"step/10": [
		[10, "", "Keith voa até [[station/79]] para encontrar [[character/3]].", false],
		[11, "", "Norris explica que [[system/15]] fica em um setor descoberto recentemente. Exilados terranos e nivelianos o colonizaram durante a Guerra Civil Niveliana e fundaram uma confederação independente. Os terranos a aceitam, mas os nivelianos ainda reivindicam o sistema, por isso há combates em sua periferia.", false],
		[11, "", "Norris se oferece para pôr Keith em contato com a Frota Espacial Terrana em troca de um favor: o contato com a estação [[station/76]] foi perdido, e um piloto experiente precisa descobrir por quê.", false],
	],
	"step/11": [
		[11, "", "Keith voa até [[station/76]] para investigar o silêncio. A estação parece intacta, sem sinais de combate, então ele atraca.", false],
		[12, "", "Lá dentro, Keith dá de cara com [[character/4]], um traficante famoso que ele conheceu muito tempo atrás. Mkkt trouxe um carregamento de neuroalgas, e a tripulação inteira está intoxicada demais para operar as comunicações. Keith vai embora assim que pode.", false],
	],
	"step/12": [
		[12, "", "Keith volta a [[station/79]] para fazer seu relatório.", false],
		[13, "", "Norris fica horrorizado e promete dar um jeito no traficante. Um comboio militar terrano está a caminho de Kernstal e dará a Keith a chance de contatar a frota. Até ele chegar, Norris sugere que Keith aceite trabalhos pagos no Space Lounge (veja [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Enquanto espera o comboio, Keith precisa concluir dois trabalhos freelance do Space Lounge (veja [[guide/jobs]]).", false],
		[14, "", "Norris informa que o comboio terrano entrou no sistema e está indo para [[station/79]]. Keith parte para encontrá-lo.", false],
	],
	"step/14": [
		[14, "", "Perto de [[station/79]], Keith encontra o comboio terrano e alguns piratas. Ele avança para afastar os piratas.", false],
		[15, "", "Em sua antiga nave pirata, Keith é confundido com um dos atacantes. O comboio desativa sua nave com armas de EMP e o prende. Ele é levado a bordo de um cruzador terrano com destino a [[station/98]], no espaço terrano.", false],
	],
	"step/15": [
		[15, "", "Keith chega a [[station/98]] como prisioneiro do comboio.", false],
		[16, "", "O oficial responsável é [[character/1]], um velho amigo de Keith, agora chefe da Agência de Segurança Interestelar. Ele pede desculpas pelo engano. O reencontro é interrompido quando caças dos Voids surgem em órbita e a estação dispara o alarme.", false],
	],
	"step/16": [
		[16, "", "Brent pede a Keith que ajude a repelir as naves dos [[faction/9|Voids]] que atacam [[station/98]] (veja [[world/voids]]).", false],
		[17, "", "Os Voids transmitem uma mensagem afirmando ter intenções pacíficas, mas atacam mesmo assim. Keith os repele, e Brent promete lhe contar tudo o que sabe diante de uma taça de vinho.", false],
	],
	"step/17": [
		[17, "", "Keith atraca em [[station/98]] para ouvir o que Brent sabe sobre os Voids.", false],
		[18, "", "Os Voids surgiram nas últimas semanas. Eles chegam por uma espécie de buraco de minhoca, atacam tudo o que encontram e parecem estar atrás de minério; até sistemas [[faction/1]] são atacados. Brent preside uma equipe de crise, e seus cientistas estão se reunindo em uma estação de pesquisa secreta mantida pela Deep Science. Ele pede a Keith que pilote para eles.", false],
		[18, "", "O sistema da estação não aparece nos mapas estelares comuns, então Keith precisa encontrar o Ten. Thomas Boyle ([[character/5]]) na estação [[station/56]], no sistema [[system/11]], para obter as coordenadas. Brent também admite que a nave de Keith não é nova: ela apenas foi repintada para evitar novas confusões.", false],
	],
	"step/18": [
		[18, "", "Keith voa até [[station/56]] para encontrar Boyle.", false],
		[19, "", "Boyle nunca chegou. Brent informa que piratas o sequestraram perto de [[station/55]] e exigem um resgate de cinco milhões de créditos. Brent está disposto a pagar, mas Keith acredita que os sequestradores vão matar Boyle depois de receber o dinheiro e segue para Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith voa até [[station/55]] para procurar os sequestradores.", false],
		[20, "", "Os scanners de Kappa localizam a nave dos sequestradores. Brent mandou deixar bombas de EMP no hangar da estação, para que Keith possa desativar a nave enquanto os sequestradores acreditam que ele está entregando o resgate.", false],
	],
	"step/2": [
		[2, "", "Gunant dá a Keith uma nave velha e muito remendada, a [[ship/0]], uma antiga nave pirata equipada com um laser de mineração e sem armas. Keith precisa extrair pelo menos dez toneladas de minério dos asteroides perto de [[station/78]] (veja [[guide/mining]]).", false],
		[3, "", "Com o minério a bordo, Gunant manda que ele atraque para que a carga seja conferida. Sem armas, Keith não tem escolha a não ser obedecer.", false],
	],
	"step/20": [
		[20, "", "Keith precisa atracar em [[station/55]] e instalar as bombas de EMP em sua nave.", false],
		[21, "", "Com as bombas montadas, Keith parte imediatamente.", false],
	],
	"step/21": [
		[21, "", "Um ponto de navegação marca a nave dos sequestradores, que pode não estar sozinha. Keith precisa desativá-la com uma bomba de EMP em vez de destruí-la e dar conta de qualquer escolta.", false],
		[22, "", "Os sequestradores acham que o resgate chegou até que a bomba derruba seus sistemas. Brent envia uma equipe para resgatar Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith atraca em [[station/55]] para encontrar o cientista resgatado.", false],
		[23, "", "Boyle agradece. Como sua própria nave se perdeu, Keith lhe oferece uma carona, e Boyle transfere para o computador de navegação de Keith as coordenadas do sistema [[system/6]], onde fica a estação de pesquisa.", false],
	],
	"step/23": [
		[23, "", "Keith leva Boyle até [[station/10]], no sistema [[system/6]], onde a Dra. Paolini os espera.", false],
		[24, "", "Keith conhece a Dra. Carla Paolini ([[character/6]]), que lidera o projeto da Deep Science. Ela quer estudar a tecnologia dos Voids, começando pelos destroços de suas naves. A Deep Science paga 20.000 créditos a Keith para equipar a nave, e um raio trator é indispensável.", false],
		[24, "", "Carla insiste em voar com ele até [[station/48]], no sistema [[system/9]], onde Voids foram avistados recentemente. Keith protesta, mas acaba cedendo.", false],
	],
	"step/24": [
		[24, "", "Perto de [[station/48]], Carla quer ver os Voids o mais de perto possível. Os Voids anunciam que vêm do futuro e que são tudo o que resta das civilizações da galáxia. Keith precisa combatê-los e recolher os restos de suas naves com um raio trator.", false],
		[25, "", "Quando já há destroços suficientes a bordo, Carla pede para voltar, mas de repente algo agarra a nave.", false],
	],
	"step/25": [
		[25, "", "Keith e Carla recobram os sentidos longe de [[station/48]], em uma região do espaço que nenhum dos dois conhece.", false],
		[26, "", "Uma gigantesca nave-mãe dos Voids está ali perto, lançando caças. Keith conclui que eles passaram por um buraco de minhoca até o setor de origem dos Voids. Esse buraco de minhoca desapareceu, mas essas aberturas parecem se fechar e reaparecer em outros lugares, então ele precisa alcançar outra para voltar para casa.", false],
	],
	"step/26": [
		[26, "", "O buraco de minhoca os leva de volta a [[station/48]], mas caças dos Voids vieram atrás. Keith precisa destruí-los para que não sigam a nave até [[station/10]].", false],
		[27, "", "Livres dos perseguidores, os dois voltam para Thynome, muito precisados de descanso.", false],
	],
	"step/27": [
		[27, "", "Keith atraca em [[station/10]].", false],
		[28, "", "Dois dias depois, Carla pede que ele volte. Sua equipe construiu uma sonda que, disparada contra a nave-mãe, a analisa e envia os resultados para a nave de Keith. Ela fica para estudar os destroços e o envia ao sistema [[system/18]], onde acabam de ser relatados Voids, para encontrar outro buraco de minhoca.", false],
		[28, "", "Keith aceita com uma condição: se voltar vivo, Carla lhe deve um encontro. Ela aceita.", false],
	],
	"step/28": [
		[28, "", "Perto de [[station/91]] chegam caças dos Voids, e Keith precisa alcançar o buraco de minhoca antes que ele se feche. Os Voids avisam que destruí-los destruirá o futuro dele próprio.", false],
		[29, "", "Keith alcança o buraco de minhoca e o atravessa até o espaço do Void.", false],
	],
	"step/29": [
		[29, "", "Perto da nave-mãe, Keith precisa travar a mira nela, o que lança a sonda, e depois resistir enquanto a sonda conclui a análise.", false],
		[30, "", "Durante a espera, os Voids voltam a transmitir, dizendo que precisam encontrar uma forma de conversar antes que os humanos os destruam e, com eles, o próprio futuro. Keith resiste até a transferência de dados terminar e vai embora.", false],
	],
	"step/3": [
		[3, "", "Keith atraca em [[station/78]] para entregar sua primeira carga de minério.", false],
		[4, "", "Gunant fica razoavelmente satisfeito, mas manda Keith sair de novo, desta vez para encher o porão de carga inteiro. Ele brinca que Keith talvez possa ficar com a nave um dia, se se comportar.", false],
	],
	"step/30": [
		[30, "", "De volta pelo buraco de minhoca, Keith aguarda perto de [[station/91]].", false],
		[31, "", "Brent liga e pede que ele passe por [[station/98]], no sistema [[system/19]], antes de voltar a Thynome, prometendo uma surpresa. Os dados da sonda podem ser enviados a Carla de lá.", false],
	],
	"step/31": [
		[31, "", "Keith atraca em [[station/98]] para ver Brent.", false],
		[32, "", "A equipe de Brent desenvolveu um sistema de alerta antecipado para o mapa estelar. Ele mostra onde os Voids estão prestes a abrir um buraco de minhoca, e o computador de navegação de Keith é modificado para recebê-lo. Brent quer que ele voe até esses lugares e apoie as forças locais, e lhe paga 30.000 créditos.", false],
		[32, "", "Brent acrescenta que um [[faction/7|Grey]] chamado [[character/20]], que trabalha para a Deep Science, pediu para ver Keith.", false],
	],
	"step/32": [
		[32, "", "Keith volta a [[station/10]] para encontrar [[character/20]].", false],
		[33, "", "Khador estudou os destroços dos Voids. Ele acredita que o segredo dos buracos de minhoca dos Voids está na estrutura de certos cristais encontrados apenas no setor dos Voids. Ele está desenvolvendo um propulsor capaz de levar uma nave instantaneamente a qualquer ponto do espaço e pede a Keith que lhe traga pelo menos 50 desses cristais.", false],
		[33, "", "Keith precisa entrar em um buraco de minhoca mais uma vez, agora usando o sistema de alerta antecipado de Brent para encontrar um.", false],
	],
	"step/33": [
		[33, "", "Keith precisa reunir 50 [[item/164]] no setor dos Voids e entregá-los em [[station/10]].", false],
		[34, "", "Khador fica encantado e dá a Keith uma cópia do seu projeto do [[item/85]], para que Keith possa construir um para si (veja [[guide/blueprints]]). Esse propulsor consegue chegar até ao setor de origem dos Voids.", false],
		[34, "", "Carla aparece, ocupada demais para o encontro. Ela conta a Keith que ela e Brent elaboraram um plano e o manda ao encontro de Brent na estação [[station/30]], no sistema [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith voa até [[station/30]] para ouvir o plano de Brent.", false],
		[35, "", "Os dados da sonda mostram que a nave-mãe é a origem dos buracos de minhoca. Nenhuma arma a feriu até agora, então o plano é lançar um cargueiro resistente, carregado de explosivos nucleares nivelianos, contra o seu núcleo.", false],
		[35, "", "Um cargueiro vossk K'Sarr é o mais indicado para a tarefa. Brent combinou obter um de [[character/7]], comandante de [[station/29]] no sistema [[system/5]], como parte de uma troca secreta de prisioneiros. Errkt insiste em conhecer o piloto pessoalmente.", false],
	],
	"step/35": [
		[35, "", "Keith voa até o território [[faction/1]] para encontrar [[character/7]] em [[station/29]].", false],
		[36, "", "Errkt, que examinou o histórico de Keith, sustenta que só um vossk sabe pilotar direito uma nave vossk. Como a missão não pode falhar, ele mesmo pilotará o cargueiro. Antes, porém, Keith precisa provar sua habilidade como piloto de caça perto do planeta [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt propõe uma disputa em um esconderijo pirata perto de [[station/27]]: vence quem abater mais piratas.", false],
		[37, "", "Keith vence. Errkt o reconhece como um piloto capaz e lhe concede a honra de escoltar o cargueiro, que ele levará ao ponto de encontro combinado. Keith liga para Brent para informá-lo.", false],
	],
	"step/37": [
		[37, "", "Keith contata Brent de [[station/27]] para relatar suas conversas com Errkt.", false],
		[38, "", "O Império Vossk confirmou seu apoio, e Brent aceita Errkt como piloto. Surgiu um novo problema: naves da [[faction/3|Confederação Mido]], em guerra com os nivelianos, capturaram o comboio que transporta os explosivos nivelianos. Ele foi avistado no sistema [[system/4]], perto de [[station/22]], e Keith concorda em interceptá-lo.", false],
	],
	"step/38": [
		[38, "", "Perto de [[station/22]], Keith encontra o comboio roubado com uma escolta de caças Mido. Ele precisa destruir a escolta sem danificar as naves do comboio.", false],
		[39, "", "Com o comboio novamente sob controle, Brent o entrega às forças de segurança locais para a viagem até [[station/30]] e pede a Keith que também volte para lá.", false],
	],
	"step/39": [
		[39, "", "Keith atraca em [[station/30]] para o briefing final.", false],
		[40, "", "Os explosivos são carregados no cargueiro vossk, e Errkt continua sendo o piloto. Quando os Voids aparecerem de novo, Keith e Errkt voarão até lá. Errkt seguirá para o primeiro buraco de minhoca, e Keith lhe dará cobertura e irá atrás. Brent pedirá reforços à estação mais próxima.", false],
		[40, "", "Errkt deve se ejetar em uma cápsula de fuga pouco antes do impacto. Keith precisa voltar pelo buraco de minhoca antes que a nave-mãe seja destruída, ou não haverá caminho de volta.", false],
	],
	"step/4": [
		[4, "", "Keith volta aos asteroides para minerar até encher o porão.", false],
		[5, "", "Enquanto ele minera, uma nave pirata se aproxima. Desarmado, Keith recebe ordem de fugir para a estação e desviar dos disparos.", false],
	],
	"step/40": [
		[40, "", "Usando o sistema de alerta antecipado, Keith voa até uma órbita sob ataque dos Voids. Errkt chega com o cargueiro e segue para o primeiro buraco de minhoca, e o Ten. [[character/8]] se junta a eles com seu esquadrão. Keith precisa proteger o cargueiro até que ele atravesse.", false],
		[41, "", "A blindagem do cargueiro fica muito danificada, mas Errkt alcança o buraco de minhoca, e Keith o segue.", false],
	],
	"step/41": [
		[41, "", "O esquadrão de Baffour não atravessou o buraco de minhoca a tempo, então Keith e Errkt estão sozinhos. O cargueiro está em rota de colisão com a nave-mãe, e Keith precisa abater os caças dos Voids em seu caminho.", false],
		[42, "", "Quando o cargueiro se aproxima, Errkt informa que sua cápsula de fuga foi atingida. Ele decide ficar no cargueiro e ordena que Keith vá embora enquanto ainda há tempo. Keith se despede e dá meia-volta.", false],
	],
	"step/42": [
		[42, "", "Keith precisa se afastar enquanto o cargueiro de Errkt avança para o alvo.", false],
		[43, "", "Brent informa que os buracos de minhoca se fecharam em todo o setor: o plano deu certo. Keith conta que Errkt não sobreviveu, e Brent promete homenageá-lo em seu relatório ao Império Vossk. Eles combinam de se encontrar para um drinque em [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith se junta a Brent em [[station/98]] para comemorar.", false],
		[44, "", "Depois de vários drinques, Carla chega em um vestido de noite para cobrar o encontro que deve a Keith. Brent, com discrição, deixa os dois a sós.", false],
	],
	"step/44": [
		[44, "", "Keith acorda em [[station/98]] de ressaca depois da noite com Carla.", false],
		[45, "", "Carla foi embora. Seu bilhete explica que ela partiu para outro projeto secreto em um lugar que não vai revelar e que a Deep Science está pagando a Keith uma última quantia de 40.000 créditos. Keith suspeita que foi usado o tempo todo e volta para o bar.", false],
	],
	"step/45": [
		[45, "", "A história está concluída. A nave-mãe dos Voids foi destruída, os buracos de minhoca se fecharam e [[character/0]] está livre para ir aonde quiser. Você pode continuar voando, comerciando, minerando e aceitando trabalhos por toda a galáxia; veja [[world/history]] para um resumo de toda a história.", false],
	],
	"step/5": [
		[5, "", "Keith precisa despistar o pirata e atracar em segurança em [[station/78]].", false],
		[6, "", "Gunant admite que os ataques piratas à sua estação estão piorando. Keith se oferece para cuidar deles se receber armas. Gunant decide tentar um ataque ao esconderijo pirata perto da estação e abre seu pequeno hangar para que Keith possa instalar uma arma e blindagem.", false],
	],
	"step/6": [
		[6, "", "No hangar da estação, Keith precisa equipar a [[ship/0]] com uma arma e uma placa de blindagem (veja [[guide/fitting]]).", false],
		[7, "", "Gunant aprova a escolha. Por precaução, ele ajustou as armas de Keith para que não consigam atravessar os escudos dele. Os dois combinam de se encontrar lá fora.", false],
	],
	"step/7": [
		[7, "", "Gunant transmite a rota até o esconderijo como pontos de navegação. Keith precisa segui-la e destruir as naves piratas que estão lá, com Gunant voando ao seu lado (veja [[guide/combat]]).", false],
		[8, "", "O esconderijo abriga muito mais piratas do que o esperado. Gunant quer recuar, mas Keith continua lutando e vence. Quando Gunant pergunta onde ele aprendeu a lutar assim, Keith conta que serviu na Frota Espacial sob o comando do almirante Smith. Gunant acha isso estranho, já que Keith parece jovem demais.", false],
	],
	"step/8": [
		[8, "", "Vencida a batalha, Keith e Gunant voltam para [[station/78]].", false],
		[9, "", "Gunant agradece a Keith por ter salvado sua vida e menciona o túmulo do almirante Smith em [[station/5]]. Keith fica atordoado: o almirante morreu de velhice por volta de 3612. Gunant então lhe diz que o ano atual é 3624, um ano que, segundo ele, será lembrado pelos Voids.", false],
	],
	"step/9": [
		[9, "", "Abalado pela notícia, Keith atraca novamente em [[station/78]] para acertar as coisas com Gunant.", false],
		[10, "", "Keith percebe que se passaram cerca de 35 anos desde que foi atingido no cinturão de asteroides. Gunant suspeita de uma falha no hiperpropulsor, já que esse tipo de propulsor é associado a incidentes parecidos há anos.", false],
		[10, "", "Para agradecer pela vitória sobre os piratas, Gunant dá a [[ship/0]] a Keith, equipada com um propulsor mais potente para viajar entre os planetas do sistema. Ele fica com o laser de mineração, um protótipo que ele mesmo construiu. Keith finalmente diz seu nome e parte para encontrar o capitão [[character/3]], um comandante humano na estação [[station/79]] que pode ajudá-lo a chegar ao espaço [[faction/0]]. A partir de agora, o [[chart]] permite viajar dentro do sistema.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] é um sistema niveliano na borda esquerda do mapa. Ele fica oculto no mapa estelar até você comprar suas coordenadas de [[agent/12]] em [[station/18]]. Seu portal em [[station/0]] o liga a [[system/2]] e [[system/8]].", false],
		[0, "", "As estações de Suteo estão entre as mais avançadas do espaço niveliano, com [[station/2]] e [[station/4]] no nível tecnológico máximo. O agente [[agent/0]] vende um projeto em [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] é um sistema terrano no canto inferior esquerdo do mapa. Ele fica oculto até você comprar suas coordenadas de [[agent/13]] em [[station/26]]. Seu portal em [[station/5]] o liga a [[system/8]] e [[system/18]].", false],
		[0, "", "Suas estações são bem desenvolvidas, com [[station/7]] no nível tecnológico máximo. O agente [[agent/1]] vende um projeto em [[station/8]].", false],
		[9, "", "Segundo [[character/2]], o almirante Smith, antigo comandante de [[character/0]], está enterrado em [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] é um sistema vossk no lado direito do mapa, classificado como Perigoso. Ele fica oculto até você comprar suas coordenadas de [[agent/14]] e não tem nenhuma conexão por portal: só uma nave com motor de salto consegue chegar lá. Todas as suas cinco estações têm os níveis tecnológicos mais altos.", false],
		[0, "", "O agente [[agent/5]] vende um projeto em [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] é um sistema terrano no centro superior do mapa, classificado como Médio. Ele tem apenas três estações. Seu portal em [[station/55]] o liga a [[system/7]], [[system/9]], [[system/14]] e [[system/16]].", false],
		[18, "", "[[character/0]] é enviado a [[station/56]] para encontrar um oficial da Deep Science.", false],
		[19, "", "O oficial, [[character/5]], foi sequestrado por piratas perto de [[station/55]].", false],
		[22, "", "[[character/0]] o liberta com bombas de EMP em [[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] é um pequeno sistema vossk com apenas duas estações, no lado direito do mapa e classificado como Médio. Seu portal em [[station/60]] o liga a [[system/3]], [[system/5]], [[system/13]] e [[system/14]], unindo assim o espaço vossk ao leste terrano.", false],
		[0, "", "O agente multípode [[agent/6]] vende um projeto em [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] é um sistema terrano na borda direita do mapa, classificado como Arriscado. Seu portal em [[station/65]] o liga a [[system/12]] e [[system/16]].", false],
		[0, "", "O agente ciborgue [[agent/14]] vende coordenadas em [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] é um sistema terrano perto do centro do mapa e um dos dois sistemas Seguros da galáxia. Seu portal em [[station/70]] o liga a [[system/3]], [[system/11]], [[system/12]] e [[system/19]]. Suas estações são em geral de baixo nível tecnológico.", false],
		[0, "", "O agente [[agent/7]] vende um projeto em [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] é um sistema midoriano no alto do mapa, classificado como Perigoso. Ele não tem conexões por portal, então uma nave só consegue entrar ou sair dele com um motor de salto. Suas cinco estações são todas pequenas e de baixo nível tecnológico. Até [[step/16]], seus vendedores de naves ficam fechados e poucas naves vão e vêm.", false],
		[0, "", "A história começa aqui, em [[station/78]].", false],
		[11, "", "O sistema é o território da [[faction/3|Confederação Mido]], fundada por exilados terranos e nivelianos durante a Guerra Civil Niveliana. Os nivelianos ainda o reivindicam, e há combates em sua periferia.", false],
		[15, "", "[[character/0]] deixa o sistema como prisioneiro em um cruzador terrano depois de [[step/14]]. Para voltar mais tarde, é preciso um motor de salto.", false],
		[0, "", "[[character/2]] vende um projeto no lounge de [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] é um sistema terrano no lado direito do mapa, classificado como Arriscado. Seu portal em [[station/80]] o liga a [[system/11]] e [[system/13]].", false],
		[0, "", "O agente vossk [[agent/8]] vende um projeto em [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] é um sistema niveliano no canto superior esquerdo do mapa, classificado como Arriscado, e o sistema mais próximo de [[system/15]]. Seu portal em [[station/85]] o liga a [[system/2]], [[system/9]] e [[system/4]]; é a única rota de portal até [[system/4]].", false],
		[0, "", "O agente vossk [[agent/15]] vende coordenadas em [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] é um sistema terrano na parte de baixo do mapa, classificado como Arriscado. Seu portal em [[station/90]] o liga a [[system/1]] e [[system/8]].", false],
		[0, "", "O agente [[agent/9]] vende um projeto em [[station/90]].", false],
		[28, "", "Em [[step/28]], [[character/0]] vem para cá depois de um relato de atividade dos Voids perto de [[station/91]], para entrar em um buraco de minhoca.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] é um sistema terrano no centro do mapa, classificado como Seguro. Seu portal em [[station/95]] o liga a [[system/3]], [[system/8]], [[system/9]] e [[system/14]].", false],
		[15, "", "[[station/98]] é para onde o cruzador terrano leva [[character/0]] depois da prisão e onde ele reencontra seu velho amigo [[character/1]].", false],
		[16, "", "Nem mesmo este sistema seguro é poupado: um esquadrão dos Voids ataca [[station/98]] em [[step/16]]. [[character/1]] mantém seu quartel-general lá.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] é um sistema niveliano no lado esquerdo do mapa e a encruzilhada do espaço niveliano. Seu portal em [[station/30]] o liga a [[system/0]], [[system/8]], [[system/9]] e [[system/17]]. Ele tem quatro estações de nível tecnológico intermediário.", false],
		[34, "", "Em [[step/33]], [[character/6]] envia [[character/0]] a [[station/30]], onde [[character/1]] o espera com um novo plano. Os últimos preparativos contra os Voids também acontecem lá.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] é um sistema vossk no canto inferior direito do mapa, classificado como Perigoso. Seu portal em [[station/62]] o liga a [[system/5]] e [[system/21]], sendo a única rota de portal até [[system/21]].", false],
		[0, "", "Um terrano, o agente [[agent/10]], vende um projeto na pequena estação [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] é um sistema vossk no extremo canto inferior direito do mapa, classificado como Perigoso. Ele fica oculto até você comprar suas coordenadas de [[agent/15]]. Seu portal em [[station/12]] o liga apenas a [[system/20]]. Suas estações são todas primitivas, com nível tecnológico 3 ou menos.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] é o sistema vossk mais próximo do centro do mapa e a principal entrada para o espaço vossk. Seu portal em [[station/15]] o liga a [[system/5]], [[system/12]], [[system/8]], [[system/14]] e [[system/19]]. Ele é classificado como Médio.", false],
		[0, "", "O agente [[agent/12]], em [[station/18]], vende as coordenadas do sistema oculto [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] é um sistema midoriano no canto superior esquerdo do mapa, classificado como Perigoso. É um beco sem saída: seu portal em [[station/20]] alcança apenas [[system/17]]. Suas estações vão da primitiva [[station/21]] à bem equipada [[station/22]].", false],
		[0, "", "O agente [[agent/2]] vende um projeto no lounge de [[station/20]].", false],
		[38, "", "Em [[step/38]], um comboio roubado que transporta explosivos nivelianos é rastreado até este sistema, perto de [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] é um sistema vossk no canto inferior direito do mapa, classificado como Arriscado. Seu portal em [[station/25]] o liga a [[system/3]], [[system/12]] e [[system/20]]. O agente [[agent/13]] vende coordenadas em [[station/26]].", false],
		[35, "", "O sistema é a base do comandante vossk [[character/7]], em [[station/29]], onde [[character/0]] o encontra em [[step/35]].", false],
		[36, "", "A disputa entre os dois acontece perto de [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] é um sistema terrano no canto superior direito do mapa, classificado como Perigoso. Ele não aparece nos mapas estelares comuns, e só a história revela suas coordenadas. Ele tem uma única estação, [[station/10]], cujo portal o liga apenas a [[system/7]].", false],
		[23, "", "O sistema esconde a estação de pesquisa secreta da Deep Science. [[character/5]] entrega as coordenadas a [[character/0]] em [[step/22]], e boa parte da luta contra os Voids é planejada lá.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] é um sistema terrano no canto superior direito do mapa, classificado como Arriscado. Seu portal em [[station/35]] o liga a [[system/11]] e ao sistema oculto [[system/6]], sendo a única rota de portal até esse sistema oculto. [[station/37]] é sua estação mais avançada.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] é um sistema terrano no quadrante inferior esquerdo do mapa e o sistema mais bem conectado da galáxia. Seu portal em [[station/40]] o liga a seis sistemas: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] e [[system/19]]. Ele é classificado como Médio.", false],
		[0, "", "O agente [[agent/4]] vende um projeto em [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] é um sistema niveliano no centro superior do mapa, classificado como Médio. Seu portal em [[station/45]] o liga a [[system/2]], [[system/11]], [[system/17]] e [[system/19]].", false],
		[24, "", "Há relatos de atividade dos Voids perto de [[station/48]], e [[character/0]] e [[character/6]] vão até lá em [[step/24]] para recolher destroços.", false],
	],
	"world/galaxy": [
		[0, "Visão geral", "O jogo se passa em uma única galáxia de 22 sistemas estelares. Cada sistema pertence a uma facção, tem um nível de segurança e abriga de uma a cinco estações espaciais. Cada estação orbita um planeta e tem sua própria loja, hangar e Space Lounge. Os sistemas estão distribuídos em um mapa plano, e as viagens entre eles passam por uma rede de portais de salto.", false],
		[0, "", "Quatro povos são donos dos sistemas mapeados. Os [[faction/0|terranos]] têm dez, os [[faction/1]] seis, os [[faction/2|nivelianos]] quatro e os [[faction/3|midorianos]] dois. Membros de raças menores, como os [[faction/4|multípodes]], os [[faction/5|ciborgues]], os [[faction/6|bobolianos]] e os [[faction/7]], vivem entre eles sem território próprio. [[faction/8|Piratas]] circulam por todos os sistemas, e desde o início há rumores sobre uma força hostil chamada [[faction/9|Voids]].", false],
		[0, "Disposição", "Os sistemas nivelianos e midorianos ficam no canto superior esquerdo do mapa, ao redor de [[system/15]], [[system/4]], [[system/17]] e [[system/2]]. O espaço terrano se estende pelo centro, pelo lado direito e pela parte de baixo do mapa, tendo [[system/19]] e [[system/14]] como núcleo. Os sistemas vossk formam um bloco separado no canto inferior direito, começando em [[system/3]] e terminando no canto mais distante, em [[system/21]].", false],
		[0, "", "As rotas de portal favorecem o centro. [[system/8]] tem seis conexões por portal, mais do que qualquer outro sistema, e [[system/19]], [[system/14]], [[system/3]] e [[system/11]] ligam quatro ou cinco sistemas cada. Sistemas nas bordas, como [[system/4]], [[system/6]] e [[system/21]], são becos sem saída com uma única conexão.", false],
		[0, "Viagens", "Dentro de um sistema, o propulsor comum de uma nave a leva da órbita de uma estação à de outra. Para sair de um sistema, a nave atravessa o portal de salto, que fica em uma das estações do sistema e só alcança os sistemas ligados a ele. Viagens mais longas são sequências de saltos por portais. Um motor de salto é a única forma de evitar a rede de portais e chegar diretamente a qualquer sistema conhecido; veja [[guide/navigation]].", false],
		[33, "", "O único motor de salto do jogo é o [[item/85]], que [[character/20]] projeta durante a história. Ele é fabricado a partir de um projeto e exige, entre outras coisas, [[item/164]].", false],
		[0, "Segurança", "Cada sistema é classificado como Seguro, Médio, Arriscado ou Perigoso. A classificação define com que frequência há atacantes de tocaia perto de uma estação quando você chega. Em um sistema Perigoso, eles aparecem na maioria das visitas; em um Seguro, são raros. Os atacantes costumam ser piratas, mas às vezes são naves da raça rival da facção. Em compensação, os sistemas mais seguros mantêm mais naves de patrulha locais ao redor de suas estações.", false],
		[0, "Facções e reputação", "Sua reputação é registrada em duas escalas: uma entre os terranos e os vossk, a outra entre os nivelianos e os midorianos. Ganhar a simpatia de um lado de um par custa a simpatia do outro. Se sua reputação com uma facção cair demais, as naves dela atacam você assim que o veem e as estações dela recusam você. Piratas e Voids são sempre hostis. Um diplomata em um Space Lounge pode recuperar sua reputação mediante pagamento.", false],
		[0, "Sistemas ocultos", "Nem todos os sistemas aparecem no mapa estelar desde o início. [[system/0]], [[system/1]], [[system/10]] e [[system/21]] ficam ocultos até você comprar as coordenadas deles de um agente em um Space Lounge; veja [[guide/lounge]]. Mais um sistema, [[system/6]], não consta nos mapas estelares comuns e só a história o revela.", false],
		[23, "", "As coordenadas de [[system/6]] chegam até você por meio de [[character/5]] em [[step/22]]. O sistema tem uma única estação, [[station/10]], a base de pesquisa secreta da organização Deep Science.", false],
		[0, "", "Dois sistemas não têm nenhuma conexão por portal: [[system/15]] e [[system/10]]. Uma nave só consegue chegar a eles, ou sair deles, com um motor de salto.", false],
		[0, "Um começo isolado", "A história começa em [[system/15]], um sistema remoto no alto do mapa, sem conexão por portal com o resto da galáxia. O comércio é fraco, as estações têm baixo nível tecnológico e os vendedores de naves ficam fechados durante a primeira parte da história. No início, a única saída do sistema é a que a história oferece.", false],
		[11, "", "[[system/15]] é a sede da [[faction/3|Confederação Mido]], um grupo de refugiados e foras da lei terranos e nivelianos que colonizou este setor recém-mapeado durante a Guerra Civil Niveliana. A Confederação se declarou independente. Os terranos aceitam isso; os nivelianos ainda reivindicam o sistema, o que mantém os combates em suas fronteiras.", false],
		[15, "", "[[character/0]] deixa [[system/15]] a bordo de um cruzador terrano depois que o comboio em [[station/79]] o desativa e o prende em [[step/14]]. Ele chega a [[station/98]], no sistema [[system/19]], em pleno espaço terrano.", false],
		[9, "O salto no tempo", "Quando [[character/0]] acorda em [[system/15]], ele acredita que pouco tempo se passou. Na verdade, seu hiperpropulsor danificado o lançou através da galáxia e cerca de 35 anos para o futuro. A galáxia que ele conhecia mudou: velhos amigos envelheceram ou morreram, e novos setores, entre eles aquele onde ele está, foram colonizados nesse meio-tempo.", false],
		[10, "", "Hiperpropulsores defeituosos do mesmo tipo já causaram saltos parecidos no tempo e no espaço antes.", false],
		[18, "Além do mapa", "Os Voids entram nos sistemas mapeados por uma espécie de buraco de minhoca. Eles atacam igualmente o espaço terrano, niveliano e vossk e parecem estar atrás de minério. Veja [[world/voids]].", false],
		[25, "", "Um buraco de minhoca leva para fora da galáxia mapeada, até o setor dos próprios Voids, que não tem lugar no mapa estelar. Os buracos de minhoca se abrem perto de uma estação por algum tempo, depois se fecham e aparecem em outro lugar.", false],
		[34, "", "Com o [[item/85]] instalado, uma nave também pode saltar diretamente para o setor dos Voids.", false],
		[32, "", "A partir de [[step/31]], um sistema de alerta antecipado mostra no mapa estelar onde o próximo buraco de minhoca vai se abrir.", false],
		[42, "", "Quando a nave-mãe dos Voids é destruída em [[step/41]], os buracos de minhoca de todo o setor se fecham e os ataques cessam.", false],
	],
	"world/history": [
		[0, "", "A galáxia é compartilhada por vários povos, entre eles os [[faction/0|terranos]], os [[faction/2|nivelianos]] e os [[faction/1|vossk]]. O espaço entre suas estações é infestado de [[faction/8|piratas]]. Esta página resume a história; cada parte aparece quando o seu salvamento chega até ela.", false],
		[0, "Primeiro ato: perdido", "O caçador de recompensas terrano [[character/0]] destrói uma gangue de piratas em um cinturão de asteroides ([[step/0]]).", false],
		[1, "", "Um último disparo danifica seu hiperpropulsor no momento em que ele salta para se encontrar com seu antigo comandante, o almirante Smith. Sua nave, com o piloto inconsciente, deriva até [[station/78]].", false],
		[2, "", "O comerciante de minério niveliano [[character/2]] recolhe os destroços, fica com a nave e obriga Keith a minerar para ele.", false],
		[8, "", "Keith ajuda Gunant a destruir um esconderijo de piratas próximo ([[step/7]]).", false],
		[9, "", "Em seguida, Keith descobre que o ano é 3624 e que o almirante Smith morreu há muito tempo.", false],
		[10, "", "Uma falha no hiperpropulsor levou Keith 35 anos para o futuro e a um canto remoto da galáxia. Gunant lhe dá a nave [[ship/0]] e o envia ao encontro de [[character/3]] na estação [[station/79]].", false],
		[11, "", "O sistema [[system/15]] pertence à [[faction/3|Confederação Mido]], fundada por exilados terranos e nivelianos durante a Guerra Civil Niveliana.", false],
		[12, "", "Keith descobre que a tripulação da estação silenciosa [[station/76]] foi dopada até o torpor pelo traficante [[character/4]] ([[step/11]]).", false],
		[15, "", "Quando um comboio terrano passa pelo sistema, confunde Keith com um pirata, desativa sua nave e o leva para [[station/98]] ([[step/14]]).", false],
		[16, "Segundo ato: a ameaça dos Voids", "Lá ele reencontra seu velho amigo [[character/1]], agora chefe de segurança, bem no momento em que os [[faction/9|Voids]] atacam a estação.", false],
		[18, "", "Os Voids invadem sistemas estelares através de buracos de minhoca em busca de minério. Brent recruta Keith para pilotar para a Deep Science, uma organização de pesquisa secreta que os estuda ([[step/17]]).", false],
		[19, "", "O cientista [[character/5]], que deveria guiar Keith até a estação de pesquisa, é sequestrado por piratas.", false],
		[23, "", "Keith desativa a nave dos sequestradores com bombas de EMP, resgata o cientista e recebe as coordenadas do sistema [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Terceiro ato: Deep Science", "Na estação [[station/10]], Keith conhece a líder do projeto, [[character/6]], e começa a trabalhar para a Deep Science.", false],
		[25, "", "Keith e Carla recolhem destroços dos Voids perto de [[station/48]], mas um buraco de minhoca engole a nave ([[step/24]]).", false],
		[26, "", "Os dois vão parar no setor de origem dos Voids, ao lado de uma gigantesca nave-mãe, e escapam por outro buraco de minhoca.", false],
		[30, "", "Keith volta ao setor dos Voids por um buraco de minhoca perto de [[station/91]] e lança uma sonda contra a nave-mãe ([[step/29]]).", false],
		[32, "", "Brent dá a Keith um sistema de alerta antecipado que mostra onde os Voids vão atacar em seguida.", false],
		[34, "", "O cientista Grey [[character/20]] pede a Keith que colete cristais do Void para um novo propulsor instantâneo e lhe entrega o projeto dele ([[step/33]]).", false],
		[35, "Quarto ato: o ataque", "A sonda revela que a nave-mãe é quem cria os buracos de minhoca. Brent e Carla planejam destruí-la com um cargueiro cheio de explosivos nivelianos, fornecido pelo comandante vossk [[character/7]].", false],
		[37, "", "Errkt insiste em pilotar o cargueiro pessoalmente, e Keith conquista o direito de escoltá-lo ([[step/36]]).", false],
		[39, "", "Keith recupera o comboio que transporta os explosivos depois que naves Mido o capturam ([[step/38]]).", false],
		[42, "", "Com reforços comandados por [[character/8]], Keith escolta Errkt através de um buraco de minhoca. Errkt lança o cargueiro contra a nave-mãe e morre no ataque ([[step/41]]).", false],
		[43, "", "Todos os buracos de minhoca se fecham e os ataques dos Voids terminam.", false],
		[45, "Epílogo", "Keith comemora com Brent e finalmente passa uma noite com Carla. Ela parte na manhã seguinte para outro projeto secreto, e Keith fica livre para percorrer a galáxia.", false],
	],
	"world/voids": [
		[0, "", "Os [[faction/9|Voids]] são a principal ameaça da história. Esta página reúne o que se descobre sobre eles; mais informações aparecem conforme o seu salvamento avança.", false],
		[2, "Primeiros relatos", "Keith ouve falar dos Voids pela primeira vez por [[character/2]]: seres hostis que aparecem de tempos em tempos até mesmo no remoto sistema [[system/15]].", false],
		[9, "", "No sistema Mido, as pessoas acham que 3624 será lembrado como o ano dos Voids.", false],
		[16, "", "Caças dos Voids atacam [[station/98]], no espaço terrano ([[step/15]]).", false],
		[17, "", "Durante o ataque, os Voids transmitem uma mensagem afirmando que vêm em paz, mas continuam atirando.", false],
		[18, "O que se sabe", "Os Voids começaram a aparecer algumas semanas antes. Eles entram em sistemas habitados através de buracos de minhoca, atacam tudo o que encontram e parecem estar atrás de minério. Até sistemas [[faction/1]] são atacados. Ninguém sabe de onde vêm nem o que querem.", false],
		[24, "", "Perto de [[station/48]], eles anunciam que vêm do futuro e que são tudo o que resta das civilizações da galáxia.", false],
		[26, "O setor de origem", "Seus buracos de minhoca levam a um setor de origem distante, onde uma gigantesca nave-mãe lança caças. Os buracos de minhoca ficam abertos por pouco tempo, depois se fecham e reaparecem em outro lugar.", false],
		[28, "", "Os Voids avisam que destruí-los significaria destruir o futuro da humanidade.", false],
		[30, "", "Eles repetem que precisam encontrar uma forma de se comunicar antes que os humanos os destruam e, com eles, o próprio futuro. Nunca se esclarece se essa afirmação é verdadeira.", false],
		[32, "", "Um sistema de alerta antecipado desenvolvido pela equipe de [[character/1]] prevê onde os Voids vão abrir seu próximo buraco de minhoca.", false],
		[33, "", "O cientista Grey [[character/20]] acredita que cristais encontrados apenas no setor dos Voids, [[item/164]], guardam o segredo de seus buracos de minhoca.", false],
		[35, "O fim dos ataques", "A sonda lançada contra a nave-mãe mostra que ela é a origem dos buracos de minhoca. Nenhuma arma conhecida conseguiu danificá-la.", false],
		[42, "", "Um cargueiro vossk carregado de explosivos nucleares nivelianos, pilotado por [[character/7]], destrói a nave-mãe ([[step/41]]).", false],
		[43, "", "Depois disso, os buracos de minhoca se fecham por todo o setor e os ataques dos Voids cessam, pelo menos por enquanto.", false],
	],
}
