extends RefCounted
## Reference prose in Spanish. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Primeros pasos", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Planos y producción", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/combat": {"title": "Combate", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Naves y equipamiento", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/flight": {"title": "Vuelo", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Trabajos freelance", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medallas", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/mining": {"title": "Minería", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navegación", "subtitle": "Guía", "category": "guide", "from": 0},
	"guide/trading": {"title": "Comercio", "subtitle": "Guía", "category": "guide", "from": 0},
	"step/0": {"title": "Recompensa en el cinturón de asteroides"},
	"step/1": {"title": "A la deriva"},
	"step/10": {"title": "Encuentro con el comandante"},
	"step/11": {"title": "Una estación en silencio"},
	"step/12": {"title": "Informe al comandante"},
	"step/13": {"title": "A la espera del convoy"},
	"step/14": {"title": "El convoy terrano"},
	"step/15": {"title": "Bajo arresto"},
	"step/16": {"title": "Defensa de la estación"},
	"step/17": {"title": "La historia de los Voids"},
	"step/18": {"title": "Cita con un científico"},
	"step/19": {"title": "El secuestro"},
	"step/2": {"title": "El primer cargamento de mineral"},
	"step/20": {"title": "Instalar las bombas"},
	"step/21": {"title": "Inutilizar a los secuestradores"},
	"step/22": {"title": "El científico rescatado"},
	"step/23": {"title": "La estación de investigación secreta"},
	"step/24": {"title": "Recuperación de restos Void"},
	"step/25": {"title": "Perdidos en un espacio extraño"},
	"step/26": {"title": "Despistar a los perseguidores"},
	"step/27": {"title": "Un nuevo encargo"},
	"step/28": {"title": "De nuevo al agujero de gusano"},
	"step/29": {"title": "Lanzamiento de la sonda"},
	"step/3": {"title": "Entrega del mineral"},
	"step/30": {"title": "La llamada de un viejo amigo"},
	"step/31": {"title": "Una sorpresa prometida"},
	"step/32": {"title": "El científico grey"},
	"step/33": {"title": "Cristales del Void"},
	"step/34": {"title": "Un plan para la victoria"},
	"step/35": {"title": "Encuentro con el comandante vossk"},
	"step/36": {"title": "Un duelo de pilotos"},
	"step/37": {"title": "Llamada al cuartel general"},
	"step/38": {"title": "Recuperar el convoy"},
	"step/39": {"title": "Últimos preparativos"},
	"step/4": {"title": "Una bodega llena"},
	"step/40": {"title": "Escolta hasta el agujero de gusano"},
	"step/41": {"title": "Ataque a la nave nodriza"},
	"step/42": {"title": "Huida del espacio del Void"},
	"step/43": {"title": "Una celebración"},
	"step/44": {"title": "La mañana siguiente"},
	"step/45": {"title": "Epílogo"},
	"step/5": {"title": "Huida a la estación"},
	"step/6": {"title": "Armar la nave"},
	"step/7": {"title": "El escondite pirata"},
	"step/8": {"title": "Después de la batalla"},
	"step/9": {"title": "Ajuste de cuentas"},
	"world/galaxy": {"title": "La galaxia", "subtitle": "Ambientación", "category": "world", "from": 0},
	"world/history": {"title": "Historia", "subtitle": "Ambientación", "category": "world", "from": 0},
	"world/voids": {"title": "Los Voids", "subtitle": "Ambientación", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] es un agente niveliano que está en el lounge de [[station/3]], en el sistema oculto [[system/0]]. Vende el plano del láser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] es un agente niveliano que está en el lounge de [[station/8]], en el sistema oculto [[system/1]]. Vende el plano del bláster [[item/15]], un arma que él califica de rara.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] es un agente terrano que vive entre los vossk, en el lounge de [[station/59]], en [[system/20]]. Vende el plano del dispositivo de camuflaje [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] es el comerciante de mineral [[character/2]], que aparece en su propio lounge de [[station/78]], en [[system/15]]. Vende el plano de [[item/90]], su propio láser de minería, a un precio muy superior al de cualquier otro agente. Como [[system/15]] no tiene conexiones por portal, para llegar hasta él más adelante en el juego hace falta un motor de salto.", false],
		[10, "", "Saluda a [[character/0]] como el viajero del tiempo y ha empezado a fabricar el taladro que antes guardaba para sí.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] es un agente vossk que está en el lounge de [[station/18]], en [[system/3]]. Vende las coordenadas del sistema oculto [[system/0]] y elogia sus numerosas estaciones avanzadas.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] es un agente boboliano que está en el lounge de [[station/26]], en [[system/5]]. Vende las coordenadas del sistema oculto [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] es un agente cyborg que está en el lounge de [[station/65]], en [[system/13]]. Vende las coordenadas de [[system/10]], pero admite que no tiene ni idea de cómo llegar allí. Sin un motor de salto, las coordenadas no sirven de nada, ya que el sistema no tiene conexiones por portal.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] es un agente vossk que está en el lounge de [[station/88]], en [[system/17]]. Vende las coordenadas del sistema oculto [[system/21]], al que llama su hogar. Una vez conocido, se puede llegar al sistema por portal desde [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] es un agente midoriano que está en el lounge de [[station/20]], en [[system/4]]. Vende el plano del [[item/25]], el plano de arma más barato que ofrece un agente, aparte del cohete de [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] es un agente terrano que está en el lounge de [[station/10]], en [[system/6]]. Vende el plano del [[item/27]], un acelerador de masas de disparo rápido.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] es un agente terrano que está en el lounge de [[station/43]], en [[system/8]]. Vende el plano del [[item/33]], el plano más barato que ofrece cualquier agente.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] es un agente vossk que está en el lounge de [[station/54]], en [[system/10]], un sistema al que solo se llega con un motor de salto. Vende el plano del torpedo guiado [[item/37]], que ninguna tienda tiene a la venta.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] es el único multipod del juego. Se sienta en el lounge de [[station/61]], en [[system/12]], y vende el plano del arma nuclear [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] es un agente terrano que está en el lounge de [[station/72]], en [[system/14]]. Vende el plano del [[item/54]], un escudo potente.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] es un agente vossk que está en el lounge de [[station/84]], en [[system/16]]. Vende el plano del [[item/59]], una placa de blindaje vossk que nunca se vendió en tiendas. Es el plano más caro que vende cualquier agente, después del taladro de [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] es un agente terrano que está en el lounge de [[station/90]], en [[system/18]]. Vende el plano del [[item/67]], un compresor de carga que recomienda a todos los comerciantes.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] es el protagonista y el personaje que controlas. Es un piloto de caza [[faction/0]] que se gana la vida cazando [[faction/8|piratas]] por las recompensas que se ofrecen por ellos. Es seguro de sí mismo, sarcástico y rápido en buscar pelea.", false],
		[1, "Varado", "De camino a Eden Prime, donde el almirante Smith tiene una misión especial para él, su hipermotor resulta dañado en un ataque pirata. El piloto automático lo lleva, inconsciente, hasta [[station/78]].", false],
		[2, "", "Allí lo rescata el comerciante de mineral [[character/2]], que ha reclamado su nave como salvamento y lo pone a trabajar como minero.", false],
		[8, "", "Keith es un veterano de la Flota Espacial Terrana, donde sirvió a las órdenes del almirante Smith.", false],
		[9, "", "Se entera de que el almirante ha muerto de viejo y de que ahora es el año 3624.", false],
		[10, "", "Han pasado unos 35 años desde su accidente, al parecer por un fallo del hipermotor, pero Keith no ha envejecido nada. Varado en el remoto sistema [[system/15]], vuelve a empezar con [[ship/0]], un regalo de Gunant.", false],
		[16, "La guerra contra los Voids", "Tras una detención por error, se reencuentra con su viejo amigo [[character/1]] en [[station/98]] y libra su primera batalla contra los [[faction/9|Voids]].", false],
		[18, "", "Brent lo recluta como piloto para Deep Science, la organización de investigación que estudia a los Voids.", false],
		[24, "", "En [[station/10]] conoce a [[character/6]], la directora del proyecto, y pronto se siente atraído por ella.", false],
		[26, "", "Carla y él son arrastrados por un agujero de gusano Void hasta el sector de origen de los Voids y encuentran el camino de vuelta.", false],
		[36, "", "El comandante vossk [[character/7]] conoce el servicio anterior de Keith en Novaterra.", false],
		[43, "", "Keith escolta el carguero que destruye la nave nodriza Void y pone fin a los ataques, aunque Errkt muere en el ataque.", false],
		[45, "Después", "Su recompensa es una noche con Carla, que luego desaparece hacia otro proyecto secreto y le deja un último pago. Con el trabajo hecho, Keith es libre de recorrer la galaxia.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] es un viejo amigo de Keith de antes de su accidente. En los 35 años que Keith perdió, Brent ha ascendido a capitán de corbeta y jefe de la Agencia de Seguridad Interestelar. Es amable, hablador y aficionado a contar largas historias personales.", false],
		[18, "La crisis de los Voids", "Como jefe de seguridad, preside el gabinete de crisis que coordina la respuesta a los [[faction/9|Voids]]. Recluta a Keith para Deep Science y se asegura de que le paguen bien. Por orden suya se repinta la nave de Keith.", false],
		[19, "", "Cuando secuestran al científico [[character/5]], Brent apoya el plan de rescate de Keith y le proporciona bombas EMP en [[station/55]].", false],
		[32, "", "Su equipo desarrolla el sistema de alerta temprana que muestra dónde abrirán los Voids su próximo agujero de gusano.", false],
		[35, "", "Junto con [[character/6]] idea el plan para destruir la nave nodriza Void con un carguero lleno de explosivos, y negocia el acuerdo con el comandante vossk [[character/7]].", false],
		[43, "Después", "Tras la destrucción de la nave nodriza, Brent celebra la victoria con Keith en [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] es un comerciante de mineral [[faction/2]] que dirige una pequeña estación minera, [[station/78]], en el sistema [[system/15]]. Encuentra los restos de la nave de [[character/0]], salva a su piloto y reclama la nave como salvamento. Brusco y práctico, obliga a Keith a saldar su deuda extrayendo mineral con [[ship/0]], una vieja nave que él mismo remendó.", false],
		[8, "", "Cuando Keith le ayuda a destruir un escondite pirata cercano a su estación, Gunant empieza a respetarlo.", false],
		[10, "", "En agradecimiento, le regala [[ship/0]] a Keith con un motor mejor y lo envía a ver a su amigo [[character/3]]. Gunant es también miembro de la [[faction/3|Confederación de Mido]]. Diseña sus propios láseres de minería y, como el agente [[agent/11]], vende el plano de uno de ellos, el [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] es un científico [[faction/7|grey]] que trabaja para Deep Science. Pide reunirse con [[character/0]] en [[station/10]].", false],
		[33, "", "Khador habla con una cortesía muy elaborada. Tras estudiar los restos Void, cree que unos cristales que solo se encuentran en el sector Void encierran el secreto de los agujeros de gusano de los Voids. Lleva años desarrollando un motor capaz de llevar una nave al instante a cualquier punto del espacio, y le pide a Keith que reúna 50 [[item/164]] para él.", false],
		[34, "", "Cuando Keith le entrega los cristales, Khador lo recompensa con una copia del plano del motor que lleva su nombre, el [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] es un capitán humano que se unió a la [[faction/3|Confederación de Mido]] y ahora está al mando de [[station/79]]. [[character/2]] se lo recomienda a Keith como alguien que puede ayudarle a volver al espacio terrano.", false],
		[11, "", "Norris recibe a Keith y le explica la historia del sistema [[system/15]]. Se ofrece a ponerlo en contacto con la Flota Espacial Terrana si Keith investiga antes el silencio de [[station/76]].", false],
		[13, "", "Organiza que Keith se reúna con un convoy terrano que pasa por el sistema, y le sugiere que acepte trabajos freelance mientras espera.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] es un conocido traficante al que Keith conoció hace mucho. Keith lo encuentra en [[station/76]], donde ha suministrado a toda la tripulación neuroalgas, una droga con desagradables efectos secundarios. Mkkt recuerda a Keith y siente curiosidad por saber por qué no ha envejecido.", false],
		[13, "", "Al oír el informe de Keith, [[character/3]] promete ocuparse de él.", false],
	],
	"character/5": [
		[18, "", "Tommy es el teniente Thomas Boyle, un científico que trabaja para Deep Science. [[character/1]] organiza un encuentro con Keith en [[station/56]] para que lo guíe hasta la estación de investigación secreta de la organización.", false],
		[19, "", "Antes del encuentro, unos piratas secuestran a Boyle cerca de [[station/55]] y piden un rescate por él.", false],
		[23, "", "Después de que Keith inutilice la nave de los secuestradores, Boyle es rescatado. Le da a Keith las coordenadas del sistema [[system/6]] y viaja con él hasta [[station/10]].", false],
	],
	"character/6": [
		[23, "", "La Dra. Paolini es la científica de Deep Science que espera a Keith y a Boyle en [[station/10]].", false],
		[24, "", "La Dra. Carla Paolini dirige el proyecto de Deep Science sobre los [[faction/9|Voids]]. Es decidida y trabajadora, e insiste en ver a los Voids con sus propios ojos, así que vuela con [[character/0]] en su primera misión de recuperación de restos. Keith se siente atraído por ella desde el primer encuentro.", false],
		[26, "", "Keith y ella son arrastrados por un agujero de gusano hasta el sector de origen de los Voids y escapan juntos por los pelos.", false],
		[28, "", "Su equipo construye una sonda para analizar la nave nodriza Void. Acepta tener una cita con Keith si vuelve de la misión con vida.", false],
		[34, "", "Demasiado ocupada con su investigación para acudir a la cita, idea con [[character/1]] un plan para atacar la nave nodriza.", false],
		[44, "Después", "Tras la victoria, se une a Keith y a Brent en [[station/98]] para la cita tanto tiempo aplazada.", false],
		[45, "", "A la mañana siguiente se ha ido y deja una nota: se ha marchado a otro proyecto secreto y le pide a Keith que no la busque.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] es un comandante [[faction/1]] al mando de [[station/29]], en el sistema [[system/5]]. Proporciona el carguero K'Sarr para el ataque contra la nave nodriza Void a cambio de prisioneros.", false],
		[36, "", "Orgulloso y formal, cree que solo un vossk puede pilotar bien una nave vossk e insiste en pilotar él mismo el carguero. Pone a prueba la habilidad de Keith antes de aceptarlo como escolta.", false],
		[37, "", "Después de que Keith lo venza en un duelo en un escondite pirata, Errkt lo trata con respeto.", false],
		[40, "", "Antes de la misión se muestra tranquilo y reservado, algo que Brent interpreta como determinación.", false],
		[42, "Muerte", "Errkt pilota el carguero a través del agujero de gusano y lo estrella contra la nave nodriza. Cuando su cápsula de escape queda destruida, se niega a dar la vuelta y muere en la explosión, tras poner a Keith a salvo.", false],
		[43, "", "Brent promete informar de su sacrificio al Imperio Vossk.", false],
	],
	"character/8": [
		[40, "", "El teniente [[character/8]] dirige el escuadrón de refuerzos que se une a Keith para proteger el carguero vossk de camino al agujero de gusano.", false],
		[41, "", "Su escuadrón no consigue cruzar el agujero de gusano antes de que se cierre, así que Keith y [[character/7]] se enfrentan solos a los Voids.", false],
	],
	"chart": [
		[0, "", "El mapa de la galaxia enumera todos los sistemas con su facción, nivel de seguridad, número de estaciones y posición en el mapa. La posición se indica con dos números del 0 al 100: el primero cuenta desde el borde izquierdo del mapa estelar y el segundo desde arriba. Los sistemas con números parecidos están cerca unos de otros.", false],
		[0, "", "En el juego, abre el mapa estelar desde una estación o en vuelo. Una línea discontinua une tu sistema actual con cada sistema al que llega su portal de salto; las demás rutas de portales aparecen como líneas finas. Las estrellas a las que puedes llegar ahora mismo brillan, y las demás aparecen atenuadas. Unos marcadores señalan el sistema de tu misión de la historia y el de tu trabajo actual, y una línea discontinua de color muestra la ruta de portales más corta hasta allí. Una línea dorada tenue traza tus últimos viajes.", false],
		[0, "", "Selecciona un sistema para ver su facción, nivel de seguridad y distancia. Amplía para ver sus estaciones, su nivel tecnológico y marcadores para las estaciones que has visitado, los objetivos de misión y el portal de salto. Los sistemas ocultos no aparecen hasta que conoces sus coordenadas; consulta [[world/galaxy]].", false],
		[32, "", "Cuando tienes el sistema de alerta temprana del [[step/31]], el mapa estelar también marca el sistema y la estación donde se abrirá el próximo agujero de gusano Void.", false],
	],
	"faction/0": [
		[0, "", "Los terranos son humanos, y [[character/0]] es uno de ellos. Controlan diez sistemas, más que ninguna otra facción, repartidos por el centro, el lado derecho y la parte inferior del mapa, con [[system/19]] y [[system/14]] como núcleo. El espacio terrano es la parte más segura de la galaxia: sus dos sistemas «Safe» (Seguro) son terranos.", false],
		[0, "", "Las estaciones terranas venden la gama más amplia de naves y equipamiento. Los vendedores de naves fuera del espacio vossk ofrecen una gran variedad de cascos. Los rivales tradicionales de los terranos son los [[faction/1]]: la reputación que se gana con unos se pierde con los otros.", false],
		[16, "", "La Flota Espacial Terrana sigue siendo la fuerza en la que sirvió [[character/0]], pero han pasado 35 años. Cuando por fin se encuentra con un convoy terrano, este confunde su vieja nave de construcción pirata con un enemigo y lo detiene.", false],
		[18, "", "Los terranos encabezan la defensa contra los Voids. [[character/1]], ahora jefe de la Agencia de Seguridad Interestelar, preside un gabinete de crisis, y el grupo de investigación Deep Science estudia el problema desde una estación secreta.", false],
	],
	"faction/1": [
		[0, "", "Los vossk son un pueblo alienígena organizado como un imperio. Controlan seis sistemas en la parte inferior derecha del mapa, desde [[system/3]] y [[system/12]] hasta el remoto [[system/21]]. Cuatro de ellos tienen un nivel «Dangerous» (Peligroso) o «Risky» (Arriesgado). [[system/10]] no tiene ninguna conexión por portal.", false],
		[0, "", "Los vendedores de naves vossk solo venden un casco, la [[ship/9]], un modelo adaptado para otras razas. Las estaciones vossk también ofrecen armas y equipamiento que no se encuentran en ningún otro sitio. Los vossk son los rivales tradicionales de los [[faction/0|terranos]], así que sus naves pueden unirse a los asaltantes en el espacio terrano, y al revés.", false],
		[18, "", "Las relaciones entre los terranos y el Imperio Vossk siguen siendo frías e imprevisibles, pero los ataques de los Voids también golpean los sistemas vossk.", false],
		[36, "", "En la historia, los vossk se muestran orgullosos y regidos por el honor. Su comandante [[character/7]] insiste en pilotar él mismo el carguero bomba y pone a prueba a [[character/0]] con un duelo antes de aceptarlo como escolta.", false],
		[42, "", "[[character/7]] da su vida para destruir la nave nodriza Void, y los terranos prometen informar de su hazaña al Imperio Vossk.", false],
	],
	"faction/2": [
		[0, "", "Los nivelianos son un pueblo alienígena que controla cuatro sistemas en el lado izquierdo del mapa: [[system/2]], [[system/9]], [[system/17]] y el oculto [[system/0]]. Sus estaciones van desde pequeños puestos avanzados hasta algunas de las más avanzadas de la galaxia. Sus rivales son los [[faction/3|midorianos]].", false],
		[2, "", "La primera persona que conoce [[character/0]] es un niveliano, el comerciante de mineral [[character/2]]. [[character/0]] tiene mala opinión de los modales nivelianos, mientras que [[character/2]] insiste en que es un hombre de negocios honrado.", false],
		[11, "", "Una guerra civil niveliana dio origen a la [[faction/3|Confederación de Mido]]. Los nivelianos nunca aceptaron su independencia y siguen reclamando el sistema [[system/15]].", false],
		[35, "", "El plan contra la nave nodriza Void se basa en explosivos nucleares nivelianos.", false],
	],
	"faction/3": [
		[0, "", "Los midorianos son el pueblo de la [[faction/3|Confederación de Mido]]. Controlan dos sistemas en la parte superior izquierda del mapa, [[system/15]] y [[system/4]], ambos con nivel «Dangerous» (Peligroso). Sus estaciones son en su mayoría pequeñas y de poca tecnología. Sus rivales son los [[faction/2|nivelianos]].", false],
		[11, "", "La Confederación la fundaron refugiados y proscritos terranos y nivelianos durante la guerra civil niveliana. Mantiene el contacto con otros sistemas al mínimo. [[character/3]], comandante de [[station/79]], es uno de sus miembros, y también lo es [[character/2]].", false],
		[38, "", "La Confederación no es amiga de los nivelianos. Sus naves capturan el convoy que transporta los explosivos nivelianos destinados a la nave nodriza Void, y [[character/0]] tiene que recuperarlo cerca de [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Los multipods son una raza menor sin sistemas propios. El único multipod que conoces es el agente [[agent/6]], que vende un plano en el lounge de [[station/61]], en [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Los cyborgs no tienen territorio. El único cyborg del juego es el agente [[agent/14]], en el lounge de [[station/65]], que comercia con las coordenadas de un sistema oculto.", false],
	],
	"faction/6": [
		[0, "", "Los bobolianos son una raza menor sin sistemas propios. El agente [[agent/13]], un boboliano, se sienta en el lounge de [[station/26]], en el espacio vossk, y vende las coordenadas de un sistema oculto.", false],
	],
	"faction/7": [
		[0, "", "Los grey son una raza sin sistemas, estaciones ni naves propias. No participan en el comercio ni en el combate.", false],
		[32, "", "El único grey de la historia es [[character/20]], un científico que colabora con Deep Science.", false],
		[33, "", "Estudia los restos de naves Void y desarrolla a partir de ellos un nuevo tipo de motor.", false],
	],
	"faction/8": [
		[0, "", "Los piratas son proscritos de todas las razas. No controlan ningún sistema, pero aparecen en todas partes y son siempre hostiles. La frecuencia con la que acechan cerca de una estación depende del nivel de seguridad del sistema. Muchos trabajos freelance consisten en darles caza, y sus restos se pueden saquear para obtener carga.", false],
		[0, "", "La historia empieza con [[character/0]] persiguiendo a una banda pirata por la recompensa que se ofrece por sus cabezas.", false],
		[2, "", "[[ship/0]], la nave que [[character/2]] presta a [[character/0]], fue en su día una nave pirata.", false],
		[16, "", "Por eso los terranos lo toman más tarde por un pirata.", false],
		[19, "", "Los piratas también secuestran a [[character/5]] cerca de [[station/55]] y piden un rescate.", false],
	],
	"faction/9": [
		[0, "", "Los Voids son una fuerza hostil que ataca sin aviso. No controlan ningún sistema del mapa, y sus naves abren fuego contra todos. Su caza, la [[ship/8]], es el casco con más blindaje del juego. Consulta [[world/voids]].", false],
		[2, "", "En [[system/15]], los Voids solo se conocen por rumores y por algún avistamiento ocasional.", false],
		[16, "", "Un escuadrón Void ataca [[station/98]] mientras [[character/0]] está allí. Sus mensajes de radio afirman tener intenciones pacíficas mientras disparan.", false],
		[18, "", "Los Voids llegan a través de agujeros de gusano que se abren cerca de las estaciones durante poco tiempo. Atacan por igual sistemas terranos, nivelianos y vossk, y parecen buscar mineral. Nadie sabe de dónde vienen.", false],
		[24, "", "En [[station/48]] emiten una afirmación más extraña: que vienen del futuro y son todo lo que queda de las civilizaciones de la galaxia.", false],
		[26, "", "Un agujero de gusano lleva a su propio sector, donde una enorme nave nodriza lanza sus cazas.", false],
		[35, "", "La nave nodriza parece ser el origen de los agujeros de gusano.", false],
		[42, "", "La destrucción de la nave nodriza en el [[step/41]] derrumba los agujeros de gusano y pone fin a los ataques, al menos por el momento.", false],
	],
	"guide/basics": [
		[0, "El comienzo", "Una partida nueva empieza en el espacio, no en una estación. [[character/0]] persigue a una banda de piratas por un campo de asteroides, y el primer vuelo es un combate breve que enseña a pilotar, apuntar y disparar. Mientras dura, solo se muestran la mira y los marcadores de las naves. Destruye a los piratas y deja que la escena termine; después la historia avanza por sí sola.", false],
		[2, "", "Tras el comienzo despiertas en [[station/78]], una pequeña estación minera que dirige [[character/2]]. Te presta [[ship/0]], una nave sin armas con un láser de minería, y los primeros pasos enseñan a minar, a usar el piloto automático y a atracar. Las armas, el mapa y el resto de la estación se desbloquean a medida que avanza la historia.", false],
		[0, "Atracar", "Para atracar, mantén la mira sobre una estación hasta fijarla y pulsa Disparar: el piloto automático toma el control y te lleva dentro. También puedes entrar en la estación pilotando tú mismo; la nave atraca en cuanto toca el casco. Al atracar se resuelve casi todo el papeleo. El casco, el blindaje y los escudos se restauran gratis, se entregan las cargas y los pasajeros, se recogen los productos de planos terminados, se conceden nuevas medallas y la partida se guarda sola.", false],
		[0, "Pantallas de la estación", "Una estación en la que has atracado ofrece seis secciones: «Hangar», Space Lounge, «Map» (Mapa), «Missions» (Misiones), «Status» (Estado) y «Game Options» (Opciones de juego). Al principio de la historia algunas están bloqueadas y aparecen con un candado. El «Hangar» se abre en el [[step/5]], el «Map» en el [[step/9]], y el Space Lounge y «Missions» en el [[step/13]]. «Status» y «Game Options» están siempre disponibles.", false],
		[0, "", "El «Hangar» contiene «Shop» (Tienda: compra y venta de mercancías y equipamiento), «Ship» (Nave: instalar y retirar equipamiento), «Ships» (Naves: el vendedor de cascos, en las estaciones que tienen uno) y «Blueprints» (Planos: producción). En el Space Lounge esperan clientes, comerciantes y pilotos de alquiler. «Map» muestra la galaxia y te permite elegir un destino. «Missions» muestra el objetivo actual de la historia y el trabajo freelance que hayas aceptado. «Status» muestra tu historial de piloto, tu reputación con las cuatro grandes razas y tus medallas. La barra superior muestra el «Tec Level» (nivel tecnológico) de la estación, que decide qué puede tener su tienda.", false],
		[0, "Salir de una estación", "Pulsa «Depart» (Despegar) para salir. Cada vuelo empieza con unos segundos en los que ves salir tu nave, con los datos del sistema y un consejo; cualquier tecla, clic o toque lo omite. Si elegiste un destino en «Map» antes de salir, el piloto automático pone rumbo hacia él en cuanto termina el despegue. No puedes salir con más carga de la que cabe en la bodega, así que antes vende o instala lo que sobre.", false],
		[0, "Guardar la partida", "La partida se guarda automáticamente tras cada atraque completado, una vez resueltas las recompensas y el siguiente paso de la historia. También puedes guardar a mano en una de tres ranuras desde «Game Options» mientras estás atracado, y cargar cualquier ranura o el autoguardado desde allí o desde la pantalla de título. Fuera de la versión de navegador, «Game Options» también permite exportar una partida a un archivo y volver a importarla. Las partidas pertenecen a los datos del juego con los que se crearon.", false],
		[0, "", "Si tu nave es destruida, el vuelo termina y continúas desde la estación de tu último autoguardado, o empiezas de nuevo si no hay ninguno. Todo lo ganado desde ese atraque se pierde, así que atraca de vez en cuando durante los viajes largos.", false],
		[0, "Nivel de piloto", "Tu piloto tiene un nivel, que se muestra en la pantalla «Status». La experiencia se obtiene con las bajas, los trabajos freelance (dos puntos cada uno), los núcleos extraídos, cada cincuenta toneladas de mineral extraído y cada dos pilotos de escolta contratados. El nivel sube uno cada vez que la experiencia supera 1,3 veces la cifra que tenía en la última subida, y se comprueba al atracar. Un nivel más alto hace más duros a los enemigos, pero también aumenta las recompensas freelance y las tarifas de los pilotos contratados.", false],
	],
	"guide/blueprints": [
		[0, "Planos", "Algunas de las mejores armas y equipamientos nunca se venden en tiendas. En su lugar se fabrican a partir de planos. Un plano indica qué mercancías necesita y en qué cantidades. Los planos se compran a los agentes con nombre del Space Lounge, que aparecen cuando la historia ha superado el [[step/16]]; cada agente vende un plano, una sola vez.", false],
		[34, "", "El plano del motor de salto [[item/85]] no lo vende nadie: la historia te lo entrega en el [[step/34]].", false],
		[0, "Producción", "La producción se realiza en la pestaña «Blueprints» (Planos) del «Hangar». Elige un plano y entrega ingredientes de tu bodega. Puedes entregarlos por partes a lo largo de varias visitas. La estación donde entregas por primera vez pasa a ser la estación de producción de ese lote. Los ingredientes entregados en cualquier otra estación se envían allí por 10 créditos por tonelada, así que conviene llevarlo todo al mismo sitio.", false],
		[0, "Productos terminados", "Cuando se entrega el último ingrediente, el lote está terminado. Las armas secundarias se fabrican de diez en diez; todo lo demás, de uno en uno. Si terminas en la estación de producción, los productos van directamente a tu bodega, aunque eso la sobrecargue. Si no, esperan en la estación de producción y se te entregan la próxima vez que atraques allí. Un plano nunca se agota: cuando un lote está terminado, puedes empezar el siguiente.", false],
		[0, "Medallas", "Poseer planos cuenta para [[medal/13]], y terminar planos distintos cuenta para [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Armas primarias", "Las armas primarias son cañones fijos que disparan hacia delante: láseres, blásters, autocañones y armas térmicas. Cada una tiene su propio daño, cadencia, alcance y velocidad de proyectil, y todas las primarias instaladas disparan a la vez. Algunos blásters, como el [[item/16]], son armas EMP que agotan la energía de una nave en lugar de su casco. El Disparo automático mantiene las armas disparando contra el objetivo sin pulsar el botón.", false],
		[0, "Escudos, blindaje y casco", "El daño agota primero el escudo, luego la placa de blindaje y solo después el propio casco. Un escudo se recarga por completo a lo largo de su tiempo de recarga; el blindaje y el casco no. Un robot de reparación repara lentamente el casco y el blindaje durante el vuelo. Al atracar se restaura todo gratis. Cuando el casco se agota, la nave es destruida.", false],
		[0, "EMP", "Cada nave tiene una reserva de energía. Las armas EMP la agotan, y una nave que se queda sin energía queda inutilizada: va a la deriva, indefensa, hasta que la energía se recupera. A una nave inutilizada se le puede robar la carga con un rayo tractor, y algunos trabajos exigen inutilizar una nave en lugar de destruirla. El equipamiento de protección EMP, como el [[item/60]], tiene un valor de defensa EMP.", false],
		[0, "Armas secundarias", "Las armas secundarias disparan desde las ranuras secundarias y consumen munición, que se apila en la ranura. Los cohetes vuelan en línea recta. Los torpedos siguen el blanco fijado por radar poco después del lanzamiento. Las bombas EMP y las nucleares estallan sobre una zona y alcanzan todo lo que está dentro de su onda expansiva, con menos fuerza hacia el borde; las bombas EMP no afectan a los asteroides, mientras que las nucleares los rompen. Elige qué lanzador usar desde el menú Acciones; hasta que lo hagas, la tecla Arma secundaria dispara el primero que esté cargado.", false],
		[0, "Torretas", "Los cascos más grandes tienen ranuras de torreta. Con una torreta instalada, la tecla Vista trasera cambia a la vista de torreta: la nave mantiene el rumbo mientras giras la torreta y disparas, lo que te permite contraatacar a las naves que te persiguen.", false],
		[0, "Pilotos de escolta", "A partir del [[step/16]], en el Space Lounge se pueden encontrar pilotos de alquiler. Un contrato cubre de una a tres naves durante diez minutos de vuelo, y te acompañan adondequiera que vayas hasta que vence. Dales órdenes desde el menú Acciones: disparar a discreción, atacar tu objetivo, asegurar el siguiente punto de ruta de la misión o alternar entre su láser y su bláster EMP. Consulta [[guide/lounge]].", false],
		[0, "Piratas", "Los piratas atacan estaciones, con más frecuencia en los sistemas peligrosos, y acechan a los pilotos que transportan carga o pasajeros. Muchos trabajos freelance consisten en combatirlos. Disparar a los piratas no enfada a nadie; mejora ligeramente tu reputación con la raza que gobierna el sistema.", false],
		[0, "Reputación", "Tu reputación se mide en dos escalas, cada una de -100 a 100: una entre las razas [[faction/0]] y [[faction/1]], y otra entre las razas [[faction/2]] y [[faction/3]]. Perjudicar a una raza desplaza la escala hacia su rival: inutilizar o robar una de sus naves cuesta 2 puntos, y derribarla cuesta 5. Completar un trabajo freelance desplaza la escala 2 puntos hacia la raza del cliente. Cuando una escala supera 60 en cualquier dirección, la raza del lado perdedor se vuelve hostil y sus naves te atacan en cuanto te ven.", false],
		[0, "", "Una raza hostil envía a un diplomático a los Space Lounges, que se ofrece a devolver la escala a cero por una tarifa que crece cuanto más se haya desplazado: como máximo 16.000 créditos. La pantalla «Status» (Estado) muestra ambas escalas. Llevar una escala más allá de 60 también otorga [[medal/28]].", false],
		[0, "Fuego amigo", "Las naves de la raza propia de un sistema solo toleran los disparos perdidos hasta cierto punto. Cuando has quitado un tercio del casco o de la energía de una nave local, esta contraataca y te avisa por radio. Con dos tercios de su casco, o si la inutilizas, todas las naves de esa raza en el sistema se vuelven contra ti. Las naves de otras razas son menos susceptibles, pero derribar una siempre cuesta reputación.", false],
	],
	"guide/fitting": [
		[0, "Cascos", "El casco de una nave determina su blindaje (la resistencia propia del casco), su bodega de carga, su maniobrabilidad y sus ranuras: armas primarias, armas secundarias, torretas y equipamiento. Un casco mejor significa sobre todo más ranuras. Las páginas de naves comparan todos los cascos.", false],
		[0, "Ranuras y la pantalla «Ship» (Nave)", "Los objetos se compran a la bodega y luego se instalan en la pantalla «Ship» del «Hangar». Cada ranura admite un objeto de su categoría; instalar algo en una ranura ocupada devuelve el objeto anterior a la bodega. El equipamiento solo se puede instalar una vez por tipo, salvo los tipos que se apilan, como las unidades de compresión de carga, los camarotes y la protección EMP, de los que se pueden instalar varios, cada uno en su propia ranura. La munición secundaria de un mismo tipo comparte una sola ranura. Un objeto instalado también se puede vender directamente desde su ranura al precio de la estación.", false],
		[0, "Tipos de equipamiento", "Los escudos absorben daño y se recargan. Las placas de blindaje aumentan la resistencia del casco. La protección EMP protege contra la pérdida de energía. La compresión de carga amplía la bodega. Los rayos tractores atraen carga de los restos y de las naves inutilizadas; sin uno, no se puede recoger nada en el espacio. Los turbos dan impulsos de velocidad. Los robots de reparación reparan la nave en vuelo. Las toberas de dirección mejoran la maniobrabilidad. Los escáneres acortan el tiempo para fijar un objetivo, y los mejores muestran la carga del objetivo. Los láseres de minería perforan asteroides. Los camarotes transportan pasajeros. Los dispositivos de camuflaje ocultan la nave durante un tiempo. Un motor de salto viaja sin portales.", false],
		[0, "Comprar un casco", "Las estaciones con vendedor muestran una pestaña «Ships» (Naves) en el «Hangar» con hasta cinco cascos a la venta. Los vendedores [[faction/1]] solo ofrecen el casco de su propia raza, la [[ship/9]]. Un vendedor descuenta del precio de lista tantos puntos porcentuales como el nivel tecnológico de su estación, así que las estaciones de alta tecnología venden los cascos más baratos. Tu casco anterior se acepta como parte del pago por cuatro quintos de su precio de lista. Todo lo instalado pasa a la bodega, así que comprueba que quepa o vende algo antes de salir. No puedes cambiar de casco con pasajeros a bordo, y los camarotes no se pueden retirar mientras están en uso.", false],
		[5, "Primeras armas", "Cuando el hangar de [[station/78]] se abre por primera vez, sus existencias incluyen gratis un láser, un autocañón y una placa de blindaje. Instala un arma y la placa antes de partir hacia la siguiente misión.", false],
		[0, "Cascos raros", "Algunos cascos nunca los ofrecen los vendedores normales. A un piloto que ha ganado todas las medallas en oro se le ofrece un prototipo, la [[ship/8]], en [[station/10]]; consulta [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Pilotaje", "La nave siempre vuela hacia delante. La giras a izquierda y derecha y subes o bajas el morro; al soltar, nivela las alas por sí sola. La rapidez con que gira depende de la maniobrabilidad del casco y de las toberas de dirección instaladas. En «Options» (Opciones), Controles, la Respuesta del timón puede ser Directa, que gira a máxima velocidad de inmediato, o Suave, que entra y sale de los giros de forma progresiva. Con el Pilotaje con ratón, las teclas izquierda y derecha pueden desplazar la nave lateralmente en lugar de girarla.", false],
		[0, "Acelerador", "Acelerar y Decelerar cambian el acelerador en pasos de un cuarto, y mantener pulsada la tecla sigue avanzando paso a paso. La nave tarda alrededor de un segundo en estabilizarse a la nueva velocidad. El piloto automático y el turbo siempre vuelan a pleno acelerador, y reducir el acelerador durante un turbo lo termina.", false],
		[0, "Turbo", "Con un turbo instalado, la tecla Turbo da un impulso de velocidad extra. Un impulso dura lo que indica el turbo y va seguido de un tiempo de recarga antes del siguiente; el HUD muestra si está listo. Los turbos mejores son más rápidos, duran más o se recargan antes. El turbo es útil para escapar de un combate y para cubrir las largas distancias dentro de un sistema.", false],
		[0, "Piloto automático", "La tecla Piloto automático cede el timón al ordenador de la nave, y al pulsarla de nuevo lo recuperas. Vuela hacia lo que esté fijado o, si no hay nada, hacia el destino elegido en «Map» (Mapa): el portal de salto si el destino está en otro sistema, o el planeta del destino si está en este. La Lista del piloto automático ofrece las opciones disponibles donde te encuentras: el destino programado, el portal de salto, esta estación, el campo de asteroides y el siguiente punto de ruta de la misión. Volar hacia una estación fijada termina en un atraque.", false],
		[0, "Velocidad del tiempo", "La tecla Velocidad del tiempo hace que el vuelo transcurra más rápido. La velocidad doble está siempre disponible mientras vuelas. Las velocidades ×4 y ×8 solo se ofrecen mientras vuela el piloto automático, no hay enemigos cerca y no hay nada más en curso, como minar, atracar o saltar.", false],
		[0, "Fijar objetivos", "Para fijar un objeto, mantenlo bajo la mira hasta que termine el escaneo. El escáner instalado decide cuánto tarda: desde varios segundos con un modelo básico hasta menos de dos con el mejor. Siguiente objetivo recorre los objetos cercanos sin apuntarles. Las estaciones, los portales de salto y las estrellas que marcan otros planetas se fijan con una sola pulsación. Lo que hace Disparar depende de lo que esté fijado: con una nave dispara, con una estación atraca, con un portal salta, con una estrella viaja a ese planeta y con un asteroide empieza a minar. Los escáneres mejores también muestran la carga de una nave fijada.", false],
		[0, "Marcadores y radar", "Las naves llevan recuadros en pantalla, y unas flechas en el borde de la pantalla señalan el objetivo, la estación y las amenazas cercanas que quedan fuera de la vista. Los enemigos se marcan en rojo, los aliados en verde, las naves neutrales en amarillo y los puntos de ruta de misión en azul; la opción Colores para daltónicos de «Options», Interfaz los cambia por enemigos en naranja y aliados en azul. Una nave cercana muestra dos pequeñas barras junto a su recuadro: su casco y, en azul, su energía EMP. La Pantalla de vuelo Ampliada añade paneles con cifras exactas y un radar circular; la pantalla Original conserva los paneles de esquina del propio juego.", false],
		[0, "Mirar alrededor", "Vista trasera gira la cámara para mirar detrás de la nave. Si hay una torreta instalada, la misma tecla cambia a la vista de torreta: la nave mantiene el rumbo mientras giras la torreta y disparas con ella. También puedes mirar alrededor de la nave sin pilotar manteniendo Alt y moviendo el ratón, con el stick derecho del mando o arrastrando un dedo por una zona libre de la pantalla.", false],
		[0, "Camuflaje", "Un dispositivo de camuflaje oculta tu nave a las demás naves mientras dura, y quien te persiga pierde tu rastro al instante. Pulsa de nuevo la tecla Dispositivo de camuflaje para apagarlo antes. Después de usarlo necesita tiempo para recargarse antes de volver a funcionar.", false],
		[0, "Atraque y viajes", "Fija la estación y pulsa Disparar, o simplemente entra en ella, para atracar. Las demás estaciones del sistema aparecen como estrellas brillantes; fija una y pulsa Disparar para viajar a ese planeta. La mayoría de los sistemas tienen un portal de salto, cerca de una de sus estaciones, para viajar a otros sistemas; consulta [[guide/navigation]]. Mientras hay un combate freelance en curso en una estación, no puedes atracar, viajar ni saltar hasta ganarlo o perderlo.", false],
	],
	"guide/help": [
		[0, "Teclado", "Estas son las teclas predeterminadas. Todas las acciones de vuelo se pueden reasignar en «Options» (Opciones), Controles, Teclado, donde Restaurar teclas predeterminadas deshace los cambios.", false],
		[0, "", "Girar a la izquierda / Girar a la derecha: flechas izquierda y derecha, o A y D.", true],
		[0, "", "Morro arriba / Morro abajo: flechas arriba y abajo.", true],
		[0, "", "Acelerar / Decelerar: W y S.", true],
		[0, "", "Disparar / usar: Espacio o Ctrl. Dispara las armas, o atraca, salta, viaja o mina cuando hay fijada una estación, un portal, una estrella o un asteroide.", true],
		[0, "", "Arma secundaria: E.", true],
		[0, "", "Turbo: Mayús.", true],
		[0, "", "Piloto automático: Q. Lista del piloto automático: R. Con Mantener piloto automático para la lista activado, mantener Q medio segundo abre la lista.", true],
		[0, "", "Siguiente objetivo: Tab.", true],
		[0, "", "Disparo automático: F.", true],
		[0, "", "Vista trasera: C. Con una torreta instalada, cambia a la vista de torreta.", true],
		[0, "", "Acciones / motor de salto: M. Abre el menú Acciones: elección del arma secundaria, camuflaje, órdenes a los pilotos de escolta y el motor de salto.", true],
		[0, "", "Mapa de rutas: N.", true],
		[0, "", "Dispositivo de camuflaje: V.", true],
		[0, "", "Velocidad del tiempo: T.", true],
		[0, "", "Modo foto: P. Congela el vuelo y oculta la interfaz; arrastra o usa las flechas para girar la cámara, y la rueda o + y - para hacer zoom.", true],
		[0, "", "Menú de pausa: Escape. F11 activa la pantalla completa en sistemas de escritorio.", true],
		[0, "", "En los menús, las flechas se mueven entre las entradas, Enter selecciona y Escape vuelve atrás.", true],
		[0, "Ratón", "Con el Pilotaje con ratón activado, mover el ratón pilota la nave. Durante el vuelo el puntero queda capturado, así que la nave gira según lo mueves; Capturar el puntero en vuelo se puede desactivar, y los menús y las pausas siempre liberan el puntero. El botón izquierdo dispara, el derecho lanza el arma secundaria, y mantener Alt mientras mueves el ratón permite mirar alrededor de la nave. Mientras el ratón pilota, las teclas izquierda y derecha desplazan la nave lateralmente; Teclas izquierda / derecha, en «Options», Controles, puede hacer que siempre desplacen o siempre giren. Sensibilidad del ratón ajusta cuánto gira la nave con cada movimiento.", false],
		[0, "Mando", "El stick izquierdo pilota y el derecho mira alrededor de la nave. RT o RB disparan, LB lanza el arma secundaria, A activa el turbo, Y conecta o desconecta el piloto automático, X selecciona el siguiente objetivo, pulsar el stick derecho da la vista trasera o de torreta, Back abre el menú Acciones y Start pausa. En los menús, la cruceta se mueve, A selecciona y B vuelve atrás. «Options», Controles, Mando ajusta la zona muerta del stick y la vibración.", false],
		[0, "Táctil", "En pantallas táctiles, los controles aparecen en pantalla cuando Controles táctiles está en Automático o Sí. Un stick a un lado pilota; por defecto aparece bajo tu pulgar dondequiera que lo apoyes en ese lado, y Stick fijo lo mantiene en su sitio. Pilotar desde cualquier punto permite pilotar con un dedo en cualquier zona libre de la pantalla. Los botones del otro lado cubren Disparar / usar, Secundaria, Turbo, Piloto automático, Objetivo, Vista trasera, Acciones, Pausa y, durante los mensajes de radio, Siguiente radio. Un control deslizante ajusta el acelerador, y un botón Más rápido acelera el tiempo.", false],
		[0, "", "Toca Disparar dos veces rápido para activar el disparo automático; un toque lo detiene. Arrastrar un dedo por una zona libre de la pantalla mira alrededor de la nave, y al soltar vuelve a mirar al frente. Diseño para zurdos intercambia los lados, Tamaño de controles táctiles cambia la escala de los controles y Ajustar posición de controles permite mover cada uno. Los teléfonos y tabletas también pueden pilotar inclinándolos: activa Pilotar inclinando, sostén el dispositivo como al jugar y calibra.", false],
		[0, "«Options»", "A «Options» se accede desde la pantalla de título, el menú de pausa y «Game Options» (Opciones de juego) en una estación. Tiene cinco páginas. Audio ajusta el volumen de la música y del sonido. Pantalla abarca la ventana, la tasa de fotogramas, la relación de aspecto y los ajustes predefinidos y detalles gráficos. Controles abarca el pilotaje, el ratón, el mando, los controles táctiles y la asignación de teclas. Interfaz abarca el tamaño de la interfaz, la pantalla de vuelo Original o Ampliada, el tamaño y la opacidad del HUD, las ventanas de ayuda, las secuencias de despegue y de entrada a la estación, el radar circular, las etiquetas, el tamaño del texto y opciones de accesibilidad como los colores para daltónicos, la reducción de destellos, la vibración de pantalla y la duración de los mensajes. Juego ajusta el idioma del motor y permite importar otro archivo del juego o gestionar mods.", false],
		[0, "«Help» (Ayuda)", "«Help», accesible desde los mismos lugares, muestra los temas de ayuda y los consejos de carga del propio juego, una lista de las asignaciones de teclas actuales y una tabla que traduce las teclas del teléfono que nombran los textos del juego a las teclas, botones y controles táctiles que se usan aquí.", false],
	],
	"guide/jobs": [
		[0, "Buscar trabajo", "Los trabajos freelance los ofrecen los clientes del Space Lounge. Un cliente describe el trabajo y el pago. Antes de aceptar un trabajo en otro lugar puedes preguntar dónde es y lo difícil que será; también puedes pedir que te repitan la oferta o rechazarla. Solo puedes tener un trabajo a la vez, y la pantalla «Missions» (Misiones) lo muestra con su destino y a cuántos saltos por portal está.", false],
		[0, "Tipos de trabajo", "Hay trece tipos. Hasta el [[step/16]], y en las copias del juego sin la campaña completa, solo se ofrecen cinco: [[job/11]], [[job/0]], [[job/7]], [[job/4]] y [[job/12]]. Después aparece toda la gama: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] y [[job/10]], además de compradores que buscan mercancías ([[job/8]]).", false],
		[0, "Dificultad y recompensa", "Los primeros trabajos tienen una dificultad de uno o dos; los posteriores llegan hasta nueve. La recompensa base de un trabajo es de 1.500 créditos más hasta 5.500 adicionales según la dificultad. Después aumenta con la distancia al destino (se duplica a 1.200 km), y se añaden 200 créditos por nivel de piloto. La retirada de chatarra paga un 30 por ciento menos, las escoltas pagan un 20 por ciento más, la recuperación y el rescate pagan el doble, y los trabajos de pasajeros pagan una base menor más una parte por cada pasajero. Las recompensas se redondean a múltiplos de cincuenta créditos.", false],
		[0, "Realizar un trabajo", "Los trabajos de mensajería y de pasajeros se completan atracando en el destino con la carga o los pasajeros a bordo. Los trabajos de compra se completan volviendo a atracar en la estación del comprador con las mercancías en la bodega. Todos los demás trabajos son combates en la estación de destino, que se preparan cuando llegas allí; mientras hay uno en curso no puedes atracar, viajar ni saltar. Los contenedores recuperados y los rehenes deben llevarse después de vuelta a la estación donde aceptaste el trabajo. Al completar un trabajo, la recompensa se paga en el acto, tu reputación con la raza del cliente mejora y el trabajo cuenta para [[medal/16]].", false],
		[0, "Fracaso", "Un combate fracasa si se incumple su condición: todas las naves que proteges son destruidas, se pierde el contenedor, se acaba el tiempo o el rival derriba más que tú. Un trabajo fallido se cancela sin pago. También puedes abandonar un trabajo desde la pantalla «Missions» (Misiones); en ese caso se retira la carga. Si tu nave es destruida, continúas desde tu último autoguardado.", false],
	],
	"guide/lounge": [
		[0, "Visitantes", "Cada estación tiene un Space Lounge, abierto a partir del [[step/13]]. Allí se sientan de tres a cinco visitantes, que cambian cada vez que atracas. La mayoría pertenecen a la raza que gobierna el sistema, pero algunos vienen de cualquier parte. Habla con un visitante para saber qué quiere; cada respuesta y decisión cuenta para una de las medallas de conversación.", false],
		[0, "Respuestas", "«OK» (De acuerdo) acepta una oferta, «No, thanks» (No, gracias) la rechaza y «How was that again?» (¿Cómo era eso?) la repite. Para un trabajo en otro lugar puedes preguntar «Can you show it on the map?» (¿Me lo enseñas en el mapa?) para conocer el destino y «Will it be difficult?» (¿Será difícil?) para saber lo complicado que es. Los comerciantes te dejan ver primero su mercancía. Rechazar ofertas, pedir que te las repitan y aceptar sin preguntar cuentan para [[medal/32]], [[medal/33]], [[medal/34]] y [[medal/35]]; hablar con visitantes que tienen una oferta cuenta para [[medal/26]].", false],
		[0, "Clientes y conversadores", "Muchos visitantes ofrecen trabajos freelance; consulta [[guide/jobs]]. Otros solo charlan y cuentan rumores, que a veces mencionan estaciones o minerales que conviene conocer.", false],
		[0, "Comerciantes y compradores", "Los comerciantes venden un único lote: una pieza de equipamiento o unas cuantas unidades de una mercancía, a entre el 40 y el 160 por ciento de su precio habitual. A partir del [[step/16]] también aparecen compradores, que piden que se lleve una cantidad de un objeto a esa misma estación; consulta [[job/8]].", false],
		[0, "Pilotos de alquiler", "A partir del [[step/16]], un visitante por lounge puede ofrecer pilotos de escolta: de uno a tres pilotos por una tarifa de 700 a 1.999 créditos por piloto, durante diez minutos de vuelo. Los pilotos [[faction/1]] nunca se alquilan. Solo puedes tener un grupo a la vez. Un piloto que tiene todas las medallas encuentra en su lugar admiradores, que pagan por volar con él.", false],
		[0, "Agentes", "Cuando la historia ha superado el [[step/16]], agentes con nombre esperan en determinadas estaciones y cierran un solo trato cada uno. La mayoría venden un plano; cuatro venden las coordenadas de un sistema oculto, que entonces aparece en el mapa. Cada agente se marcha después del trato. Los agentes tienen sus propias páginas.", false],
		[0, "Diplomáticos", "Cuando una de las cuatro grandes razas se ha vuelto hostil, uno de sus diplomáticos se sienta en cada lounge. Por una tarifa que crece cuanto más haya caído tu reputación, hasta 16.000 créditos, el diplomático devuelve esa escala de reputación a cero.", false],
	],
	"guide/medals": [
		[0, "Niveles", "La mayoría de las medallas tienen tres niveles: bronce, plata y oro. Cada nivel tiene su propio objetivo, y alcanzar uno superior sustituye a la medalla inferior. Unas pocas medallas tienen un único nivel. Las páginas de medallas muestran el objetivo de cada nivel.", false],
		[0, "Cuándo se conceden las medallas", "Tu historial se comprueba al acercarte a una estación, antes de que el atraque repare tu nave, y las medallas nuevas o mejoradas se anuncian una vez atracado. En vuelo no se concede nada, así que un objetivo alcanzado en el espacio solo cuenta en el siguiente atraque. La pantalla «Status» (Estado) enumera todas las medallas que tienes, su nivel y el motivo por el que se concedieron.", false],
		[0, "La primera y la última", "[[medal/0]] se tiene desde el principio de la partida. [[medal/36]] se concede automáticamente cuando se tienen todas las demás medallas.", false],
		[0, "Recompensas", "Tener todas las medallas cambia el trato que te dan los pilotos del Space Lounge: los admiradores te pagan por volar contigo como escolta en lugar de cobrarte una tarifa. Tener todas las medallas en oro te vale la oferta de la [[ship/8]], un prototipo que se vende en [[station/10]]. En la pantalla «Status», [[character/0]] lleva gafas oscuras cuando tiene todas las medallas, y doradas cuando todas son de oro.", false],
	],
	"guide/mining": [
		[0, "Asteroides", "El espacio de cada estación contiene asteroides en dos campos: uno cerca de la estación y otro más alejado, al que te puede llevar la Lista del piloto automático. Los minerales de un campo dependen de lo cerca que esté el sistema del sistema de origen de cada mineral, así que no todos los minerales se encuentran en todas partes. Los asteroides también se pueden destruir a tiros; a veces esto deja flotando un poco de mineral, y los asteroides destruidos cuentan para [[medal/29]].", false],
		[0, "Empezar a minar", "Para minar hace falta un láser de minería y espacio libre en la bodega. Fija un asteroide manteniéndolo bajo la mira y pulsa Disparar. La nave se acerca a la roca y el taladro arranca; no puedes pilotar hasta que termines. Una vez fijado, el HUD muestra el mineral y la clase del asteroide.", false],
		[0, "El taladro", "Un indicador muestra las capas de roca del asteroide apiladas unas sobre otras, cada una más estrecha que la anterior. El taladro deriva hacia un lado y cambia de dirección al azar cada medio segundo a dos segundos y medio. Pilota a izquierda y derecha para mantenerlo dentro de la zona verde de la capa actual. La primera capa requiere seis segundos de perforación, y cada capa más profunda requiere aproximadamente una sexta parte menos de tiempo que la anterior. El mineral se acumula mientras permaneces en la zona verde, y más deprisa en las capas profundas.", false],
		[0, "Zonas rojas", "El tiempo que pasas fuera de la zona verde cuenta como daño y las zonas rojas del indicador crecen. Tras dos segundos y medio en rojo en total, el asteroide se rompe y se pierde todo lo extraído de él. Pulsa Disparar en cualquier momento para parar y quedarte con el mineral reunido hasta entonces. Cada asteroide solo se puede minar una vez.", false],
		[0, "Clases y núcleos", "Los asteroides más grandes tienen más capas, de dos a siete. Los mayores, de clase A, tienen las siete, y perforarlas todas proporciona un núcleo además del mineral. Los núcleos valen mucho más que el mineral y cuentan para [[medal/3]] y [[medal/7]]. Los minerales cuentan para [[medal/2]] y [[medal/6]].", false],
		[0, "Láseres de minería", "Un láser de minería tiene dos valores. Su rendimiento hace que el taladro derive más despacio y se pilote con más precisión, lo que facilita mantenerlo en la zona verde. Su velocidad aumenta el ritmo al que se acumula el mineral. Los láseres van del [[item/86]] al [[item/89]]; el [[item/90]] se fabrica a partir de un plano.", false],
		[0, "Carga", "El mineral y los núcleos van directamente a la bodega, y solo te quedas con lo que quepa. Cuando la bodega está llena, el HUD lo indica y debes vender o descargar en una estación. Las unidades de compresión de carga amplían la bodega en una parte de la capacidad del casco, y se pueden instalar varias a la vez. Lo que más ayuda es un casco más grande.", false],
	],
	"guide/navigation": [
		[0, "El mapa de la galaxia", "La sección «Map» (Mapa) de una estación, y la tecla Mapa de rutas en vuelo, muestran la galaxia: cada sistema conocido en su lugar, las conexiones por portal entre ellos, la raza que gobierna y el nivel de seguridad del sistema. Al elegir un sistema se amplía y se muestran sus estaciones; al elegir allí una estación, se fija como destino. El mapa también muestra la distancia a un sistema en kilómetros, marca las estaciones que has visitado y señala dónde continúan la historia y tu trabajo actual. Un cuadro de búsqueda encuentra estaciones conocidas por su nombre. La página [[chart]] enumera todos los sistemas.", false],
		[0, "", "Al principio de la historia estás limitado a la órbita de tu primera estación. El mapa se abre en el [[step/9]]; a partir de entonces puedes volar a los demás planetas del sistema.", false],
		[0, "Sistemas y seguridad", "Cada sistema está gobernado por una de las cuatro grandes razas y tiene un nivel de seguridad: «Safe» (Seguro), «Average» (Medio), «Risky» (Arriesgado) o «Dangerous» (Peligroso). Los ataques de piratas y enemigos son mucho más frecuentes en los sistemas peligrosos, mientras que los sistemas seguros son en su mayoría tranquilos. La mayoría de los sistemas tienen varias estaciones, cada una en órbita de su propio planeta, con su propia tienda, lounge y nivel tecnológico.", false],
		[0, "Portales de salto", "Los viajes entre sistemas pasan por portales de salto. Un sistema tiene como máximo un portal, situado en el espacio de una de sus estaciones, y solo conecta con sistemas vecinos. Para saltar, elige en «Map» un destino en un sistema vecino, vuela hasta el portal (el piloto automático te llevará), fíjalo y pulsa Disparar una vez dentro de su zona. Los viajes más largos se hacen portal a portal; la pantalla «Missions» (Misiones) muestra cuántos saltos por portal necesita un destino a través de los sistemas que conoces.", false],
		[0, "Sistemas ocultos", "Al principio faltan cinco sistemas en el mapa: [[system/0]], [[system/1]], [[system/6]], [[system/10]] y [[system/21]]. Un sistema oculto aparece cuando has estado allí o has comprado sus coordenadas. Cuatro agentes del Space Lounge las venden: [[agent/12]] las de [[system/0]], [[agent/13]] las de [[system/1]], [[agent/14]] las de [[system/10]] y [[agent/15]] las de [[system/21]]. Los agentes con nombre solo aparecen cuando la historia ha superado el [[step/16]]. [[system/10]] no tiene ninguna conexión por portal y solo se puede llegar a él con un motor de salto.", false],
		[23, "", "El camino a [[system/6]] te lo da la historia en el [[step/22]].", false],
		[0, "Motor de salto", "Un motor de salto lleva la nave directamente a una estación de cualquier sistema conocido, sin portales. El único es el [[item/85]], que nunca se vende en tiendas y debe fabricarse a partir de su plano. Se usa desde el menú Acciones en vuelo. Un salto no cuesta combustible ni tarifa. No está disponible mientras haya un combate freelance en curso en tu estación, aunque los trabajos de mensajería y de pasajeros no lo impiden.", false],
		[34, "", "La historia te da el plano del [[item/85]] en el [[step/34]], con parte de sus ingredientes ya entregados.", false],
		[0, "Distancia", "Las distancias entre sistemas se dan en kilómetros, medidas desde la posición de los sistemas en el mapa. La distancia importa para el comercio, porque los precios suben con la distancia al origen de un objeto, y para los trabajos freelance, cuya recompensa crece con la distancia al destino.", false],
	],
	"guide/tips": [
		[0, "", "Consulta la página de un objeto antes de un viaje comercial: indica el sistema donde el objeto es más barato y la dirección en la que se encarece.", true],
		[0, "", "Las estaciones compran y venden al mismo precio, así que una carga solo da dinero cuando se ha alejado de su origen.", true],
		[0, "", "Al minar, reacciona de inmediato a cada cambio de deriva. El tiempo en rojo se acumula durante toda la perforación, así que los pequeños deslices cuestan tanto como uno largo.", true],
		[0, "", "Si el taladro ya ha pasado mucho tiempo en rojo, detenlo con Disparar y quédate con lo que tienes en lugar de perder toda la carga.", true],
		[0, "", "Busca los asteroides más grandes si quieres núcleos: solo las rocas de clase A tienen uno, y solo si atraviesas las siete capas.", true],
		[0, "", "Instala pronto un rayo tractor. Sin él no se puede recoger en absoluto la carga de los restos y de las naves inutilizadas.", true],
		[0, "", "Un escáner mejor se amortiza en combate: fija los objetivos más deprisa, y los mejores muestran lo que lleva una nave antes de atacarla.", true],
		[0, "", "Atracar repara tu nave gratis, así que merece la pena detenerse en una estación entre combates en lugar de seguir adelante con el casco dañado.", true],
		[0, "", "Atraca con regularidad en los viajes largos. Solo un atraque completado crea un autoguardado, y si tu nave es destruida vuelves al último.", true],
		[0, "", "Vigila tu reputación en la pantalla «Status» (Estado). Los disparos perdidos contra naves locales se acumulan, y toda una raza puede volverse hostil.", true],
		[0, "", "Pregunta a un cliente dónde es el trabajo y lo difícil que será antes de aceptarlo, salvo que estés reuniendo las medallas por no preguntar.", true],
		[0, "", "Haz sitio en la bodega antes de aceptar un trabajo de mensajería, e instala camarotes antes de un trabajo de pasajeros: ninguno de los dos se puede aceptar sin el espacio necesario.", true],
		[0, "", "Para los trabajos de recuperación y de rescate, lleva un arma EMP, un escáner que muestre la carga, un rayo tractor y algo de espacio libre en la bodega.", true],
		[0, "", "Lleva todos los ingredientes de un plano a la estación donde lo empezaste y te ahorrarás el coste de envío.", true],
		[0, "", "Contrata pilotos de escolta justo antes de un combate difícil: su contrato solo descuenta tiempo mientras vuelas.", true],
	],
	"guide/trading": [
		[0, "Cómo se fijan los precios", "Cada objeto tiene un precio mínimo, un precio máximo y un sistema de origen. En el origen se vende a su precio mínimo; cuanto más lejos del origen está una estación, más alto es el precio, hasta llegar al precio máximo a una distancia fija. Además, cada estación añade su propia variación fija de hasta un cinco por ciento aproximadamente, hacia arriba o hacia abajo. Las páginas de objetos muestran dónde es más barato un objeto y en qué dirección se encarece.", false],
		[0, "Comprar y vender", "Una estación compra al mismo precio al que vende, así que el beneficio solo viene de transportar mercancías: compra cerca del origen de un objeto y véndelo lejos de él. Las mercancías que vendes se añaden a las existencias de la estación. La pantalla «Shop» (Tienda) también recuerda el precio más bajo y el más alto que has visto para cada objeto, y en qué sistema, y los muestra junto al objeto. Hay carga que no se puede vender, como la de mensajería y los contenedores que transportas para un cliente.", false],
		[0, "Qué vende una tienda", "Cada estación tiene un «Tec Level» (nivel tecnológico). Sus existencias incluyen objetos de ese nivel o inferior; las estaciones de nivel cuatro o superior excluyen los objetos por debajo de la mitad de su propio nivel. Cada objeto tiene además una probabilidad de estar a la venta en una tienda concreta, así que las existencias varían de una visita a otra. Unos pocos objetos están siempre a la venta en una estación concreta. Algunas mercancías solo se venden en sistemas [[faction/1]], y los productos de planos no se venden nunca.", false],
		[0, "", "Las mercancías básicas se ofrecen en cantidades mayores, y en cantidades mucho mayores cerca de su origen. Las armas y el equipamiento suelen ofrecerse de uno en uno o hasta tres, mientras que los cohetes, torpedos y bombas vienen en lotes más grandes. Las existencias se reponen cada vez que atracas, salvo en las tres últimas estaciones que has visitado, que las mantienen tal como las dejaste.", false],
		[0, "Licores", "Cada sistema tiene su propia bebida local, que solo se vende en ese sistema, como [[item/132]] en [[system/0]] o [[item/146]] en [[system/14]]. Las bebidas son mercancías comerciales normales. Comprarlas en tiendas cuenta para [[medal/8]]; poseer distintos tipos comprados a comerciantes del lounge o recuperados de restos cuenta para [[medal/9]].", false],
		[0, "Otras fuentes", "Los comerciantes del Space Lounge ofrecen lotes sueltos a entre el 40 y el 160 por ciento del precio habitual, así que conviene comparar sus ofertas. Las naves llevan carga que se puede recoger con un rayo tractor cuando son destruidas o inutilizadas, y el mineral se puede extraer. Los compradores del lounge piden una cantidad de un objeto concreto y pagan muy por encima de su valor; consulta [[job/8]].", false],
	],
	"home": [
		[0, "", "Esta referencia trata de Galaxy on Fire 2, un juego espacial de comercio, minería, combate y exploración. Pilotas como [[character/0]], un piloto veterano varado lejos de casa, a través de 22 sistemas estelares controlados por humanos y razas alienígenas. Entre las misiones de la historia puedes aceptar trabajos freelance, minar asteroides, comerciar con mercancías, fabricar equipamiento a partir de planos y comprar naves cada vez mejores.", false],
		[0, "", "Las páginas se generan a partir del juego que importaste. Los nombres, cifras, precios y diálogos proceden de él, y las explicaciones que los acompañan se han escrito para esta referencia. Los detalles de la historia más allá del punto al que ha llegado tu partida permanecen ocultos hasta que llegues. Buenos puntos de partida son [[world/galaxy]], el [[chart]] y [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Los agentes son comerciantes que se sientan en determinados Space Lounges y venden algo que no se puede comprar en una tienda: un plano poco común o las coordenadas de un sistema oculto. Aparecen a partir del [[step/17]], y cada uno vende solo una vez. Habla con ellos en el lounge de su estación para ver la oferta; consulta [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Los objetos de planos nunca se venden en tiendas. Cada uno se fabrica a partir de una receta de mercancías cuando tienes su plano, que normalmente se compra a un agente en el Space Lounge. Cómo funciona la producción se explica en [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Estas son las personas que [[character/0]] conoce en su viaje: comerciantes, oficiales, científicos y compañías más extrañas. Cada biografía crece a medida que avanza la historia, así que solo sabes de un personaje lo que el propio Keith ha descubierto.", false],
	],
	"intro/equipment": [
		[0, "", "El equipamiento ocupa las ranuras de equipamiento de una nave: escudos y placas de blindaje para protegerse, compresores de carga, rayos tractores para recoger contenedores, turbos, toberas de dirección, escáneres, láseres de minería, camarotes de pasajeros, dispositivos de camuflaje, un robot de reparación y el motor de salto. Cada pieza ocupa una ranura, así que el número de ranuras limita lo completa que puede estar una nave. Los precios varían según el sistema, y las tiendas solo venden objetos hasta el nivel tecnológico de su estación. Algunas de las mejores piezas se fabrican a partir de planos, y varias las fabrican los [[faction/1|vossk]] y solo se venden en sus sistemas.", false],
	],
	"intro/factions": [
		[0, "", "En el juego aparecen diez facciones. Cuatro de ellas poseen sistemas y estaciones: los terranos, los vossk, los nivelianos y los midorianos. Las demás no tienen territorio y solo te las encuentras como individuos o como enemigos. Tu reputación con las cuatro grandes potencias se mide en dos escalas, terranos contra vossk y nivelianos contra midorianos; consulta [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Las mercancías son todo lo que se transporta en la bodega para comerciar. Las mercancías básicas y las bebidas se compran baratas en un sistema y se venden caras en otro (consulta [[guide/trading]]); cada sistema tiene su propia bebida. Los minerales se extraen de los asteroides, y perforar todas las capas de un asteroide de clase A proporciona un núcleo de mucho más valor (consulta [[guide/mining]]). Las mercancías básicas, los minerales y los núcleos son también los ingredientes para fabricar objetos a partir de planos. Unas pocas mercancías, como [[item/116]] y [[item/131]], solo aparecen mediante trabajos o la historia y no se pueden comprar.", false],
	],
	"intro/guide": [
		[0, "", "Estas páginas explican cómo se juega: volar y combatir, minar y comerciar, las pantallas de la estación, el trabajo freelance, la producción y las medallas. Las cifras citadas aquí siguen las reglas del motor; las tablas de las páginas de objetos, naves y medallas proceden de los datos de tu propio juego. Empieza por [[guide/basics]] y [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Los trabajos freelance son encargos secundarios que ofrecen los clientes del Space Lounge, desde transportar carga hasta cazar a criminales buscados. Proporcionan créditos, reputación con la raza del cliente y experiencia. Existen trece tipos; cómo se ofrecen y se pagan se explica en [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Las medallas premian el historial de un piloto: combate, minería, comercio, viajes e incluso cómo hablas con la gente del Space Lounge. La mayoría tienen niveles de bronce, plata y oro. Se comprueban cada vez que atracas; consulta [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Las naves se diferencian en blindaje, espacio de carga, maniobrabilidad y número de ranuras: ranuras primarias para las armas frontales, ranuras secundarias para cohetes, torpedos y bombas, una ranura de torreta opcional y ranuras de equipamiento para todo lo demás. Los precios suben mucho, desde menos de 20.000 créditos para los cascos más pequeños hasta varios millones para los mejores cazas. Los vendedores de fuera de los sistemas [[faction/1|vossk]] muestran hasta cinco cascos en cada visita; los vendedores [[faction/1|vossk]] solo venden la [[ship/9]]. Un vendedor descuenta del precio de lista tantos puntos porcentuales como el nivel tecnológico de su estación, y paga cuatro quintos del precio de lista por tu casco anterior. La [[ship/0]] y la [[ship/10]] no se venden nunca. Consulta [[guide/fitting]] para saber cómo equipar una nave.", false],
	],
	"intro/stations": [
		[0, "", "Cada estación tiene una tienda, un hangar, un vendedor de naves y un Space Lounge. Su nivel tecnológico, del 1 al 10, determina lo avanzados que pueden ser las mercancías y el equipamiento a la venta, y su vendedor descuenta ese mismo porcentaje del precio de lista de las naves. Las existencias cambian de una visita a otra. Las estaciones que aparecen en la historia o que albergan a un agente tienen aquí una breve descripción.", false],
	],
	"intro/story": [
		[0, "", "La historia sigue a [[character/0]], un piloto terrano cuya caza de piratas sale muy mal, a lo largo de 45 pasos. Cada página de paso describe la tarea y, cuando la completas, lo que ocurrió. Las páginas solo revelan lo que tu partida ya ha alcanzado; [[world/history]] cuenta en un solo lugar la historia hasta el momento.", false],
	],
	"intro/systems": [
		[0, "", "La galaxia tiene 22 sistemas estelares. Cada uno pertenece a una facción, tiene un nivel de seguridad que fija la frecuencia con la que aparecen asaltantes y alberga hasta cinco estaciones, una de las cuales tiene el portal de salto. Las conexiones por portal deciden entre qué sistemas puedes viajar; unos pocos sistemas están ocultos o no tienen ninguna conexión. Consulta [[world/galaxy]] y el [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Las armas se dividen en dos grupos. Las armas primarias (láseres, blásters, autocañones y armas térmicas) disparan sin munición desde las ranuras frontales; se diferencian en daño por disparo, cadencia y alcance. Las armas secundarias (cohetes, torpedos, bombas EMP y bombas nucleares) se compran por unidades y se disparan desde las ranuras secundarias. Las torretas necesitan su propia ranura y pueden disparar en cualquier dirección. Algunas armas agotan la energía de una nave en lugar de dañarla, o además de dañarla; una nave sin energía queda inutilizada durante un tiempo. Varias de las mejores armas nunca se venden en tiendas y hay que fabricarlas a partir de planos (consulta [[guide/blueprints]]). Muchos modelos los fabrican los [[faction/1|vossk]] y solo se venden en sus sistemas. Consulta [[guide/combat]] para conocer las tácticas.", false],
	],
	"intro/world": [
		[0, "", "Estas páginas describen la ambientación del juego: la galaxia y su distribución, su historia y las fuerzas que la moldean. Complementan las páginas de sistemas, estaciones y facciones con una visión de conjunto.", false],
	],
	"item/0": [
		[0, "", "El [[item/0]] es el láser básico: 3 de daño por disparo cada 0,4 s, con el alcance de 2.000 unidades que comparten todos los primeros láseres. Es el láser más débil del juego, pero es barato y casi todas las tiendas lo tienen. El [[item/1]] y el [[item/2]] mantienen la misma cadencia y añaden daño.", false],
		[6, "", "Es una de las tres piezas que [[character/2]] ofrece gratis en su hangar de [[station/78]] antes del asalto al escondite pirata, junto con el [[item/22]] y el [[item/55]].", false],
	],
	"item/1": [
		[0, "", "El [[item/1]] es el segundo escalón de la línea Nirai. Dispara tan rápido como el [[item/0]] (cada 0,4 s), pero hace 5 de daño por disparo en lugar de 3, con el mismo alcance. Es una mejora barata hasta que el [[item/2]] resulte asequible.", false],
	],
	"item/10": [
		[0, "", "El [[item/10]] hace 34 de daño cada 1,4 s con un alcance de 2.600. Golpea más fuerte por disparo que el [[item/9]] y llega más lejos, con una cadencia algo más lenta. Es el láser más potente que se vende en tiendas.", false],
	],
	"item/11": [
		[0, "", "El [[item/11]] es el láser más potente del juego: 45 de daño cada 1,5 s con un alcance de 2.600, el disparo individual más fuerte de cualquier arma primaria. Nunca se vende ya fabricado. Su plano lo vende [[agent/0]] en [[station/3]], y fabricarlo consume un [[item/9]] junto con [[item/155]] y varias mercancías básicas.", false],
	],
	"item/116": [
		[0, "", "Los contenedores seguros son carga sellada que solo aparece mediante el trabajo freelance. Aceptar un trabajo de [[job/0]] carga en tu bodega el número acordado, donde ocupan espacio de carga; no se pueden vender y se entregan en el destino. También representan la mercancía robada en los trabajos de [[job/3]], en los que hay que inutilizar la nave que los transporta en lugar de destruirla.", false],
	],
	"item/117": [
		[0, "", "Un camarote seguro es una carga especial que solo aparece mediante el trabajo freelance, en los trabajos de [[job/5]] que te piden liberar a un cautivo de una de varias naves y traerlo de vuelta. Como un [[item/116]], no se puede comprar ni vender.", false],
	],
	"item/12": [
		[0, "", "El [[item/12]] es el bláster [[faction/1|vossk]] básico: 11 de daño cada 0,6 s con un alcance de 1.500. Los blásters llegan menos lejos que los láseres, pero hacen más daño a lo largo del tiempo; incluso este primer modelo supera ligeramente en daño al mejor láser Nirai. También es necesario para fabricar el [[item/15]]. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/13": [
		[0, "", "El [[item/13]] es un bláster [[faction/1|vossk]] que hace 12 de daño cada 0,5 s con un alcance de 1.500, una clara mejora respecto al [[item/12]] en cadencia y daño. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/131": [
		[0, "", "Los [[item/131]] son los restos de los cazas [[faction/9|Void]]. Cada nave [[faction/9|Void]] hostil destruida suelta un contenedor con entre uno y tres, que solo se puede recoger con un rayo tractor (consulta [[item/68]]). Se venden a un precio fijo de 199 créditos, y recogerlos cuenta para la medalla [[medal/21]].", false],
		[24, "", "[[character/6]] necesita estos restos para su investigación y envía a [[character/0]] a recogerlos cerca de [[station/48]].", false],
		[25, "", "Mientras [[character/0]] los transporta de vuelta, los restos no se pueden vender.", false],
		[28, "", "Se entregan al equipo de [[character/6]] al llegar a [[station/10]].", false],
	],
	"item/14": [
		[0, "", "El [[item/14]] es un bláster [[faction/1|vossk]] que dispara cada 0,4 s y hace 10 de daño. Hace algo más de daño a lo largo del tiempo que el [[item/13]], pero su alcance de 1.000 es corto, así que conviene a los pilotos que se acercan a sus objetivos. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/15": [
		[0, "", "El [[item/15]] es el mejor bláster [[faction/1|vossk]]: 10 de daño cada 0,3 s con un alcance de 1.500. Combina la cadencia de los blásters más rápidos con el alcance del [[item/12]]. Nunca se vende ya fabricado. Su plano lo vende [[agent/1]] en [[station/8]], y fabricarlo consume un [[item/12]] y un [[item/166]] junto con varias mercancías básicas.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] es el mineral corriente más valioso. Los campos de asteroides favorecen los minerales cuyo sistema de origen está cerca, y su origen es [[system/9]], donde además es más barato. Se necesita en cantidad para fabricar el [[item/27]]. Perforar por completo un asteroide de clase A de [[item/154]] da un [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] es un mineral de precio medio cuyo sistema de origen es [[system/21]], donde se vende más barato. Es ingrediente del [[item/11]] y de [[item/90]]. Su núcleo es el [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] es el mineral más barato, con origen en [[system/0]]. Su escaso valor lo convierte en una mala carga para vender, pero es ingrediente de la placa de blindaje [[item/59]]. Su núcleo es el [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] es un mineral de precio medio cuyo sistema de origen es [[system/7]]. Junto con su núcleo, el [[item/168]], se necesita para fabricar la placa de blindaje [[item/59]].", false],
	],
	"item/158": [
		[0, "", "[[item/158]] es un mineral de precio medio cuyo sistema de origen es [[system/4]]. Es uno de los minerales necesarios para el [[item/85]]. Su núcleo es el [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] es un mineral de precio medio cuyo sistema de origen es [[system/18]]. Ningún plano lo usa, así que solo se extrae para venderlo o para las medallas de mineral. Su núcleo es el [[item/170]].", false],
	],
	"item/16": [
		[0, "", "El [[item/16]] es el primer bláster EMP. No daña el casco ni el blindaje; en su lugar, cada impacto agota 3 puntos de la energía de una nave, y una nave cuya energía llega a cero queda inutilizada durante un tiempo. Las armas EMP son necesarias cuando hay que detener un objetivo en lugar de destruirlo. Este modelo dispara cada 0,3 s, pero solo alcanza 1.200 unidades. El [[item/17]] y el [[item/18]] llegan más lejos y agotan más energía por disparo.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] es un mineral de precio bajo cuyo sistema de origen es [[system/13]]. Es uno de los minerales necesarios para el [[item/85]]. Su núcleo es el [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] es un mineral de precio medio cuyo sistema de origen es [[system/19]]. Ningún plano lo usa. Su núcleo es el [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] es un mineral de precio medio cuyo sistema de origen es [[system/14]]. Ningún plano lo usa. Su núcleo es el [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] es un mineral de precio medio cuyo sistema de origen es [[system/5]]. Es el ingrediente principal del [[item/54]], que necesita 80 t, y también se necesita para el [[item/85]]. Su núcleo es el [[item/174]].", false],
	],
	"item/164": [
		[0, "", "Los [[item/164]] son un mineral que nunca aparece en los campos de asteroides de los sistemas habitados. A diferencia de otros minerales, un asteroide de cristal no deja nada al destruirlo a tiros, así que los cristales hay que extraerlos con el taladro. Son el ingrediente clave del [[item/85]], que necesita 50.", false],
		[25, "", "Todos los asteroides del espacio de origen de los [[faction/9|Voids]], al que se llega por sus agujeros de gusano, están hechos de estos cristales.", false],
		[33, "", "[[character/20]] le pide a [[character/0]] que le traiga al menos 50 cristales, que según él encierran el secreto de los agujeros de gusano de los [[faction/9|Voids]].", false],
	],
	"item/165": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/154]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/9]]. Es el núcleo más valioso después del [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/155]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/21]]. Se necesita para fabricar el [[item/15]] y, de diez en diez, [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/156]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/0]]. Es el núcleo de menor valor.", false],
	],
	"item/168": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/157]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/7]]. Se necesitan quince para fabricar la [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/158]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/4]].", false],
	],
	"item/17": [
		[0, "", "El [[item/17]] agota 5 de energía por impacto cada 0,5 s y alcanza 2.000 unidades, mucho más que el [[item/16]]. No daña el casco. Agota energía aproximadamente al mismo ritmo que el Mk I, pero puede hacerlo desde una distancia más segura.", false],
	],
	"item/170": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/159]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/160]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/161]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/162]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Este núcleo es el raro centro de un asteroide de clase A de [[item/163]]. Se obtiene perforando las siete capas de un asteroide así, y de vez en cuando cae uno al destruir a tiros un asteroide de clase A. Se vende por varias veces el precio del propio mineral, más barato en [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] es el núcleo de un asteroide de clase A de [[item/164]]. Como los asteroides de cristal no dejan nada al destruirlos a tiros, la única forma de conseguirlo es perforar las siete capas. Se vende a un precio fijo de 5.000 créditos, más de cinco veces el mejor precio de cualquier otro núcleo.", false],
		[25, "", "Solo se encuentra en el espacio de origen de los [[faction/9|Voids]].", false],
	],
	"item/18": [
		[0, "", "El [[item/18]] es el bláster EMP más potente: 8 de energía por impacto cada 0,5 s con un alcance de 2.000, con lo que inutiliza las naves notablemente más rápido que el [[item/17]]. Como los demás blásters EMP, no daña el casco.", false],
	],
	"item/19": [
		[0, "", "El [[item/19]] hace 15 de daño cada 0,3 s con un alcance de 1.400. A lo largo del tiempo golpea mucho más fuerte que cualquier láser. El [[item/20]] y el [[item/21]] disparan más rápido, pero solo alcanzan 1.000 unidades.", false],
	],
	"item/2": [
		[0, "", "El [[item/2]] es el mejor láser Nirai: 7 de daño cada 0,4 s. Cada disparo es más débil que los de los láseres Berger, pero como dispara aproximadamente el doble de veces, hace más daño a lo largo del tiempo que cualquiera de ellos, incluido el [[item/8]]. Solo los láseres de haz M6 (el [[item/9]] y sus sucesores) lo superan claramente.", false],
	],
	"item/20": [
		[0, "", "El [[item/20]] dispara cada 0,2 s y hace 13 de daño. A lo largo del tiempo supera en daño al [[item/19]], pero su alcance es de solo 1.000 unidades, así que funciona mejor a corta distancia.", false],
	],
	"item/21": [
		[0, "", "El [[item/21]] hace 14 de daño cada 0,2 s, el mayor daño a lo largo del tiempo de cualquier arma frontal. Como el [[item/20]], solo alcanza 1.000 unidades. También es el bláster más raro en las tiendas.", false],
	],
	"item/22": [
		[0, "", "El [[item/22]] es el arma más débil del juego: 2 de daño cada 0,4 s con un alcance de 1.000. Los autocañones disparan proyectiles pequeños y rápidos; golpean poco, pero algunos modelos disparan muy deprisa. Este primer modelo es solo un recurso provisional.", false],
		[6, "", "Es una de las tres piezas que [[character/2]] ofrece gratis en su hangar de [[station/78]] antes del asalto al escondite pirata, junto con el [[item/0]] y el [[item/55]].", false],
	],
	"item/23": [
		[0, "", "El [[item/23]] duplica el daño del [[item/22]] hasta 4 por disparo y dispara algo más rápido (cada 0,3 s), con el mismo alcance de 1.000. Es un arma barata para el principio.", false],
	],
	"item/24": [
		[0, "", "El [[item/24]] hace 6 de daño cada 0,3 s con un alcance de 1.200. Es un autocañón sólido de gama media e iguala el daño a lo largo del tiempo del [[item/25]], que llega más lejos.", false],
	],
	"item/25": [
		[0, "", "El [[item/25]] hace 8 de daño cada 0,4 s y alcanza 1.400 unidades, el mayor alcance de cualquier autocañón. A lo largo del tiempo hace el mismo daño que el [[item/24]]. Nunca se vende ya fabricado. Su plano lo vende [[agent/2]] en [[station/20]], y se fabrica solo con mercancías básicas, sin mineral.", false],
	],
	"item/26": [
		[0, "", "El [[item/26]] dispara cada 0,2 s y hace 5 de daño con un alcance de 1.000. Su rápida cadencia le da más daño a lo largo del tiempo que los cañones de riel, a costa del alcance.", false],
	],
	"item/27": [
		[0, "", "El [[item/27]] dispara cada 0,1 s, la cadencia más rápida de cualquier autocañón, y hace 6 de daño por proyectil. Su daño a lo largo del tiempo se acerca al de los mejores blásters, pero su alcance de 900 es el más corto de cualquier arma. Nunca se vende ya fabricado. Su plano lo vende [[agent/3]] en [[station/10]], y para fabricarlo hace falta, entre otras mercancías, [[item/154]].", false],
	],
	"item/28": [
		[0, "", "El [[item/28]] es el primer modelo de arma térmica. Las armas térmicas disparan proyectiles rápidos y ligeros con un alcance de 1.000; esta hace 3 de daño cada 0,3 s. Pese a su alto nivel tecnológico, a lo largo del tiempo es más débil que la mayoría de los blásters y autocañones de gama media.", false],
	],
	"item/29": [
		[0, "", "El [[item/29]] hace 4 de daño cada 0,2 s con un alcance de 1.000, el doble de daño a lo largo del tiempo que el [[item/28]].", false],
	],
	"item/3": [
		[0, "", "El [[item/3]] es un láser [[faction/1|vossk]] que hace 7 de daño cada 0,5 s. Iguala al [[item/2]] por disparo, pero dispara algo más despacio, así que se queda un poco atrás a lo largo del tiempo. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
		[0, "", "La [[ship/10]] de [[character/0]] lleva dos en la escena inicial.", false],
	],
	"item/30": [
		[0, "", "El [[item/30]] dispara cada 0,1 s y hace 3 de daño, el más rápido de los modelos térmicos. A lo largo del tiempo hace más daño que el [[item/29]], pero menos que los mejores blásters, como el [[item/21]].", false],
	],
	"item/31": [
		[0, "", "El [[item/31]] es el cohete [[faction/1|vossk]] básico y la munición secundaria más barata: 60 de daño por impacto, un lanzamiento cada 1,2 s y un alcance de 1.200. Los cohetes vuelan en línea recta y no siguen al objetivo, así que funcionan mejor a corta distancia. Cualquier cohete o torpedo que impacta en un asteroide lo hace pedazos. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/32": [
		[0, "", "El [[item/32]] es el cohete no guiado común: 70 de daño por impacto, un lanzamiento cada 0,9 s y un alcance de 1.200. Golpea más fuerte y se lanza más rápido que el [[item/31]], y se vende en muchos sitios.", false],
	],
	"item/33": [
		[0, "", "El [[item/33]] hace 72 de daño y además agota 34 de energía, así que puede dañar un objetivo y a la vez ayudar a inutilizarlo. Se recarga despacio (2 s) y alcanza 1.000 unidades. Nunca se vende ya fabricado. Su plano lo vende [[agent/4]] en [[station/43]], y un lote solo requiere unas pocas mercancías básicas baratas.", false],
	],
	"item/34": [
		[0, "", "El [[item/34]] está pensado para inutilizar más que para destruir: agota 45 de energía y solo hace 10 de daño por impacto, con un lanzamiento por segundo. El [[item/35]] agota más energía y hace más daño.", false],
	],
	"item/35": [
		[0, "", "El [[item/35]] agota 60 de energía y hace 30 de daño por impacto, con un lanzamiento por segundo y un alcance de 1.000. Inutiliza las naves más rápido que el [[item/34]] y a la vez desgasta su casco.", false],
	],
	"item/36": [
		[0, "", "El [[item/36]] es el torpedo básico. Los torpedos vuelan en línea recta durante los primeros 1,5 s y luego se dirigen hacia su objetivo. El [[item/36]] hace 70 de daño con un alcance de 3.000 unidades, pero es lento y solo se lanza cada 3 s. El [[item/38]] duplica su daño.", false],
	],
	"item/37": [
		[0, "", "El [[item/37]] es el torpedo más rápido: hace 100 de daño, agota 50 de energía y alcanza 4.000 unidades. Se lanza cada 4 s. Nunca se vende ya fabricado. Su plano lo vende [[agent/5]] en [[station/54]], y un lote solo requiere unas pocas mercancías básicas.", false],
	],
	"item/38": [
		[0, "", "El [[item/38]] es el torpedo que más daño hace, con 140 de daño por impacto y un alcance de 4.000. Es lento en vuelo y se lanza cada 4 s. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/39": [
		[0, "", "El [[item/39]] es un torpedo guiado para inutilizar naves: agota 100 de energía y no hace daño. Con un alcance de 5.000, es una forma barata de detener un objetivo desde lejos. El [[item/40]] añade 120 de daño al mismo drenaje de energía.", false],
	],
	"item/4": [
		[0, "", "El [[item/4]] es el láser [[faction/1|vossk]] más potente: 10 de daño cada 0,6 s. Su daño a lo largo del tiempo es casi exactamente el del [[item/2]], con disparos más fuertes pero menos frecuentes que los del [[item/3]]. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/40": [
		[0, "", "El [[item/40]] combina 120 de daño con un drenaje de energía de 100 puntos en un solo torpedo guiado, con un alcance de 5.000 y un lanzamiento cada 5 s. Cuesta más del doble que el [[item/39]].", false],
	],
	"item/41": [
		[0, "", "La [[item/41]] es la bomba EMP más pequeña. Una bomba se lanza con una pulsación y se detona con una segunda; la explosión agota la energía de todas las naves dentro de su radio, con más fuerza cerca del centro, y no afecta a la nave que la lanzó. Los asteroides no se ven afectados. Este modelo agota hasta 80 de energía en un radio de 22.000. La [[item/42]] y la [[item/43]] son más potentes y de mayor alcance.", false],
		[20, "", "La seguridad [[faction/0|terrana]] deja diez de estas bombas gratis en [[station/55]] para que [[character/0]] pueda inutilizar la nave de los secuestradores sin destruirla.", false],
	],
	"item/42": [
		[0, "", "La [[item/42]] agota hasta 150 de energía en un radio de 30.000, casi el doble de potencia que la [[item/41]] y una explosión mucho más amplia.", false],
	],
	"item/43": [
		[0, "", "La [[item/43]] es la bomba EMP más potente: agota hasta 300 de energía en un radio de 37.000. Se recarga algo más rápido que la [[item/42]], pero cuesta casi el doble.", false],
	],
	"item/44": [
		[0, "", "La [[item/44]] es la bomba nuclear más pequeña. Como una bomba EMP, se lanza y luego se detona con una segunda pulsación, pero su explosión causa daño real: hasta 200 en un radio de 20.000, menos hacia el borde. También rompe asteroides. La nave que la lanza no sufre daños.", false],
	],
	"item/45": [
		[0, "", "La [[item/45]] hace hasta 560 de daño en un radio de 30.000, casi el triple de potencia que la [[item/44]] en una explosión más amplia.", false],
	],
	"item/46": [
		[0, "", "La [[item/46]] es el arma más destructiva del juego: hasta 950 de daño en un radio de 40.000. Nunca se vende ya fabricada. Su plano lo vende [[agent/6]] en [[station/61]], y para fabricarla hacen falta, entre otras mercancías básicas, productos radiactivos y explosivos.", false],
	],
	"item/47": [
		[0, "", "La [[item/47]] es la torreta básica. Una torreta va en su propia ranura, que solo tienen algunos cascos, y puede girar por completo, así que alcanza objetivos a los lados o detrás de la nave; mientras la apuntas, la nave sigue volando sola. Este modelo hace 6 de daño cada 0,3 s con un alcance de 2.000 y gira despacio (maniobrabilidad 40).", false],
	],
	"item/48": [
		[0, "", "La [[item/48]] hace 10 de daño cada 0,2 s con un alcance de 2.500 y gira más rápido que la [[item/47]] (maniobrabilidad 60). Cuesta más del triple.", false],
	],
	"item/49": [
		[0, "", "La [[item/49]] es la mejor torreta: 12 de daño cada 0,1 s con un alcance de 3.000 y el giro más rápido (maniobrabilidad 100). También es muy cara: cuesta aproximadamente el doble que la [[item/48]]. Solo la venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/5": [
		[0, "", "El [[item/5]] abre la línea de láseres Berger, que sacrifica cadencia a cambio de disparos más fuertes y un alcance algo mayor (2.200). Hace 8 de daño cada 0,9 s, menos daño a lo largo del tiempo que el [[item/2]], más barato. Su ventaja es el mayor alcance.", false],
	],
	"item/50": [
		[0, "", "El [[item/50]] es el escudo básico. Un escudo absorbe el daño recibido antes de que lo sufran el blindaje y el casco, y se recarga solo a lo largo de su tiempo de carga. El Targe solo aguanta 50 puntos, pero se recarga por completo en 20 s, más rápido que cualquier otro escudo.", false],
	],
	"item/51": [
		[0, "", "El [[item/51]] aguanta 80 puntos, pero necesita 46 s para recargarse por completo. Absorbe más que el [[item/50]] en un solo combate, pero se recupera mucho más despacio entre ataques.", false],
	],
	"item/52": [
		[0, "", "El [[item/52]] es un escudo [[faction/1|vossk]] que aguanta 120 puntos y se recarga en 58 s. Absorbe mucho más que el [[item/51]], pero el [[item/53]] aguanta más y se recarga más rápido. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/53": [
		[0, "", "El [[item/53]] aguanta 150 puntos y se recarga en 45 s, así que supera al [[item/52]] en ambos aspectos. Es el mejor escudo que se vende en tiendas.", false],
	],
	"item/54": [
		[0, "", "El [[item/54]] es el escudo más potente: 220 puntos y recarga en 60 s. Nunca se vende ya fabricado. Su plano lo vende [[agent/7]] en [[station/72]], y para fabricarlo hace falta una gran cantidad de [[item/163]] además de electrónica, nanotecnología y microchips.", false],
	],
	"item/55": [
		[0, "", "La [[item/55]] es la placa de blindaje básica. Una placa suma sus puntos al blindaje de la nave; después del escudo, recibe el daño antes que el casco y, a diferencia de un escudo, no se recarga. La E2 añade 40 puntos, una parte importante para una nave inicial ligera como la [[ship/32]], que tiene 100 propios.", false],
		[6, "", "Es una de las tres piezas que [[character/2]] ofrece gratis en su hangar de [[station/78]] antes del asalto al escondite pirata, junto con el [[item/0]] y el [[item/22]].", false],
	],
	"item/56": [
		[0, "", "La [[item/56]] añade 80 puntos de blindaje, el doble que la [[item/55]], por un precio moderado.", false],
	],
	"item/57": [
		[0, "", "La [[item/57]] añade 110 puntos de blindaje. Es la mejor placa que se vende fuera de los sistemas [[faction/1|vossk]].", false],
	],
	"item/58": [
		[0, "", "La [[item/58]] es una placa [[faction/1|vossk]] que añade 160 puntos de blindaje, mucho más que la [[item/57]]. Solo la venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/59": [
		[0, "", "La [[item/59]] es la mejor placa de blindaje: añade 250 puntos, tanto como el blindaje base de la [[ship/9]] y más que el de cualquier otro casco salvo la [[ship/8]]. Nunca se vende ya fabricada. Su plano lo vende [[agent/8]] en [[station/84]], y para fabricarla hacen falta [[item/157]], [[item/168]] y [[item/156]], además de mercancías básicas.", false],
	],
	"item/6": [
		[0, "", "El [[item/6]] hace 9 de daño cada 0,8 s con un alcance de 2.200. Es una mejora modesta respecto al [[item/5]], y su precio apenas varía entre sistemas.", false],
	],
	"item/60": [
		[0, "", "El [[item/60]] es el más débil de los tres módulos de protección EMP, con una defensa EMP de 20. Ninguno de los tres tiene precio, y ninguna tienda los vende.", false],
	],
	"item/61": [
		[0, "", "El [[item/61]] es el módulo de protección EMP intermedio, con una defensa EMP de 40, el doble que el [[item/60]]. Como sus hermanos, no tiene precio y no se vende en tiendas.", false],
	],
	"item/62": [
		[0, "", "El [[item/62]] es el módulo de protección EMP más potente, con una defensa EMP de 60. Como el [[item/60]] y el [[item/61]], no tiene precio y no se vende en tiendas.", false],
	],
	"item/63": [
		[0, "", "El [[item/63]] es el compresor de carga básico. Un compresor amplía la bodega en un porcentaje de la capacidad propia del casco; este añade un 15 %. Es barato y merece la pena para cualquier comerciante o minero.", false],
	],
	"item/64": [
		[0, "", "El [[item/64]] amplía la bodega un 25 %, una clara mejora respecto al [[item/63]] por un precio bajo.", false],
	],
	"item/65": [
		[0, "", "El [[item/65]] amplía la bodega un 40 %. En un carguero grande añade tanto espacio como el que carga toda una nave pequeña.", false],
	],
	"item/66": [
		[0, "", "El [[item/66]] amplía la bodega un 75 %, más que cualquier otro compresor que se venda en tiendas.", false],
	],
	"item/67": [
		[0, "", "El [[item/67]] duplica la bodega, añadiendo el 100 % de la capacidad del casco: una [[ship/36]] carga 700 t con él. Nunca se vende ya fabricado. Su plano lo vende [[agent/9]] en [[station/90]], y se fabrica solo con mercancías básicas.", false],
	],
	"item/68": [
		[0, "", "El [[item/68]] es el rayo tractor básico. Sin un rayo tractor no se puede recoger ningún contenedor flotante; chocar contra uno no sirve de nada. Con el Retractor mantienes el contenedor bajo la mira durante 4 s y después es atraído a bordo. El [[item/69]] necesita menos tiempo, y el [[item/70]] funciona automáticamente.", false],
		[24, "", "[[character/6]] le pide a [[character/0]] que instale un rayo tractor antes de la primera expedición contra los [[faction/9|Voids]], para que pueda recoger los restos de sus naves. Hasta entonces, las tiendas tienen bastantes probabilidades de ofrecer un Retractor además de su gama habitual.", false],
	],
	"item/69": [
		[0, "", "El [[item/69]] funciona como el [[item/68]], pero solo necesita el objetivo bajo la mira durante 3 s antes de atraer el contenedor.", false],
	],
	"item/7": [
		[0, "", "El [[item/7]] hace 10 de daño cada 0,8 s con un alcance de 2.200. A lo largo del tiempo iguala al [[item/1]], así que su valor está en golpes más escasos y fuertes a larga distancia.", false],
	],
	"item/70": [
		[0, "", "El [[item/70]] es el rayo tractor automático: recoge cualquier contenedor que esté en la vista frontal sin necesidad de apuntarlo y mantenerlo, lo que ahorra mucho tiempo al saquear un campo de batalla. Es mucho más caro que el [[item/69]].", false],
	],
	"item/71": [
		[0, "", "El [[item/71]] es el turbo básico. Un turbo da un breve impulso de velocidad extra y después necesita tiempo para recargarse. Este añade un 60 % de velocidad durante 3 s y se recarga en 8 s.", false],
	],
	"item/72": [
		[0, "", "El [[item/72]] está clasificado con un 80 % de velocidad extra durante 4,4 s, con una recarga de 10 s. En vuelo, su impulso alcanza la misma velocidad máxima que el [[item/71]]; lo que añade es un impulso más largo.", false],
	],
	"item/73": [
		[0, "", "El [[item/73]] duplica con creces la ganancia de los turbos más baratos: un 160 % de velocidad extra durante 5,6 s, con recarga en 12 s.", false],
	],
	"item/74": [
		[0, "", "El [[item/74]] es el turbo más potente: un 200 % de velocidad extra durante 6 s. Necesita la recarga más larga, 16 s. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/75": [
		[0, "", "El [[item/75]] es el único robot de reparación del juego y ocupa una ranura de equipamiento. Mientras vuelas, restaura un punto de casco cada 0,6 s y un punto de placa de blindaje cada segundo, así que los daños se reparan entre combates sin atracar. Es barato y lo venden la mayoría de las tiendas.", false],
	],
	"item/76": [
		[0, "", "La [[item/76]] es la tobera de dirección básica. Una tobera suma su valor a la maniobrabilidad de la nave, que así gira más rápido. Esta añade 20, poca ganancia para los cazas ágiles pero notable en un carguero lento.", false],
	],
	"item/77": [
		[0, "", "La [[item/77]] añade 40 de maniobrabilidad, el doble que la [[item/76]], por un precio bajo.", false],
	],
	"item/78": [
		[0, "", "La [[item/78]] es una tobera [[faction/1|vossk]] que añade 70 de maniobrabilidad. Solo la venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/79": [
		[0, "", "La [[item/79]] es una tobera [[faction/1|vossk]] que añade 100 de maniobrabilidad, suficiente para que un carguero pesado gire como un caza ágil. Solo la venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/8": [
		[0, "", "El [[item/8]] es el último y más potente láser Berger: 12 de daño por disparo cada 0,9 s con un alcance de 2.200. Es el láser convencional que más daño hace por disparo, pero el [[item/2]], más rápido, sigue haciendo más daño a lo largo del tiempo. Los láseres de haz M6 que lo siguen (a partir del [[item/9]]) golpean más del doble de fuerte por disparo.", false],
	],
	"item/80": [
		[0, "", "La [[item/80]] es la mejor tobera de dirección y añade 130 de maniobrabilidad. Eleva la de la [[ship/36]], el casco que gira más despacio, de 45 a 175, más de lo que tiene cualquier caza sin tobera. Es rara en las tiendas.", false],
	],
	"item/81": [
		[0, "", "El [[item/81]] es el escáner básico. Un escáner determina cuánto se tarda en fijar un objetivo, como una nave, una estación o un asteroide; el Quickscan necesita 4 s. El [[item/82]] fija más rápido y además muestra lo que transportan otras naves.", false],
		[2, "", "La nave minera de [[character/2]], la [[ship/0]], viene equipada con uno.", false],
	],
	"item/82": [
		[0, "", "El [[item/82]] fija en 3 s y muestra la carga de las naves fijadas, lo que ayuda cuando buscas botín.", false],
	],
	"item/83": [
		[0, "", "El [[item/83]] fija en 1,8 s, un tiempo que solo iguala el [[item/84]], y también muestra la carga de los objetivos.", false],
	],
	"item/84": [
		[0, "", "El [[item/84]] fija tan rápido como el [[item/83]] y muestra la carga, y además marca los asteroides de clase A, los únicos que pueden dar un núcleo (consulta [[guide/mining]]). Es el escáner preferido de los mineros.", false],
	],
	"item/85": [
		[0, "", "El [[item/85]] es el único motor de salto del juego. Con él instalado puedes viajar desde el mapa estelar directamente a una estación de otro sistema sin pasar por portales de salto. No se puede usar durante algunas misiones. Nunca se vende ya fabricado, y ningún agente vende su plano. Para fabricarlo hacen falta [[item/164]], [[item/158]], [[item/160]] y [[item/163]], además de grandes cantidades de mercancías básicas.", false],
		[33, "", "Su inventor, [[character/20]], le pide a [[character/0]] 50 [[item/164]] para su trabajo en un motor capaz de llegar a cualquier lugar del espacio.", false],
		[34, "", "A cambio de los cristales, [[character/20]] le da a [[character/0]] una copia del plano. Los 50 cristales entregados cuentan para el motor, así que solo hay que aportar los ingredientes restantes.", false],
	],
	"item/86": [
		[0, "", "El [[item/86]] es el láser de minería básico. Hace falta un láser de minería para extraer mineral de los asteroides. Su rendimiento determina la estabilidad con la que el taladro mantiene su rumbo, y cada modelo tiene además su propia velocidad de perforación (consulta [[guide/mining]]). Este tiene un rendimiento de 30 y es difícil de mantener en su sitio en las capas profundas.", false],
	],
	"item/87": [
		[0, "", "El [[item/87]] tiene un rendimiento de 50. Es notablemente más estable que el [[item/86]], aunque perfora algo más despacio.", false],
	],
	"item/88": [
		[0, "", "El [[item/88]] es un láser de minería [[faction/1|vossk]] con un rendimiento de 80, el taladro más estable que se vende en tiendas. Su inconveniente es que es el más lento extrayendo mineral. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/89": [
		[0, "", "El [[item/89]] tiene un rendimiento de 60, menos estable que el [[item/88]], pero extrae mineral mucho más rápido que cualquier otro láser que se venda en tiendas. Conviene a los mineros capaces de mantener el taladro en su sitio por sí mismos.", false],
	],
	"item/9": [
		[0, "", "El [[item/9]] es el primero de los láseres de haz M6. Disparan poco, pero golpean muy fuerte: 27 de daño cada 1,2 s, con un alcance de 2.400, mayor que el de cualquier láser anterior. La puntería es importante, ya que un fallo desperdicia una larga recarga. También es la pieza base para fabricar el [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] es el mejor láser de minería: un rendimiento de 100 y la perforación más rápida de todos los modelos. Nunca se vende ya fabricado. Su plano lo vende [[agent/11]] en [[station/78]], y para fabricarlo hacen falta grandes cantidades de nanotecnología, suministros mecánicos e hidráulica, además de [[item/155]] y diez [[item/166]].", false],
		[2, "", "El láser de la primera nave minera de [[character/0]] es el prototipo de este taladro que [[character/2]] construyó a mano.", false],
		[10, "", "Cuando [[character/2]] le da la [[ship/0]] a [[character/0]], se queda con el prototipo, el único que tiene, y le sugiere volver más adelante, cuando quizá haya fabricado más.", false],
	],
	"item/91": [
		[0, "", "El [[item/91]] aloja a 3 pasajeros. Los camarotes son necesarios para los trabajos de [[job/11]], y el espacio de varios camarotes se suma. El [[item/92]] y el [[item/93]] alojan a más.", false],
	],
	"item/92": [
		[0, "", "El [[item/92]] aloja a 5 pasajeros, dos más que el [[item/91]].", false],
	],
	"item/93": [
		[0, "", "El [[item/93]] aloja a 10 pasajeros, el doble que el [[item/92]], lo que da acceso a los trabajos de pasajeros más grandes.", false],
	],
	"item/94": [
		[0, "", "El [[item/94]] es el dispositivo de camuflaje básico. Mientras un dispositivo de camuflaje está activo, las demás naves no pueden verte. Este oculta la nave durante 15 s y luego necesita 18 s para recargarse. El tiempo pasado camuflado cuenta para la medalla [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "El [[item/95]] es un dispositivo de camuflaje [[faction/1|vossk]] que oculta la nave durante 28 s y se recarga en 32 s, casi el doble de cobertura que el [[item/94]]. Solo lo venden las tiendas de los sistemas [[faction/1|vossk]].", false],
	],
	"item/96": [
		[0, "", "El [[item/96]] es el mejor dispositivo de camuflaje: oculta la nave durante 46 s y se recarga en solo 40 s, así que puede estar activo más tiempo del que está apagado. Nunca se vende ya fabricado. Su plano lo vende [[agent/10]] en [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Un trabajo de mensajería consiste en llevar una carga de contenedores sellados a otra estación. Los contenedores se cargan en tu bodega al aceptar, así que necesitas espacio libre suficiente; no se pueden vender. El trabajo se completa al atracar en el destino con la carga a bordo. A veces los piratas acechan a los mensajeros. La carga entregada cuenta para [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "En un trabajo de defensa, una estación está a punto de ser atacada y te contratan para ayudar a sus propios cazas a repeler a los asaltantes. Los atacantes suelen ser piratas o, si no, naves de la raza rival. Vuela a la estación y destruye a todos los atacantes; las bajas de los cazas aliados también cuentan. Los trabajos más difíciles traen más atacantes.", false],
	],
	"job/10": [
		[0, "", "En un trabajo de interceptación, un convoy de dos o tres cargueros con carga ilegal espera lejos de una estación, custodiado por cazas. Sigue los puntos de ruta y destruye los cargueros. Sus escoltas esperan por el camino y alrededor del convoy.", false],
	],
	"job/11": [
		[0, "", "Un trabajo de pasajeros consiste en llevar a un grupo de personas a otra estación. Al aceptarlo necesitas camarotes con sitio suficiente para todos; mientras estén a bordo, los camarotes no se pueden retirar ni se puede cambiar de casco. Atraca en el destino para dejarlos. La recompensa base es menor, pero cada pasajero la aumenta. Los pasajeros entregados cuentan para [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Un desafío es un concurso de tiro que te propone otro piloto en el Space Lounge. Los dos salen de la misma estación hacia un grupo de piratas repartidos a lo largo de una ruta, y gana quien derribe más. El rival no puede ser destruido y golpea tan fuerte como tus propias armas. Solo cobras si consigues más bajas; siempre hay un número impar de piratas, así que no hay empates.", false],
	],
	"job/2": [
		[0, "", "Un trabajo de protección te envía a vigilar naves mineras que trabajan en un campo de asteroides cerca de una estación. Llegan asaltantes que se dirigen a la estación y a los mineros. Destrúyelos a todos antes de que acaben con los mineros; si se pierden todas las naves mineras, el trabajo fracasa.", false],
	],
	"job/3": [
		[0, "", "En un trabajo de recuperación, una de las naves de un grupo pirata cerca de una estación transporta mercancía robada. Debes recuperar el contenedor sin destruirlo: inutiliza la nave que lo lleva con un arma EMP y atrae el contenedor con un rayo tractor. Un escáner que muestre la carga te ayuda a encontrar la nave correcta. El contenedor se pierde si la nave que lo lleva es destruida o si no cabe en tu bodega. Cuando lo tengas, vuelve a la estación donde aceptaste el trabajo para cobrar. La recuperación paga el doble.", false],
	],
	"job/4": [
		[0, "", "La caza de piratas consiste en limpiar un escondite pirata cerca de una estación. Los piratas esperan en el campo de asteroides o en una ruta de dos o tres puntos de ruta, y solo se mueven cuando te ven. Sigue los puntos de ruta y destruye a todos los piratas. A mayor dificultad, más piratas.", false],
	],
	"job/5": [
		[0, "", "Un trabajo de rescate consiste en liberar a un rehén retenido a bordo de una de las naves de un grupo cerca de una estación. Como en un trabajo de recuperación, inutiliza con EMP la nave del secuestrador y usa un rayo tractor para subir al rehén a bordo; destruir esa nave pone fin al trabajo. Después lleva al rehén de vuelta a la estación donde aceptaste el trabajo. El rescate paga el doble.", false],
	],
	"job/6": [
		[0, "", "Un trabajo de busca y captura señala a un criminal peligroso que ha sido visto cerca de una estación. El objetivo espera en un punto alejado y solo reacciona cuando apareces a la vista. Es mucho más resistente que un pirata normal, y lo es más aún con la dificultad del trabajo y tu nivel de piloto. Destrúyelo para cobrar la recompensa.", false],
	],
	"job/7": [
		[0, "", "La retirada de chatarra consiste en limpiar una nube de chatarra espacial cerca de una estación en unos dos minutos. Hay que destruir todas las piezas antes de que se acabe el tiempo; con mayor dificultad se suman algunos piratas. Paga menos que la mayoría de los trabajos, pero es rápido, y la chatarra destruida cuenta para [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Un trabajo de compra lo ofrece un comprador del Space Lounge que quiere una cantidad de un objeto concreto. Consigue la mercancía, en tiendas, de comerciantes o minando, y vuelve a atracar en la estación del comprador con ella en la bodega. Se entrega la mercancía y cobras la mitad de la recompensa habitual de un trabajo más tres veces el valor medio de la mercancía, así que un comprador suele pagar mucho más que cualquier tienda. Los compradores aparecen a partir del [[step/16]].", false],
	],
	"job/9": [
		[0, "", "Un trabajo de escolta consiste en proteger un convoy de cinco cargueros cerca de una estación. A medida que avanzan los cargueros, se acercan atacantes que esperaban a lo largo de su ruta. Destruye a todos los atacantes. Si se pierden todos los cargueros, el trabajo fracasa. Las escoltas pagan una quinta parte más que la mayoría de los trabajos.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] tiene esta medalla desde el principio de la partida, por sus servicios pasados. No hay que hacer nada para ganarla.", false],
	],
	"medal/1": [
		[0, "", "Se concede por llegar a una estación con muy poco casco restante. La comprobación se hace al acercarte, antes de que el atraque repare la nave, y usa la resistencia propia del casco, no la placa de blindaje. Cuanto menor sea la parte restante, mejor es el nivel.", false],
	],
	"medal/10": [
		[0, "", "Se concede por destruir chatarra espacial, como la de los trabajos de [[job/7]]. Cada pieza que derribas cuenta.", false],
	],
	"medal/11": [
		[0, "", "Se concede por el número de estaciones distintas en las que has atracado.", false],
	],
	"medal/12": [
		[0, "", "Se concede por el número de sistemas distintos que has visitado. Los sistemas ocultos cuentan cuando llegas a ellos.", false],
	],
	"medal/13": [
		[0, "", "Se concede por el número de planos que posees. Los planos se compran a los agentes del Space Lounge; consulta [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Se concede por el número de planos distintos que has terminado al menos una vez. Volver a fabricar el mismo objeto no suma.", false],
	],
	"medal/15": [
		[0, "", "Se concede por el tiempo que has jugado, en horas. El juego cuenta el tiempo pasado en vuelo.", false],
	],
	"medal/16": [
		[0, "", "Se concede por el número de trabajos freelance completados. Los trabajos fallidos y abandonados no cuentan.", false],
	],
	"medal/17": [
		[0, "", "Se concede por el número de veces que has viajado a través de un portal de salto. Los saltos con motor de salto no cuentan.", false],
	],
	"medal/18": [
		[0, "", "Se concede por el número de pasajeros entregados en trabajos de [[job/11]]. Más espacio en camarotes significa grupos más grandes.", false],
	],
	"medal/19": [
		[0, "", "Se concede por el total de minutos que has pasado camuflado. Instala un dispositivo de camuflaje y úsalo siempre que esté cargado.", false],
	],
	"medal/2": [
		[0, "", "Se concede por extraer distintos tipos de mineral. Cada tipo cuenta una vez, por mucho que extraigas de él. Como los campos contienen los minerales cuyo origen está cerca, tendrás que minar en varias partes de la galaxia.", false],
	],
	"medal/20": [
		[0, "", "Se concede por el número de bombas EMP y bombas nucleares lanzadas.", false],
	],
	"medal/21": [
		[0, "", "Se concede por las toneladas de [[item/131]] recogidas con un rayo tractor de los restos y de las naves inutilizadas.", false],
	],
	"medal/22": [
		[0, "", "Una medalla de un solo nivel por volar sin ningún arma, o sin ningún equipamiento, instalado; se comprueba en el siguiente atraque. No se puede ganar al principio de la historia: hasta el [[step/8]] la nave siempre cuenta como armada.", false],
	],
	"medal/23": [
		[0, "", "Se concede por el número de armas primarias instaladas a la vez; se comprueba al atracar. Para los niveles más altos hace falta un casco con muchas ranuras primarias. Como [[medal/22]], solo cuenta a partir del [[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Se concede por las toneladas de carga recogidas con un rayo tractor de los restos y de las naves inutilizadas.", false],
	],
	"medal/25": [
		[0, "", "Se concede por la mayor cantidad de créditos que has tenido a la vez. Gastar dinero después no la reduce.", false],
	],
	"medal/26": [
		[0, "", "Se concede por hablar con visitantes del Space Lounge que tienen algo que ofrecer. Cada visitante cuenta una vez, la primera vez que hablas con él.", false],
	],
	"medal/27": [
		[0, "", "Se concede por el número de pilotos de escolta que has contratado en el Space Lounge, contando cada piloto de cada grupo.", false],
	],
	"medal/28": [
		[0, "", "Una medalla de un solo nivel por poner en tu contra a una de las cuatro grandes razas, llevando una de las dos escalas de reputación más allá de 60 en cualquier dirección. Consulta [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Se concede por el número de asteroides destruidos con tus armas. Los asteroides rotos al minar no cuentan.", false],
	],
	"medal/3": [
		[0, "", "Se concede por extraer distintos tipos de núcleo. Los núcleos solo se obtienen perforando las siete capas de un asteroide de clase A, así que hace falta paciencia y un buen láser de minería, además de viajar.", false],
	],
	"medal/30": [
		[0, "", "Una medalla de un solo nivel que se concede por completar la historia.", false],
	],
	"medal/31": [
		[0, "", "Se concede por el mayor espacio de carga libre que has tenido a la vez. Un casco grande con unidades de compresión de carga y la bodega vacía consigue los niveles más altos.", false],
	],
	"medal/32": [
		[0, "", "Se concede por el número de ofertas que has rechazado con «No, thanks» (No, gracias) en el Space Lounge.", false],
	],
	"medal/33": [
		[0, "", "Se concede por el número de veces que has pedido a un visitante del Space Lounge que repita una oferta con «How was that again?» (¿Cómo era eso?)", false],
	],
	"medal/34": [
		[0, "", "Se concede por aceptar trabajos en otras estaciones sin preguntar antes al cliente si serán difíciles.", false],
	],
	"medal/35": [
		[0, "", "Se concede por aceptar trabajos en otras estaciones sin pedir antes al cliente que te muestre el destino en el mapa.", false],
	],
	"medal/36": [
		[0, "", "Se concede automáticamente cuando tienes todas las demás medallas, en cualquier nivel. Tenerlas todas también tiene otras recompensas; consulta [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Se concede por el número de naves que has destruido, contado a lo largo de toda la partida. Cuentan los piratas, los enemigos y los objetivos de los trabajos.", false],
	],
	"medal/5": [
		[0, "", "Se concede por las toneladas de carga entregadas en trabajos de [[job/0]]. Las cargas de mensajería grandes cuentan más, así que una bodega grande ayuda.", false],
	],
	"medal/6": [
		[0, "", "Se concede por el total de toneladas de mineral extraídas a lo largo de toda la partida.", false],
	],
	"medal/7": [
		[0, "", "Se concede por el número de núcleos extraídos a lo largo de toda la partida. Cada asteroide de clase A perforado hasta el final da uno.", false],
	],
	"medal/8": [
		[0, "", "Se concede por las toneladas de licor compradas en las tiendas de las estaciones. Cuenta la bebida local de cada sistema.", false],
	],
	"medal/9": [
		[0, "", "Se concede por poseer distintos tipos de licor. Los tipos se cuentan cuando los compras a comerciantes del Space Lounge o los recoges de los restos con un rayo tractor.", false],
	],
	"ship/0": [
		[0, "", "La [[ship/0]] es el casco más débil de la tabla de naves: 95 de blindaje, una bodega de 25 t, una ranura primaria, una secundaria y tres ranuras de equipamiento. Su maniobrabilidad de 140 es respetable para una nave inicial, pero la [[ship/32]], el casco más barato a la venta, tiene las mismas ranuras con más blindaje, más espacio de carga y más agilidad. Ningún vendedor ofrece nunca la [[ship/0]]; el jugador solo la obtiene a través de la historia.", false],
		[2, "", "[[character/2]] es el dueño de esta remendada antigua nave [[faction/8|pirata]] y pone en ella a [[character/0]] en [[station/78]], pintada con colores piratas y equipada con un láser de minería y un [[item/81]], pero sin armas. El láser es su propio prototipo, el diseño que más tarde vende como [[item/90]].", false],
		[10, "", "Tras el asalto al escondite pirata, [[character/2]] le regala la nave a [[character/0]] para siempre, con un motor más potente para viajar entre los planetas del sistema, pero se queda con el láser prototipo. Keith la sigue pilotando tras llegar al espacio [[faction/0|terrano]].", false],
		[18, "", "En [[station/98]], [[character/1]] manda repintar el casco con colores [[faction/0|terranos]] para que las patrullas dejen de confundirlo con una nave pirata.", false],
	],
	"ship/1": [
		[0, "", "La [[ship/1]] es el casco más barato con cuatro ranuras secundarias, y además tiene una ranura de torreta, dos armas primarias y siete ranuras de equipamiento. El blindaje (192) y la bodega (65 t) son sólidos. Su maniobrabilidad de 106 es lenta, así que combate mejor con torpedos y la torreta. Por un poco más de dinero, la [[ship/9]] ofrece mucho más blindaje y agilidad, pero sin torreta y con solo dos ranuras secundarias.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/10": [
		[0, "", "La [[ship/10]] es la nave de [[character/0]] en la escena inicial, armada con dos láseres [[item/3]]. Combina un blindaje sólido (200) y una bodega de 100 t con cuatro ranuras secundarias y una maniobrabilidad de 150, lo que la hace mucho más ágil que la [[ship/11]], el casco con el precio de lista más parecido. Su punto débil es el escaso número de ranuras de equipamiento: solo cinco. Los vendedores normales nunca la ofrecen.", false],
		[2, "", "Un fallo del hipermotor lleva a [[character/0]] hasta [[station/78]], donde [[character/2]] recupera los restos y los desmonta para aprovechar las piezas. La nave nunca vuelve a sus manos.", false],
	],
	"ship/11": [
		[0, "", "La [[ship/11]] es un carguero pesado bien equipado: bodega de 180 t, 210 de blindaje, una ranura de torreta, dos ranuras primarias y dos secundarias y ocho ranuras de equipamiento. Su maniobrabilidad de 75 es pobre. Frente a la [[ship/7]], más barata, sacrifica 60 t de espacio de carga a cambio de una ranura secundaria y una ranura de equipamiento adicionales.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/12": [
		[0, "", "La [[ship/12]] es un caza diseñado en torno a sus armas secundarias: tres ranuras secundarias, dos armas primarias, seis ranuras de equipamiento, 175 de blindaje y una maniobrabilidad de 132. Su bodega de 30 t es muy pequeña, así que no es adecuada para el comercio ni la minería. La [[ship/30]] cuesta más y ofrece menos blindaje y una ranura secundaria menos.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/16": [
		[0, "", "La [[ship/16]] es un caza muy orientado a los misiles, con cuatro ranuras secundarias, dos armas primarias, diez ranuras de equipamiento, 180 de blindaje y una maniobrabilidad de 120. Su bodega de 45 t es pequeña. La [[ship/21]], más cara, añade dos armas primarias más y una ranura de equipamiento.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/17": [
		[0, "", "La [[ship/17]] lleva cuatro armas primarias, dos ranuras secundarias y diez ranuras de equipamiento. Para una nave de su precio, su blindaje (145), su bodega (65 t) y su maniobrabilidad (95) son flojos, así que depende de su equipamiento, sobre todo de escudos y placas de blindaje. La [[ship/19]], más barata, tiene más blindaje y espacio de carga con una ranura de equipamiento menos.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/18": [
		[0, "", "La [[ship/18]] es una nave pequeña y ágil (maniobrabilidad 145) con ocho ranuras de equipamiento; ningún casco más barato tiene tantas. Su blindaje de 115 y su bodega de 28 t son pobres, y solo tiene dos ranuras primarias y dos secundarias. Conviene a un piloto que confía en los escudos, el camuflaje y otro equipamiento más que en el blindaje.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/19": [
		[0, "", "La [[ship/19]] es una cañonera pesada con cuatro ranuras primarias, dos secundarias, nueve ranuras de equipamiento, 225 de blindaje y una bodega de 105 t. Su maniobrabilidad de 90 es lenta. Es la única nave con cuatro armas frontales y una bodega de más de 100 t.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/2": [
		[0, "", "La [[ship/2]] es una nave polivalente y ágil entre los cascos baratos: 155 de blindaje, bodega de 52 t, una ranura primaria y dos secundarias, cuatro ranuras de equipamiento y una maniobrabilidad de 150. Iguala a la [[ship/35]] en todo salvo en espacio de carga, donde lleva 12 t más. Los pilotos que quieren una segunda arma se fijan en la [[ship/5]] o en la [[ship/6]].", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/20": [
		[0, "", "La [[ship/20]] es un caza ligero que reúne seis ranuras de equipamiento en un casco pequeño y rápido (maniobrabilidad 155). Lleva dos armas primarias pero solo una ranura secundaria, 125 de blindaje y una bodega de 25 t, que empata con la [[ship/0]] como la más pequeña de la tabla. Conviene a los pilotos que quieren escudos, turbos y otro equipamiento pronto y no piensan transportar carga.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/21": [
		[0, "", "La [[ship/21]] es el casco más barato con cuatro ranuras primarias y cuatro secundarias. Añade once ranuras de equipamiento, 195 de blindaje y una bodega de 70 t. Su maniobrabilidad de 100 es normal. Es una nave de combate completa un escalón por debajo de la [[ship/29]].", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/22": [
		[0, "", "La [[ship/22]] tiene la bodega más grande de todas las naves de más de un millón de créditos (130 t), junto con tres ranuras primarias y tres secundarias, nueve ranuras de equipamiento y una maniobrabilidad de 118. Su blindaje de 160 es bajo para su precio. Conviene a los pilotos que comercian y combaten con la misma nave.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/23": [
		[0, "", "La [[ship/23]] es el casco más barato con ranura de torreta, y sus 205 de blindaje son los más altos de cualquier nave de menos de 100.000 créditos. Añade dos ranuras primarias y dos secundarias, cinco ranuras de equipamiento, una bodega de 55 t y una maniobrabilidad de 128, lo que la convierte en una nave polivalente robusta de gama media. Su principal limitación es el escaso número de ranuras de equipamiento.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/24": [
		[0, "", "La [[ship/24]] es un carguero armado: tres armas primarias, dos ranuras secundarias, una torreta, ocho ranuras de equipamiento y una bodega de 95 t. Su blindaje de 170 es normal, mientras que su maniobrabilidad de 125 es buena para una nave que carga tanto. Sirve igual de bien para el comercio, la minería y el combate.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/25": [
		[0, "", "La [[ship/25]] es una lanzamisiles: cuatro ranuras secundarias, ocho ranuras de equipamiento y una maniobrabilidad de 130, pero solo un arma primaria. Sus 124 de blindaje y su bodega de 52 t son escasos para su precio, así que depende de los torpedos y los escudos. La [[ship/1]] ofrece el mismo número de ranuras secundarias más una torreta por un tercio del precio, con menos ranuras de equipamiento.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/26": [
		[0, "", "La [[ship/26]] es el casco más barato con siete ranuras de equipamiento. Por lo demás es una nave polivalente corriente: 152 de blindaje, bodega de 64 t, dos ranuras primarias y dos secundarias y una maniobrabilidad de 108. Conviene a los pilotos que quieren un equipamiento completo antes de poder permitirse una nave más pesada.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/27": [
		[0, "", "La [[ship/27]] es el casco más barato con tres ranuras primarias. Las combina con 176 de blindaje, dos ranuras secundarias, seis ranuras de equipamiento y una bodega de 50 t. Su maniobrabilidad de 113 es más bien lenta, así que intercambia golpes en lugar de superar en giro a sus enemigos.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/28": [
		[0, "", "La [[ship/28]] es la nave polivalente más completa a la venta: tres ranuras primarias y cuatro secundarias, una torreta, doce ranuras de equipamiento y una bodega de 110 t. Ninguna otra nave que se pueda comprar tiene torreta y tantas ranuras de equipamiento. Su blindaje de 195 es bueno y su maniobrabilidad de 92 es lenta. La [[ship/29]] combate mejor, pero carga mucho menos.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/29": [
		[0, "", "La [[ship/29]] es la nave más cara que venden los vendedores normales y su mejor caza: cuatro ranuras primarias y cuatro secundarias, doce ranuras de equipamiento, 240 de blindaje y una maniobrabilidad de 118. Su bodega de 75 t es modesta y no tiene torreta. Solo la [[ship/8]] la supera en combate.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/3": [
		[0, "", "La [[ship/3]] es una nave polivalente equilibrada para el principio: dos ranuras primarias y dos secundarias, cinco ranuras de equipamiento, 135 de blindaje y una bodega de 55 t. Su maniobrabilidad de 112 es lenta para una nave pequeña. Cuesta más o menos lo mismo que la [[ship/6]], que gira mucho más deprisa pero tiene menos blindaje, menos espacio de carga y una ranura secundaria menos.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/30": [
		[0, "", "La [[ship/30]] es un caza de término medio: 165 de blindaje, bodega de 45 t, dos ranuras primarias y dos secundarias, seis ranuras de equipamiento y una maniobrabilidad de 128. No destaca en nada para su precio; la [[ship/12]], más barata, tiene más blindaje y una ranura secundaria adicional, y la [[ship/23]] añade una torreta.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/31": [
		[0, "", "La [[ship/31]] es un carguero ligero con una bodega de 110 t, una ranura de torreta, dos armas primarias y seis ranuras de equipamiento. Su blindaje (156), su única ranura secundaria y su maniobrabilidad de 102 son modestos. Compite con la [[ship/33]], más barata, que tiene algo menos de espacio de carga y un arma menos, pero más blindaje y mejor maniobrabilidad.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/32": [
		[0, "", "La [[ship/32]] es el casco más barato que vende cualquier vendedor y la primera compra habitual. Es pequeña y está poco protegida (100 de blindaje, bodega de 30 t, una ranura primaria, una secundaria y tres de equipamiento), pero con una maniobrabilidad de 160 solo la [[ship/4]] gira más deprisa. Frente a la [[ship/0]] añade algo de blindaje y de espacio de carga y se maneja mejor. La [[ship/35]] cuesta unos 8.000 créditos más y ofrece un blindaje mucho mejor, una segunda ranura secundaria y una cuarta ranura de equipamiento.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/33": [
		[0, "", "La [[ship/33]] es el casco más barato con más de 100 t de espacio de carga (108 t), y añade una ranura de torreta, 176 de blindaje y seis ranuras de equipamiento. Con una sola arma primaria y una maniobrabilidad de 112, es más un carguero capaz de defenderse que un caza. La [[ship/31]] es una rival cercana con una segunda arma y una bodega algo mayor, pero es más débil y más lenta.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/34": [
		[0, "", "La [[ship/34]] es una cañonera con cuatro ranuras primarias, una secundaria, seis ranuras de equipamiento, una bodega de 60 t y una maniobrabilidad de 130. Frente a la [[ship/4]], más barata, sacrifica blindaje (135 frente a 170) y agilidad a cambio de más espacio de carga y una ranura de equipamiento adicional.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/35": [
		[0, "", "La [[ship/35]] es un caza ligero del extremo inferior de la lista de precios. Por su precio ofrece buen blindaje (155), una ranura primaria y dos secundarias, cuatro ranuras de equipamiento y una maniobrabilidad rápida de 150, pero solo una bodega de 40 t. La [[ship/2]] es casi la misma nave con 12 t más de espacio de carga por unos miles de créditos más, mientras que la [[ship/5]] cambia agilidad por más blindaje, más carga y una segunda arma.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/36": [
		[0, "", "La [[ship/36]] es el mayor carguero del juego, con una bodega de 350 t. No tiene ninguna ranura primaria y debe confiar su defensa a sus cuatro ranuras secundarias y una torreta. Siete ranuras de equipamiento y 200 de blindaje están bien, pero su maniobrabilidad de 45 es la más baja de la tabla. La [[ship/7]] carga menos, pero conserva dos armas frontales y gira mejor.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/4": [
		[0, "", "La [[ship/4]] es el casco más barato con cuatro ranuras primarias y, con una maniobrabilidad de 162, la nave más ágil del juego. Sus 170 de blindaje son buenos para su precio. El precio a pagar es una bodega de 38 t, una sola ranura secundaria y cinco ranuras de equipamiento, así que es una nave de combate pura. La [[ship/34]] también lleva cuatro armas, con más espacio de carga y ranuras de equipamiento pero menos blindaje y agilidad.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/5": [
		[0, "", "La [[ship/5]] es el casco más barato con dos ranuras primarias, y sus 170 de blindaje son mucho para su precio. Su bodega de 60 t también la hace útil para comerciar y minar al principio. Sus inconvenientes son una sola ranura secundaria, solo cuatro ranuras de equipamiento y una torpe maniobrabilidad de 115. Los pilotos que valoran más la agilidad que el blindaje eligen la [[ship/2]] o la [[ship/35]] por un precio parecido.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/6": [
		[0, "", "La [[ship/6]] es un caza ligero y rápido con dos ranuras primarias, una secundaria, cinco ranuras de equipamiento y una maniobrabilidad de 148. Su blindaje de 105 es muy escaso; solo la [[ship/0]] y la [[ship/32]] tienen menos, así que depende más de la velocidad que de la resistencia. Por casi el mismo precio, la [[ship/3]] ofrece más blindaje, más espacio de carga y una segunda ranura secundaria, a costa de la maniobrabilidad.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/7": [
		[0, "", "La [[ship/7]] es un carguero pesado con una bodega de 240 t, 220 de blindaje, una ranura de torreta, dos armas primarias, una ranura secundaria y siete ranuras de equipamiento. Con una maniobrabilidad de 65, gira con lentitud. Frente a la [[ship/36]] sacrifica 110 t de espacio de carga a cambio de armas frontales y mejor maniobrabilidad; la [[ship/11]], más cara, añade una ranura de equipamiento y una segunda ranura secundaria.", false],
		[0, "", "Cualquier vendedor de fuera de los sistemas [[faction/1|vossk]] puede tenerla.", false],
	],
	"ship/8": [
		[0, "", "La [[ship/8]] es un caza [[faction/9|Void]] restaurado y la nave más potente del juego. Sus 450 de blindaje son casi el doble que los de cualquier otro casco, tiene cuatro ranuras primarias y cuatro secundarias y quince ranuras de equipamiento, y su maniobrabilidad de 155 está entre las mejores. Su única debilidad es una bodega de 30 t. Su precio de lista, de más de ocho millones de créditos, es casi el doble que el de la [[ship/29]].", false],
		[0, "", "Los vendedores normales no la venden. Solo se ofrece en [[station/10]], como prototipo, cuando el jugador tiene todas las medallas en oro (consulta [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "La [[ship/9]] es la única nave que venden los vendedores [[faction/1|vossk]], y no venden nada más. Sus 250 de blindaje son los más altos de cualquier casco salvo la [[ship/8]], y los combina con una maniobrabilidad rápida de 152, dos ranuras primarias y dos secundarias, siete ranuras de equipamiento y una bodega de 65 t. Por su precio es el caza más resistente disponible, aunque le faltan la torreta y las ranuras adicionales de la [[ship/1]].", false],
		[36, "", "[[character/7]] explica que las naves [[faction/1|vossk]] normalmente solo las pilota su propia raza; esta nave es la excepción, un diseño adaptado para poder venderse a otras razas.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] alberga el portal de salto de [[system/0]]. El periodo de espera del [[step/13]] figura en esta estación, pero ese paso se completa terminando trabajos del lounge en cualquier sitio, y aquí no ocurre nada.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] es la única estación de [[system/6]] y alberga su portal de salto. Los trabajos freelance nunca te envían aquí. El agente [[agent/3]] vende un plano en su lounge y, cuando todas las medallas son de oro, la estación ofrece un prototipo de [[ship/8]].", false],
		[23, "", "La estación es la base de investigación secreta de Deep Science, dirigida por [[character/6]]. [[character/0]] llega allí con [[character/5]] en el [[step/23]] y vuelve varias veces: para planear la expedición a los Voids, para reunirse con [[character/20]] y para entregar sus cristales.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] es una modesta estación vossk en [[system/3]]. El agente [[agent/12]] vende las coordenadas de [[system/0]] en su lounge.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] alberga el portal de salto de [[system/4]]. El agente midoriano [[agent/2]] vende el plano de un arma en su lounge.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] es la estación más avanzada de [[system/4]].", false],
		[38, "", "En el [[step/38]] se avista cerca de la estación el convoy con los explosivos nivelianos, escoltado por cazas midorianos. [[character/0]] tiene que ahuyentar a la escolta sin destruir el convoy.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] es una estación vossk de máxima tecnología en [[system/5]]. El agente boboliano [[agent/13]] vende las coordenadas de [[system/1]] en su lounge.", false],
	],
	"station/27": [
		[36, "", "Cerca de [[station/27]], [[character/7]] y [[character/0]] asaltan un escondite pirata en el [[step/36]]; gana quien destruya más piratas.", false],
		[37, "", "[[character/0]] gana y se gana el derecho a escoltar el carguero vossk. Desde aquí informa a [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] es la estación del comandante vossk [[character/7]], que ha aceptado proporcionar un carguero K'Sarr para el ataque contra los Voids. [[character/0]] se reúne aquí con él en el [[step/35]].", false],
		[36, "", "[[character/7]] no permite que nadie más que un vossk pilote el carguero y desafía a [[character/0]] a demostrar su valía como piloto de escolta.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] es una estación niveliana de alta tecnología en el sistema oculto [[system/0]]. En su lounge se encuentra el agente [[agent/0]], que vende el plano de un arma.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] espera en [[station/30]] en el [[step/34]] con un plan contra la nave nodriza Void.", false],
		[35, "", "El plan consiste en estrellar contra la nave nodriza un carguero pesado lleno de explosivos nucleares nivelianos.", false],
		[39, "", "Los explosivos recuperados llegan aquí y se cargan en el carguero vossk. En el [[step/39]], [[character/1]] explica la operación final.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] es una pequeña estación terrana en [[system/8]]. El agente [[agent/4]] vende en su lounge el plano barato de un cohete.", false],
	],
	"station/48": [
		[24, "", "Se han avistado naves Void cerca de [[station/48]]. En el [[step/24]], [[character/0]] trae aquí a [[character/6]] para observarlas y recoger restos con un rayo tractor.", false],
		[25, "", "Al final de la recuperación, un agujero de gusano se traga la nave de [[character/0]] con [[character/6]] a bordo.", false],
		[27, "", "Cuando vuelven por otro agujero de gusano, los cazas Void los siguen, y [[character/0]] tiene que destruirlos aquí antes de regresar a [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] es una estación vossk de máxima tecnología en [[system/10]], un sistema al que solo se llega con un motor de salto. El agente vossk [[agent/5]] vende el plano de un misil en su lounge.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] alberga el portal de salto de [[system/11]].", false],
		[19, "", "Cerca de la estación se encuentran los piratas que retienen a [[character/5]] para pedir un rescate. Deep Science deja bombas EMP en su hangar para [[character/0]].", false],
		[22, "", "Tras el rescate, [[character/0]] se reúne en la estación con el oficial liberado y recibe las coordenadas de [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] es el punto de encuentro donde [[character/0]] debe recoger a un oficial de Deep Science en el [[step/18]].", false],
		[19, "", "El oficial nunca llega. En su lugar, un mensaje de [[character/1]] informa de que unos piratas lo han secuestrado.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] es una pequeña estación en el sistema vossk [[system/20]]. En su lounge está un terrano, el agente [[agent/10]], que vende el plano de un dispositivo de camuflaje.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] es una de las dos únicas estaciones de [[system/12]]. El agente multipod [[agent/6]] vende el plano de un arma nuclear en su lounge.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] alberga el portal de salto de [[system/13]]. El agente cyborg [[agent/14]] vende las coordenadas de [[system/10]] en su lounge.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] es una pequeña estación terrana en el sistema seguro [[system/14]]. El agente [[agent/7]] vende el plano de un escudo en su lounge.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] es una estación de [[system/15]] que ha dejado de responder a las llamadas. En el [[step/11]], [[character/3]] envía a [[character/0]] a averiguar por qué.", false],
		[12, "", "La estación está intacta. Su tripulación simplemente no está en condiciones de trabajar, gracias a un cargamento de neuroalgas que trajo el traficante [[character/4]], un viejo conocido de [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] es la pequeña estación minera del comerciante de mineral niveliano [[character/2]] en [[system/15]]. La historia empieza en su órbita.", false],
		[1, "", "La nave dañada de [[character/0]] llega aquí a la deriva con el piloto automático, y [[character/2]] la acoge, con piloto incluido.", false],
		[2, "", "[[character/2]] desmantela los restos y pone a [[character/0]] a extraer mineral en los asteroides cercanos con [[ship/0]].", false],
		[8, "", "Tras escapar de un ataque pirata, [[character/0]] instala su primera arma y ayuda a [[character/2]] a destruir el escondite pirata cercano a la estación.", false],
		[10, "", "Después, [[character/2]] le regala la nave y lo envía a [[station/79]].", false],
		[0, "", "Más adelante en el juego, [[character/2]] vende en el lounge de la estación el plano de su taladro de minería.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] es una estación de [[system/15]] y la sede de su comandante, [[character/3]].", false],
		[10, "", "[[character/2]] envía aquí a [[character/0]] en el [[step/9]] para reunirse con [[character/3]], un humano que puede ayudarle a llegar al espacio terrano.", false],
		[11, "", "[[character/3]] le explica qué es la [[faction/3|Confederación de Mido]] y, a cambio de su ayuda, le pide que investigue [[station/76]].", false],
		[13, "", "Tras el informe sobre [[station/76]], [[character/3]] promete ponerlo en contacto con un convoy terrano que debe llegar a la estación.", false],
		[15, "", "Cuando el convoy llega en el [[step/14]], confunde a [[character/0]] con un pirata, inutiliza su nave y lo sube a bordo.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] es una estación terrana en el sistema oculto [[system/1]]. El agente niveliano [[agent/1]] vende un plano en su lounge.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] es una estación terrana en [[system/16]]. El agente vossk [[agent/8]] vende en su lounge el plano de un blindaje vossk.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] es una pequeña estación niveliana en [[system/17]]. El agente vossk [[agent/15]] vende las coordenadas de [[system/21]] en su lounge.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] alberga el portal de salto de [[system/18]]. El agente [[agent/9]] vende en su lounge el plano de un compresor de carga.", false],
	],
	"station/91": [
		[28, "", "En el [[step/28]] se informa de actividad Void cerca de [[station/91]]. [[character/0]] se abre paso aquí a tiros hasta un agujero de gusano para llevar una sonda a la nave nodriza Void.", false],
		[31, "", "De vuelta del sector Void, [[character/0]] recibe aquí una llamada de [[character/1]], que lo invita a [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] es una estación terrana en [[system/19]]. El crucero que detuvo a [[character/0]] lo trae aquí, y descubre que su viejo amigo [[character/1]] está al mando.", false],
		[16, "", "Durante su conversación, cazas Void atacan la estación, y [[character/0]] ayuda a repelerlos.", false],
		[18, "", "[[character/1]] le informa sobre los Voids y lo recluta para Deep Science.", false],
		[32, "", "En el [[step/31]], [[character/1]] equipa la nave de [[character/0]] con el sistema de alerta temprana y le habla de [[character/20]].", false],
		[44, "", "Tras la victoria, [[character/0]] y [[character/1]] lo celebran en la estación, y [[character/6]] se une a ellos.", false],
		[45, "", "A la mañana siguiente, [[character/6]] se ha ido y deja una nota y un último pago de Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] persigue a una banda de [[faction/8|piratas]] por un cinturón de asteroides para cobrar la recompensa por sus cabezas. Debes encontrar y destruir todas las naves piratas.", false],
		[1, "", "Una vez eliminados los piratas, Keith pone rumbo a Eden Prime, donde el almirante Smith quiere verle por un encargo especial. Cuando arranca el hipermotor, un último disparo daña su nave. El motor falla, el soporte vital queda muy dañado y el piloto automático lleva al piloto inconsciente hacia la estación más cercana, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "El piloto automático ha puesto la maltrecha nave de Keith en órbita alrededor de [[station/78]], con su piloto inconsciente a bordo.", false],
		[2, "", "Keith despierta en una pequeña estación minera que dirige [[character/2]], un comerciante de mineral [[faction/2]]. Gunant ha desmontado la nave y la reclama por derecho de salvamento. Se ríe de la idea de llegar a Eden Prime, que está en el otro extremo de la galaxia, y le sorprende que Keith nunca haya oído hablar de los Voids, seres hostiles que ahora aparecen incluso en el sistema [[system/15]].", false],
		[2, "", "Keith no tiene dinero ni nave, así que debe trabajar para Gunant extrayendo mineral con una nave desarmada.", false],
	],
	"step/10": [
		[10, "", "Keith vuela a [[station/79]] para reunirse con [[character/3]].", false],
		[11, "", "Norris explica que [[system/15]] está en un sector descubierto hace poco. Exiliados terranos y nivelianos lo colonizaron durante la guerra civil niveliana y fundaron una confederación independiente. Los terranos la aceptan, pero los nivelianos siguen reclamando el sistema, así que hay combates en sus afueras.", false],
		[11, "", "Norris se ofrece a poner a Keith en contacto con la Flota Espacial Terrana a cambio de un favor: se ha perdido el contacto con la estación [[station/76]] y hace falta un piloto experimentado que averigüe por qué.", false],
	],
	"step/11": [
		[11, "", "Keith vuela a [[station/76]] para investigar su silencio. La estación parece intacta, sin señales de combate, así que atraca.", false],
		[12, "", "Dentro, Keith se topa con [[character/4]], un conocido traficante al que conoció hace mucho. Mkkt ha traído un cargamento de neuroalgas y toda la tripulación está demasiado intoxicada para atender las comunicaciones. Keith se marcha en cuanto puede.", false],
	],
	"step/12": [
		[12, "", "Keith regresa a [[station/79]] para informar.", false],
		[13, "", "Norris queda horrorizado y promete ocuparse del traficante. Un convoy militar terrano se dirige a Kernstal y le dará a Keith la oportunidad de contactar con la flota. Hasta que llegue, Norris le sugiere que acepte trabajos remunerados en el Space Lounge (consulta [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Mientras espera al convoy, Keith debe completar dos trabajos freelance del Space Lounge (consulta [[guide/jobs]]).", false],
		[14, "", "Norris informa de que el convoy terrano ha entrado en el sistema y se dirige a [[station/79]]. Keith sale a su encuentro.", false],
	],
	"step/14": [
		[14, "", "Cerca de [[station/79]], Keith encuentra el convoy terrano y unos cuantos piratas. Se acerca para ahuyentar a los piratas.", false],
		[15, "", "Con su antigua nave pirata, Keith es confundido con uno de los asaltantes. El convoy inutiliza su nave con armas EMP y lo detiene. Lo suben a bordo de un crucero terrano con destino a [[station/98]], en el espacio terrano.", false],
	],
	"step/15": [
		[15, "", "Keith llega a [[station/98]] como prisionero del convoy.", false],
		[16, "", "El oficial al mando es [[character/1]], un viejo amigo de Keith y ahora jefe de la Agencia de Seguridad Interestelar. Se disculpa por el error. El reencuentro se interrumpe cuando aparecen cazas Void en órbita y suena la alarma de la estación.", false],
	],
	"step/16": [
		[16, "", "Brent le pide a Keith que ayude a repeler las naves [[faction/9|Void]] que atacan [[station/98]] (consulta [[world/voids]]).", false],
		[17, "", "Los Voids emiten un mensaje en el que afirman tener intenciones pacíficas, pero atacan de todos modos. Keith los rechaza, y Brent promete contarle todo lo que sabe con una copa de vino.", false],
	],
	"step/17": [
		[17, "", "Keith atraca en [[station/98]] para escuchar lo que Brent sabe de los Voids.", false],
		[18, "", "Los Voids han aparecido en las últimas semanas. Llegan a través de una especie de agujero de gusano, atacan todo lo que encuentran y parecen buscar mineral; incluso los sistemas [[faction/1]] sufren sus ataques. Brent preside un gabinete de crisis cuyos científicos se están reuniendo en una estación de investigación secreta dirigida por Deep Science. Le pide a Keith que pilote para ellos.", false],
		[18, "", "El sistema de la estación no figura en los mapas estelares normales, así que Keith debe reunirse con el teniente Thomas Boyle ([[character/5]]) en [[station/56]], en el sistema [[system/11]], para obtener las coordenadas. Brent también reconoce que la nave de Keith no es nueva: solo la han repintado para evitar más confusiones.", false],
	],
	"step/18": [
		[18, "", "Keith vuela a [[station/56]] para reunirse con Boyle.", false],
		[19, "", "Boyle no ha llegado. Brent informa de que unos piratas lo han secuestrado cerca de [[station/55]] y piden un rescate de cinco millones de créditos. Brent está dispuesto a pagar, pero Keith cree que los secuestradores matarán a Boyle en cuanto cobren, y se dirige a Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith vuela a [[station/55]] en busca de los secuestradores.", false],
		[20, "", "Los escáneres de Kappa localizan la nave de los secuestradores. Brent ha hecho dejar bombas EMP en el hangar de la estación para que Keith pueda inutilizar la nave mientras los secuestradores creen que les lleva el rescate.", false],
	],
	"step/2": [
		[2, "", "Gunant le da a Keith una nave vieja y muy remendada, [[ship/0]], un antiguo navío pirata equipado con un láser de minería y sin armas. Keith debe extraer al menos diez toneladas de mineral de los asteroides cercanos a [[station/78]] (consulta [[guide/mining]]).", false],
		[3, "", "Con el mineral a bordo, Gunant le dice que atraque para revisar la carga. Sin armas, Keith no tiene más remedio que seguirle el juego.", false],
	],
	"step/20": [
		[20, "", "Keith debe atracar en [[station/55]] e instalar las bombas EMP en su nave.", false],
		[21, "", "Con las bombas montadas, Keith parte de inmediato.", false],
	],
	"step/21": [
		[21, "", "Un punto de ruta marca la nave de los secuestradores, que quizá no esté sola. Keith debe inutilizarla con una bomba EMP en lugar de destruirla, y encargarse de cualquier escolta.", false],
		[22, "", "Los secuestradores creen que ha llegado el rescate hasta que la bomba deja fuera de combate sus sistemas. Brent envía un equipo a recuperar a Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith atraca en [[station/55]] para reunirse con el científico rescatado.", false],
		[23, "", "Boyle le da las gracias. Ha perdido su propia nave, así que Keith se ofrece a llevarlo, y Boyle transfiere al ordenador de navegación de Keith las coordenadas del sistema [[system/6]], donde se encuentra la estación de investigación.", false],
	],
	"step/23": [
		[23, "", "Keith lleva a Boyle a [[station/10]], en el sistema [[system/6]], donde los espera la Dra. Paolini.", false],
		[24, "", "Keith conoce a la Dra. Carla Paolini ([[character/6]]), que dirige el proyecto de Deep Science. Quiere estudiar la tecnología Void, empezando por los restos de sus naves. Deep Science paga a Keith 20.000 créditos para equipar su nave, y un rayo tractor es imprescindible.", false],
		[24, "", "Carla insiste en volar con él a [[station/48]], en el sistema [[system/9]], donde se han avistado Voids hace poco. Keith protesta, pero acaba cediendo.", false],
	],
	"step/24": [
		[24, "", "En [[station/48]], Carla quiere ver a los Voids lo más de cerca posible. Los Voids anuncian que vienen del futuro y que son todo lo que queda de las civilizaciones de la galaxia. Keith debe combatirlos y recoger los restos de sus naves con un rayo tractor.", false],
		[25, "", "Cuando ya hay suficientes restos a bordo, Carla pide volver, pero de repente algo atrapa la nave.", false],
	],
	"step/25": [
		[25, "", "Keith y Carla vuelven en sí lejos de [[station/48]], en una región del espacio que ninguno de los dos conoce.", false],
		[26, "", "Cerca hay una gigantesca nave nodriza Void que lanza cazas. Keith deduce que han atravesado un agujero de gusano hasta el sector de origen de los Voids. Ese agujero ha desaparecido, pero estas aberturas parecen derrumbarse y reaparecer en otro lugar, así que debe llegar a otra para volver a casa.", false],
	],
	"step/26": [
		[26, "", "El agujero de gusano los devuelve a [[station/48]], pero los cazas Void los han seguido. Keith debe destruirlos para que no sigan a la nave hasta [[station/10]].", false],
		[27, "", "Sin perseguidores, la pareja regresa a Thynome, muy necesitada de descanso.", false],
	],
	"step/27": [
		[27, "", "Keith atraca en [[station/10]].", false],
		[28, "", "Dos días después, Carla le pide que vuelva. Su equipo ha construido una sonda que, disparada contra la nave nodriza, la analiza y envía los resultados a la nave de Keith. Ella se queda para estudiar los restos y lo envía al sistema [[system/18]], donde se acaba de informar de la presencia de Voids, para que encuentre otro agujero de gusano.", false],
		[28, "", "Keith acepta con una condición: si vuelve con vida, Carla le debe una cita. Ella acepta.", false],
	],
	"step/28": [
		[28, "", "Cerca de [[station/91]] llegan cazas Void, y Keith debe alcanzar el agujero de gusano antes de que se derrumbe. Los Voids advierten que destruirlos destruirá su propio futuro.", false],
		[29, "", "Keith alcanza el agujero de gusano y lo atraviesa hasta el espacio del Void.", false],
	],
	"step/29": [
		[29, "", "Cerca de la nave nodriza, Keith debe fijarla como objetivo, lo que lanza la sonda, y después resistir mientras la sonda completa su análisis.", false],
		[30, "", "Durante la espera, los Voids vuelven a emitir un mensaje: deben encontrar la forma de hablar antes de que los humanos los destruyan y, con ellos, su propio futuro. Keith resiste hasta que termina la transferencia de datos y se marcha.", false],
	],
	"step/3": [
		[3, "", "Keith atraca en [[station/78]] para entregar su primera carga de mineral.", false],
		[4, "", "Gunant queda bastante satisfecho, pero vuelve a enviar a Keith, esta vez para llenar toda la bodega. Bromea con que quizá algún día Keith pueda quedarse la nave si se porta bien.", false],
	],
	"step/30": [
		[30, "", "De vuelta por el agujero de gusano, Keith espera cerca de [[station/91]].", false],
		[31, "", "Brent llama y le pide que pase por [[station/98]], en el sistema [[system/19]], antes de volver a Thynome, y le promete una sorpresa. Desde allí se pueden enviar a Carla los datos de la sonda.", false],
	],
	"step/31": [
		[31, "", "Keith atraca en [[station/98]] para ver a Brent.", false],
		[32, "", "El equipo de Brent ha desarrollado un sistema de alerta temprana para el mapa estelar. Muestra dónde están a punto de abrir los Voids un agujero de gusano, y el ordenador de navegación de Keith se modifica para recibirlo. Brent quiere que vuele a esos lugares y apoye a las fuerzas locales, y le paga 30.000 créditos.", false],
		[32, "", "Brent añade que un [[faction/7|grey]] llamado [[character/20]], que trabaja para Deep Science, ha pedido ver a Keith.", false],
	],
	"step/32": [
		[32, "", "Keith regresa a [[station/10]] para reunirse con [[character/20]].", false],
		[33, "", "Khador ha estudiado los restos Void. Cree que el secreto de los agujeros de gusano de los Voids reside en la estructura de ciertos cristales que solo se encuentran en el sector Void. Está desarrollando un motor capaz de llevar una nave al instante a cualquier punto del espacio, y le pide a Keith que le traiga al menos 50 de estos cristales.", false],
		[33, "", "Keith debe entrar una vez más en un agujero de gusano, esta vez usando el sistema de alerta temprana de Brent para encontrarlo.", false],
	],
	"step/33": [
		[33, "", "Keith debe reunir 50 [[item/164]] en el sector Void y entregarlos en [[station/10]].", false],
		[34, "", "Khador, encantado, le da a Keith una copia de su plano del [[item/85]] para que pueda fabricarse uno (consulta [[guide/blueprints]]). Un motor así puede llegar incluso al sector de origen de los Voids.", false],
		[34, "", "Aparece Carla, demasiado ocupada para su cita. Le cuenta a Keith que Brent y ella han ideado un plan y lo envía a ver a Brent en [[station/30]], en el sistema [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith vuela a [[station/30]] para conocer el plan de Brent.", false],
		[35, "", "Los datos de la sonda muestran que la nave nodriza es el origen de los agujeros de gusano. Hasta ahora ningún arma la ha dañado, así que el plan es estrellar en su núcleo un carguero resistente cargado de explosivos nucleares nivelianos.", false],
		[35, "", "Un carguero vossk K'Sarr es el más adecuado para la tarea. Brent ha acordado conseguir uno de [[character/7]], comandante de [[station/29]] en el sistema [[system/5]], como parte de un intercambio secreto de prisioneros. Errkt insiste en conocer al piloto en persona.", false],
	],
	"step/35": [
		[35, "", "Keith vuela a territorio [[faction/1]] para reunirse con [[character/7]] en [[station/29]].", false],
		[36, "", "Errkt, que ha revisado el historial de Keith, sostiene que solo un vossk puede pilotar bien una nave vossk. Como la misión no puede fallar, pilotará él mismo el carguero. Pero antes Keith debe demostrar su habilidad como piloto de caza cerca del planeta [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt propone un duelo en un escondite pirata cercano a [[station/27]]: gana quien derribe más piratas.", false],
		[37, "", "Keith gana. Errkt lo acepta como piloto competente y le concede el honor de escoltar el carguero, que llevará al punto de encuentro acordado. Keith llama a Brent para informarle.", false],
	],
	"step/37": [
		[37, "", "Keith contacta con Brent desde [[station/27]] para informar de sus conversaciones con Errkt.", false],
		[38, "", "El Imperio Vossk ha confirmado su apoyo, y Brent acepta a Errkt como piloto. Ha surgido un nuevo problema: naves de la [[faction/3|Confederación de Mido]], en guerra con los nivelianos, han capturado el convoy que transporta los explosivos nivelianos. Lo han avistado en el sistema [[system/4]] cerca de [[station/22]], y Keith acepta interceptarlo.", false],
	],
	"step/38": [
		[38, "", "Cerca de [[station/22]], Keith encuentra el convoy robado con una escolta de cazas de Mido. Debe destruir la escolta sin dañar las naves del convoy.", false],
		[39, "", "Con el convoy de nuevo bajo control, Brent lo confía a las fuerzas de seguridad locales para el viaje hasta [[station/30]] y le pide a Keith que también regrese allí.", false],
	],
	"step/39": [
		[39, "", "Keith atraca en [[station/30]] para recibir las últimas instrucciones.", false],
		[40, "", "Los explosivos se cargan en el carguero vossk, y Errkt sigue siendo su piloto. Cuando los Voids vuelvan a aparecer, Keith y Errkt volarán hasta allí. Errkt se dirigirá al primer agujero de gusano, y Keith lo cubrirá y lo seguirá. Brent pedirá refuerzos a la estación más cercana.", false],
		[40, "", "Errkt debe eyectarse en una cápsula de escape poco antes del impacto. Keith debe volver a cruzar el agujero de gusano antes de que la nave nodriza sea destruida, o no habrá forma de volver a casa.", false],
	],
	"step/4": [
		[4, "", "Keith vuelve a los asteroides para minar hasta llenar la bodega.", false],
		[5, "", "Mientras mina, se acerca una nave pirata. Desarmado, Keith recibe la orden de huir a la estación esquivando sus disparos.", false],
	],
	"step/40": [
		[40, "", "Con el sistema de alerta temprana, Keith vuela a una órbita atacada por los Voids. Errkt llega con el carguero y se dirige al primer agujero de gusano, y el teniente [[character/8]] se une con su escuadrón. Keith debe proteger el carguero hasta que lo atraviese.", false],
		[41, "", "El blindaje del carguero sufre graves daños, pero Errkt alcanza el agujero de gusano y Keith lo sigue.", false],
	],
	"step/41": [
		[41, "", "El escuadrón de Baffour no ha cruzado el agujero de gusano a tiempo, así que Keith y Errkt están solos. El carguero va en rumbo de colisión con la nave nodriza, y Keith debe despejar los cazas Void de su camino.", false],
		[42, "", "Cuando el carguero se acerca, Errkt informa de que su cápsula de escape ha sido alcanzada. Decide quedarse en el carguero y ordena a Keith que se marche mientras aún hay tiempo. Keith se despide y da media vuelta.", false],
	],
	"step/42": [
		[42, "", "Keith debe alejarse mientras el carguero de Errkt se dirige a su objetivo.", false],
		[43, "", "Brent informa de que los agujeros de gusano de todo el sector se han derrumbado: el plan ha funcionado. Keith le cuenta que Errkt no ha sobrevivido, y Brent promete honrarlo en su informe al Imperio Vossk. Quedan para tomar algo en [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith se reúne con Brent en [[station/98]] para celebrarlo.", false],
		[44, "", "Tras varias copas, llega Carla con un vestido de noche para reclamar la cita que le debe a Keith. Brent, con tacto, los deja a solas.", false],
	],
	"step/44": [
		[44, "", "Keith despierta en [[station/98]] con resaca tras su noche con Carla.", false],
		[45, "", "Carla se ha ido. En una nota explica que se ha marchado a otro proyecto secreto en un lugar que no piensa revelar, y que Deep Science le paga a Keith un último pago de 40.000 créditos. Keith sospecha que lo han estado utilizando todo el tiempo, y vuelve al bar.", false],
	],
	"step/45": [
		[45, "", "La historia ha terminado. La nave nodriza Void ha sido destruida, los agujeros de gusano se han cerrado y [[character/0]] es libre de ir adonde quiera. Puedes seguir volando, comerciando, minando y aceptando trabajos por toda la galaxia; consulta [[world/history]] para ver un resumen de toda la historia.", false],
	],
	"step/5": [
		[5, "", "Keith debe dejar atrás al pirata y atracar sano y salvo en [[station/78]].", false],
		[6, "", "Gunant reconoce que los ataques piratas contra su estación van a peor. Keith se ofrece a encargarse de ellos si consigue armas. Gunant decide intentar un ataque contra el escondite pirata cercano a la estación y abre su pequeño hangar para que Keith instale un arma y blindaje.", false],
	],
	"step/6": [
		[6, "", "En el hangar de la estación, Keith debe equipar [[ship/0]] con un arma y una placa de blindaje (consulta [[guide/fitting]]).", false],
		[7, "", "Gunant aprueba la elección. Por precaución, ha ajustado las armas de Keith para que no puedan atravesar sus propios escudos. Los dos quedan en verse fuera.", false],
	],
	"step/7": [
		[7, "", "Gunant transmite la ruta hasta el escondite como puntos de ruta. Keith debe seguirla y destruir allí las naves piratas, con Gunant volando a su lado (consulta [[guide/combat]]).", false],
		[8, "", "En el escondite hay muchos más piratas de lo esperado. Gunant quiere retirarse, pero Keith sigue luchando y vence. Cuando le pregunta dónde aprendió a pelear así, Keith dice que sirvió en la Flota Espacial a las órdenes del almirante Smith. A Gunant le parece extraño, porque Keith parece demasiado joven.", false],
	],
	"step/8": [
		[8, "", "Ganada la batalla, Keith y Gunant regresan a [[station/78]].", false],
		[9, "", "Gunant le agradece a Keith que le salvara la vida y menciona la tumba del almirante Smith en [[station/5]]. Keith se queda atónito: el almirante murió de viejo hacia 3612. Gunant le dice entonces que el año actual es 3624, un año que, según él, se recordará por los Voids.", false],
	],
	"step/9": [
		[9, "", "Conmocionado por la noticia, Keith vuelve a atracar en [[station/78]] para ajustar cuentas con Gunant.", false],
		[10, "", "Keith se da cuenta de que han pasado unos 35 años desde que lo alcanzaron en el cinturón de asteroides. Gunant sospecha de un fallo del hipermotor, ya que ese tipo de motor lleva años relacionado con incidentes similares.", false],
		[10, "", "En agradecimiento por la victoria sobre los piratas, Gunant le regala [[ship/0]] a Keith, equipada con un motor más potente para viajar entre los planetas del sistema. Se queda con el láser de minería, un prototipo que construyó él mismo. Keith por fin dice su nombre y parte a reunirse con el capitán [[character/3]], un comandante humano de [[station/79]] que puede ayudarle a llegar al espacio [[faction/0]]. A partir de ahora, el [[chart]] permite viajar dentro del sistema.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] es un sistema niveliano en el borde izquierdo del mapa. Permanece oculto en el mapa estelar hasta que compras sus coordenadas a [[agent/12]] en [[station/18]]. Su portal, en [[station/0]], lo conecta con [[system/2]] y [[system/8]].", false],
		[0, "", "Las estaciones de Suteo están entre las más avanzadas del espacio niveliano, con [[station/2]] y [[station/4]] en el nivel tecnológico máximo. El agente [[agent/0]] vende un plano en [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] es un sistema terrano en la esquina inferior izquierda del mapa. Permanece oculto hasta que compras sus coordenadas a [[agent/13]] en [[station/26]]. Su portal, en [[station/5]], lo conecta con [[system/8]] y [[system/18]].", false],
		[0, "", "Sus estaciones están muy desarrolladas, con [[station/7]] en el nivel tecnológico máximo. El agente [[agent/1]] vende un plano en [[station/8]].", false],
		[9, "", "Según [[character/2]], el almirante Smith, antiguo comandante de [[character/0]], está enterrado en [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] es un sistema vossk en el lado derecho del mapa, con nivel «Dangerous» (Peligroso). Permanece oculto hasta que compras sus coordenadas a [[agent/14]], y no tiene ninguna conexión por portal: solo una nave con motor de salto puede llegar a él. Sus cinco estaciones tienen los niveles tecnológicos más altos.", false],
		[0, "", "El agente [[agent/5]] vende un plano en [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] es un sistema terrano en la parte superior central del mapa, con nivel «Average» (Medio). Solo tiene tres estaciones. Su portal, en [[station/55]], lo conecta con [[system/7]], [[system/9]], [[system/14]] y [[system/16]].", false],
		[18, "", "[[character/0]] es enviado a [[station/56]] para reunirse con un oficial de Deep Science.", false],
		[19, "", "El oficial, [[character/5]], ha sido secuestrado por piratas cerca de [[station/55]].", false],
		[22, "", "[[character/0]] lo libera con bombas EMP en el [[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] es un pequeño sistema vossk con solo dos estaciones, en el lado derecho del mapa y con nivel Medio. Su portal, en [[station/60]], lo conecta con [[system/3]], [[system/5]], [[system/13]] y [[system/14]], de modo que une el espacio vossk con el este terrano.", false],
		[0, "", "El agente multipod [[agent/6]] vende un plano en [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] es un sistema terrano en el borde derecho del mapa, con nivel «Risky» (Arriesgado). Su portal, en [[station/65]], lo conecta con [[system/12]] y [[system/16]].", false],
		[0, "", "El agente cyborg [[agent/14]] vende coordenadas en [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] es un sistema terrano cerca del centro del mapa y uno de los dos sistemas «Safe» (Seguro) de la galaxia. Su portal, en [[station/70]], lo conecta con [[system/3]], [[system/11]], [[system/12]] y [[system/19]]. Sus estaciones tienen en su mayoría poca tecnología.", false],
		[0, "", "El agente [[agent/7]] vende un plano en [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] es un sistema midoriano en la parte superior del mapa, con nivel «Dangerous» (Peligroso). No tiene conexiones por portal, así que una nave solo puede entrar o salir con un motor de salto. Sus cinco estaciones son todas pequeñas y de poca tecnología. Hasta el [[step/16]] sus vendedores de naves permanecen cerrados y van y vienen pocas naves.", false],
		[0, "", "La historia empieza aquí, en [[station/78]].", false],
		[11, "", "El sistema es el territorio de la [[faction/3|Confederación de Mido]], fundada por exiliados terranos y nivelianos durante la guerra civil niveliana. Los nivelianos siguen reclamándolo y hay combates en sus afueras.", false],
		[15, "", "[[character/0]] sale del sistema como prisionero en un crucero terrano tras el [[step/14]]. Para volver más adelante hace falta un motor de salto.", false],
		[0, "", "[[character/2]] vende un plano en el lounge de [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] es un sistema terrano en el lado derecho del mapa, con nivel «Risky» (Arriesgado). Su portal, en [[station/80]], lo conecta con [[system/11]] y [[system/13]].", false],
		[0, "", "El agente vossk [[agent/8]] vende un plano en [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] es un sistema niveliano en la parte superior izquierda del mapa, con nivel «Risky» (Arriesgado), y el sistema más cercano a [[system/15]]. Su portal, en [[station/85]], lo conecta con [[system/2]], [[system/9]] y [[system/4]]; es la única ruta de portales hacia [[system/4]].", false],
		[0, "", "El agente vossk [[agent/15]] vende coordenadas en [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] es un sistema terrano en la parte inferior del mapa, con nivel «Risky» (Arriesgado). Su portal, en [[station/90]], lo conecta con [[system/1]] y [[system/8]].", false],
		[0, "", "El agente [[agent/9]] vende un plano en [[station/90]].", false],
		[28, "", "En el [[step/28]], [[character/0]] viene aquí tras un aviso de actividad Void cerca de [[station/91]], para colarse en un agujero de gusano.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] es un sistema terrano en el centro del mapa, con nivel «Safe» (Seguro). Su portal, en [[station/95]], lo conecta con [[system/3]], [[system/8]], [[system/9]] y [[system/14]].", false],
		[15, "", "[[station/98]] es adonde el crucero terrano lleva a [[character/0]] tras su detención, y donde se reencuentra con su viejo amigo [[character/1]].", false],
		[16, "", "Ni siquiera este sistema seguro se libra: un escuadrón Void ataca [[station/98]] en el [[step/16]]. [[character/1]] tiene allí su cuartel general.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] es un sistema niveliano en el lado izquierdo del mapa y el cruce de caminos del espacio niveliano. Su portal, en [[station/30]], lo conecta con [[system/0]], [[system/8]], [[system/9]] y [[system/17]]. Tiene cuatro estaciones de nivel tecnológico medio.", false],
		[34, "", "En el [[step/33]], [[character/6]] envía a [[character/0]] a [[station/30]], donde [[character/1]] lo espera con un nuevo plan. Allí se realizan también los últimos preparativos contra los Voids.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] es un sistema vossk en la parte inferior derecha del mapa, con nivel «Dangerous» (Peligroso). Su portal, en [[station/62]], lo conecta con [[system/5]] y [[system/21]], por lo que es la única ruta de portales hacia [[system/21]].", false],
		[0, "", "Un terrano, el agente [[agent/10]], vende un plano en la pequeña estación [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] es un sistema vossk en el extremo de la esquina inferior derecha del mapa, con nivel «Dangerous» (Peligroso). Permanece oculto hasta que compras sus coordenadas a [[agent/15]]. Su portal, en [[station/12]], solo lo conecta con [[system/20]]. Todas sus estaciones son primitivas, con niveles tecnológicos de 3 o menos.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] es el sistema vossk más cercano al centro del mapa y la entrada principal al espacio vossk. Su portal, en [[station/15]], lo conecta con [[system/5]], [[system/12]], [[system/8]], [[system/14]] y [[system/19]]. Su nivel de seguridad es «Average» (Medio).", false],
		[0, "", "El agente [[agent/12]], en [[station/18]], vende las coordenadas del sistema oculto [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] es un sistema midoriano en la esquina superior izquierda del mapa, con nivel «Dangerous» (Peligroso). Es un callejón sin salida: su portal, en [[station/20]], solo llega a [[system/17]]. Sus estaciones van desde la primitiva [[station/21]] hasta la bien equipada [[station/22]].", false],
		[0, "", "El agente [[agent/2]] vende un plano en el lounge de [[station/20]].", false],
		[38, "", "En el [[step/38]] se rastrea hasta este sistema, cerca de [[station/22]], un convoy robado que transporta explosivos nivelianos.", false],
	],
	"system/5": [
		[0, "", "[[system/5]] es un sistema vossk en la parte inferior derecha del mapa, con nivel «Risky» (Arriesgado). Su portal, en [[station/25]], lo conecta con [[system/3]], [[system/12]] y [[system/20]]. El agente [[agent/13]] vende coordenadas en [[station/26]].", false],
		[35, "", "El sistema es la base del comandante vossk [[character/7]], en [[station/29]], donde [[character/0]] se reúne con él en el [[step/35]].", false],
		[36, "", "Su duelo tiene lugar cerca de [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] es un sistema terrano en la parte superior derecha del mapa, con nivel «Dangerous» (Peligroso). No aparece en los mapas estelares normales, y solo la historia revela sus coordenadas. Tiene una sola estación, [[station/10]], cuyo portal lo conecta únicamente con [[system/7]].", false],
		[23, "", "El sistema oculta la estación de investigación secreta de Deep Science. [[character/5]] le da sus coordenadas a [[character/0]] en el [[step/22]], y allí se planea buena parte de la lucha contra los Voids.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] es un sistema terrano en la parte superior derecha del mapa, con nivel «Risky» (Arriesgado). Su portal, en [[station/35]], lo conecta con [[system/11]] y con el oculto [[system/6]], por lo que es la única ruta de portales hacia el sistema oculto. [[station/37]] es su estación más avanzada.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] es un sistema terrano en el cuadrante inferior izquierdo del mapa y el sistema mejor conectado de la galaxia. Su portal, en [[station/40]], lo conecta con seis sistemas: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] y [[system/19]]. Su nivel de seguridad es «Average» (Medio).", false],
		[0, "", "El agente [[agent/4]] vende un plano en [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] es un sistema niveliano en la parte superior central del mapa, con nivel «Average» (Medio). Su portal, en [[station/45]], lo conecta con [[system/2]], [[system/11]], [[system/17]] y [[system/19]].", false],
		[24, "", "Se informa de actividad Void cerca de [[station/48]], y [[character/0]] y [[character/6]] van allí en el [[step/24]] para recoger restos.", false],
	],
	"world/galaxy": [
		[0, "Panorama general", "El juego transcurre en una única galaxia de 22 sistemas estelares. Cada sistema pertenece a una facción, tiene un nivel de seguridad y alberga entre una y cinco estaciones espaciales. Cada estación orbita un planeta y tiene su propia tienda, hangar y Space Lounge. Los sistemas se reparten sobre un mapa plano, y los viajes entre ellos pasan por una red de portales de salto.", false],
		[0, "", "Cuatro pueblos se reparten los sistemas cartografiados. Los [[faction/0|terranos]] controlan diez, los [[faction/1]] seis, los [[faction/2|nivelianos]] cuatro y los [[faction/3|midorianos]] dos. Miembros de razas menores, como los [[faction/4|multipods]], los [[faction/5|cyborgs]], los [[faction/6|bobolianos]] y los [[faction/7]], viven entre ellos sin territorio propio. Los [[faction/8|piratas]] recorren todos los sistemas, y desde el principio corren rumores sobre una fuerza hostil llamada los [[faction/9|Voids]].", false],
		[0, "Distribución", "Los sistemas nivelianos y midorianos están en la parte superior izquierda del mapa, en torno a [[system/15]], [[system/4]], [[system/17]] y [[system/2]]. El espacio terrano ocupa el centro, el lado derecho y la parte inferior del mapa, con [[system/19]] y [[system/14]] como núcleo. Los sistemas vossk forman un bloque aparte en la parte inferior derecha, que empieza en [[system/3]] y termina en el extremo de la esquina, en [[system/21]].", false],
		[0, "", "Las rutas de portales favorecen el centro. [[system/8]] tiene seis conexiones por portal, más que ningún otro sistema, y [[system/19]], [[system/14]], [[system/3]] y [[system/11]] conectan cada uno cuatro o cinco sistemas. Los sistemas de los bordes, como [[system/4]], [[system/6]] y [[system/21]], son callejones sin salida con una sola conexión.", false],
		[0, "Viajes", "Dentro de un sistema, el motor normal de una nave la lleva de la órbita de una estación a la de otra. Para salir de un sistema, la nave atraviesa su portal de salto, que se encuentra en una de las estaciones del sistema y solo llega a los sistemas conectados con él. Los viajes más largos son cadenas de saltos por portales. Un motor de salto es la única forma de saltarse la red de portales y llegar directamente a cualquier sistema conocido; consulta [[guide/navigation]].", false],
		[33, "", "El único motor de salto del juego es el [[item/85]], que [[character/20]] diseña durante la historia. Se fabrica a partir de un plano y requiere, entre otras cosas, [[item/164]].", false],
		[0, "Seguridad", "Cada sistema tiene un nivel de seguridad: «Safe» (Seguro), «Average» (Medio), «Risky» (Arriesgado) o «Dangerous» (Peligroso). El nivel determina con qué frecuencia te esperan asaltantes cerca de una estación al llegar. En un sistema «Dangerous» aparecen en la mayoría de las visitas; en uno «Safe» son raros. Los asaltantes suelen ser piratas, pero a veces son naves de la raza rival de la facción. A cambio, los sistemas más seguros mantienen más naves de patrulla locales alrededor de sus estaciones.", false],
		[0, "Facciones y reputación", "Tu reputación se mide en dos escalas: una entre los terranos y los vossk, y otra entre los nivelianos y los midorianos. Ganar el favor de un bando de cada pareja cuesta el favor del otro. Si tu reputación con una facción cae demasiado, sus naves te atacan en cuanto te ven y sus estaciones te rechazan. Los piratas y los Voids son siempre hostiles. Un diplomático en un Space Lounge puede reparar tu reputación a cambio de una tarifa.", false],
		[0, "Sistemas ocultos", "No todos los sistemas aparecen al principio en el mapa estelar. [[system/0]], [[system/1]], [[system/10]] y [[system/21]] permanecen ocultos hasta que compras sus coordenadas a un agente en un Space Lounge; consulta [[guide/lounge]]. Hay otro sistema, [[system/6]], que no figura en los mapas estelares normales y que solo la historia revela.", false],
		[23, "", "Las coordenadas de [[system/6]] te llegan a través de [[character/5]] en el [[step/22]]. El sistema tiene una sola estación, [[station/10]], la base de investigación secreta de la organización Deep Science.", false],
		[0, "", "Dos sistemas no tienen ninguna conexión por portal: [[system/15]] y [[system/10]]. Una nave solo puede llegar a ellos, o salir de ellos, con un motor de salto.", false],
		[0, "Un comienzo aislado", "La historia empieza en [[system/15]], un sistema remoto en la parte superior del mapa sin conexión por portal con el resto de la galaxia. Su comercio es pobre, sus estaciones tienen poca tecnología y sus vendedores de naves permanecen cerrados durante la primera parte de la historia. Al principio, la única forma de salir del sistema es la que ofrece la historia.", false],
		[11, "", "[[system/15]] es el hogar de la [[faction/3|Confederación de Mido]], un grupo de refugiados y proscritos terranos y nivelianos que colonizaron este sector recién cartografiado durante la guerra civil niveliana. La Confederación se declaró independiente. Los terranos lo aceptan; los nivelianos siguen reclamando el sistema, lo que mantiene vivos los combates en sus límites.", false],
		[15, "", "[[character/0]] sale de [[system/15]] a bordo de un crucero terrano después de que el convoy de [[station/79]] inutilice su nave y lo detenga en el [[step/14]]. Llega a [[station/98]], en [[system/19]], en pleno espacio terrano.", false],
		[9, "El salto en el tiempo", "Cuando [[character/0]] despierta en [[system/15]], cree que solo ha pasado poco tiempo. En realidad, su hipermotor dañado lo ha lanzado al otro lado de la galaxia y unos 35 años hacia el futuro. La galaxia que conocía ha cambiado: viejos amigos han envejecido o muerto, y entretanto se han colonizado nuevos sectores, entre ellos aquel en el que se encuentra.", false],
		[10, "", "Los hipermotores defectuosos de su tipo ya habían causado antes saltos parecidos a través del tiempo y el espacio.", false],
		[18, "Más allá del mapa", "Los Voids entran en los sistemas cartografiados a través de una especie de agujero de gusano. Atacan por igual el espacio terrano, niveliano y vossk, y parecen buscar mineral. Consulta [[world/voids]].", false],
		[25, "", "Un agujero de gusano lleva fuera de la galaxia cartografiada, al sector propio de los Voids, que no aparece en el mapa estelar. Los agujeros de gusano se abren cerca de una estación durante un tiempo, luego se derrumban y aparecen en otro lugar.", false],
		[34, "", "Con el [[item/85]] instalado, una nave también puede saltar directamente al sector Void.", false],
		[32, "", "A partir del [[step/31]], un sistema de alerta temprana muestra en el mapa estelar dónde se abrirá el próximo agujero de gusano.", false],
		[42, "", "Cuando la nave nodriza Void es destruida en el [[step/41]], los agujeros de gusano de todo el sector se derrumban y los ataques cesan.", false],
	],
	"world/history": [
		[0, "", "La galaxia la comparten varios pueblos, entre ellos los [[faction/0|terranos]], los [[faction/2|nivelianos]] y los [[faction/1|vossk]]. Los [[faction/8|piratas]] infestan el espacio entre sus estaciones. Esta página resume la historia; cada parte aparece cuando tu partida llega a ella.", false],
		[0, "Primer acto: varado", "El cazarrecompensas terrano [[character/0]] destruye una banda pirata en un cinturón de asteroides ([[step/0]]).", false],
		[1, "", "Un último disparo daña su hipermotor cuando salta para reunirse con su antiguo comandante, el almirante Smith. Su nave, con el piloto inconsciente, va a la deriva hasta [[station/78]].", false],
		[2, "", "El comerciante de mineral niveliano [[character/2]] rescata los restos, se queda con la nave y obliga a Keith a minar para él.", false],
		[8, "", "Keith ayuda a Gunant a destruir un escondite pirata cercano ([[step/7]]).", false],
		[9, "", "Después, Keith se entera de que es el año 3624 y de que el almirante Smith murió hace mucho.", false],
		[10, "", "Un fallo del hipermotor ha llevado a Keith 35 años al futuro y a un rincón remoto de la galaxia. Gunant le regala la nave [[ship/0]] y lo envía a ver a [[character/3]] en [[station/79]].", false],
		[11, "", "El sistema [[system/15]] pertenece a la [[faction/3|Confederación de Mido]], fundada por exiliados terranos y nivelianos durante la guerra civil niveliana.", false],
		[12, "", "Keith descubre que el traficante [[character/4]] ha drogado hasta el estupor a la tripulación de la estación silenciosa [[station/76]] ([[step/11]]).", false],
		[15, "", "Al pasar por el sistema, un convoy terrano confunde a Keith con un pirata, inutiliza su nave y lo lleva a [[station/98]] ([[step/14]]).", false],
		[16, "Segundo acto: la amenaza Void", "Allí se reencuentra con su viejo amigo [[character/1]], ahora jefe de seguridad, justo cuando los [[faction/9|Voids]] atacan la estación.", false],
		[18, "", "Los Voids asaltan sistemas estelares a través de agujeros de gusano en busca de mineral. Brent recluta a Keith para que pilote para Deep Science, una organización de investigación secreta que los estudia ([[step/17]]).", false],
		[19, "", "Unos piratas secuestran al científico [[character/5]], que debía guiar a Keith hasta la estación de investigación.", false],
		[23, "", "Keith inutiliza la nave de los secuestradores con bombas EMP, lo rescata y recibe las coordenadas del sistema [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Tercer acto: Deep Science", "En [[station/10]] Keith conoce a la directora del proyecto, [[character/6]], y empieza a trabajar para Deep Science.", false],
		[25, "", "Keith y Carla recogen restos de naves Void en [[station/48]], pero un agujero de gusano se traga su nave ([[step/24]]).", false],
		[26, "", "Aparecen en el sector de origen de los Voids, junto a una gigantesca nave nodriza, y escapan por otro agujero de gusano.", false],
		[30, "", "Keith vuelve al sector Void por un agujero de gusano cercano a [[station/91]] y lanza una sonda contra la nave nodriza ([[step/29]]).", false],
		[32, "", "Brent le entrega a Keith un sistema de alerta temprana que muestra dónde atacarán los Voids la próxima vez.", false],
		[34, "", "El científico grey [[character/20]] encarga a Keith reunir cristales Void para un nuevo motor instantáneo y le da su plano ([[step/33]]).", false],
		[35, "Cuarto acto: el ataque", "La sonda revela que la nave nodriza crea los agujeros de gusano. Brent y Carla planean destruirla con un carguero lleno de explosivos nivelianos, que proporciona el comandante vossk [[character/7]].", false],
		[37, "", "Errkt insiste en pilotar él mismo el carguero, y Keith se gana el derecho a escoltarlo ([[step/36]]).", false],
		[39, "", "Keith recupera el convoy que transporta los explosivos después de que unas naves de Mido lo capturen ([[step/38]]).", false],
		[42, "", "Con refuerzos al mando de [[character/8]], Keith escolta a Errkt a través de un agujero de gusano. Errkt estrella el carguero contra la nave nodriza y muere en el ataque ([[step/41]]).", false],
		[43, "", "Todos los agujeros de gusano se derrumban y los ataques de los Voids terminan.", false],
		[45, "Epílogo", "Keith lo celebra con Brent y por fin pasa una noche con Carla. Ella se marcha a la mañana siguiente a otro proyecto secreto, y Keith queda libre para recorrer la galaxia.", false],
	],
	"world/voids": [
		[0, "", "Los [[faction/9|Voids]] son la amenaza central de la historia. Esta página recoge lo que se sabe de ellos; aparece más información a medida que avanza tu partida.", false],
		[2, "Primeras noticias", "Keith oye hablar de los Voids por primera vez a [[character/2]]: seres hostiles que aparecen de vez en cuando incluso en el remoto sistema [[system/15]].", false],
		[9, "", "En el sistema Mido se espera que 3624 se recuerde como el año de los Voids.", false],
		[16, "", "Cazas Void atacan [[station/98]] en el espacio terrano ([[step/15]]).", false],
		[17, "", "Durante el ataque, los Voids emiten un mensaje en el que afirman venir en son de paz, pero siguen disparando.", false],
		[18, "Lo que se sabe", "Los Voids empezaron a aparecer hace unas semanas. Entran en sistemas habitados a través de agujeros de gusano, atacan todo lo que encuentran y parecen buscar mineral. Incluso los sistemas [[faction/1]] sufren sus ataques. Nadie sabe de dónde vienen ni qué quieren.", false],
		[24, "", "En [[station/48]] anuncian que vienen del futuro y que son todo lo que queda de las civilizaciones de la galaxia.", false],
		[26, "El sector de origen", "Sus agujeros de gusano llevan a un lejano sector de origen, donde una gigantesca nave nodriza lanza cazas. Los agujeros de gusano se abren durante poco tiempo, luego se derrumban y reaparecen en otro lugar.", false],
		[28, "", "Los Voids advierten que destruirlos destruiría el futuro de la humanidad.", false],
		[30, "", "Repiten que deben encontrar una forma de comunicarse antes de que los humanos los destruyan, y con ellos su propio futuro. Nunca se aclara si esta afirmación es cierta.", false],
		[32, "", "Un sistema de alerta temprana desarrollado por el equipo de [[character/1]] predice dónde abrirán los Voids su próximo agujero de gusano.", false],
		[33, "", "El científico grey [[character/20]] cree que unos cristales que solo se encuentran en el sector Void, los [[item/164]], encierran el secreto de sus agujeros de gusano.", false],
		[35, "El fin de los ataques", "La sonda lanzada contra la nave nodriza demuestra que es el origen de los agujeros de gusano. Ningún arma conocida ha logrado dañarla.", false],
		[42, "", "Un carguero vossk cargado de explosivos nucleares nivelianos y pilotado por [[character/7]] destruye la nave nodriza ([[step/41]]).", false],
		[43, "", "A continuación, los agujeros de gusano se derrumban en todo el sector y los ataques de los Voids cesan, al menos por el momento.", false],
	],
}
